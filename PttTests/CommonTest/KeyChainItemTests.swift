//
//  KeyChainItemTests.swift
//  PttTests
//
//  Created by AnsonChen on 2023/2/16.
//  Copyright © 2023 Ptt. All rights reserved.
//

@testable import Ptt
import XCTest

final class KeyChainItemTests: XCTestCase {
    private var sut: KeyChainItem!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = KeyChainItem()
        sut.delete(for: .unitTest)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut.delete(for: .unitTest)
        sut = nil
    }

    func testWriteReadText() {
        var cache = sut.readText(for: .unitTest)
        XCTAssertNil(cache)

        var text = String.random(length: 8)
        sut.save(text: text, for: .unitTest)
        cache = sut.readText(for: .unitTest)
        XCTAssertEqual(cache, text)

        text = String.random(length: 4)
        sut.save(text: text, for: .unitTest)
        cache = sut.readText(for: .unitTest)
        XCTAssertEqual(cache, text)
    }

    func testWriteReadObject() throws {
        let obj = APIModel.LoginToken(
            user_id: String.random(length: 5),
            access_token: String.random(length: 9),
            token_type: String.random(length: 4),
            refresh_token: String.random(length: 3)
        )
        sut.save(object: obj, for: .unitTest)
        let cache: APIModel.LoginToken = try XCTUnwrap(sut.readObject(for: .unitTest))
        XCTAssertEqual(cache.user_id, obj.user_id)
        XCTAssertEqual(cache.access_token, obj.access_token)
        XCTAssertEqual(cache.token_type, obj.token_type)
    }
}
