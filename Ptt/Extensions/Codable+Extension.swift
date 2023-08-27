//
//  Codable+Extension.swift
//  Ptt
//
//  Created by AnsonChen on 2023/7/30.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
