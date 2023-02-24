//
//  KeyChainItem.swift
//  Ptt
//
//  Created by You Gang Kuo on 2021/1/12.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

extension KeyChainItem {
    enum Key: String {
        case loginToken = "service"
        case userID
        case unitTest
    }
}

final class KeyChainItem {
    // MARK: - Save
    @discardableResult
    static func save(text: String, for key: Key) -> Bool {
        let data = Data(text.utf8)
        return save(data: data, for: key)
    }

    @discardableResult
    static func save(object: Codable, for key: Key) -> Bool {
        do {
            let data = try JSONEncoder().encode(object)
            return save(data: data, for: key)
        } catch {
            return false
        }
    }

    @discardableResult
    static func save(data: Data, for key: Key) -> Bool {
        delete(for: key)
        let query: [String : Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key.rawValue,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // MARK: - Read
    static func readText(for key: Key) -> String? {
        guard let data = readData(for: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func readObject<T: Decodable>(for key: Key) -> T? {
        guard let data = readData(for: key) else { return nil }
        do {
            let obj = try JSONDecoder().decode(T.self, from: data)
            return obj
        } catch {
            return nil
        }
    }

    static func readData(for key: Key) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key.rawValue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue!
        ]

        var retrievedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrievedData)
        return retrievedData as? Data
    }

    // MARK: - Delete
    @discardableResult
    static func delete(for key: Key) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: key.rawValue
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}

