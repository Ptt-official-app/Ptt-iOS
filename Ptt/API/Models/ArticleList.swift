//
//  ArticleList.swift
//  Ptt
//
//  Created by AnsonChen on 2023/4/29.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    struct ArticleList: Codable {
        var list: [ArticleSummary]
        var next_idx: String
    }

    struct ArticleSummary: Codable {
        var aid: String
        var bid: String
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
        var mode: FileMode
        var url: URL?
        var read: Bool
        var index: String
        var rank: Int
        var subjectType: SubjectType

        enum CodingKeys: String, CodingKey {
            case aid
            case bid
            case deleted
            case createTime = "create_time"
            case modified
            case recommend
            case comments = "n_comments"
            case owner
            case title
            case money
            case `class`
            case mode
            case url
            case read
            case index = "idx"
            case rank
            case subjectType = "subject_type"
        }

        init() {
            aid = String.random(length: 3)
            bid = String.random(length: 5)
            deleted = Bool.random()
            createTime = Date()
            modified = Date()
            recommend = Int.random(in: 1...10)
            comments = Int.random(in: 1...10)
            owner = String.random(length: 8)
            title = String.random(length: 58)
            money = Int.random(in: 10...100)
            `class` = String.random(length: 3)
            mode = .digest
            url = nil
            read = Bool.random()
            index = String.random(length: 8)
            rank = Int.random(in: 1...10)
            subjectType = .normal
        }

        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<APIModel.ArticleSummary.CodingKeys> = try decoder.container(keyedBy: APIModel.ArticleSummary.CodingKeys.self)
            self.aid = try container.decode(String.self, forKey: APIModel.ArticleSummary.CodingKeys.aid)
            self.bid = try container.decode(String.self, forKey: APIModel.ArticleSummary.CodingKeys.bid)
            self.deleted = try container.decode(Bool.self, forKey: APIModel.ArticleSummary.CodingKeys.deleted)
            self.createTime = try container.decode(Date.self, forKey: APIModel.ArticleSummary.CodingKeys.createTime)
            self.modified = try container.decode(Date.self, forKey: APIModel.ArticleSummary.CodingKeys.modified)
            self.recommend = try container.decode(Int.self, forKey: APIModel.ArticleSummary.CodingKeys.recommend)
            self.comments = try container.decode(Int.self, forKey: APIModel.ArticleSummary.CodingKeys.comments)
            self.owner = try container.decode(String.self, forKey: APIModel.ArticleSummary.CodingKeys.owner)
            self.title = try container.decode(String.self, forKey: APIModel.ArticleSummary.CodingKeys.title)
            self.money = try container.decode(Int.self, forKey: APIModel.ArticleSummary.CodingKeys.money)
            self.class = try container.decode(String.self, forKey: APIModel.ArticleSummary.CodingKeys.class)
            self.mode = try container.decode(APIModel.FileMode.self, forKey: APIModel.ArticleSummary.CodingKeys.mode)
            self.url = try container.decodeIfPresent(URL.self, forKey: APIModel.ArticleSummary.CodingKeys.url)
            self.read = try container.decode(Bool.self, forKey: APIModel.ArticleSummary.CodingKeys.read)
            self.index = try container.decode(String.self, forKey: APIModel.ArticleSummary.CodingKeys.index)
            self.rank = try container.decode(Int.self, forKey: APIModel.ArticleSummary.CodingKeys.rank)
            self.subjectType = try container.decode(APIModel.SubjectType.self, forKey: APIModel.ArticleSummary.CodingKeys.subjectType)
        }
    }

    struct FileMode: OptionSet, Codable {
        let rawValue: UInt

        static let none = FileMode([])
        static let local = FileMode(rawValue: 0x01)
        static let read = FileMode(rawValue: 0x01)
        static let marked = FileMode(rawValue: 0x02)
        static let digest = FileMode(rawValue: 0x04)
        static let replied = FileMode(rawValue: 0x04)
        // TODO, document has duplicated value, checking with BE
    }

    /// https://github.com/Ptt-official-app/go-pttbbs/blob/v0.16.2/ptttype/subject_type.go
    enum SubjectType: Int, Codable {
        case normal = 0
        case reply = 1
        case forward = 2
        case locked = 3
        case deleted = 4
        case unknown = -1
    }
}
