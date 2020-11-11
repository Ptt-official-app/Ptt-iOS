//
//  Board.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    struct Board : Codable {
        let page : Int
        let boardInfo : BoardInfo
        var postList : [BoardPost]
        let message : Message?
    }
}
