//
//  ANSIColor.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/5.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation
import UIKit

enum ANSIColor: CaseIterable {
    case black
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white

    var foreground: Int {
        switch self {
        case .black:
            return 30
        case .red:
            return 31
        case .green:
            return 32
        case .yellow:
            return 33
        case .blue:
            return 34
        case .magenta:
            return 35
        case .cyan:
            return 36
        case .white:
            return 37
        }
    }

    var background: Int {
        switch self {
        case .black:
            return 40
        case .red:
            return 41
        case .green:
            return 42
        case .yellow:
            return 43
        case .blue:
            return 44
        case .magenta:
            return 45
        case .cyan:
            return 46
        case .white:
            return 47
        }
    }

    var color: UIColor {
        switch self {
        case .black:
            return UIColor.black
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .yellow:
            return UIColor.yellow
        case .blue:
            return UIColor.blue
        case .magenta:
            return UIColor.magenta
        case .cyan:
            return UIColor.cyan
        case .white:
            return UIColor.white
        }
    }

    init?(rawValue: Int, isForeground: Bool) {
        for color in ANSIColor.allCases {
            if isForeground {
                if color.foreground == rawValue {
                    self = color
                    return
                }
            } else {
                if color.background == rawValue {
                    self = color
                    return
                }
            }
        }
        return nil
    }
}
