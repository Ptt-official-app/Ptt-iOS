//
//  MockURLSession.swift
//  PttTests
//
//  Created by Anson on 2020/11/19.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
@testable import Ptt

class MockURLSession: URLSessionProtocol {
    private let error: Error?
    private let mockDataTask: MockURLSessionDataTask
    private let fakeData: Data?
    private let statusCode: Int
    
    init(mockDataTask: MockURLSessionDataTask, fakeData: Data?=nil, error: Error?=nil, statusCode: Int=200) {
        self.error = error
        self.mockDataTask = mockDataTask
        self.fakeData = fakeData
        self.statusCode = statusCode
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        
        if let _error = self.error {
            completionHandler(nil, nil, _error)
            return self.mockDataTask
        }
        
        if let _data = self.fakeData {
            let response = self.mockHttpURLResponse(request: request)
            completionHandler(_data, response, nil)
            return self.mockDataTask
        }
        
        let response = self.mockHttpURLResponse(request: request)
        completionHandler(nil, response, nil)
        return self.mockDataTask
    }
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        let req = URLRequest(url: url)
        return self.dataTask(with: req, completionHandler: completionHandler)
    }
}

// MARK: Private
extension MockURLSession {
    
    private func mockHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!,
                               statusCode: self.statusCode,
                               httpVersion: "HTTP/1.1", headerFields: nil)!
    }
}
