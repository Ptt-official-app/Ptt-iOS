//
//  Article.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

protocol Article: Codable {
    var aid: String { get }
    var bid: String { get }
    var subjectType: APIModel.SubjectType { get }
    var `class`: String { get }
    var title: String { get }
    var date: String { get }
    var owner: String { get }

    // implemented in protocol extension below
    var displayTitle: String { get }
}

extension Article {

    var displayTitle: String {
        switch subjectType {
        case .reply:
            return "Re: " + title
        case .forward:
            return "Fw: " + title
        case .normal, .locked, .deleted, .unknown:
            return title
        }
    }
}
