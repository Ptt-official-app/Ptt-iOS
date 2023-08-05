//
//  MockKeyChain.swift
//  PttTests
//
//  Created by AnsonChen on 2023/3/21.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation
@testable import Ptt

final class MockKeyChain: PTTKeyChain {

    private var dict: [KeyChainItem.Key: Any] = [:]
    private var isSaveSuccess = true

    func save(text: String, for key: Ptt.KeyChainItem.Key) -> Bool {
        if isSaveSuccess {
            dict[key] = text
        }
        return isSaveSuccess
    }

    func save(object: Codable, for key: Ptt.KeyChainItem.Key) -> Bool {
        if isSaveSuccess {
            dict[key] = object
        }
        return isSaveSuccess
    }

    func save(data: Data, for key: Ptt.KeyChainItem.Key) -> Bool {
        if isSaveSuccess {
            dict[key] = data
        }
        return isSaveSuccess
    }

    func readText(for key: Ptt.KeyChainItem.Key) -> String? {
        dict[key] as? String
    }

    func readObject<T>(for key: Ptt.KeyChainItem.Key) -> T? where T: Decodable {
        dict[key] as? T
    }

    func readData(for key: Ptt.KeyChainItem.Key) -> Data? {
        dict[key] as? Data
    }

    func delete(for key: Ptt.KeyChainItem.Key) -> Bool {
        dict.removeValue(forKey: key)
        return true
    }

    func clear() {
        dict = [:]
    }
}
