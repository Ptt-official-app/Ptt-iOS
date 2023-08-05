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
        let user_id: String
        let access_token: String
        let token_type: String
        let refresh_token: String
    }
}
