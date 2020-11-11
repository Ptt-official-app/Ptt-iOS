//
//  Message.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    struct Message : Codable {
        let error : String?
        let metadata : String?
    }
}
