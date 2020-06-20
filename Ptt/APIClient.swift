//
//  APIClient.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

protocol Post : Codable {
    var category : String { get }
    var titleWithoutCategory : String { get }

    var title : String { get }
    var href : String { get }
    var author : String { get }
    var date : String { get }
}

extension Post {
    var category : String {
        if let leftBracket = title.firstIndex(of: "["), let rightBracket = title.firstIndex(of: "]") {
            let nextLeftBracket = title.index(after: leftBracket)
            let range = nextLeftBracket..<rightBracket
            let category = title[range]
            return String(category)
        }
        return "　　"
    }
    var titleWithoutCategory : String {
        if let leftBracket = title.firstIndex(of: "["), let rightBracket = title.firstIndex(of: "]") {
            var _title = title
            let nextRightBracket = _title.index(after: rightBracket)
            let range = leftBracket...nextRightBracket
            _title.removeSubrange(range)
            return _title
        }
        return title
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
        let title : String
        let href : String
        let author : String
        let date : String
    }
    struct BoardInfo : Codable {
        let name : String
        let nuser : String
        let `class` : String
        let title : String
        let href : String
        let maxSize : Int
    }
    struct Message : Codable {
        let error : String?
        let metadata : String?
    }
    struct Board : Codable {
        let page : Int
        let boardInfo : BoardInfo
        var postList : [BoardPost]
        let message : Message?
    }
    enum GetNewPostlistResult {
        case failure(error: APIError)
        case success(board: Board)
    }
    static func getNewPostlist(board: String, page: Int, completion: @escaping (GetNewPostlistResult) -> Void) {
        var urlComponent = rootURLComponents
        urlComponent.path = "/api/Article/\(board)"
        urlComponent.queryItems = [     // Percent encoding is automatically done with RFC 3986
            URLQueryItem(name: "page", value: "\(page)")
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
        let title : String
        let href : String
        let author : String
        let date : String
        let board : String
        let nickname : String
        let content : String
        let pushs : [Push]
    }
    struct Push : Codable {
        let userid : String
        let content : String
        let iPdatetime : String
    }
    enum GetPostResult {
        case failure(error: APIError)
        case success(post: Post)
    }
    static func getPost(board: String, filename: String, completion: @escaping (GetPostResult) -> Void) {
        var urlComponent = rootURLComponents
        urlComponent.path = "/api/Article/\(board)/\(filename)"
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
