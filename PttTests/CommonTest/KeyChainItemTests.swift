//
//  KeyChainItemTests.swift
//  PttTests
//
//  Created by AnsonChen on 2023/2/16.
//  Copyright © 2023 Ptt. All rights reserved.
//

import XCTest
@testable import Ptt

final class KeyChainItemTests: XCTestCase {

    override func setUpWithError() throws {
        KeyChainItem.delete(for: .unitTest)
    }

    override func tearDownWithError() throws {
        KeyChainItem.delete(for: .unitTest)
    }

    func testWriteReadText() {
        var cache = KeyChainItem.readText(for: .unitTest)
        XCTAssertNil(cache)

        var text = String.random(length: 8)
        KeyChainItem.save(text: text, for: .unitTest)
        cache = KeyChainItem.readText(for: .unitTest)
        XCTAssertEqual(cache, text)

        text = String.random(length: 4)
        KeyChainItem.save(text: text, for: .unitTest)
        cache = KeyChainItem.readText(for: .unitTest)
        XCTAssertEqual(cache, text)
    }

    func testWriteReadObject() throws {
        let obj = APIModel.LoginToken(
            user_id: String.random(length: 5),
            access_token: String.random(length: 9),
            token_type: String.random(length: 4)
        )
        KeyChainItem.save(object: obj, for: .unitTest)
        var cache: APIModel.LoginToken = try XCTUnwrap(KeyChainItem.readObject(for: .unitTest))
        XCTAssertEqual(cache.user_id, obj.user_id)
        XCTAssertEqual(cache.access_token, obj.access_token)
        XCTAssertEqual(cache.token_type, obj.token_type)
    }
}
