//
//  GetArticleFakeData.swift
//  PttTests
//
//  Created by AnsonChen on 2023/3/22.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

enum GetArticleFakeData {
    static let successData: [String: Any] = [
        "board": "MyBoard",
        "title": "[問卦] 有沒有問卦的八卦",
        "href": "https://www.ptt.cc/bbs/Gossiping/M.392837.A.F25.html",
        "author": "user3",
        "nickname": "ewfsfsdf",
        "date": "Thu Nov 19 21:20:42 2020",
        "content": "你好，我也不知道這是在問什麼 QQ",
        "comments": [
            [
                "tag": "→",
                "userid": "user2",
                "content": ": 菜雞下去",
                "iPdatetime": " 11/19 21:21\n"
            ],
            [
                "tag": "推",
                "userid": "user2",
                "content": ": 叫學長啦",
                "iPdatetime": " 11/19 21:21\n"
            ]
        ]
    ]
}
