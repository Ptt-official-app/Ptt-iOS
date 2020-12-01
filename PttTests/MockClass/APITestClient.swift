//
//  APITestClient.swift
//  PttTests
//
//  Created by Anson on 2020/11/27.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
@testable import Ptt

struct APITestClient {
    static func newPostClient() -> APIClientProtocol {
        guard let path = Bundle.main.path(forResource: "NewPostlist", ofType: "json") else {
            fatalError("NewPostlist.json not found")
        }
        let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        
        let dataTask = MockURLSessionDataTask()
        let session = MockURLSession(mockDataTask: dataTask, fakeData: data, error: nil)
        let client = APIClient(session: session)
        return client
    }
    
    static func getPostClient() -> APIClientProtocol {
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
