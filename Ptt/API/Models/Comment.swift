//
//  Comment.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
extension APIModel {
    struct Comment : Codable {
        let userid : String
        let content : String
        let iPdatetime : String
    }
}
