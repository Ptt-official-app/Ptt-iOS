//
//  Board.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

extension APIModel {

    struct BoardModel : Codable {
        let page : Int?     // offset-based pagination
        let next : String?  // cursor-based pagination
        var articleList : [BoardArticle]
    }

    struct GoPttBBSBoard : Codable {
        let list : [GoPttBBSBrdArticle]
        let next_idx : String

        static func adapter(model: GoPttBBSBoard) -> BoardModel {
            var articleList = [BoardArticle]()
            for item in model.list {
                let article = GoPttBBSBrdArticle.adapter(model: item)
                articleList.append(article)
            }
            return BoardModel(page: nil, next: nil, articleList: articleList)
        }
    }

    struct GoBBSBoard : Codable {
        let data : GoBBSBoardData

        struct GoBBSBoardData : Codable {
            let items : [GoBBSBrdArticle]
        }

        static func adapter(model: GoBBSBoard) -> BoardModel {
            var articleList = [APIModel.BoardArticle]()
            for item in model.data.items {
                let article = GoBBSBrdArticle.adapter(model: item)
                articleList.append(article)
            }
            return BoardModel(page: nil, next: nil, articleList: articleList)
        }
    }

    struct LegacyBoard : Codable {
        let page : Int
        var postList : [LegacyBrdArticle]

        static func adapter(model: LegacyBoard) -> BoardModel {
            var articleList = [BoardArticle]()
            for post in model.postList {
                if let article = LegacyBrdArticle.adapter(model: post) {
                    articleList.append(article)
                }
            }
            let model = BoardModel(page: model.page,
                                   next: nil,
                                   articleList: articleList)
            return model
        }
    }
}
