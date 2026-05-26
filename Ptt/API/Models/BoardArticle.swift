//
//  BoardArticle.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

extension APIModel {

    struct BoardArticle: Article {
        let bid: String
        let aid: String
        let subjectType: SubjectType
        let `class`: String
        let title: String
        let date: String
        let owner: String
        let recommend: Int

        let boardID: String
        let articleID: String

        enum CodingKeys: String, CodingKey {
            case bid
            case aid
            case title
            case date
            case owner
            case recommend
            case subjectType = "subject_type"
            case `class`
            case boardID
            case articleID
        }
    }

    struct GoPttBBSBrdArticle: Codable {
        let bid: String
        let aid: String
        let subjectType: SubjectType
        let `class`: String
        let title: String
        let create_time: TimeInterval
        let owner: String
        let recommend: Int
        let nComments: Int
        let money: Int
        let idx: String
        let url: String

        enum CodingKeys: String, CodingKey {
            case bid
            case aid
            case subjectType = "subject_type"
            case `class`
            case title
            case create_time
            case owner
            case recommend
            case nComments = "n_comments"
            case money
            case idx
            case url
        }

        static func adapter(model: GoPttBBSBrdArticle) -> BoardArticle {
            return BoardArticle(bid: model.bid,
                                aid: model.aid,
                                subjectType: model.subjectType,
                                class: model.class,
                                title: model.title,
                                date: Date(timeIntervalSince1970: model.create_time).toBoardDateString(),
                                owner: model.owner,
                                recommend: model.recommend,
                                boardID: model.bid,
                                articleID: model.aid)
        }

        func adapter() -> BoardArticle {
            return GoPttBBSBrdArticle.adapter(model: self)
        }
    }

    struct GoBBSBrdArticle: Codable {
        let title: String
        let modified_time: String
        let owner: String

        let filename: String

        static func adapter(model: GoBBSBrdArticle) -> BoardArticle {
            // TODO:
            return BoardArticle(bid: "", aid: "", subjectType: .normal, class: "", title: model.title, date: model.modified_time, owner: model.owner, recommend: 0, boardID: "", articleID: model.filename)
        }
    }

    struct LegacyBrdArticle: Codable {
        let title: String
        let href: String
        let author: String
        let date: String

        static func adapter(model: LegacyBrdArticle) -> BoardArticle? {
            guard let url = URL(string: "https://www.ptt.cc\(model.href)") else {
                return nil
            }
            let (boardName, filename) = APIModel.FullArticle.info(from: url)
            guard let boardName = boardName, let filename = filename else { return nil }
            let boardArticle = BoardArticle(
                bid: boardName,
                aid: filename,
                subjectType: .normal,
                class: "",
                title: model.title,
                date: model.date,
                owner: model.author,
                recommend: 0,
                boardID: boardName,
                articleID: filename
            )
            return boardArticle
        }
    }
}
