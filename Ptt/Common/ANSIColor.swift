//
//  ANSIColor.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/5.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

enum ANSIColor {
    enum Foreground: Int {
        case black = 30
        case red = 31
        case green = 32
        case yellow = 33
        case blue = 34
        case magenta = 35
        case cyan = 36
        case white = 37
    }

    enum Background: Int {
        case black = 40
        case red = 41
        case green = 42
        case yellow = 43
        case blue = 44
        case magenta = 45
        case cyan = 46
        case white = 47
    }
}
