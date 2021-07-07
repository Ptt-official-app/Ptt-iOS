//
//  FullArticle.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

extension APIModel {

    struct FullArticle : Article {
        let title : String
        let date : String
        let author : String

        let board : String
        let nickname : String
        let content : String
        let comments : [Comment]

        let url : String
    }

    struct GoPttBBSArticle : Codable {
        let title : String
        let create_time : TimeInterval
        let owner : String

        let brdname : String
//        let content : [GoPttBBSArticleContent]
        let url : String

        static func adapter(model: GoPttBBSArticle) -> FullArticle {
            // TODO:
            return FullArticle(title: model.title, date: "\(model.create_time)", author: model.owner, board: model.brdname, nickname: "", content: "", comments: [APIModel.Comment](), url: model.url)
        }
    }

    struct GoBBSArticle : Codable {
        let data : GoBBSBrdArticleData

        struct GoBBSBrdArticleData : Codable {
            let raw : String
        }

        static func adapter(model: GoBBSArticle) -> FullArticle {
            // TODO:
            return FullArticle(title: "", date: "", author: "", board: "", nickname: "", content: "", comments: [APIModel.Comment](), url: "")
        }
    }

    struct LegacyArticle : Codable {
        let board : String
        let title : String
        let href : String
        let author : String
        let nickname : String
        let date : String
        let content : String
        let comments : [Comment]

        static func adapter(model: LegacyArticle) -> FullArticle {
            let fullArticle = FullArticle(title: model.title, date: model.date, author: model.author, board: model.board, nickname: model.nickname, content: model.content, comments: model.comments, url: model.href)
            return fullArticle
        }
    }
}
