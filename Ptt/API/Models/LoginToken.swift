//
//  LoginToken.swift
//  Ptt
//
//  Created by Anson on 2020/12/16.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
extension APIModel {
    struct LoginToken: Codable {
        enum TokenStatus {
            case normal, refreshToken, reLogIn
        }

        let user_id: String
        let access_token: String
        let token_type: String
        let refresh_token: String
        let access_expire: Date
        let refresh_expire: Date

        var tokenStatus: TokenStatus {
            let now = Date()
            if access_expire > now {
                return .normal
            } else if now >= access_expire && now < refresh_expire {
                return .refreshToken
            } else {
                return .reLogIn
            }
        }
    }
}
