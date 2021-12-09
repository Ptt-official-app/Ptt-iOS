//
//  StringExtension.swift
//  Ptt
//
//  Created by Anson on 2021/12/8.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

extension String {
    var withCategory : String {
        if let leftBracket = self.firstIndex(of: "["),
            let rightBracket = self.firstIndex(of: "]") {
            var _title = self
            let range = leftBracket...rightBracket
            _title.removeSubrange(range)
            return _title
        }
        return self
    }
}
