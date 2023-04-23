//
//  UserInfoViewModel.swift
//  Ptt
//
//  Created by AnsonChen on 2023/4/23.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation
import SwiftUI

final class UserInfoViewModel: ObservableObject {
    @Published var avatar: UIImage
    @Published var account: String = "PttUser"
    @Published var name: String = "鄉民一號"
    @Published var currentSegment: Int = 0
    @Published var profileData: [[(String, String)]] = [
        [
            (L10n.loginDays, "-"),
            (L10n.validPosts, "-")
        ],
        [
            (L10n.economy, "-"),
            (L10n.badPosts, "-")
        ],
        [
            (L10n.lastLoginIP, "-")
        ]
    ]
    @Published var articles: [APIModel.ArticleSummary] = []
    @Published var comments: [APIModel.ArticleComment] = []

    let segment: [String] = [L10n.profile, L10n.historyArticles, L10n.historyComments]
    let apiClient: APIClientProtocol
    let keyChain: PTTKeyChain
    let dateFormatter = DateFormatter()

    init(
        apiClient: APIClientProtocol = APIClient.shared,
        keyChain: PTTKeyChain = KeyChainItem.shared
    ) {
        self.apiClient = apiClient
        self.keyChain = keyChain
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        avatar = UIImage(named: "AppIcon")!
    }

    func fetchData() {
        Task {
            await [fetchProfileInfo(), fetchUserArticles(), fetchUserComments()]
        }
    }

    func fetchProfileInfo() async {
        guard let loginToken: APIModel.LoginToken = keyChain.readObject(for: .loginToken) else { return }
        do {
            let response = try await apiClient.getProfile(userID: loginToken.user_id)
            let date = dateFormatter.string(from: response.lastSeen)
            await MainActor.run {
                account = response.userID
                name = response.nickName
                profileData = [
                    [
                        (L10n.loginDays, "\(response.loginDays)"),
                        (L10n.validPosts, "\(response.loginDays)")
                    ],
                    [
                        (L10n.economy, "\(response.money.description)"),
                        (L10n.badPosts, "\(response.badPost)")
                    ],
                    [
                        (L10n.lastLoginIP, "\(date) \(response.lastIP)")
                    ]
                ]
            }
        } catch { }
    }

    func fetchUserArticles() async {
        guard let loginToken: APIModel.LoginToken = keyChain.readObject(for: .loginToken) else { return }
        do {
            let response = try await apiClient.getUserArticles(userID: loginToken.user_id, startIndex: "")
            await MainActor.run(body: {
                if articles.isEmpty {
                    articles = response.list
                } else {
                    articles += response.list
                }
            })
        } catch { }
    }

    func fetchUserComments() async {
        guard let loginToken: APIModel.LoginToken = keyChain.readObject(for: .loginToken) else { return }
        do {
            let response = try await apiClient.getUserComment(userID: loginToken.user_id, startIndex: "")
            await MainActor.run(body: {
                if comments.isEmpty {
                    comments = response.list
                } else {
                    comments += response.list
                }
            })
        } catch { }
    }

    func updateCurrentSegment(to index: Int) {
        currentSegment = index
    }
}
