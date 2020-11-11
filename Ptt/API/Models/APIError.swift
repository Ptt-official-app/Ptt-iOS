//
//  APIError.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

struct APIError : Codable, Error {
    let message : String
}

