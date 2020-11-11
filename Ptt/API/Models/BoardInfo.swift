//
//  BoardInfo.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    struct BoardInfo : Codable {
        let name : String
        let nuser : String
        let `class` : String
        let title : String
        let href : String
        let maxSize : Int
    }
}
