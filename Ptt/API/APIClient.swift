//
//  APIClient.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

class APIClient {
    static let shared: APIClient = APIClient()
    
    private var rootURLComponents : URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "webptt.azurewebsites.net"
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
