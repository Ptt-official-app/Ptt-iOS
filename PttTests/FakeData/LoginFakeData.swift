//
//  LoginFakeData.swift
//  PttTests
//
//  Created by AnsonChen on 2023/3/22.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

enum LoginFakeData {
    static let successData: [String: Any] = [
        "user_id": "fake id",
        "access_token": "fake token",
        "token_type": "fake type",
        "refresh_token": "fake refresh token",
        "access_expire": 1694014793,
        "refresh_expire": 1697014793
    ]
}
