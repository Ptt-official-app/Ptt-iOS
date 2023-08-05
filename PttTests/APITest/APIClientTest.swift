//
//  APIClientTest.swift
//  PttTests
//
//  Created by Anson on 2020/11/19.
//  Copyright © 2020 Ptt. All rights reserved.
//

@testable import Ptt
import XCTest

final class APIClientTest: XCTestCase {
    private var apiClient: APIClientProtocol!
    private var keyChainItem: PTTKeyChain!
    private var urlSession: MockURLSession!
    private var userID: String!
    private var token: String!
    private var refreshToken: String!

    override func setUp() {
        super.setUp()
        urlSession = MockURLSession()
        keyChainItem = MockKeyChain()
        userID = String.random(length: 8)
        token = String.random(length: 8)
        refreshToken = String.random(length: 8)
        keyChainItem.save(
            object: APIModel.LoginToken(
                user_id: userID,
                access_token: token,
                token_type: "bear",
                refresh_token: refreshToken
            ),
            for: .loginToken
        )

        apiClient = APIClient(session: urlSession, keyChainItem: keyChainItem)
    }

    override func tearDown() {
        super.tearDown()
        urlSession = nil
        keyChainItem = nil
        userID = nil
        apiClient = nil
        refreshToken = nil
        token = nil
    }

    func testLoginSuccess() {
        let username = String.random(length: 9)
        let password = String.random(length: 8)
        urlSession.stub { path, _, _, body, completion in
            XCTAssertEqual(path, "/api/account/login")
            let data = try XCTUnwrap(body)
            let obj = try XCTUnwrap(try JSONSerialization.jsonObject(with: data) as? [String: String])
            XCTAssertEqual(obj["username"], username)
            XCTAssertEqual(obj["password"], password)
            completion(.success((200, LoginFakeData.successData)))
        }
        apiClient.login(account: username, password: password) { result in
            switch result {
            case .failure:
                XCTAssert(false)
            case .success(let token):
                XCTAssert(token.access_token == "fake token")
                XCTAssert(token.token_type == "fake type")
            }
        }
    }

    func testRefreshToken_successCase() async throws {
        urlSession.stub { path, header, _, body, completion in
            XCTAssertEqual(path, "/api/account/refresh")
            let authToken = try XCTUnwrap(header["Authorization"])
            XCTAssertEqual(authToken, "bearer \(self.token!)")
            let data = try XCTUnwrap(body)
            let obj = try XCTUnwrap(try JSONSerialization.jsonObject(with: data) as? [String: String])
            XCTAssertEqual(obj["refresh_token"], self.refreshToken)
            let responseDict = [
                "user_id": "tester",
                "access_token": "newToken",
                "token_type": "bearer",
                "refresh_token": "new refreshToken"
            ]
            completion(.success((200, responseDict)))
        }
        try await apiClient.refreshToken()
        let newToken: APIModel.LoginToken = try XCTUnwrap(keyChainItem.readObject(for: .loginToken))
        XCTAssertEqual(newToken.access_token, "newToken")
        XCTAssertEqual(newToken.refresh_token, "new refreshToken")
    }

    func testRefreshToken_failureCase() async throws {
        urlSession.stub { _, _, _, _, completion in
            completion(.success((400, ["Msg": "invalid params"])))
        }
        do {
            try await apiClient.refreshToken()
        } catch {
            let apiError = try XCTUnwrap(error as? APIError)
            if case let .requestFailed(code, message) = apiError {
                XCTAssertEqual(code, 400)
                XCTAssertEqual(message, "invalid params")
            } else {
                XCTFail("Unexpected error")
            }
        }
    }

    func testGetBoardArticlesSuccess() {
        urlSession.stub { path, _, queryParams, _, completion in
            XCTAssertEqual(path, "/api/Article/MyBoard")
            XCTAssertEqual(queryParams[0].value, "1")
            completion(.success((200, GetBoardArticlesFakeData.successData)))
        }

        apiClient.getBoardArticles(of: .legacy(boardName: "MyBoard", page: 1)) { result in
            switch result {
            case .failure:
                XCTAssert(false)
            case .success(let board):
                XCTAssert(board.page == 1)
//                XCTAssert(board.boardInfo.name == "MyBoard")
//                XCTAssert(board.boardInfo.nuser == "21471")
                XCTAssert(board.articleList.count == 2)
                XCTAssert(board.articleList[0].title == "Re: [問卦] 這是測試嗎")
            }
        }
    }

    func testGetArticleSuccess() {
        urlSession.stub { path, _, _, _, completion in
            XCTAssertEqual(path, "/api/Article/MyBoard/M.392837.A.F25")
            completion(.success((200, GetArticleFakeData.successData)))
        }

        apiClient.getArticle(of: .legacy(boardName: "MyBoard", filename: "M.392837.A.F25")) { result in
            switch result {
            case .failure:
                XCTAssert(false)
            case .success(let article):
                guard let fullArticle = article as? APIModel.FullArticle else {
                    XCTFail("Should be a FullArticle")
                    return
                }
                XCTAssert(article.author == "user3")
                XCTAssert(article.date == "Thu Nov 19 21:20:42 2020")
                XCTAssert(article.category == "問卦")
                XCTAssert(article.titleWithoutCategory == "有沒有問卦的八卦")
                XCTAssert(fullArticle.comments.count == 2)
                XCTAssert(fullArticle.comments[1].content == ": 叫學長啦")
            }
        }
    }

    func testBoardListSuccess_with_english_keyword() {
        let startIdx = "\(Int.random(in: 0...99))"
        let max = Int.random(in: 0...99)
        urlSession.stub { path, _, queryItem, _, completion in
            XCTAssertEqual(path, "/api/boards/autocomplete")
            for item in queryItem {
                if item.name == "brdname" {
                    XCTAssertEqual(item.value, "stup")
                } else if item.name == "start_idx" {
                    XCTAssertEqual(item.value, startIdx)
                } else if item.name == "limit" {
                    XCTAssertEqual(item.value, "\(max)")
                }
            }
            completion(.success((200, BoardListFakeData.successData)))
        }
        apiClient.getBoardList(keyword: "stup", startIdx: startIdx, max: max) { result in
            switch result {
            case .failure:
                XCTFail("Shouldn't fail")
            case .success(let list):
                XCTAssertEqual(list.next_idx, "")
                XCTAssert(list.list.count == 6)
                let info = list.list[0]
                XCTAssert(info.bid == "Baseball")
                XCTAssert(info.brdname == "Baseball")
                XCTAssert(info.title == "[棒球] 板主選舉投票中")
                XCTAssert(info.flag.contains(.cpLog))
                XCTAssert(info.nuser == 14)
            }
        }
    }

    func testBoardListSuccess_with_chinese_keyword() {
        let startIdx = "\(Int.random(in: 0...99))"
        let max = Int.random(in: 0...99)
        urlSession.stub { path, _, queryItem, _, completion in
            XCTAssertEqual(path, "/api/boards/byclass")
            for item in queryItem {
                if item.name == "keyword" {
                    XCTAssertEqual(item.value, "笨")
                } else if item.name == "start_idx" {
                    XCTAssertEqual(item.value, startIdx)
                } else if item.name == "limit" {
                    XCTAssertEqual(item.value, "\(max)")
                }
            }
            completion(.success((200, BoardListFakeData.successData)))
        }
        apiClient.getBoardList(keyword: "笨", startIdx: startIdx, max: max) { result in
            switch result {
            case .failure:
                XCTFail("Shouldn't fail")
            case .success(let list):
                XCTAssertEqual(list.next_idx, "")
                XCTAssert(list.list.count == 6)
            }
        }
    }

    func testBoardListSuccess_with_japanese_keyword() {
        let startIdx = "\(Int.random(in: 0...99))"
        let max = Int.random(in: 0...99)
        urlSession.stub { path, _, queryItem, _, completion in
            XCTAssertEqual(path, "/api/boards")
            for item in queryItem {
                if item.name == "keyword" {
                    XCTAssertEqual(item.value, "ごじゅうおん")
                } else if item.name == "start_idx" {
                    XCTAssertEqual(item.value, startIdx)
                } else if item.name == "limit" {
                    XCTAssertEqual(item.value, "\(max)")
                }
            }
            completion(.success((200, BoardListFakeData.successData)))
        }
        apiClient.getBoardList(keyword: "ごじゅうおん", startIdx: startIdx, max: max) { result in
            switch result {
            case .failure:
                XCTFail("Shouldn't fail")
            case .success(let list):
                XCTAssertEqual(list.next_idx, "")
                XCTAssert(list.list.count == 6)
            }
        }
    }

    func testFavoritesBoards_succeed() async throws {
        let startIdx = "\(Int.random(in: 0...99))"
        let limit = Int.random(in: 0...99)
        urlSession.stub { path, headers, queryItem, _, completion in
            XCTAssertEqual(path, "/api/user/\(self.userID ?? "")/favorites")
            XCTAssertEqual(headers["Authorization"], "bearer \(self.token ?? "")")
            for item in queryItem {
                if item.name == "start_idx" {
                    XCTAssertEqual(item.value, startIdx)
                } else if item.name == "limit" {
                    XCTAssertEqual(item.value, "\(limit)")
                }
            }
            completion(.success((200, BoardListFakeData.successData)))
        }
        let result = try await apiClient.favoritesBoards(startIndex: startIdx, limit: limit)
        XCTAssertEqual(result.next_idx, "")
        XCTAssertEqual(result.list.count, 6)
        XCTAssertEqual(result.list[0].bid, "Baseball")
        XCTAssertEqual(result.list[2].title, "[NBA] Dwight Howard 來台打球")
    }

    func testFavoritesBoards_failed_due_to_invalidUser() async throws {
        let startIdx = "\(Int.random(in: 0...99))"
        let limit = Int.random(in: 0...99)
        urlSession.stub { path, headers, queryItem, _, completion in
            XCTAssertEqual(path, "/api/user/\(self.userID ?? "")/favorites")
            XCTAssertEqual(headers["Authorization"], "bearer \(self.token ?? "")")
            for item in queryItem {
                if item.name == "start_idx" {
                    XCTAssertEqual(item.value, startIdx)
                } else if item.name == "limit" {
                    XCTAssertEqual(item.value, "\(limit)")
                }
            }
            completion(.success((403, ["Msg": "Invalid user"])))
        }
        do {
            _ = try await apiClient.favoritesBoards(startIndex: startIdx, limit: limit)
            XCTFail("Should throw error")
        } catch {
            let apiError = try XCTUnwrap(error as? APIError)
            if case let .requestFailed(code, message) = apiError {
                XCTAssertEqual(code, 403)
                XCTAssertEqual(message, "Invalid user")
            } else {
                XCTFail("Unexpected error")
            }
        }

    }

    func testAddBoardToFavorite() async throws {
        let levelIndex = String.random(length: 8)
        let bid = String.random(length: 4)
        urlSession.stub { path, headers, _, body, completion in
            XCTAssertEqual(path, "/api/user/\(self.userID ?? "")/favorites/addboard")
            XCTAssertEqual(headers["Authorization"], "bearer \(self.token ?? "")")
            let data = try XCTUnwrap(body)
            let dict = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: String])
            XCTAssertEqual(dict["bid"], bid)
            XCTAssertEqual(dict["level_idx"], levelIndex)
            completion(.success((200, BoardSummaryFakeData.successData)))
        }
        let result = try await apiClient.addBoardToFavorite(levelIndex: levelIndex, bid: bid)
        XCTAssertEqual(result.bid, "G-Basketball")
        XCTAssertTrue(result.flag.contains(.noBoo))
        XCTAssertTrue(result.flag.contains(.cpLog))
        XCTAssertTrue(result.flag.contains(.ipLogRecommend))
        XCTAssertEqual(result.title, "女生打籃球籃球女生打打女生籃球")
    }

    func testDeleteBoardFromFavorite_succeed() async throws {
        let levelIndex = String.random(length: 8)
        let index = String.random(length: 3)
        urlSession.stub { path, headers, _, body, completion in
            XCTAssertEqual(path, "/api/user/\(self.userID ?? "")/favorites/delete")
            XCTAssertEqual(headers["Authorization"], "bearer \(self.token ?? "")")
            let data = try XCTUnwrap(body)
            let dict = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: String])
            XCTAssertEqual(dict["idx"], index)
            XCTAssertEqual(dict["level_idx"], levelIndex)
            completion(.success((200, ["success": true])))
        }
        let result = try await apiClient.deleteBoardFromFavorite(levelIndex: levelIndex, index: index)
        XCTAssertTrue(result)
    }

    func testDeleteBoardFromFavorite_failure() async throws {
        let levelIndex = String.random(length: 8)
        let index = String.random(length: 3)
        urlSession.stub { path, headers, _, body, completion in
            XCTAssertEqual(path, "/api/user/\(self.userID ?? "")/favorites/delete")
            XCTAssertEqual(headers["Authorization"], "bearer \(self.token ?? "")")
            let data = try XCTUnwrap(body)
            let dict = try XCTUnwrap(JSONSerialization.jsonObject(with: data) as? [String: String])
            XCTAssertEqual(dict["idx"], index)
            XCTAssertEqual(dict["level_idx"], levelIndex)
            completion(.success((500, ["Msg": "error message"])))
        }
        do {
            _ = try await apiClient.deleteBoardFromFavorite(levelIndex: levelIndex, index: index)
            XCTFail("Shouldn't success")
        } catch {
            XCTAssertEqual(error.localizedDescription, "500 - error message")
        }

    }

    func testPopularBoards_succeed() async throws {
        urlSession.stub { path, headers, queryItem, _, completion in
            XCTAssertEqual(path, "/api/boards/popular")
            XCTAssertEqual(headers.count, 0)
            XCTAssertEqual(queryItem.count, 0)
            completion(.success((200, BoardListFakeData.successData)))
        }
        let result = try await apiClient.popularBoards()
        XCTAssertEqual(result.next_idx, "")
        XCTAssertEqual(result.list.count, 6)
        XCTAssertEqual(result.list[0].bid, "Baseball")
        XCTAssertEqual(result.list[2].title, "[NBA] Dwight Howard 來台打球")
    }

    func testBoardDetail_succeed() async throws {
        let boardID = String.random(length: 4)
        urlSession.stub { path, _, _, _, completion in
            XCTAssertEqual(path, "/api/board/\(boardID)")
            completion(.success((200, BoardDetailFakeData.successData)))
        }
        let result = try await apiClient.boardDetail(boardID: boardID)
        XCTAssertEqual(result.boardID, "PttApp")
        XCTAssertEqual(result.title, "測試與建議回饋的集散地")
        XCTAssertEqual(result.postTypes[2], "蘋果")
    }

    func testProfile_succeed() async throws {
        let userID = String.random(length: 5)
        urlSession.stub { path, _, _, _, completion in
            XCTAssertEqual(path, "/api/user/\(userID)")
            completion(.success((200, ProfileFakeData.successData)))
        }
        let result = try await apiClient.getProfile(userID: userID)
        XCTAssertEqual(result.userID, "fakeUserID")
        XCTAssertEqual(result.nickName, "我是暱稱")
        XCTAssertEqual(result.firstLogin, Date(timeIntervalSince1970: 1676384013))
        let goRecord = try XCTUnwrap(result.gameRecords.first(where: { $0.type == .go }))
        XCTAssertEqual(goRecord.win, 9)
        XCTAssertEqual(goRecord.lose, 8)
        XCTAssertEqual(goRecord.tie, 7)
    }

    func testUserArticles_succeed() async throws {
        let userID = String.random(length: 7)
        let startIndex = String.random(length: 2)
        urlSession.stub { path, _, queries, _, completion in
            XCTAssertEqual(path, "/api/user/\(userID)/articles")
            for query in queries {
                let key = query.name
                if key == "user_id" {
                    XCTAssertEqual(query.value, userID)
                } else if key == "start_idx" {
                    XCTAssertEqual(query.value, startIndex)
                } else {
                    XCTFail("What is this?")
                }
            }
            completion(.success((200, UserArticlesFakeData.successData)))
        }
        let result = try await apiClient.getUserArticles(userID: userID, startIndex: startIndex)
        XCTAssertEqual(result.next_idx, "aaa")
        XCTAssertEqual(result.list.count, 2)
        let article = try XCTUnwrap(result.list.first)
        XCTAssertEqual(article.bid, "ALLPOST")
        XCTAssertEqual(article.createTime, Date(timeIntervalSince1970: 1678005674))
        XCTAssertEqual(article.mode, .local)
    }

    func testUserComments_succeed() async throws {
        let userID = String.random(length: 7)
        let startIndex = String.random(length: 2)
        urlSession.stub { path, _, queries, _, completion in
            XCTAssertEqual(path, "/api/user/\(userID)/comments")
            for query in queries {
                let key = query.name
                if key == "user_id" {
                    XCTAssertEqual(query.value, userID)
                } else if key == "start_idx" {
                    XCTAssertEqual(query.value, startIndex)
                } else if key == "limit" {
                    XCTAssertEqual(query.value, "200")
                } else {
                    XCTFail("What is this?")
                }
            }
            completion(.success((200, UserCommentFakeData.successData)))
        }
        let result = try await apiClient.getUserComment(userID: userID, startIndex: startIndex)
        XCTAssertEqual(result.next_idx, "bbb")
        XCTAssertEqual(result.list.count, 2)
        let comment = try XCTUnwrap(result.list.first)
        XCTAssertEqual(comment.aid, "M.1677601372.A.E11")
        XCTAssertEqual(comment.modified, Date(timeIntervalSince1970: 1677601371))
        XCTAssertEqual(comment.title, "中文測試(Test)")
        let content = comment.comment
        XCTAssertEqual(content.count, 1)
        let lineOneContent = try XCTUnwrap(content.first)
        let contentElement = try XCTUnwrap(lineOneContent.first)
        XCTAssertEqual(contentElement.text, "這是箭頭")
        XCTAssertEqual(ANSIColor(rawValue: contentElement.color0.background, isForeground: false), .black)
        XCTAssertEqual(ANSIColor(rawValue: contentElement.color1.foreground, isForeground: true), .blue)
    }
}
