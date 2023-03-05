//
//  CViewModel.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/4.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

final class CViewModel {
    let apiClient: APIClientProtocol
    let boardName: String
    let postTypes: [String]
    private var selectedPostType: String = ""

    init(boardName: String, postTypes: [String], apiClient: APIClientProtocol) {
        self.apiClient = apiClient
        self.boardName = boardName
        self.postTypes = postTypes
    }

    func update(postType: String) {
        selectedPostType = postType
    }

    func createPost(title: String, content: String) {

    }
}
