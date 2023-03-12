//
//  Register.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/22.
//  Copyright © 2022 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    struct Register: Codable {
        let user_id: String
        let access_token: String
        let token_type: String
    }
}
