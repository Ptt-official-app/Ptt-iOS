//
//  StringExtensionTest.swift
//  PttTests
//
//  Created by Anson on 2021/12/10.
//  Copyright © 2021 Ptt. All rights reserved.
//

@testable import Ptt
import XCTest

class StringExtensionTest: XCTestCase {
    func testGetBoardName() throws {
        let url = "http://localhost/bbs/test/M.1234567900.A.125"
        XCTAssertEqual(url.getBorderName(), "test")

        let str = "random string"
        XCTAssertEqual(str.getBorderName(), "")

        let str2 = "http/localhost/bbs/test/M.1234567900.A.125"
        XCTAssertEqual(str2.getBorderName(), "")
    }
}
