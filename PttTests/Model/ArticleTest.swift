//
//  ArticleTest.swift
//  PttTests
//
//  Created by Denken Chen on 2021/12/14.
//  Copyright © 2021 Ptt. All rights reserved.
//

import XCTest
@testable import Ptt

class ArticleTest: XCTestCase {

    func testArticleCategory() {
        let testCases = [
            ("[category] title", "category", "title"),  // normal format, with spacing
            ("[category]title", "category", "title"),
            ("[category]  title", "category", "title"),
            ("title", nil, "title"),
            ("[category1][category2] title", "category1", "[category2] title"),
        ]
        for (title, expectedCategory, expectedTitleWithoutCategory) in testCases {
            let article1 = APIModel.BoardArticle(title: title, date: "", author: "", boardID: "", articleID: "")
            XCTAssertEqual(article1.category, expectedCategory)
            XCTAssertEqual(article1.titleWithoutCategory, expectedTitleWithoutCategory)
        }
    }

    func testPttURL() {
        guard let url = URL(string: "https://www.ptt.cc/bbs/SYSOP/M.1627259537.A.390.html") else {
            XCTFail()
            return
        }
        XCTAssertEqual(APIModel.FullArticle.isPttArticle(url: url), true)
        let info = APIModel.FullArticle.info(from: url)
        XCTAssertEqual(info.boardName, "SYSOP")
        XCTAssertEqual(info.filename, "M.1627259537.A.390")
    }
}
