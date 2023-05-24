//
//  Profile.swift
//  Ptt
//
//  Created by AnsonChen on 2023/4/23.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    struct Profile: Decodable {
        let userID: String
        let userName: String
        let realName: String
        let nickName: String
        let flag: UserFlag
        let perm: UserPermission
        /// Number of login days
        let loginDays: Int
        /// Number of posts
        let posts: Int
        let firstLogin: Date
        let lastLogin: Date
        let lastIP: String
        let lastHost: String
        let money: Economy
        /// 在 ptt 上的 email
        let pttEmail: String
        /// 審核資料
        let justify: String
        let over18: Bool
        /// 呼叫器界面類別
        let pagerUI: Int
        /// 呼叫器狀態
        let pager: Pager
        /// 隱身
        let invisible: Bool
        /// 可容納站外信數量，購買信箱數
        let exMail: Int
        let career: String
        /// Role-specific permissions
        let role: Int
        /// 最近上站時間(隱身不計)
        let lastSeen: Date
        /// 上次得到天使時間
        let timeSetAngel: Date?
        /// 上次與天使互動時間 (by day)
        let timePlayAngel: Int
        /// last-time the user ordered an song
        let lastSong: Date?
        /// 進站畫面
        let loginView: Int
        /// violation count
        let violation: Int
        let gameRecords: [GameRecord]
        /// 象棋等級
        let chessRank: Int
        /// User-agreement 的版本
        let uaVersion: Int
        /// 慣用簽名檔
        let signature: Int
        /// bad post count
        let badPost: Int
        /// 小天使
        let angel: String
        /// 上次刪除劣文時間
        let timeRemoveBadPost: Date?
        /// 被開罰單時間
        let timeViolateLaw: Date?
        let deleted: Bool
        let updateTS: Date
        let userLevel2: Int
        let avatar: String?
        /// 設定聯絡 avatar 的時間
        let avatarTS: Date?
        /// 聯絡的 email
        let email: String?
        /// 是否設定聯絡的 email
        let emailSet: Bool
        /// 設定聯絡 email 的時間
        let emailTS: Date?
        /// 是否使用 2FA 機制
        let twoFactorEnabled: Bool
        /// 設定 2FA 機制的時間
        let twoFactorEnabledTS: Date?
        /// 認證 email
        let idEmail: String?
        /// 是否已經設定完成認證 email
        let idEmailSet: Bool
        /// update 認證 email 的時間.
        let idEmailTS: Date?

        enum CodingKeys: String, CodingKey {
            case userID = "user_id"
            case userName = "username"
            case realName = "realtime"
            case nickName = "nickname"
            case flag
            case perm
            case loginDays = "login_days"
            case posts
            case firstLogin = "first_login"
            case lastLogin = "last_login"
            case lastIP = "last_ip"
            case lastHost = "last_host"
            case money
            case pttEmail = "pttemail"
            case justify
            case over18
            case pagerUI = "pager_ui"
            case pager
            case invisible
            case exMail = "exmail"
            case career
            case role
            case lastSeen = "last_seen"
            case timeSetAngel = "time_set_angel"
            case timePlayAngel = "time_play_angel"
            case lastSong = "last_song"
            case loginView = "login_view"
            case violation
            case fiveWin = "five_win"
            case fiveLose = "five_lose"
            case fiveTie = "five_tie"
            case chcWin = "chc_win"
            case chcLose = "chc_lose"
            case chcTie = "chc_tie"
            case conn6Win = "conn6_win"
            case conn6Lose = "conn6_lose"
            case conn6Tie = "conn6_tie"
            case goWin = "go_win"
            case goLose = "go_lose"
            case goTie = "go_tie"
            case darkWin = "dark_win"
            case darkLose = "dark_lose"
            case darkTie = "dark_tie"
            case chessRank = "chess_rank"
            case uaVersion = "ua_version"
            case signature = "signaure"
            case badPost = "bad_post"
            case angel
            case timeRemoveBadPost = "time_remove_bad_post"
            case timeViolateLaw = "time_violate_law"
            case deleted
            case updateTS = "update_ts"
            case userLevel2 = "UserLevel2"
            case avatar
            case avatarTS = "avatar_ts"
            case email
            case emailSet = "email_set"
            case emailTS = "email_ts"
            case twoFactorEnabled = "twofactor_enabled"
            case twoFactorEnabledTS = "twofactor_enabled_ts"
            case idEmail = "idemail"
            case idEmailSet = "idemail_set"
            case idEmailTS = "idemail_ts"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            userID = try container.decode(String.self, forKey: .userID)
            userName = try container.decode(String.self, forKey: .userName)
            realName = try container.decode(String.self, forKey: .realName)
            nickName = try container.decode(String.self, forKey: .nickName)
            flag = try container.decode(UserFlag.self, forKey: .flag)
            perm = try container.decode(UserPermission.self, forKey: .perm)
            loginDays = try container.decode(Int.self, forKey: .loginDays)
            posts = try container.decode(Int.self, forKey: .posts)
            firstLogin = try container.decode(Date.self, forKey: .firstLogin)
            lastLogin = try container.decode(Date.self, forKey: .lastLogin)
            lastIP = try container.decode(String.self, forKey: .lastIP)
            lastHost = try container.decode(String.self, forKey: .lastHost)
            money = Economy(rawValue: try container.decode(Int.self, forKey: .money))
            pttEmail = try container.decode(String.self, forKey: .pttEmail)
            justify = try container.decode(String.self, forKey: .justify)
            over18 = try container.decode(Bool.self, forKey: .over18)
            pagerUI = try container.decode(Int.self, forKey: .pagerUI)
            let pagerValue = try container.decode(Int.self, forKey: .pager)
            pager = Pager(rawValue: pagerValue) ?? .off
            invisible = try container.decode(Bool.self, forKey: .invisible)
            exMail = try container.decode(Int.self, forKey: .exMail)
            career = try container.decode(String.self, forKey: .career)
            role = try container.decode(Int.self, forKey: .role)
            lastSeen = try container.decode(Date.self, forKey: .lastSeen)
            timeSetAngel = try Profile.parseDate(container: container, key: .timeSetAngel)
            timePlayAngel = try container.decode(Int.self, forKey: .timePlayAngel)
            lastSong = try Profile.parseDate(container: container, key: .lastSong)
            loginView = try container.decode(Int.self, forKey: .loginView)
            violation = try container.decode(Int.self, forKey: .violation)
            gameRecords = [
                GameRecord(
                    type: .five,
                    win: try container.decode(Int.self, forKey: .fiveWin),
                    lose: try container.decode(Int.self, forKey: .fiveLose),
                    tie: try container.decode(Int.self, forKey: .fiveTie)
                ),
                GameRecord(
                    type: .chc,
                    win: try container.decode(Int.self, forKey: .chcWin),
                    lose: try container.decode(Int.self, forKey: .chcLose),
                    tie: try container.decode(Int.self, forKey: .chcTie)
                ),
                GameRecord(
                    type: .conn6,
                    win: try container.decode(Int.self, forKey: .conn6Win),
                    lose: try container.decode(Int.self, forKey: .conn6Lose),
                    tie: try container.decode(Int.self, forKey: .conn6Tie)
                ),
                GameRecord(
                    type: .go,
                    win: try container.decode(Int.self, forKey: .goWin),
                    lose: try container.decode(Int.self, forKey: .goLose),
                    tie: try container.decode(Int.self, forKey: .goTie)
                ),
                GameRecord(
                    type: .dark,
                    win: try container.decode(Int.self, forKey: .darkWin),
                    lose: try container.decode(Int.self, forKey: .darkLose),
                    tie: try container.decode(Int.self, forKey: .darkTie)
                )
            ]
            chessRank = try container.decode(Int.self, forKey: .chessRank)
            uaVersion = try container.decode(Int.self, forKey: .uaVersion)
            signature = try container.decode(Int.self, forKey: .signature)
            badPost = try container.decode(Int.self, forKey: .badPost)
            angel = try container.decode(String.self, forKey: .angel)
            timeRemoveBadPost = try Profile.parseDate(container: container, key: .timeRemoveBadPost)
            timeViolateLaw = try Profile.parseDate(container: container, key: .timeViolateLaw)
            deleted = try container.decode(Bool.self, forKey: .deleted)
            updateTS = try container.decode(Date.self, forKey: .updateTS)
            userLevel2 = try container.decode(Int.self, forKey: .userLevel2)
            avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
            avatarTS = try Profile.parseDate(container: container, key: .avatarTS)
            email = try container.decodeIfPresent(String.self, forKey: .email)
            emailSet = try container.decode(Bool.self, forKey: .emailSet)
            emailTS = try Profile.parseDate(container: container, key: .emailTS)
            twoFactorEnabled = try container.decode(Bool.self, forKey: .twoFactorEnabled)
            twoFactorEnabledTS = try Profile.parseDate(container: container, key: .twoFactorEnabledTS)
            idEmail = try container.decodeIfPresent(String.self, forKey: .idEmail)
            idEmailSet = try container.decode(Bool.self, forKey: .idEmailSet)
            idEmailTS = try Profile.parseDate(container: container, key: .idEmailTS)
        }

        static func parseDate(
            container: KeyedDecodingContainer<APIModel.Profile.CodingKeys>,
            key: CodingKeys
        ) throws -> Date? {
            let value = try container.decode(Double.self, forKey: key)
            return value == 0 ? nil : Date(timeIntervalSince1970: value)
        }
    }

    enum GameType: Codable {
        // 五子棋
        case five
        // 象棋
        case chc
        // 圍棋
        case go
        // 六子棋
        case conn6
        // 暗棋
        case dark
    }

    struct GameRecord: Codable {
        let type: GameType
        let win: Int
        let lose: Int
        let tie: Int
    }

    /// https://github.com/Ptt-official-app/go-pttbbs/blob/main/ptttype/uflags.go
    struct UserFlag: OptionSet, Codable {
        let rawValue: UInt

        /// Highlight favorite or not
        static let favoriteNoHighlight = UserFlag(rawValue: 0x00000001)
        /// Add new board into one's fav
        static let favoriteAddNew = UserFlag(rawValue: 0x00000002)
        /// show friends only
        static let friendsOnly = UserFlag(rawValue: 0x00000010)
        static let boardSortAlphabetical = UserFlag(rawValue: 0x00000020)
        static let showAdvertisementBanner = UserFlag(rawValue: 0x00000040)
        /// show user songs in banner
        static let showUserSongsBanner = UserFlag(rawValue: 0x00000080)
        /// DBCS-aware enabled.
        static let dbcsAware = UserFlag(rawValue: 0x00000200)
        /// No Escapes interrupting DBCS characters
        static let dbcsNoInterrupt = UserFlag(rawValue: 0x00000400)
        /// Detect and drop repeated input from evil clients
        static let dbcsDropRepeat = UserFlag(rawValue: 0x00000800)

        /// Modified files are NOT marked
        static let noModMark = UserFlag(rawValue: 0x00001000)
        /// Mod-mark is colored.
        static let coloredModMark = UserFlag(rawValue: 0x00002000)

        /// User defaults to backup
        static let defaultBackup = UserFlag(rawValue: 0x00010000)
        /// User (angel) wants the new pager
        static let newAngelPager = UserFlag(rawValue: 0x00020000)
        /// Don't accept outside mails
        static let rejectOutSideMail = UserFlag(rawValue: 0x00040000)
        /// Login from insecure (ex, telnet) connection will be rejected.
        static let secureLogin = UserFlag(rawValue: 0x00080000)
        /// A foreign
        static let foreign = UserFlag(rawValue: 0x00100000)
        /// Get "live right" already
        static let liveRight = UserFlag(rawValue: 0x00200000)

        /// Use light bar-based menu
        static let menuLightBar = UserFlag(rawValue: 0x01000000)
        /// Enable ASCII-safe cursor.
        static let cursorASCII = UserFlag(rawValue: 0x02000000)
    }

    /// https://github.com/Ptt-official-app/go-pttbbs/blob/main/ptttype/perm.go
    struct UserPermission: OptionSet, Codable {
        let rawValue: UInt

        static let invalid = UserPermission([])
        /// 基本權力
        static let basic = UserPermission(rawValue: 0o00000000001)
        /// 進入聊天室
        static let chat = UserPermission(rawValue: 0o00000000002)
        /// 找人聊天
        static let page = UserPermission(rawValue: 0o00000000004)
        /// 發表文章
        static let post = UserPermission(rawValue: 0o00000000010)
        /// 註冊程序認證
        static let loginOK = UserPermission(rawValue: 0o00000000020)
        /// 信件無上限
        static let mailLimit = UserPermission(rawValue: 0o00000000040)
        /// 目前隱形中
        static let cloak = UserPermission(rawValue: 0o00000000100)
        /// 看見忍者
        static let seeCloak = UserPermission(rawValue: 0o00000000200)
        /// 永久保留帳號
        static let xempt = UserPermission(rawValue: 0o00000000400)
        /// 站長隱身術
        static let sysOPHide = UserPermission(rawValue: 0o00000001000)
        /// 板主
        static let bm = UserPermission(rawValue: 0o00000002000)
        /// 帳號總管
        static let accounts = UserPermission(rawValue: 0o00000004000)
        /// 聊天室總管
        static let chatRoom = UserPermission(rawValue: 0o00000010000)
        /// 看板總管
        static let board = UserPermission(rawValue: 0o00000020000)
        /// 站長
        static let sysOP = UserPermission(rawValue: 0o00000040000)
        static let bbsAdmin = UserPermission(rawValue: 0o00000100000)
        /// 不列入排行榜
        static let noTop = UserPermission(rawValue: 0o00000200000)
        /// 違法通緝中
        static let violateLaw = UserPermission(rawValue: 0o00000400000)
        /// 有資格擔任小天使
        static let angel = UserPermission(rawValue: 0o00001000000)
        /// 不允許認證碼註冊
        static let noRegisterCode = UserPermission(rawValue: 0o00002000000)
        /// 視覺站長
        static let viewSYSOP = UserPermission(rawValue: 0o00004000000)
        /// 觀察使用者行蹤
        static let logUser = UserPermission(rawValue: 0o00010000000)
        /// 搋奪公權
        static let noCitizen = UserPermission(rawValue: 0o00020000000)
        /// 群組長
        static let sysSuperSubOP = UserPermission(rawValue: 0o00040000000)
        /// 帳號審核組
        static let accTREG = UserPermission(rawValue: 0o00100000000)
        /// 程式組
        static let prg = UserPermission(rawValue: 0o00200000000)
        /// 活動組
        static let action = UserPermission(rawValue: 0o00400000000)
        /// 美工組
        static let paint = UserPermission(rawValue: 0o01000000000)
        /// 警察總管
        static let policeMan = UserPermission(rawValue: 0o02000000000)
        /// 小組長
        static let sysSubOP = UserPermission(rawValue: 0o04000000000)
        /// 退休站長
        static let oldSysOP = UserPermission(rawValue: 0o10000000000)
        /// 警察
        static let police = UserPermission(rawValue: 0o20000000000)
    }

    struct Economy: Codable {
        let rawValue: Int

        var description: String {
            switch rawValue {
            case 0...10:
                return "家徒四壁"
            case 11...109:
                return "赤貧"
            case 110...1_099:
                return "清寒"
            case 1_100...10_999:
                return "普通"
            case 11_000...109_999:
                return "小康"
            case 110_000...1_099_999:
                return "小富"
            case 1_100_000...10_999_999:
                return "中富"
            case 11_000_000...109_999_999:
                return "大富翁"
            case 110_000_000...1_099_999_999:
                return "富可敵國"
            default:
                return "比爾蓋天"
            }
        }
    }

    /// https://github.com/Ptt-official-app/go-pttbbs/blob/main/ptttype/modes.go#L5
    enum Pager: Int, Codable {
        case off = 0
        case on = 1
        case disable = 2
        case antiWB = 3
        case friendOnly = 4
        case modes = 5
    }
}
