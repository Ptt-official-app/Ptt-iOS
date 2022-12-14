//
//  APIClient.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

struct APIClient {
    private enum Method: String {
        case GET = "GET"
        case POST = "POST"
        case DELETE = "DELETE"
        case PUT = "PUT"
    }
    static let shared: APIClient = APIClient()

    private var legacyURLComponents : URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "webptt.azurewebsites.net"
        return urlComponent
    }

    private var go_pttbbs_URLComponents : URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.devptt.dev"
        return urlComponent
    }

    private var go_bbs_URLComponents : URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "pttapp.cc"
        return urlComponent
    }
    
    private var rootURLComponents : URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        if let address = URL(string: UserDefaultsManager.address()) {
            urlComponent.host = address.host
            urlComponent.port = address.port
        }
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
        
        var urlComponent = rootURLComponents
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
    
    /**
     api attemptregister:
     backend will send verify email, get number for next api: register
     */
    func attemptRegister(account: String, email: String, completion: @escaping (AttemptRegisterResult) -> Void) {
        let bodyDic = ["client_id": "test_client_id",
                       "client_secret": "test_client_secret",
                       "username": account,
                       "email": email]
        
        var urlComponent = rootURLComponents
        urlComponent.path = "/api/account/attemptregister"
        guard let url = urlComponent.url,
              let jsonBody = try? JSONSerialization.data(withJSONObject: bodyDic) else {
            assertionFailure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = jsonBody
        
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            let result = self.processResponseWithErrorMSG(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(let apiError):
                completion(.failure(apiError))
            case .success(let resultData):
                do {
                    let token = try self.decoder.decode(APIModel.AttemptRegister.self, from: resultData)
                    completion(.success(token))
                } catch (let decodingError) {
                    let message = self.message(of: decodingError)
                    completion(.failure(APIError(message: message)))
                }
            }
        }
        task.resume()
    }
    
    
    /**
     api tregister:
     over18 or other information can be update later
     the email field still not comfrm
     token: verify code six digit
     */
    func register(account: String, email: String, password:String, token:String, completion: @escaping (RegisterResult) -> Void) {
        
        
        let bodyDic = ["client_id": "test_client_id",
                       "client_secret": "test_client_secret",
                       "username": account,
                       "password": password,
                       "password_confirm": password,
                       "over18": false,
                       "email": email,
                       "token": token] as [String : Any]
        
        var urlComponent = rootURLComponents
        urlComponent.path = "/api/account/register"
        guard let url = urlComponent.url,
              let jsonBody = try? JSONSerialization.data(withJSONObject: bodyDic) else {
            assertionFailure()
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = jsonBody
        
        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            let result = self.processResponseWithErrorMSG(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(let apiError):
                completion(.failure(apiError))
            case .success(let resultData):
                do {
                    let token = try self.decoder.decode(APIModel.Register.self, from: resultData)
                    completion(.success(token))
                } catch (let decodingError) {
                    let message = self.message(of: decodingError)
                    completion(.failure(APIError(message: message)))
                }
            }
        }
        task.resume()
    }
    
    
    
    func getBoardArticles(of params: BoardArticlesParams, completion: @escaping (getBoardArticlesResult) -> Void) {
        var urlComponent : URLComponents
        switch params {
        case .go_pttbbs(bid: let bid, startIdx: let startIdx):
            urlComponent = go_pttbbs_URLComponents
            urlComponent.path = "/api/board/\(bid)/articles"
            // Percent encoding is automatically done with RFC 3986
            urlComponent.queryItems = [
                URLQueryItem(name: "start_idx", value: startIdx)
            ]
        case .go_bbs(boardID: let boardID):
            urlComponent = go_bbs_URLComponents
            urlComponent.path = "/v1/boards/\(boardID)/articles"
        case .legacy(boardName: let boardName, page: let page):
            urlComponent = legacyURLComponents
            urlComponent.path = "/api/Article/\(boardName)"
            urlComponent.queryItems = [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        }
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
                    let board : APIModel.BoardModel
                    switch params {
                    case .go_pttbbs(bid: _, startIdx: _):
                        let _board = try self.decoder.decode(APIModel.GoPttBBSBoard.self, from: resultData)
                        board = APIModel.GoPttBBSBoard.adapter(model: _board)
                    case .go_bbs(boardID: _):
                        let _board = try self.decoder.decode(APIModel.GoBBSBoard.self, from: resultData)
                        board = APIModel.GoBBSBoard.adapter(model: _board)
                    case .legacy(boardName: _, page: _):
                        let _board = try self.decoder.decode(APIModel.LegacyBoard.self, from: resultData)
                        board = APIModel.LegacyBoard.adapter(model: _board)
                    }
                    completion(.success(board))
                } catch (let decodingError) {
                    let message = self.message(of: decodingError)
                    completion(.failure(APIError(message: message)))
                }
            }
        }
        task.resume()
    }

    func getArticle(of params: ArticleParams, completion: @escaping (GetArticleResult) -> Void) {
        var urlComponent : URLComponents
        switch params {
        case .go_pttbbs(bid: let bid, aid: let aid):
            urlComponent = go_pttbbs_URLComponents
            urlComponent.path = "/api/board/\(bid)/article/\(aid)"
        case .go_bbs(boardID: let boardID, articleID: let articleID):
            urlComponent = go_bbs_URLComponents
            urlComponent.path = "/v1/boards/\(boardID)/articles/\(articleID)"
        case .legacy(boardName: let boardName, filename: let filename):
            urlComponent = legacyURLComponents
            urlComponent.path = "/api/Article/\(boardName)/\(filename)"
        }
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
                    let article : APIModel.FullArticle
                    switch params {
                    case .go_pttbbs(bid: _, aid: _):
                        let _article = try self.decoder.decode(APIModel.GoPttBBSArticle.self, from: resultData)
                        article = APIModel.GoPttBBSArticle.adapter(model: _article)
                    case .go_bbs(boardID: _, articleID: _):
                        let _article = try self.decoder.decode(APIModel.GoBBSArticle.self, from: resultData)
                        article = APIModel.GoBBSArticle.adapter(model: _article)
                    case .legacy(boardName: _, filename: _):
                        let _article = try self.decoder.decode(APIModel.LegacyArticle.self, from: resultData)
                        article = APIModel.LegacyArticle.adapter(model: _article)
                    }
                    completion(.success(article))
                } catch (let decodingError) {
                    let message = self.message(of: decodingError)
                    completion(.failure(APIError(message: message)))
                }
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
    func getBoardList(token: String, keyword: String="", startIdx: String="", max: Int=200, completion: @escaping (BoardListResult) -> Void) {
        
        let matcherEnglish = MyRegex("^[a-zA-Z]+$")
        let matcherChinese = MyRegex("^[\\u4e00-\\u9fa5]+$")
        var urlComponent = rootURLComponents
        
        urlComponent.path = matcherEnglish.match(input: keyword) ?
                    "/api/boards/autocomplete" : matcherChinese.match(input: keyword) ?
                    "/api/boards/byclass" : "/api/boards"
        
        let keywordQueryItemName = matcherEnglish.match(input: keyword) ? "brdname" : "keyword"
        // Percent encoding is automatically done with RFC 3986
        urlComponent.queryItems = [
            URLQueryItem(name: keywordQueryItemName, value: keyword),
            URLQueryItem(name: "start_idx", value: startIdx),
            URLQueryItem(name: "limit", value: "\(max)")
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
    
    func getPopularBoards(subPath: String, token: String, querys: Dictionary<String, Any>=[:], completion: @escaping (BoardListResult) -> Void) {
        var urlComponent = rootURLComponents
        urlComponent.path = "/api/"+subPath

        urlComponent.queryItems = []
        if (querys.count > 0) {
            for (key, value) in querys {
                urlComponent.queryItems?.append(URLQueryItem(name: key, value: value as? String))
            }
        }

        guard let url = urlComponent.url else {
            assertionFailure()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = Method.GET.rawValue
//        request.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")

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
    
    func createArticle(boardId: String, article: APIModel.CreateArticle, completion: @escaping (createArticleResult) -> Void) {
        var urlComponent = rootURLComponents
        urlComponent.path = "/api/board/" + boardId + "/article"
        
        guard let url = urlComponent.url,
              let jsonBody = try? JSONEncoder().encode(article) else {
            assertionFailure()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = jsonBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(LoginKeyChainItem.shared.readToken()!)", forHTTPHeaderField: "Authorization")

        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            let result = self.processResponse(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(let apiError):
                completion(.failure(apiError))
            case .success(let resultData):
                do {
                    let response = try self.decoder.decode(APIModel.CreateArticleResponse.self, from: resultData)
                    completion(.success(response))
                } catch (let decodingError) {
                    let message = self.message(of: decodingError)
                    completion(.failure(APIError(message: message)))
                }
            }
        }
        task.resume()
    }

    func getPopularArticles(startIdx: String, limit: Int, desc: Bool, completion: @escaping (PopularArticlesResult) -> Void) {
        var urlComponent = rootURLComponents
        urlComponent.path = "/api/articles/popular"

        let limit = min(200, limit)
        let desc = desc ? "true": "false"
        urlComponent.queryItems = [
            URLQueryItem(name: "start_idx", value: startIdx),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "desc", value: desc)
        ]

        guard let url = urlComponent.url else {
            assertionFailure()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = Method.GET.rawValue

        let task = self.session.dataTask(with: request) { (data, urlResponse, error) in
            let result = self.processResponse(data: data, urlResponse: urlResponse, error: error)
            switch result {
            case .failure(let apiError):
                completion(.failure(apiError))
            case .success(let resultData):
                do {
                    let result = try self.decoder.decode(APIModel.GoPttBBSBoard.self, from: resultData)
                    completion(.success(result))
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
    
    /**
     Temp for get Register/AttmentRegister Error msg
     */
    private func processResponseWithErrorMSG(data: Data?, urlResponse: URLResponse?, error: Error?) -> ProcessResult {
        
        var error_msg:String = "" ;
        do {
            if let d = data {
                let errorDict = try decoder.decode(APIModel.ErrorMsg.self, from: d)
                error_msg = errorDict.Msg
                print("get server message=", errorDict.Msg)
            }
        } catch (let decodingError) {
            print("Decode error:", decodingError) ;
        }

            
        if let error = error {
            return .failure(APIError(message: "\(error):\(error_msg)"))
        }
        
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            return .failure(APIError(message: error_msg))
        }
    
        let statusCode = httpURLResponse.statusCode
        if statusCode != 200 {
            return .failure(APIError(message: "\(statusCode) \(HTTPURLResponse.localizedString(forStatusCode: statusCode)) : \(error_msg)"))
        }
        
        guard let resultData = data else {
            return .failure(APIError(message: error_msg))
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
    
    struct MyRegex {
        let regex: NSRegularExpression?
        init(_ pattern: String) {
            regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        }

        func match(input: String) -> Bool {
            if let matches = regex?.matches(in: input, options: [],
                                            range: NSMakeRange(0, (input as NSString).length)) {
                return matches.count > 0
            }else {
                return false
            }
        }
    }
}
