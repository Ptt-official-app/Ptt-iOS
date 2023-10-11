//
//  FavoriteBoardManagerTest.swift
//  PttTests
//
//  Created by AnsonChen on 2023/7/30.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Combine
@testable import Ptt
import XCTest

final class FavoriteBoardManagerTest: XCTestCase {
    private var apiClient: APIClientProtocol!
    private var keyChainItem: PTTKeyChain!
    private var urlSession: MockURLSession!
    private var sut: FavoriteBoardManager!
    private var userID = "sampleID"
    private var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        cancellables = []
        urlSession = MockURLSession()
        keyChainItem = MockKeyChain()
        keyChainItem.save(
            object: APIModel.LoginToken(
                user_id: userID,
                access_token: "fakeToken",
                token_type: "bear",
                refresh_token: "fake",
                access_expire: Date(timeIntervalSinceNow: 40),
                refresh_expire: Date(timeIntervalSinceNow: 140)
            ),
            for: .loginToken
        )

        apiClient = APIClient(session: urlSession, keyChainItem: keyChainItem)
        sut = FavoriteBoardManager(apiClient: apiClient)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        cancellables = []
        apiClient = nil
        keyChainItem = nil
        urlSession = nil
        sut = nil
        try super.tearDownWithError()
    }

    func testAddBoardToFavorite_receivedDataShouldFollowAddedSequence() async {
        let boards = [mockBoardInfo(), mockBoardInfo()]
        let ex = expectation(description: "receiveValue is called")
        ex.expectedFulfillmentCount = 3
        sut.boards
            .sink { _ in

            } receiveValue: { newBoards in
                if let newBoards = newBoards {
                    if newBoards.count == 1 {
                        XCTAssertEqual(newBoards.map { $0.brdname }, [boards[0].brdname])
                    } else if newBoards.count == 2 {
                        XCTAssertEqual(newBoards.map { $0.brdname }, boards.map { $0.brdname })
                    }
                }
                ex.fulfill()
            }
            .store(in: &cancellables)

        Task {
            stubAddFavoriteBoards(isError: false, board: boards[0])
            try await sut.addBoardToFavorite(board: boards[0])

            Task {
                stubAddFavoriteBoards(isError: false, board: boards[1])
                try await sut.addBoardToFavorite(board: boards[1])
            }
        }

        await fulfillment(of: [ex])
    }

    func testAddBoardToFavorite_whenErrorHappensShouldThrow() async throws {
        stubAddFavoriteBoards(isError: true, board: nil)
        do {
            try await sut.addBoardToFavorite(board: mockBoardInfo())
        } catch {
            let apiError = try XCTUnwrap(error as? APIError)
            guard case let .requestFailed(int, _) = apiError,
                  int == 500 else {
                XCTFail("Unexpected error")
                return
            }
        }
    }

    func testDeleteBoardFromFavorite_whenFavoritedBoardsIsEmpty_shouldIgnore() async throws {
        let ex = expectation(description: "receiveValue is called")
        sut.boards
            .sink { _ in

            } receiveValue: { newBoards in
                XCTAssertNil(newBoards)
                ex.fulfill()
            }
            .store(in: &cancellables)

        try await sut.deleteBoardFromFavorite(board: mockBoardInfo())
        await fulfillment(of: [ex])
    }

    func testDeleteBoardFromFavorite_successDelete() async throws {
        let mockBoard = mockBoardInfo()
        var expected: [[APIModel.BoardInfo]?] = [nil, [mockBoard], []]
        let ex = expectation(description: "receiveValue is called")
        ex.expectedFulfillmentCount = 3
        sut.boards
            .sink { _ in

            } receiveValue: { newBoards in
                let expectedResult = expected.removeFirst()
                XCTAssertEqual(expectedResult, newBoards)
                ex.fulfill()
            }
            .store(in: &cancellables)

        stubAddFavoriteBoards(isError: false, board: mockBoard)
        try await sut.addBoardToFavorite(board: mockBoard)

        stubDeleteFavoriteBoards(isError: false)
        try await sut.deleteBoardFromFavorite(board: mockBoard)

        await fulfillment(of: [ex])
    }

    func testDeleteBoardFromFavorite_whenDeleteFailed() async throws {
        let mockBoard = mockBoardInfo()
        stubAddFavoriteBoards(isError: false, board: mockBoard)
        try await sut.addBoardToFavorite(board: mockBoard)

        stubDeleteFavoriteBoards(isError: true)
        do {
            try await sut.deleteBoardFromFavorite(board: mockBoard)
        } catch {
            let apiError = try XCTUnwrap(error as? APIError)
            guard case let .requestFailed(int, _) = apiError,
                  int == 500 else {
                XCTFail("Unexpected error")
                return
            }
        }
    }

    func testFetchAllFavoriteBoards_needsToCallAPITwice() async {
        let ex = expectation(description: "receiveValue is called")
        ex.expectedFulfillmentCount = 2
        sut.boards
            .sink { _ in

            } receiveValue: { newBoards in
                if let newBoards = newBoards {
                    XCTAssertEqual(4, newBoards.count)
                }
                ex.fulfill()
            }
            .store(in: &cancellables)

        stubFetchFavoriteBoards(isError: false, iterate: 2)
        await sut.fetchAllFavoriteBoards()
        await fulfillment(of: [ex])
    }

    func testFetchAllFavoriteBoards_whenErrorHappens() async throws {
        let ex = expectation(description: "receiveValue is called")
        sut.boards
            .sink { completion in
                switch completion {
                case .failure(let error):
                    guard let apiError = error as? APIError,
                          case .requestFailed(let code, _) = apiError,
                          code == 403 else {
                        XCTFail("Unexpected error")
                        return
                    }
                    ex.fulfill()
                case .finished:
                    XCTFail("Shouldn't finish")
                }
            } receiveValue: { _ in

            }
            .store(in: &cancellables)

        stubFetchFavoriteBoards(isError: true, iterate: 0)
        await sut.fetchAllFavoriteBoards()
        await fulfillment(of: [ex])
    }
}

extension FavoriteBoardManagerTest {
    private func stubAddFavoriteBoards(isError: Bool, board: APIModel.BoardInfo?) {
        urlSession.stub { path, _, _, _, completion in
            XCTAssertEqual(path, "/api/user/\(self.userID)/favorites/addboard")
            if isError {
                completion(.success((500, ["Msg": "error message"])))
            } else if let board = board,
                      let dict = try? board.asDictionary() {
                completion(.success((200, dict)))
            } else {
                XCTFail("config error")
            }
        }
    }

    private func stubDeleteFavoriteBoards(isError: Bool) {
        urlSession.stub { path, _, _, _, completion in
            XCTAssertEqual(path, "/api/user/\(self.userID)/favorites/delete")
            if isError {
                completion(.success((500, ["Msg": "error message"])))
            } else {
                completion(.success((200, ["success": true])))
            }
        }
    }

    private func stubFetchFavoriteBoards(isError: Bool, iterate: Int) {
        urlSession.stub { path, _, queryItem, _, completion in
            XCTAssertEqual(path, "/api/user/\(self.userID)/favorites")
            if isError {
                completion(.success((403, ["Msg": "Invalid user"])))
            } else {
                guard let item = queryItem.first(where: { $0.name == "start_idx" }),
                      let value = item.value else {
                    XCTFail("Should have start_idx")
                    return
                }
                let nextIdx = value.isEmpty ? "1" : ""
                let data = BoardListFakeData.mockSuccessData(nextIdx: nextIdx, numOfBoards: 2)
                completion(.success((200, data)))
            }
        }
    }

    private func mockBoardInfo() -> APIModel.BoardInfo {
        APIModel.BoardInfo(brdname: String.random(length: 8), title: String.random(length: 2))
    }
}
