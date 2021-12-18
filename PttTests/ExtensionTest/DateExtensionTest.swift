//
//  DateExtensionTest.swift
//  PttTests
//
//  Created by Anson on 2021/12/18.
//  Copyright © 2021 Ptt. All rights reserved.
//

import XCTest
@testable import Ptt

final class TimeIntervalExtensionTest: XCTestCase {
    private let minuteDiff: TimeInterval = 60
    private var hourDiff: TimeInterval { minuteDiff * 60 }
    private var dayDiff: TimeInterval { hourDiff * 24 }
    private var monthDiff: TimeInterval { dayDiff * 31 }
    private var yearDiff: TimeInterval { dayDiff * 365 }

    func testDiffFrom_second_level() throws {
        let interval: TimeInterval = 1639820098
        
        var interval_diff = interval + 10
        var date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "Just now")

        interval_diff = interval + 40
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "Just now")

        interval_diff = interval - 33440
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "Just now")
    }

    func testDiffFrom_minute_level() throws {
        let interval: TimeInterval = 1639820098

        var interval_diff = interval + minuteDiff
        var date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "1 minute ago")
        
        interval_diff = interval + 2 * minuteDiff
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "2 minutes ago")

        interval_diff = interval + 30 * minuteDiff
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "30 minutes ago")

        interval_diff = interval + 59 * minuteDiff
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "59 minutes ago")
    }

    func testDiffFrom_hour_level() throws {
        let interval: TimeInterval = 1639820098

        var interval_diff = interval + hourDiff
        var date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "1 hour ago")

        interval_diff = interval + 3 * hourDiff
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "3 hours ago")

        interval_diff = interval + 23 * hourDiff
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "23 hours ago")
    }

    func testDiffFrom_day_level() throws {
        let interval: TimeInterval = 1639820098

        var interval_diff = interval + dayDiff
        var date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "1 day ago")

        interval_diff = interval + 3 * dayDiff
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "3 days ago")

        interval_diff = interval + 29 * dayDiff
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "29 days ago")
    }

    func testDiffFrom_month_level() throws {
        let interval: TimeInterval = 1639820098

        var interval_diff = interval + monthDiff
        var date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "1 month ago")

        interval_diff = interval + 3 * monthDiff
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "3 months ago")

        interval_diff = interval + 11 * monthDiff
        date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "11 months ago")
    }

    func testDiffFrom_year_level() throws {
        let interval: TimeInterval = 1639785600

        var interval_diff = interval + yearDiff
        var date_diff = Date(timeIntervalSince1970: interval_diff)
        XCTAssertEqual(interval.diff(from: date_diff), "1 year ago")

        interval_diff = interval + 3 * yearDiff
        date_diff = Date(timeIntervalSince1970: interval_diff)
        // A year is 365.2425 days (Gregorian calendar)
        // So the `interval` after 1095 days is 2 years, 11 months, 29 days ago
        XCTAssertEqual(interval.diff(from: date_diff), "2 years ago")
    }
}
