//
//  GetBoardArticlesFakeData.swift
//  PttTests
//
//  Created by AnsonChen on 2023/3/22.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

enum GetBoardArticlesFakeData {
    static let successData: [String: Any] = [
        "page": 1,
        "boardInfo": [
            "name": "MyBoard",
            "nuser": "21471",
            "class": "",
            "title": "這是版標",
            "href": "/bbs/MyBoard/index.html",
            "maxSize": 39_314
        ],
        "postList": [
            [
                "title": "Re: [問卦] 這是測試嗎",
                "href": "/bbs/Gossiping/M.27372.A.943.html",
                "author": "user1",
                "date": "11/19",
                "board": "MyBoard",
                "aid": "aaa",
                "goup": 0,
                "down": 0
            ],
            [
                "title": "Re: [問卦] 有沒有五樓的八卦",
                "href": "/bbs/Gossiping/M.27372.A.943.html",
                "author": "user2",
                "date": "11/19",
                "board": "MyBoard",
                "aid": "vvv",
                "goup": 0,
                "down": 0
            ]
        ]
    ]
}
