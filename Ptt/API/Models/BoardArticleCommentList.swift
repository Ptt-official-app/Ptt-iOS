//
//  BoardArticleCommentList.swift
//  Ptt
//
//  Created by denkeni on 2026/5/11.
//  Copyright © 2026 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    /// Response of GET /api/board/{bid}/article/{aid}/comments
    struct BoardArticleCommentList: Codable {
        var list: [BoardArticleComment]
        var nextIdx: String
        var tokenuser: String?

        enum CodingKeys: String, CodingKey {
            case list
            case nextIdx = "next_idx"
            case tokenuser
        }
    }

    /// A single comment on an article (push/boo/arrow). The `type` field is an Int
    /// matching APIModel.CommentType. See:
    /// https://github.com/Ptt-official-app/go-pttbbs/blob/main/ptttype/comment_type.go
    struct BoardArticleComment: Codable, Hashable {
        var bid: String
        var aid: String
        var cid: String
        var type: CommentType
        var refid: String?
        var deleted: Bool
        var createTime: Date
        var sortTime: Date
        var owner: String
        var content: [[ContentProperty]]
        var ip: String?
        var host: String?
        var idx: String
        var tokenuser: String?

        var plainContent: String {
            content.map { $0.map(\.text).joined() }.joined()
        }

        enum CodingKeys: String, CodingKey {
            case bid
            case aid
            case cid
            case type
            case refid
            case deleted
            case createTime = "create_time"
            case sortTime = "sort_time"
            case owner
            case content
            case ip
            case host
            case idx
            case tokenuser
        }

        static func == (lhs: BoardArticleComment, rhs: BoardArticleComment) -> Bool {
            lhs.idx == rhs.idx && lhs.cid == rhs.cid
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(idx)
            hasher.combine(cid)
        }
    }
}
