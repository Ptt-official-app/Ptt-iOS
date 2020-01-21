//
//  APIClient.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

struct APIClient {

    private static var rootURLComponents : URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "webptt.azurewebsites.net"
        return urlComponent
    }
    static var pttURLComponents : URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "www.ptt.cc"
        return urlComponent
    }

    private static let decoder = JSONDecoder()

    struct Post : Codable {
        let Title : String
        let Href : String
        let Author : String
        let Date : String
    }
    struct BoardInfo : Codable {
        let Name : String
        let Nuser : String
        let Class : String
        let Title : String
        let Href : String
        let MaxSize : Int
    }
    struct Message : Codable {
        let Error : String?
        let Metadata : String?
    }
    struct Board : Codable {
        let Page : Int
        let BoardInfo : BoardInfo
        let PostList : [Post]
        let Message : Message?
    }
    struct APIError : Codable {
        let message : String
    }
    static func getNewPostlist(board: String, completion: @escaping (APIError?, Board?) -> Void) {
        var urlComponent = rootURLComponents
        urlComponent.path = "/API/GetNewPostlist"
        urlComponent.queryItems = [     // Percent encoding is automatically done with RFC 3986
            URLQueryItem(name: "board", value: board)
        ]
        guard let url = urlComponent.url else {
            assertionFailure()
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            if let error = error {
                completion(APIError(message: error.localizedDescription), nil)
                return
            }
            guard let data = data else {
                completion(APIError(message: "No data"), nil)
                return
            }
            do {
                let board = try decoder.decode(Board.self, from: data)
                completion(nil, board)
            } catch {
                completion(APIError(message: error.localizedDescription), nil)
            }
        }
        task.resume()
    }
}
