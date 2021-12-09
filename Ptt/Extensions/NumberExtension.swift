//
//  NumberExtension.swift
//  Ptt
//
//  Created by Anson on 2021/12/9.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

extension Int {
    var easyRead: String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        let absValue = abs(self)
        if absValue < 1_000 {
            return "\(self)"
        } else if 10_000 > absValue && absValue >= 1_000 {
            let num = NSNumber(value: Double(self) / 1_000.0)
            return "\(formatter.string(from: num)!)K"
        } else {
            let num = NSNumber(value: Double(self) / 1_000_000.0)
            return "\(formatter.string(from: num)!)M"
        }
    }
}
