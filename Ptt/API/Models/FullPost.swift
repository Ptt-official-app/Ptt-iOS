//
//  FullPost.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
extension APIModel {
    struct FullPost : Post {
        let title : String
        let href : String
        let author : String
        let date : String
        let board : String
        let nickname : String
        let content : String
        let comments : [Comment]
    }
}
