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
            return _title
        }
        return self
    }

    func getBorderName() -> String {
        // Sample url
        // "http://localhost/bbs/test/M.1234567900.A.125"
        let urlSplits = self.split(separator: "/")
        guard urlSplits.count == 5 else { return "" }
        let boardName = String(urlSplits[3])
        return boardName
    }
}
