//
//  APITestClient.swift
//  PttTests
//
//  Created by Anson on 2020/11/27.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
@testable import Ptt

class APITestClient {
    func login() -> APIClientProtocol {
        
        guard let path = Bundle(for: type(of: self)).path(forResource: "Login", ofType: "json") else {
            fatalError("Login.json not found")
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let dataTask = MockURLSessionDataTask()
        let session = MockURLSession(mockDataTask: dataTask, fakeData: data, error: nil)
        let client = APIClient(session: session)
        return client
    }
    
    func newArticleClient() -> APIClientProtocol {
        guard let path = Bundle(for: type(of: self)).path(forResource: "BoardArticles", ofType: "json") else {
            fatalError("BoardArticles.json not found")
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let dataTask = MockURLSessionDataTask()
        let session = MockURLSession(mockDataTask: dataTask, fakeData: data, error: nil)
        let client = APIClient(session: session)
        return client
    }
    
    func getArticleClient() -> APIClientProtocol {
        guard let path = Bundle(for: type(of: self)).path(forResource: "Article", ofType: "json") else {
            fatalError("Article.json not found")
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let dataTask = MockURLSessionDataTask()
        let session = MockURLSession(mockDataTask: dataTask, fakeData: data, error: nil)
        let client = APIClient(session: session)
        return client
    }
    
    func getBoardList() -> APIClientProtocol {
        guard let path = Bundle(for: type(of: self)).path(forResource: "BoardList", ofType: "json") else {
            fatalError("BoardList.json not found")
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let dataTask = MockURLSessionDataTask()
        let session = MockURLSession(mockDataTask: dataTask, fakeData: data, error: nil)
        let client = APIClient(session: session)
        return client
    }
}
