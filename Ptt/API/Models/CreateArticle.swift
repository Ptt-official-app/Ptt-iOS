//
//  CreateArticle.swift
//  Ptt
//
//  Created by marcus fu on 2021/7/25.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

extension APIModel {
    final class CreateArticle: Codable {
        let `class` : String
        let title : String
        /// The first dimension means line, the first line, the second line ...etc
        /// The second dimension means content property
        let content: [[ContentProperty]]
        
        init(className: String, title: String, content: [[ContentProperty]]) {
            `class` = className
            self.title = title
            self.content = content
        }
    }
    
    final class ContentProperty: Codable {
        let text: String
        let color0: Color
        let color1: Color
        
        init(text: String, color0: Color = Color(), color1: Color? = nil) {
            self.text = text
            self.color0 = color0
            self.color1 = color1 ?? color0
        }
    }
    
    final class Color: Codable {
        let foreground: Int
        let background: Int
        let blink: Bool
        let highlight: Bool
        /// `true`, the text will be reseted to black background, white foreground
        /// Default value is `false`
        let reset: Bool
        
        init(
            foreground: ANSIColor.Foreground = .white,
            background: ANSIColor.Background = .black,
            blink: Bool = false,
            highlight: Bool = false,
            reset: Bool = false
        ) {
            self.foreground = foreground.rawValue
            self.background = background.rawValue
            self.blink = blink
            self.highlight = highlight
            self.reset = reset
        }
    }
    
    struct CreateArticleResponse: Codable {
        let bid: String
        let aid: String
        let deleted: Bool
        let create_time: Int
        let modified: Int
        let recommend: Int
        let n_comments: Int
        let owner: String
        let title: String
        let money: Int
        let `class`: String
        let mode: Int
        let url: String
        let read: Bool
        let idx: String
        let rank: Int
    }
}
