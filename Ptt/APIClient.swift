//
//  APIClient.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

protocol Post : Codable {
    var Category : String { get }
    var TitleWithoutCategory : String { get }

    var Title : String { get }
    var Href : String { get }
    var Author : String { get }
    var Date : String { get }
}

extension Post {
    var Category : String {
        if let leftBracket = Title.firstIndex(of: "["), let rightBracket = Title.firstIndex(of: "]") {
            let nextLeftBracket = Title.index(after: leftBracket)
            let range = nextLeftBracket..<rightBracket
            let category = Title[range]
            return String(category)
        }
        return "　　"
    }
    var TitleWithoutCategory : String {
        if let leftBracket = Title.firstIndex(of: "["), let rightBracket = Title.firstIndex(of: "]") {
            var title = Title
            let nextRightBracket = Title.index(after: rightBracket)
            let range = leftBracket...nextRightBracket
            title.removeSubrange(range)
            return title
        }
        return Title
    }
}

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

    struct BoardPost : Post {
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
        var PostList : [BoardPost]
        let Message : Message?
    }
    enum GetNewPostlistResult {
        case failure(error: APIError)
        case success(board: Board)
    }
    static func getNewPostlist(board: String, page: Int, completion: @escaping (GetNewPostlistResult) -> Void) {
        var urlComponent = rootURLComponents
        urlComponent.path = "/API/GetNewPostlist"
        urlComponent.queryItems = [     // Percent encoding is automatically done with RFC 3986
            URLQueryItem(name: "Board", value: board),
            URLQueryItem(name: "Page", value: "\(page)")
        ]
        guard let url = urlComponent.url else {
            assertionFailure()
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            let result = processResponse(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(error: let apiError):
                completion(.failure(error: apiError))
            case .success(data: let resultData):
                do {
                    let board = try decoder.decode(Board.self, from: resultData)
                    completion(.success(board: board))
                } catch (let parseError) {
                    completion(.failure(error: APIError(message: parseError.localizedDescription)))
                }
            }
        }
        task.resume()
    }

    struct FullPost : Post {
        let Title : String
        let Href : String
        let Author : String
        let Date : String
        let Board : String
        let Nickname : String
        let Content : String
        let Pushs : [Push]
    }
    struct Push : Codable {
        let Userid : String
        let Content : String
        let IPdatetime : String
    }
    enum GetPostResult {
        case failure(error: APIError)
        case success(post: Post)
    }
    static func getPost(board: String, filename: String, completion: @escaping (GetPostResult) -> Void) {
        var urlComponent = rootURLComponents
        urlComponent.path = "/API/GetPost"
        urlComponent.queryItems = [     // Percent encoding is automatically done with RFC 3986
            URLQueryItem(name: "Board", value: board),
            URLQueryItem(name: "Filename", value: filename)
        ]
        guard let url = urlComponent.url else {
            assertionFailure()
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
            let result = processResponse(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(error: let apiError):
                completion(.failure(error: apiError))
            case .success(data: let resultData):
                do {
                    let post = try decoder.decode(FullPost.self, from: resultData)
                    completion(.success(post: post))
                } catch (let parseError) {
                    completion(.failure(error: APIError(message: parseError.localizedDescription)))
                }
            }
        }
        task.resume()
    }

    enum BoardListResult {
        case failure(error: APIError)
        case success(data: Data)
    }
    static func getBoardList(completion: @escaping (BoardListResult) -> Void) {
        // Raw file is 13.3 MB but with HTTP compression by default,
        // network data usage should be actually around 750 KB.
        let task = URLSession.shared.dataTask(with: URL(string: "https://raw.githubusercontent.com/PttCodingMan/PTTBots/master/PttApp/BoardList.json")!) { (data, urlResponse, error) in
            let result = processResponse(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(error: let apiError):
                completion(.failure(error: apiError))
            case .success(data: let resultData):
                completion(.success(data: resultData))
            }
        }
        task.resume()
    }

    struct APIError : Codable {
        let message : String
    }
    private enum ProcessResult {
        case failure(error: APIError)
        case success(data: Data)
    }
    private static func processResponse(data: Data?, urlResponse: URLResponse?, error: Error?) -> ProcessResult {
        if let error = error {
            return .failure(error: APIError(message: error.localizedDescription))
        }
        if let httpURLResponse = urlResponse as? HTTPURLResponse {
            let statusCode = httpURLResponse.statusCode
            if httpURLResponse.statusCode != 200 {
                return .failure(error: APIError(message: "\(statusCode) \(HTTPURLResponse.localizedString(forStatusCode: statusCode))"))
            }
        }
        guard let resultData = data else {
            return .failure(error: (APIError(message: "No data")))
        }
        return .success(data: resultData)
    }
}
