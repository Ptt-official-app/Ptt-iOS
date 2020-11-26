//
//  MockURLSessionDataTask.swift
//  PttTests
//
//  Created by Anson on 2020/11/19.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
@testable import Ptt

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
