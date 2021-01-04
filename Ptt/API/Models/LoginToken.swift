//
//  LoginToken.swift
//  Ptt
//
//  Created by Anson on 2020/12/16.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
extension APIModel {
    struct LoginToken : Codable {
        let access_token : String
        let token_type : String
    }
}
