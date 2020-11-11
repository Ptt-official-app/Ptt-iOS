//
//  Post.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

protocol Post : Codable {
    var category : String { get }
    var titleWithoutCategory : String { get }

    var title : String { get }
    var href : String { get }
    var author : String { get }
    var date : String { get }
}

extension Post {
    var category : String {
        if let leftBracket = title.firstIndex(of: "["), let rightBracket = title.firstIndex(of: "]") {
            let nextLeftBracket = title.index(after: leftBracket)
            let range = nextLeftBracket..<rightBracket
            let category = title[range]
            return String(category)
        }
        return "　　"
    }
    var titleWithoutCategory : String {
        if let leftBracket = title.firstIndex(of: "["), let rightBracket = title.firstIndex(of: "]") {
            var _title = title
            let nextRightBracket = _title.index(after: rightBracket)
            let range = leftBracket...nextRightBracket
            _title.removeSubrange(range)
            return _title
        }
        return title
    }
}
