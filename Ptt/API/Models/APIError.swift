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
    case reLogin
    /// Error returns by backend
    case requestFailed(Int, String)
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
        case .reLogin:
            return "Token is expired, please login again"
        case let .requestFailed(statusCode, message):
            return "\(statusCode) - \(message)"
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
