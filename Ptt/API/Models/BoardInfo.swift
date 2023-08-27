//
//  BoardInfo.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

extension APIModel {

    struct BoardInfoList: Codable {
        let list: [BoardInfo]
        var next_idx: String?
    }

    struct BoardInfo: Codable, Equatable {
        /// system-defined board-id
        let bid: String
        /// user-defined board-name (英文板名)
        let brdname: String
        let title: String
        let flag: BoardAttribute
        /// 板的種類 (□, ◎, ...)
        let type: String
        /// 板的類別
        let `class`: String
        /// 人氣
        let nuser: Int
        let moderators: [String]
        /// 不給看的原因.
        let reason: String
        /// 文章總數.
        let total: Int
        /// 上次 post 的時間.
        let last_post_time: Int
        let stat_attr: BoardStat
        /// folder 的 level-idx
        var level_idx: String?
        var idx: String
        /// 已讀這個板的最新文章.
        let read: Bool
        /// 我的最愛.
        let fav: Bool

        init(brdname: String, title: String, nuser: Int = 0) {
            self.bid = "bid"
            self.brdname = brdname
            self.title = title
            self.flag = .noCount
            self.type = ""
            self.class = ""
            self.nuser = nuser
            self.moderators = []
            self.reason = ""
            self.read = false
            self.total = 0
            self.last_post_time = 0
            self.stat_attr = .invalid
            self.fav = false
            self.idx = "0"
        }
    }

    /// https://github.com/Ptt-official-app/go-pttbbs/blob/main/ptttype/brdattr.go
    struct BoardAttribute: OptionSet, Codable {
        let rawValue: UInt32

        /// 不列入統計
        static let noCount = BoardAttribute(rawValue: 0x00000002)
        /// 群組板
        static let groupBoard = BoardAttribute(rawValue: 0x00000008)
        /// 隱藏板 (看板好友才可看)
        static let hide = BoardAttribute(rawValue: 0x00000010)
        /// 限制發表或閱讀
        static let postMask = BoardAttribute(rawValue: 0x00000020)
        /// 匿名板
        static let anonymous = BoardAttribute(rawValue: 0x00000040)
        /// 預設匿名板
        static let defaultAnonymous = BoardAttribute(rawValue: 0x00000080)
        /// 發文無獎勵看板
        static let noCredit = BoardAttribute(rawValue: 0x00000100)
        /// 連署機看板
        static let voteBoard = BoardAttribute(rawValue: 0x00000200)
        /// 已警告要廢除
        static let warnel = BoardAttribute(rawValue: 0x00000400)
        /// 熱門看板群組
        static let top = BoardAttribute(rawValue: 0x00000800)
        /// 不可推薦
        static let noRecommend = BoardAttribute(rawValue: 0x00001000)
        /// 小天使可匿名
        static let angelAnonymous = BoardAttribute(rawValue: 0x00002000)
        /// 板主設定列入記錄
        static let bmCount = BoardAttribute(rawValue: 0x00004000)
        /// Symbolic link to board
        static let symbolic = BoardAttribute(rawValue: 0x00008000)
        /// 不可噓
        static let noBoo = BoardAttribute(rawValue: 0x00010000)
        /// 板友才能發文
        static let restrictedPost = BoardAttribute(rawValue: 0x00040000)
        /// guest能 post
        static let guestPost = BoardAttribute(rawValue: 0x00080000)
        /// 冷靜
        static let coolDown = BoardAttribute(rawValue: 0x00100000)
        /// 自動留轉錄記錄
        static let cpLog = BoardAttribute(rawValue: 0x00200000)
        /// 禁止快速推文
        static let noFastRecommend = BoardAttribute(rawValue: 0x00400000)
        /// 推文記錄 IP
        static let ipLogRecommend = BoardAttribute(rawValue: 0x00800000)
        /// 十八禁
        static let over18 = BoardAttribute(rawValue: 0x01000000)
        /// 不可回文
        static let noReply = BoardAttribute(rawValue: 0x02000000)
        /// 對齊式的推文
        static let alignedComment = BoardAttribute(rawValue: 0x04000000)
        /// 不可自刪
        static let noSelfDeletePost = BoardAttribute(rawValue: 0x08000000)
        /// 允許板主刪除特定文字
        static let bmMaskContent = BoardAttribute(rawValue: 0x10000000)
    }

    /// Personal board state
    /// https://github.com/Ptt-official-app/go-pttbbs/blob/main/ptttype/board_stat.go
    struct BoardStat: OptionSet, Codable {
        let rawValue: UInt8

        static let invalid = BoardStat([])
        static let favorite = BoardStat(rawValue: 1)
        static let board = BoardStat(rawValue: 2)
        static let line = BoardStat(rawValue: 4)
        static let folder = BoardStat(rawValue: 8)
        static let tag = BoardStat(rawValue: 16)
        static let unRead = BoardStat(rawValue: 32)
        static let symbolic = BoardStat(rawValue: 64)
    }
}
