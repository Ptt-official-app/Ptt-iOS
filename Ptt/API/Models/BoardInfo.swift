//
//  BoardInfo.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    
    struct BoardInfoList: Codable {
        let list: [BoardInfo]
        var next_idx: String? = nil
    }
    
    struct BoardInfo: Codable {
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
        let last_post_time: Int
        let stat_attr: Int
        var level_idx: String? = nil
        
        init(brdname: String, title: String, nuser: Int = 0) {
            self.bid = "bid"
            self.brdname = brdname
            self.title = title
            self.flag = 0
            self.type = ""
            self.class = ""
            self.nuser = nuser
            self.moderators = []
            self.reason = ""
            self.read = false
            self.total = 0
            self.last_post_time = 0
            self.stat_attr = 0
        }
    }
}

