//
//  ArticleTest.swift
//  PttTests
//
//  Created by Denken Chen on 2021/12/14.
//  Copyright © 2021 Ptt. All rights reserved.
//

@testable import Ptt
import XCTest

class ArticleTest: XCTestCase {

    func testArticleCategory() {
        let testCases: [(String, APIModel.SubjectType, String)] = [
            ("title", .normal, "title"),
            ("Re: title", .reply, "title"),
            ("Fw: title", .forward, "title"),
        ]
        for (displayTitle, subjectType, title) in testCases {
            let article = APIModel.BoardArticle(bid: "", aid: "", subjectType: subjectType, class: "", title: title, date: "", owner: "", recommend: 0, boardID: "", articleID: "")
            XCTAssertEqual(displayTitle, article.displayTitle)
        }
    }

    func testPttURL() {
        guard let url = URL(string: "https://www.ptt.cc/bbs/SYSOP/M.1627259537.A.390.html") else {
            XCTFail("Shouldn't happen")
            return
        }
        XCTAssertEqual(APIModel.FullArticle.isPttArticle(url: url), true)
        let info = APIModel.FullArticle.info(from: url)
        XCTAssertEqual(info.boardName, "SYSOP")
        XCTAssertEqual(info.filename, "M.1627259537.A.390")
    }
}
