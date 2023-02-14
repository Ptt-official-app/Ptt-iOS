//
//  KeyChainWraper.swift
//  Ptt
//
//  Created by AnsonChen on 2023/2/14.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation
import KeychainSwift

enum KeychainWrapper {
    enum Key: String {
        case loginToken
        case unitTest
    }

    static func set(text: String, for key: Key) {
        let keychain = KeychainSwift()
        keychain.set(text, forKey: key.rawValue)
    }

    static func getText(for key: Key) -> String? {
        let keychain = KeychainSwift()
        return keychain.get(key.rawValue)
    }

    static func set(object: Codable, for key: Key) throws {
        let keychain = KeychainSwift()
        let data = try JSONEncoder().encode(object)
        keychain.set(data, forKey: key.rawValue)
    }

    static func getObject<T: Codable>(for key: Key) throws -> T? {
        let keychain = KeychainSwift()
        guard let data = keychain.getData(key.rawValue) else { return nil }
        let obj = try JSONDecoder().decode(T.self, from: data)
        return obj
    }

    static func clear() {
        KeychainSwift().clear()
    }
}
