//
//  ComposeArticleViewModel.swift
//  Ptt
//
//  Created by marcus fu on 2021/9/5.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

final class ComposeArticleViewModel {
    let apiClient: APIClientProtocol
    let boardName: String
    let postTypes: [String]
    private(set) var selectedPostType: String = ""

    init(boardName: String, postTypes: [String], apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
        self.boardName = boardName
        self.postTypes = postTypes
    }

    func update(postType: String) {
        selectedPostType = postType
    }

    func createPost(title: String, content: String) async throws -> APIModel.CreateArticleResponse {
        let parsedContent = parse(content: content)
        let article = APIModel.CreateArticle(className: selectedPostType, title: title, content: parsedContent)
        let response = try await apiClient.createArticle(boardId: boardName, article: article)
        return response
    }
}

extension ComposeArticleViewModel {
    private func parse(content: String) -> [[APIModel.ContentProperty]] {
        let lines = content.components(separatedBy: .newlines)
        return lines.map { [APIModel.ContentProperty(text: $0)] }
    }
}
