//
//  UserDefaultItem.swift
//  Ptt
//
//  Created by AnsonChen on 2023/7/30.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

struct UserDefaultItem {
    enum Key: String {
        case alreadyInstalled
    }

    static func set(value: Bool, for key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    static func getValue<T>(for key: Key) -> T? {
        UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
}
