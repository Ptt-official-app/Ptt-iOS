//
//  Article.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

protocol Article: Codable {
    var title: String { get }
    var date: String { get }
    var author: String { get }

    // implemented in protocol extension below
    var category: String? { get }
    var titleWithoutCategory: String { get }
}

extension Article {
    var category: String? {
        if let leftBracket = title.firstIndex(of: "["), let rightBracket = title.firstIndex(of: "]") {
            let nextLeftBracket = title.index(after: leftBracket)
            let range = nextLeftBracket..<rightBracket
            let category = title[range]
            return String(category)
        }
        return nil
    }

    var titleWithoutCategory: String {
        if let leftBracket = title.firstIndex(of: "["),
            let rightBracket = title.firstIndex(of: "]") {
            var _title = title
            let categoryRange = leftBracket...rightBracket
            _title.removeSubrange(categoryRange)
            let _titleWithBothEndsTrimmed = _title.trimmingCharacters(in: .whitespacesAndNewlines)
            return _titleWithBothEndsTrimmed
        }
        return title
    }
}
