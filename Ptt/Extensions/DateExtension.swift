//
//  DateExtension.swift
//  Ptt
//
//  Created by Anson on 2021/12/18.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

extension TimeInterval {
    static var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
        formatter.unitsStyle = .full
        return formatter
    }()

    func diff(from date: Date = Date()) -> String {
        let end = date
        let start = Date(timeIntervalSince1970: self)
        guard start.compare(end) == .orderedAscending else {
            return NSLocalizedString("Just now", comment: "")
        }

        let formatter = TimeInterval.dateComponentsFormatter
        let values = formatter
            .string(from: start, to: end)?
            .split(separator: ",")
            .compactMap { String($0) } ?? []
        let diff = values.first ?? "0"
        if diff.hasPrefix("0") {
            return NSLocalizedString("Just now", comment: "")
        } else {
            return diff + " " + NSLocalizedString("ago", comment: "")
        }
    }
}
