//
//  LoginTokenTest.swift
//  PttTests
//
//  Created by Anson on 2023/9/3.
//  Copyright © 2023 Ptt. All rights reserved.
//
@testable import Ptt
import XCTest

final class LoginTokenTest: XCTestCase {

    func testTokenStatus_accessToken_doesNotExpire_shouldReturnNormal() {
        let sut = APIModel.LoginToken(
            user_id: "",
            access_token: "",
            token_type: "",
            refresh_token: "",
            access_expire: Date(timeIntervalSinceNow: 2000),
            refresh_expire: Date(timeIntervalSinceNow: 6000)
        )
        XCTAssertEqual(sut.tokenStatus, .normal)
    }

    func testTokenStatus_accessTokenIsExpired_refreshTokenIsGood_shouldReturnRefreshToken() {
        let sut = APIModel.LoginToken(
            user_id: "",
            access_token: "",
            token_type: "",
            refresh_token: "",
            access_expire: Date(timeIntervalSince1970: 50),
            refresh_expire: Date(timeIntervalSinceNow: 6000)
        )
        XCTAssertEqual(sut.tokenStatus, .refreshToken)
    }

    func testTokenStatus_refreshToken_doesNotExpire_shouldReturnReLogin() {
        let sut = APIModel.LoginToken(
            user_id: "",
            access_token: "",
            token_type: "",
            refresh_token: "",
            access_expire: Date(timeIntervalSince1970: 50),
            refresh_expire: Date(timeIntervalSince1970: 6000)
        )
        XCTAssertEqual(sut.tokenStatus, .reLogIn)
    }
}
