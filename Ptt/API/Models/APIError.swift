//
//  APIError.swift
//  Ptt
//
//  Created by Anson on 2020/11/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

enum APIError: Error, LocalizedError {
    case dataNotExist
    case decodingError(String)
    case httpError(Error)
    case loginTokenNotExist
    case notExpectedHTTPStatus(String)
    /// Error returns by backend
    case requestFailed(String)
    case responseNotExist
    case urlError

    var errorDescription: String? {
        switch self {
        case .dataNotExist:
            return "Data doesn't exist"
        case .decodingError(let message):
            return message
        case .httpError(let error):
            return error.localizedDescription
        case .loginTokenNotExist:
            return "Login token doesn't exist"
        case .notExpectedHTTPStatus(let message):
            return message
        case .requestFailed(let message):
            return message
        case .responseNotExist:
            return "Response doesn't exist"
        case .urlError:
            return "URL error"
        }
    }

    var message: String {
        return localizedDescription
    }
}

