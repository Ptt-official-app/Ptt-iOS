//
//  APIClientProtocol.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
protocol APIClientProtocol: class {
    typealias GetNewPostlistResult = Result<APIModel.Board, APIError>
    typealias GetPostResult = Result<Post, APIError>
    typealias BoardListResult = Result<Data, APIError>
    typealias ProcessResult = Result<Data, APIError>
    
    func getNewPostlist(board: String, page: Int, completion: @escaping (GetNewPostlistResult) -> Void)
    func getPost(board: String, filename: String, completion: @escaping (GetPostResult) -> Void)
    func getBoardList(completion: @escaping (BoardListResult) -> Void)
}
