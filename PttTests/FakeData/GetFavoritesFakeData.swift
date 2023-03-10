//
//  GetFavoritesFakeData.swift
//  PttTests
//
//  Created by AnsonChen on 2023/2/28.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

enum GetFavoritesFakeData {
    static var successfulResponse: String {
        """
{
  "list": [
    {
      "bid": "SYSOP",
      "brdname": "SYSOP",
      "title": "站長好!",
      "flag": 32,
      "type": "◎",
      "class": "嘰哩",
      "nuser": 0,
      "moderators": [],
      "reason": "",
      "read": false,
      "total": 0,
      "last_post_time": 0,
      "stat_attr": 1,
      "gid": 2,
      "pttbid": 1,
      "idx": "0"
    },
    {
      "bid": "PttApp",
      "brdname": "PttApp",
      "title": "測試與建議回饋的集散地",
      "flag": 10551296,
      "type": "◎",
      "class": "官方",
      "nuser": 0,
      "moderators": [
        "teemocogs"
      ],
      "reason": "",
      "read": false,
      "total": 14,
      "last_post_time": 1677510550,
      "stat_attr": 1,
      "gid": 152,
      "pttbid": 14468,
      "idx": "1"
    }
  ],
  "next_idx": ""
}
"""
    }
}
