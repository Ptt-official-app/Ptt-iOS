//
//  BoardDetail.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/25.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

extension APIModel {

    struct BoardDetail: Codable {
        let boardID: String
        let boardName: String
        let title: String
        let flag: Int
        let type: String
        let `class`: String
        let numberOfUser: Int
        let moderators: [String]
        let reason: String
        let read: Bool
        let total: Int
        let lastPostTime: Int
        let voteLimitLogins: Int
        let postLimitLogins: Int
        let voteLimitBadPost: Int
        let postLimitBadPost: Int
        let vote: Int
        let vTime: Int
        let level: Int
        let lastSetTime: Int
        let linkPTTBoardID: Int
        let postTypes: [String]
        let endGamble: Int
        let pttBoardID: Int

        enum CodingKeys: String, CodingKey {
            case boardID = "bid"
            case boardName = "brdname"
            case title
            case flag
            case type
            case `class`
            case numberOfUser = "nuser"
            case moderators
            case reason
            case read
            case total
            case lastPostTime = "last_post_time"
            case voteLimitLogins = "vote_limit_logins"
            case postLimitLogins = "post_limit_logins"
            case voteLimitBadPost = "vote_limit_bad_post"
            case postLimitBadPost = "post_limit_bad_post"
            case vote
            case vTime = "vtime"
            case level
            case lastSetTime = "last_set_time"
            case linkPTTBoardID = "link_pttbid"
            case postTypes = "post_type"
            case endGamble = "end_gamble"
            case pttBoardID = "pttbid"
        }
    }
}
