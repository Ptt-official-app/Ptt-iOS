//
//  FavoriteStruct.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/20.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

struct Favorite {

    // TODO: Switch to Ptt API later
    private static let savePath: URL? = {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent("favoriteBoardsData")
            return path
        }
        assertionFailure()
        return nil
    }()
    static var boards: [APIModel.BoardInfo] = {
        guard let url = savePath,
            let data = try? Data(contentsOf: url),
            let boards = try? JSONDecoder().decode([APIModel.BoardInfo].self, from: data) else {
                return [APIModel.BoardInfo(brdname: "Gossiping", title: "【八卦】 請協助置底協尋"),
                        APIModel.BoardInfo(brdname: "C_Chat", title: "[希洽] 養成好習慣 看文章前先ID"),
                        APIModel.BoardInfo(brdname: "NBA", title: "[NBA] R.I.P. Mr. David Stern"),
                        APIModel.BoardInfo(brdname: "Lifeismoney", title: "[省錢] 省錢板"),
                        APIModel.BoardInfo(brdname: "Stock", title: "[股版]發文請先詳閱版規"),
                        APIModel.BoardInfo(brdname: "HatePolitics", title: "[政黑] 第三勢力先知王kusanagi02"),
                        APIModel.BoardInfo(brdname: "Baseball", title: "[棒球] 2020東奧六搶一在台灣"),
                        APIModel.BoardInfo(brdname: "Tech_Job", title: "[科技] 修機改善是設備終生職責"),
                        APIModel.BoardInfo(brdname: "LoL", title: "[LoL] PCS可憐哪"),
                        APIModel.BoardInfo(brdname: "Beauty", title: "《表特板》發文附圖")]
        }
        return boards
        }() {
        willSet {
            guard let data = try? JSONEncoder().encode(newValue), let url = savePath else {
                assertionFailure()
                return
            }
            do {
                try data.write(to: url)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
