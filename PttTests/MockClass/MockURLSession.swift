//
//  MockURLSession.swift
//  PttTests
//
//  Created by Anson on 2020/11/19.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
@testable import Ptt

final class MockURLSession: URLSessionProtocol {
    private var handler: ((String, [String: String], [URLQueryItem], Data?, ((Result<(Int, [AnyHashable: Any]), APIError>) -> Void)) throws -> Void)?
    // (path, headers, queryParams, body, completion)
    func stub(_ stubHandler: @escaping (String, [String: String], [URLQueryItem], Data?, ((Result<(Int, [AnyHashable: Any]), APIError>) -> Void)) throws -> Void) {
        handler = stubHandler
    }

    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping Ptt.DataTaskResult
    ) -> Ptt.URLSessionDataTaskProtocol {
        guard
            let url = request.url,
            let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { return MockURLSessionDataTask() }

        let path = urlComponent.path
        let headers = request.allHTTPHeaderFields ?? [:]
        let queryItems = urlComponent.queryItems ?? []
        let body = request.httpBody
        let response = mockHttpURLResponse(request: request)
        do {
            try handler?(path, headers, queryItems, body, { result in
                switch result {
                case .success(let tuple):
                    let data = try? JSONSerialization.data(withJSONObject: tuple.1)
                    completionHandler(data, response, nil)
                case .failure(let error):
                    completionHandler(nil, response, error)
                }
            })
        } catch {
            completionHandler(nil, response, error)
        }
        return MockURLSessionDataTask()
    }

    func dataTask(with url: URL, completionHandler: @escaping Ptt.DataTaskResult) -> Ptt.URLSessionDataTaskProtocol {
        let req = URLRequest(url: url)
        return dataTask(with: req, completionHandler: completionHandler)
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation({ continuation in
            guard
                let url = request.url,
                let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else {
                continuation.resume(throwing: NSError(domain: "test.cc.ptt", code: 999))
                return
            }
            let path = urlComponent.path
            let headers = request.allHTTPHeaderFields ?? [:]
            let queryItems = urlComponent.queryItems ?? []
            let body = request.httpBody
            do {
                try handler?(path, headers, queryItems, body, { result in
                    switch result {
                    case .success(let tuple):
                        let data = try? JSONSerialization.data(withJSONObject: tuple.1)
                        let response = mockHttpURLResponse(request: request, code: tuple.0)
                        continuation.resume(with: .success((data ?? Data(), response)))
                    case .failure(let error):
                        continuation.resume(with: .failure(error))
                    }
                })
            } catch {
                continuation.resume(throwing: error)
            }
        })
    }

    private func mockHttpURLResponse(request: URLRequest, code: Int = 200) -> URLResponse {
        return HTTPURLResponse(
            url: request.url!,
            statusCode: code,
            httpVersion: "HTTP/1.1",
            headerFields: nil
        )!
    }
}
