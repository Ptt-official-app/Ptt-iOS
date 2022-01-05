//
//  APIClientProtocol.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

enum BoardArticlesParams {
    case go_pttbbs(bid: String, startIdx: String)
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
    typealias getBoardArticlesResult = Result<APIModel.BoardModel, APIError>
    typealias GetArticleResult = Result<Article, APIError>
    typealias BoardListResult = Result<APIModel.BoardInfoList, APIError>
    typealias ProcessResult = Result<Data, APIError>
    typealias createArticleResult = Result<APIModel.CreateArticleResponse, APIError>
    
    func login(account: String, password: String, completion: @escaping (LoginResult) -> Void)

    func getBoardArticles(of params: BoardArticlesParams, completion: @escaping (getBoardArticlesResult) -> Void)
    func getArticle(of params: ArticleParams, completion: @escaping (GetArticleResult) -> Void)
    
    /// Get board list
    /// - Parameters:
    ///   - token: access token
    ///   - keyword: query string, '' returns all boards
    ///   - startIdx: starting idx, '' if fetch from the beginning.
    ///   - max: max number of the returned list, requiring <= 300
    ///   - completion: the list of board information
    func getBoardList(token: String, keyword: String, startIdx: String, max: Int, completion: @escaping (BoardListResult) -> Void)
    
    func getPopularBoards(subPath: String, token: String, querys: Dictionary<String, Any>, completion: @escaping (BoardListResult) -> Void)
    
    func createArticle(boardId: String, article: APIModel.CreateArticle, completion: @escaping (createArticleResult) -> Void)
}
