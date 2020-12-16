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
    
    struct BoardInfoList: Codable {
        let list: [BoardInfoV2]
        let next_idx: String
    }
    
    struct BoardInfoV2: Codable {
        let bid: String
        let brdname: String
        let title: String
        let flag: Int
        let type: String
        let `class`: String
        let nuser: Int
        let moderators: [String]
        let reason: String
        let read: Bool
        let total: Int
    }
}

