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
    
    func newPostClient() -> APIClientProtocol {
        guard let path = Bundle.main.path(forResource: "NewPostlist", ofType: "json") else {
            fatalError("NewPostlist.json not found")
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let dataTask = MockURLSessionDataTask()
        let session = MockURLSession(mockDataTask: dataTask, fakeData: data, error: nil)
        let client = APIClient(session: session)
        return client
    }
    
    func getPostClient() -> APIClientProtocol {
        guard let path = Bundle.main.path(forResource: "GetPost", ofType: "json") else {
            fatalError("GetPost.json not found")
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let dataTask = MockURLSessionDataTask()
        let session = MockURLSession(mockDataTask: dataTask, fakeData: data, error: nil)
        let client = APIClient(session: session)
        return client
    }
}
