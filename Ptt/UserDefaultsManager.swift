//
//  UserDefaultsManager.swift
//  Ptt
//
//  Created by denkeni on 2021/1/14.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

struct UserDefaultsManager {

    static func registerDefaultValues() {
        UserDefaults.standard.register(defaults: [appearanceModeKey: appearanceModeDefault.rawValue])
    }
}

// MARK: - Appearance Mode

extension UserDefaultsManager {

    enum AppearanceMode : String {
        case system, light, dark
    }

    private static let appearanceModeKey = "appearanceMode"
    private static let appearanceModeDefault : AppearanceMode = .dark

    static func appearanceMode() -> AppearanceMode {
        guard let modeString = UserDefaults.standard.string(forKey: appearanceModeKey), let mode = AppearanceMode(rawValue: modeString) else {
            return appearanceModeDefault
        }
        return mode
    }

    static func setAppearanceMode(mode: AppearanceMode) {
        UserDefaults.standard.setValue(mode.rawValue, forKey: appearanceModeKey)
    }
}
