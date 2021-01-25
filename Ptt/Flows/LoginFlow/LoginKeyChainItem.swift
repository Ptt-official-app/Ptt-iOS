//
//  LoginKeyChainItem.swift
//  Ptt
//
//  Created by You Gang Kuo on 2021/1/12.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation
class LoginKeyChainItem: NSObject {
    
    static let shared: LoginKeyChainItem = LoginKeyChainItem(service: "service")
    
    private var service = ""
   
    init(service: String) {
        super.init()
        self.service = service
    }

    func saveToken(_ token: String) -> Bool {

        let tokenData = token.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: self.service,
                                    kSecValueData as String: tokenData]
        
        if readToken() != nil {
            let attributes: [String: Any] = [kSecValueData as String: tokenData]
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            if status == errSecSuccess {
                return true
            }
        }
        else {
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecSuccess {
                return true
            }
        }
        return false
    }
    
    func removeToken() -> Bool {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: self.service]
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            return true
        }
        else {
            return false
        }
    }
        
    func readToken() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: self.service,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: kCFBooleanTrue!]
        
        
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        
        
        guard let data = retrivedData as? Data else {return nil}
        return String(data: data, encoding: String.Encoding.utf8)
    }
        
}

