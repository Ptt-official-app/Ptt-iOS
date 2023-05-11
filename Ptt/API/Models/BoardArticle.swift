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
        let title: String
        let date: String
        let author: String

        let boardID: String
        let articleID: String
    }

    struct GoPttBBSBrdArticle: Codable {
        let title: String
        let create_time: TimeInterval
        let owner: String
        let bid: String
        let aid: String
        let recommend: Int
        let n_comments: Int
        let money: Int
        let idx: String
        let url: String
        let `class`: String

        static func adapter(model: GoPttBBSBrdArticle) -> BoardArticle {
            return BoardArticle(title: "[" + model.`class` + "]" + model.title,
                                date: Date(timeIntervalSince1970: model.create_time).toBoardDateString(),
                                author: model.owner,
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
            return BoardArticle(title: model.title, date: model.modified_time, author: model.owner, boardID: "", articleID: model.filename)
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
                title: model.title,
                date: model.date,
                author: model.author,
                boardID: boardName,
                articleID: filename
            )
            return boardArticle
        }
    }
}
