//
//  CreateArticle.swift
//  Ptt
//
//  Created by marcus fu on 2021/7/25.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    class CreateArticle: Codable {
        var `class` : String = ""
        var title : String = ""
        var content: [[ContentProperty]] = []
        
        init(className: String, title: String, content: [[ContentProperty]]) {
            `class` = className
            self.title = title
            self.content = content
        }
    }
    
    class ContentProperty: Codable {
        var text: String = ""
        var color0: Color
        var color1: Color
        
        init(text: String, color0: Color = Color(), color1: Color = Color()) {
            self.text = text
            self.color0 = color0
            self.color1 = color1
        }
    }
    
    class Color: Codable {
        var foreground: Int
        var background: Int
        var blink: Bool
        var highlight: Bool
        var reset: Bool
        
        init(foreground: Int = 0, background: Int = 0, blink: Bool = false, highlight: Bool = false, reset: Bool = false) {
            self.foreground = foreground
            self.background = background
            self.blink = blink
            self.highlight = highlight
            self.reset = reset
        }
    }
    
    struct CreateArticleResponse: Codable {
        let aid: String
        let bid: String
        let deleted: Bool
        let filename: String
        let create_time: Int
        let modified: Int
        let recommend: Int
        let n_comments: Int
        let owner: String
        let date: String
        let title: String
        let money: Int
        let type: String
        let `class`: String
        let mode: Int
        let url: String
        let read: Bool
        let idx: String
        let rank: Int
    }
}
