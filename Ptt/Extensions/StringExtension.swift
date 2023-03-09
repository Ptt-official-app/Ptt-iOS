//
//  StringExtension.swift
//  Ptt
//
//  Created by Anson on 2021/12/8.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

extension String {
    var withoutCategory: String {
        if let leftBracket = self.firstIndex(of: "["),
            let rightBracket = self.firstIndex(of: "]") {
            var _title = self
            let range = leftBracket...rightBracket
            _title.removeSubrange(range)
            return _title.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return self
    }

    func getBorderName() -> String {
        // Sample url
        // "http://localhost/bbs/test/M.1234567900.A.125"
        guard self.isLink else { return "" }
        let urlSplits = self.split(separator: "/")
        guard urlSplits.count == 5 else { return "" }
        let boardName = String(urlSplits[3])
        return boardName
    }

    var isLink: Bool {
        // Why not URL(string: )?
        // The function said http/localhost/bbs/test/M.1234567900.A.125 is a link...
        self.starts(with: "http://") || self.starts(with: "https://")
    }

    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
