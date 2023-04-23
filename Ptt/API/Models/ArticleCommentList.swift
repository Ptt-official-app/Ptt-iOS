//
//  ArticleCommentList.swift
//  Ptt
//
//  Created by AnsonChen on 2023/4/29.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    struct ArticleCommentList: Codable {
        var list: [ArticleComment]
        var next_idx: String
    }

    struct ArticleComment: Codable {
        var aid: String
        var bid: String
        var cid: String
        /// is deleted
        var deleted: Bool
        var createTime: Date
        var modified: Date
        var recommend: Int
        var comments: Int
        var owner: String
        var title: String
        var money: Int
        var `class`: String
        var url: URL?
        var read: Int
        var index: String
        var rank: Int
        var commentType: CommentType
        var commentTime: Date
        var comment: [[ContentProperty]]
        var plainComment: String {
            comment.map { $0.map { $0.text }.joined() }.joined()
        }

        enum CodingKeys: String, CodingKey {
            case aid
            case bid
            case cid
            case deleted
            case createTime = "create_time"
            case modified
            case recommend
            case comments = "n_comments"
            case owner
            case title
            case money
            case `class`
            case url
            case read
            case index = "idx"
            case rank
            case commentType = "ctype"
            case commentTime = "ctime"
            case comment
        }

        init() {
            aid = String.random(length: 3)
            bid = String.random(length: 5)
            cid = String.random(length: 4)
            deleted = Bool.random()
            createTime = Date()
            modified = Date()
            recommend = Int.random(in: 1...10)
            comments = Int.random(in: 1...10)
            owner = String.random(length: 8)
            title = String.random(length: 59)
            money = Int.random(in: 10...100)
            `class` = String.random(length: 3)
            url = nil
            read = Int.random(in: 2...7)
            index = String.random(length: 8)
            rank = Int.random(in: 1...10)
            commentType = .recommend
            commentTime = Date()
            comment = [[
                .init(text: String.random(length: 8)),
                .init(text: String.random(length: 38))
            ]]
        }

        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<APIModel.ArticleComment.CodingKeys> = try decoder.container(keyedBy: APIModel.ArticleComment.CodingKeys.self)
            self.aid = try container.decode(String.self, forKey: APIModel.ArticleComment.CodingKeys.aid)
            self.bid = try container.decode(String.self, forKey: APIModel.ArticleComment.CodingKeys.bid)
            self.cid = try container.decode(String.self, forKey: APIModel.ArticleComment.CodingKeys.cid)
            self.deleted = try container.decode(Bool.self, forKey: APIModel.ArticleComment.CodingKeys.deleted)
            self.createTime = try container.decode(Date.self, forKey: APIModel.ArticleComment.CodingKeys.createTime)
            self.modified = try container.decode(Date.self, forKey: APIModel.ArticleComment.CodingKeys.modified)
            self.recommend = try container.decode(Int.self, forKey: APIModel.ArticleComment.CodingKeys.recommend)
            self.comments = try container.decode(Int.self, forKey: APIModel.ArticleComment.CodingKeys.comments)
            self.owner = try container.decode(String.self, forKey: APIModel.ArticleComment.CodingKeys.owner)
            self.title = try container.decode(String.self, forKey: APIModel.ArticleComment.CodingKeys.title)
            self.money = try container.decode(Int.self, forKey: APIModel.ArticleComment.CodingKeys.money)
            self.class = try container.decode(String.self, forKey: APIModel.ArticleComment.CodingKeys.class)
            self.url = try container.decodeIfPresent(URL.self, forKey: APIModel.ArticleComment.CodingKeys.url)
            self.read = try container.decode(Int.self, forKey: APIModel.ArticleComment.CodingKeys.read)
            self.index = try container.decode(String.self, forKey: APIModel.ArticleComment.CodingKeys.index)
            self.rank = try container.decode(Int.self, forKey: APIModel.ArticleComment.CodingKeys.rank)
            self.commentType = try container.decode(APIModel.CommentType.self, forKey: APIModel.ArticleComment.CodingKeys.commentType)
            self.commentTime = try container.decode(Date.self, forKey: APIModel.ArticleComment.CodingKeys.commentTime)
            self.comment = try container.decode([[APIModel.ContentProperty]].self, forKey: APIModel.ArticleComment.CodingKeys.comment)
        }
    }

    enum CommentType: Int, Codable {
        case unknown = 0
        case recommend
        case boo
        case comment
        case forward
        case reply
        case edit
        case deleted
        case basic
        case basicDate
    }
}
