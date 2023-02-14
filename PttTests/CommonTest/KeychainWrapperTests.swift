//
//  KeychainWrapperTests.swift
//  PttTests
//
//  Created by AnsonChen on 2023/2/14.
//  Copyright © 2023 Ptt. All rights reserved.
//

import XCTest
@testable import Ptt

final class KeychainWrapperTests: XCTestCase {

    override func setUpWithError() throws {
        KeychainWrapper.clear()
    }

    override func tearDownWithError() throws {
        KeychainWrapper.clear()
    }

    func testSetText() throws {
        let value = String.random(length: 8)
        KeychainWrapper.set(text: value, for: .unitTest)
        let cache = try XCTUnwrap(KeychainWrapper.getText(for: .unitTest))
        XCTAssertEqual(cache, value)
    }

    func testSetCodable() throws {
        let userID = String.random(length: 9)
        let accessToken = String.random(length: 9)
        let tokenType = String.random(length: 8)
        let token = APIModel.LoginToken(
            user_id: userID,
            access_token: accessToken,
            token_type: tokenType
        )
        try KeychainWrapper.set(object: token, for: .unitTest)
        let cache: APIModel.LoginToken = try XCTUnwrap(KeychainWrapper.getObject(for: .unitTest))
        XCTAssertEqual(cache.user_id, userID)
        XCTAssertEqual(cache.access_token, accessToken)
        XCTAssertEqual(cache.token_type, tokenType)
    }
}
