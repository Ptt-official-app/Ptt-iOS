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
        UserDefaults.standard.register(defaults: [appearanceModeKey: appearanceModeDefault.rawValue,
                                                  addressKey: addressDefault
                                                  ])
    }
}

// MARK: - Appearance Mode

extension UserDefaultsManager {

    enum AppearanceMode: String {
        case system, light, dark
    }

    private static let appearanceModeKey = "appearanceMode"
    private static let appearanceModeDefault: AppearanceMode = .dark

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

// MARK: - Site Address

extension UserDefaultsManager {

    private static let addressKey = "address"
    private static let addressDefault = "https://api.devptt.dev"

    private static func displayString(of address: String) -> String {
        guard let url = URL(string: address), let host = url.host else {
            return ""
        }
        if let port = url.port {
            return "\(host):\(port)"
        }
        return "\(host)"
    }

    static var addressForDisplay: String {
        return displayString(of: address())
    }

    static var addressDefaultForDisplay: String {
        return displayString(of: addressDefault)
    }

    static func address() -> String {
        guard let address = UserDefaults.standard.string(forKey: addressKey) else {
            return addressDefault
        }
        return address
    }

    static func set(address: String) -> Bool {
        var urlString = address
        if !urlString.hasPrefix("https://") {
            urlString.insert(contentsOf: "https://", at: urlString.startIndex)
        }
        guard let url = URL(string: urlString) else {
            return false
        }
        UserDefaults.standard.setValue(url.absoluteString, forKey: addressKey)
        return true
    }
}
