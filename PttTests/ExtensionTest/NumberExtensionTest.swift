//
//  NumberExtensionTest.swift
//  PttTests
//
//  Created by Anson on 2021/12/10.
//  Copyright © 2021 Ptt. All rights reserved.
//

import XCTest
@testable import Ptt

class NumberExtensionTest: XCTestCase {

    func testEasyRead() {
        let num1 = 124
        XCTAssertEqual(num1.easyRead, "124")

        let num2 = 1234
        XCTAssertEqual(num2.easyRead, "1.2K")

        let num3 = 12345678
        XCTAssertEqual(num3.easyRead, "12.3M")
    }
}
