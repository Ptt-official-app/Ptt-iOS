//
//  APIClientProtocol.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

enum BoardArticlesParams {
    case go_pttbbs(bid: String, startIdx: String?)
    case go_bbs(boardID: String)    // pagination not implemented yet
    case legacy(boardName: String, page: Int)
}

enum ArticleParams {
    case go_pttbbs(bid: String, aid: String)
    case go_bbs(boardID: String, articleID: String)
    case legacy(boardName: String, filename: String)
}

protocol APIClientProtocol {
    typealias LoginResult = Result<APIModel.LoginToken, APIError>
    typealias AttemptRegisterResult = Result<APIModel.AttemptRegister, APIError>
    typealias RegisterResult = Result<APIModel.Register, APIError>
    typealias GetBoardArticlesResult = Result<APIModel.BoardModel, APIError>
    typealias GetArticleResult = Result<Article, APIError>
    typealias ProcessResult = Result<Data, APIError>
    typealias PopularArticlesResult = Result<APIModel.GoPttBBSBoard, APIError>
    
    func login(account: String, password: String, completion: @escaping (LoginResult) -> Void)

    func getBoardArticles(of params: BoardArticlesParams, completion: @escaping (GetBoardArticlesResult) -> Void)
    func getArticle(of params: ArticleParams, completion: @escaping (GetArticleResult) -> Void)

    /// Get board list
    /// - Parameters:
    ///   - keyword: query string, '' returns all boards
    ///   - startIdx: starting idx, '' if fetch from the beginning.
    ///   - max: max number of the returned list, requiring <= 300
    func getBoardList(keyword: String, startIdx: String, max: Int) async throws -> APIModel.BoardInfoList

    func createArticle(boardId: String, article: APIModel.CreateArticle) async throws -> APIModel.CreateArticleResponse
    func deleteArticle(boardID: String, articleIDs: [String]) async throws -> APIModel.GeneralResponse

    /// Get popular article list data
    /// - Parameters:
    ///   - startIdx: query string, empty string if fetch from the beginning
    ///   - limit: max number of the returned list, requiring <= 200
    ///   - desc: descending (or ascending if false)
    func getPopularArticles(startIdx: String, limit: Int, desc: Bool, completion: @escaping (PopularArticlesResult) -> Void)
    func boardDetail(boardID: String) async throws -> APIModel.BoardDetail
    func favoritesBoards(startIndex: String, limit: Int) async throws -> APIModel.BoardInfoList
    func addBoardToFavorite(levelIndex: String, bid: String) async throws -> APIModel.BoardInfo
    func deleteBoardFromFavorite(levelIndex: String, index: String) async throws -> Bool
    func popularBoards() async throws -> APIModel.BoardInfoList
    func getProfile(userID: String) async throws -> APIModel.Profile
    func getUserArticles(userID: String, startIndex: String) async throws -> APIModel.ArticleList
    func getUserComment(userID: String, startIndex: String) async throws -> APIModel.ArticleCommentList
}
