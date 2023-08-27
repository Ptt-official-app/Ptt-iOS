//
//  BoardList.swift
//  PttTests
//
//  Created by AnsonChen on 2023/3/4.
//  Copyright © 2023 Ptt. All rights reserved.
//

@testable import Ptt

enum BoardListFakeData {
    static var successData: [String: Any] = [
        "list": [
            [
                "bid": "Baseball",
                "brdname": "Baseball",
                "title": "[棒球] 板主選舉投票中",
                "flag": 2097152,
                "type": "◎",
                "class": "棒球",
                "nuser": 14,
                "moderators": [
                    "test1"
                ],
                "reason": "",
                "read": true,
                "fav": false,
                "total": 19522,
                "last_post_time": 0,
                "stat_attr": 2,
                "url": "/board/Baseball/articles",
                "gid": 0,
                "pttbid": 13703,
                "idx": ""
            ],
            [
                "bid": "C_Chat",
                "brdname": "C_Chat",
                "title": "[希洽] 恭喜艾爾登法環榮獲GOTY",
                "flag": 2097152,
                "type": "◎",
                "class": "閒談",
                "nuser": 13,
                "moderators": [
                    "test1"
                ],
                "reason": "",
                "read": true,
                "fav": false,
                "total": 15965,
                "last_post_time": 0,
                "stat_attr": 2,
                "url": "/board/C_Chat/articles",
                "gid": 0,
                "pttbid": 14067,
                "idx": ""
            ],
            [
                "bid": "NBA",
                "brdname": "NBA",
                "title": "[NBA] Dwight Howard 來台打球",
                "flag": 2097152,
                "type": "◎",
                "class": "NBA.",
                "nuser": 11,
                "moderators": [
                    "test1"
                ],
                "reason": "",
                "read": true,
                "fav": false,
                "total": 1543,
                "last_post_time": 0,
                "stat_attr": 2,
                "url": "/board/NBA/articles",
                "gid": 0,
                "pttbid": 13810,
                "idx": ""
            ],
            [
                "bid": "Test",
                "brdname": "Test",
                "title": "[測試] 每週定期清除本板文章",
                "flag": 2097152,
                "type": "◎",
                "class": "嘰哩",
                "nuser": 10,
                "moderators": [
                    "test1"
                ],
                "reason": "",
                "read": true,
                "fav": false,
                "total": 30,
                "last_post_time": 0,
                "stat_attr": 2,
                "url": "/board/Test/articles",
                "gid": 0,
                "pttbid": 2569,
                "idx": ""
            ],
            [
                "bid": "PttApp",
                "brdname": "PttApp",
                "title": "測試與建議回饋的集散地",
                "flag": 10551296,
                "type": "◎",
                "class": "官方",
                "nuser": 9,
                "moderators": [
                    "teemocogs"
                ],
                "reason": "",
                "read": true,
                "fav": false,
                "total": 14,
                "last_post_time": 0,
                "stat_attr": 2,
                "url": "/board/PttApp/articles",
                "gid": 0,
                "pttbid": 14468,
                "idx": ""
            ],
            [
                "bid": "WhoAmI",
                "brdname": "WhoAmI",
                "title": "呵呵，猜猜我是誰！",
                "flag": 0,
                "type": "◎",
                "class": "嘰哩",
                "nuser": 9,
                "moderators": [],
                "reason": "",
                "read": true,
                "fav": false,
                "total": 7,
                "last_post_time": 0,
                "stat_attr": 2,
                "url": "/board/WhoAmI/articles",
                "gid": 5,
                "pttbid": 10,
                "idx": ""
            ]
        ],
        "next_idx": ""
    ]

    static func mockSuccessData(nextIdx: String, numOfBoards: Int) -> [String: Any] {
        let boards = [Int](1...numOfBoards).map { _ in
            return (try? APIModel.BoardInfo(brdname: String.random(length: 7), title: String.random(length: 3))
                .asDictionary()) ?? [:]
        }

        return [
            "list": boards,
            "next_idx": nextIdx
        ]
    }
}
