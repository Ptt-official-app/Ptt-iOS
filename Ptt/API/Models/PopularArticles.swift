//
//  PopularArticles.swift
//  Ptt
//
//  Created by Anson on 2021/12/5.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation
extension APIModel {
    struct PopularArticleList: Codable {
        let list: [ArticleInfo]
        let next_idx: String
    }

    struct ArticleInfo: Codable {
        let bid: String
        let aid: String
        let deleted: Bool
        let create_time: Int
        let modified: Int
        let recommend: Int
        let n_comments: Int
        let owner: String
        let title: String
        let money: Int
        let `class`: String
        let mode: Int
        let url: String
        let read: Bool
        let idx: String
        let rank: Int
        let subject_type: Int
    }
}
