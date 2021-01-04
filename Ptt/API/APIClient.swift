//
//  APIClient.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

class APIClient {
    private enum Method: String {
        case GET = "GET"
        case POST = "POST"
        case DELETE = "DELETE"
        case PUT = "PUT"
    }
    static let shared: APIClient = APIClient()
    
    private var rootURLComponents : URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "webptt.azurewebsites.net"
        return urlComponent
    }
    
    private var tempURLComponents : URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "www.devptt.site"
        return urlComponent
    }
    
    private var pttURLComponents : URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "www.ptt.cc"
        return urlComponent
    }

    private let decoder = JSONDecoder()
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol=URLSession.shared) {
        self.session = session
    }
}

// MARK: Public api function
extension APIClient: APIClientProtocol {
    func login(account: String, password: String, completion: @escaping (LoginResult) -> Void) {
        let bodyDic = ["client_id": "test_client_id",
                       "client_secret": "test_client_secret",
                       "username": account,
                       "password": password]
        
        var urlComponent = tempURLComponents
        urlComponent.path = "/api/account/login"
        guard let url = urlComponent.url,
              let jsonBody = try? JSONSerialization.data(withJSONObject: bodyDic) else {
            assertionFailure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = jsonBody
        
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            let result = self.processResponse(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(let apiError):
                completion(.failure(apiError))
            case .success(let resultData):
                do {
                    let token = try self.decoder.decode(APIModel.LoginToken.self, from: resultData)
                    completion(.success(token))
                } catch (let decodingError) {
                    let message = self.message(of: decodingError)
                    completion(.failure(APIError(message: message)))
                }
            }
        }
        task.resume()
    }
    
    func getNewPostlist(board: String, page: Int, completion: @escaping (GetNewPostlistResult) -> Void) {
        var urlComponent = rootURLComponents
        urlComponent.path = "/api/Article/\(board)"
        // Percent encoding is automatically done with RFC 3986
        urlComponent.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let url = urlComponent.url else {
            assertionFailure()
            return
        }
        let task = self.session.dataTask(with: url) {(data, urlResponse, error) in
            let result = self.processResponse(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(let apiError):
                completion(.failure(apiError))
            case .success(let resultData):
                do {
                    let board = try self.decoder.decode(APIModel.Board.self, from: resultData)
                    completion(.success(board))
                } catch (let decodingError) {
                    let message = self.message(of: decodingError)
                    completion(.failure(APIError(message: message)))
                }
            }
        }
        task.resume()
    }

    func getPost(board: String, filename: String, completion: @escaping (GetPostResult) -> Void) {
        var urlComponent = rootURLComponents
        urlComponent.path = "/api/Article/\(board)/\(filename)"
        guard let url = urlComponent.url else {
            assertionFailure()
            return
        }
        let task = self.session.dataTask(with: url) { (data, urlResponse, error) in
            let result = self.processResponse(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(let apiError):
                completion(.failure(apiError))
            case .success(let resultData):
                do {
                    let post = try self.decoder.decode(APIModel.FullPost.self, from: resultData)
                    completion(.success(post))
                } catch (let decodingError) {
                    let message = self.message(of: decodingError)
                    completion(.failure(APIError(message: message)))
                }
            }
        }
        task.resume()
    }

    func getBoardList(completion: @escaping (BoardListResult) -> Void) {
        // Raw file is 13.3 MB but with HTTP compression by default,
        // network data usage should be actually around 750 KB.
        let url = URL(string: "https://raw.githubusercontent.com/PttCodingMan/PTTBots/master/PttApp/BoardList.json")!
        let task = self.session.dataTask(with: url) { (data, urlResponse, error) in
            let result = self.processResponse(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(error: let apiError):
                completion(.failure(apiError))
            case .success(data: let resultData):
                completion(.success(resultData))
            }
        }
        task.resume()
    }
    
    
    /// Get board list
    /// - Parameters:
    ///   - token: access token
    ///   - keyword: query string, '' returns all boards
    ///   - startIdx: starting idx, '' if fetch from the beginning.
    ///   - max: max number of the returned list, requiring <= 300
    ///   - completion: the list of board information
    func getBoardListV2(token: String, keyword: String="", startIdx: String="", max: Int=300, completion: @escaping (BoardListResultV2) -> Void) {
        var urlComponent = tempURLComponents
        urlComponent.path = "/api/boards"
        // Percent encoding is automatically done with RFC 3986
        urlComponent.queryItems = [
            URLQueryItem(name: "keyword", value: keyword),
            URLQueryItem(name: "startIdx", value: startIdx),
            URLQueryItem(name: "max", value: "\(max)")
        ]
        guard let url = urlComponent.url else {
            assertionFailure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Method.GET.rawValue
        request.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            let result = self.processResponse(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(let apiError):
                completion(.failure(apiError))
            case .success(let resultData):
                do {
                    let list = try self.decoder.decode(APIModel.BoardInfoList.self, from: resultData)
                    completion(.success(list))
                } catch (let decodingError) {
                    let message = self.message(of: decodingError)
                    completion(.failure(APIError(message: message)))
                }
            }
        }
        task.resume()
    }
}

// MARK: Private helper function
extension APIClient {
    private func processResponse(data: Data?, urlResponse: URLResponse?, error: Error?) -> ProcessResult {
        if let error = error {
            return .failure(APIError(message: error.localizedDescription))
        }
        
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            return .failure(APIError(message: "No data"))
        }
    
        let statusCode = httpURLResponse.statusCode
        if statusCode != 200 {
            return .failure(APIError(message: "\(statusCode) \(HTTPURLResponse.localizedString(forStatusCode: statusCode))"))
        }
        
        guard let resultData = data else {
            return .failure(APIError(message: "No data"))
        }
        
        return .success(resultData)
    }

    private func message(of decodingError: Error) -> String {
        guard let error = decodingError as? DecodingError else {
            return decodingError.localizedDescription
        }
        
        let message : String
        switch error {
        case .typeMismatch(_, let context):
            message = context.debugDescription + " \(context.codingPath.map({$0.stringValue}))"
        case .valueNotFound( _, let context):
            message = context.debugDescription + " \(context.codingPath.map({$0.stringValue}))"
        case .keyNotFound(_, let context):
            message = context.debugDescription
        case .dataCorrupted(let context):
            message = context.debugDescription
        @unknown default:
            message = "unknowd error value"
        }
        
        return message
    }

}
