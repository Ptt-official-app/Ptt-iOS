//
//  APIClientProtocol.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
protocol APIClientProtocol: class {
    typealias LoginResult = Result<APIModel.LoginToken, APIError>
    typealias GetNewPostlistResult = Result<APIModel.Board, APIError>
    typealias GetPostResult = Result<Post, APIError>
    typealias BoardListResult = Result<Data, APIError>
    typealias BoardListResultV2 = Result<APIModel.BoardInfoList, APIError>
    typealias ProcessResult = Result<Data, APIError>
    
    func login(account: String, password: String, completion: @escaping (LoginResult) -> Void)
    func getNewPostlist(board: String, page: Int, completion: @escaping (GetNewPostlistResult) -> Void)
    func getPost(board: String, filename: String, completion: @escaping (GetPostResult) -> Void)
    func getBoardList(completion: @escaping (BoardListResult) -> Void)
    
    /// Get board list
    /// - Parameters:
    ///   - token: access token
    ///   - keyword: query string, '' returns all boards
    ///   - startIdx: starting idx, '' if fetch from the beginning.
    ///   - max: max number of the returned list, requiring <= 300
    ///   - completion: the list of board information
    func getBoardListV2(token: String, keyword: String, startIdx: String, max: Int, completion: @escaping (BoardListResultV2) -> Void)
    
    func getPopularBoards(subPath: String, token: String, querys: Dictionary<String, Any>, completion: @escaping (BoardListResultV2) -> Void)
}
