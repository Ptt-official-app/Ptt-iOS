//
//  Data+Extension.swift
//  Ptt
//
//  Created by Anson on 2023/10/26.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

extension Data {
    func toDictionary() throws -> [String: Any]? {
        return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
    }
}
