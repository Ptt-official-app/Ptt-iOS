//
//  BoardListViewModel.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/12.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

protocol BoardListUIProtocol: AnyObject {
    func show(error: Error)
    func listDidUpdate()
    func favoriteBoardsDidUpdate()
    func inValidUser()
}

extension BoardListViewModel {
    enum ListType {
        case favorite, popular
    }
}

final class BoardListViewModel {
    let listType: ListType
    let apiClient: APIClientProtocol
    private var startIndex = ""
    private(set) var list: [APIModel.BoardInfo] = []
    private var favoriteBoards: [APIModel.BoardInfo] = []
    private var favoriteStartIndex = ""
    weak var uiDelegate: BoardListUIProtocol?

    init(listType: ListType, apiClient: APIClientProtocol = APIClient.shared) {
        self.listType = listType
        self.apiClient = apiClient
    }

    var favoriteBoardNames: [String] {
        favoriteBoards.map(\.brdname)
    }

    func fetchListData() {
        if case .popular = listType {
            Task { await fetchPopularBoards() }
        }
        Task {
            await fetchAllFavoriteBoards()
            if case .favorite = listType {
                list = favoriteBoards
                startIndex = favoriteStartIndex
                uiDelegate?.listDidUpdate()
            }
            uiDelegate?.favoriteBoardsDidUpdate()
        }
    }

    func pullDownToRefresh() {
        startIndex = ""
        fetchListData()
    }

    func fetchMoreData() {
        switch listType {
        case .favorite:
            break
        case .popular:
            guard !startIndex.isEmpty else { return }
            Task { await fetchPopularBoards() }
        }
    }

    func removeBoard(at index: Int) {
        list.remove(at: index)
    }

    func moveBoard(from source: Int, to target: Int) {
        let element = list.remove(at: source)
        list.insert(element, at: target)
    }
}

extension BoardListViewModel {
    func fetchAllFavoriteBoards() async {
        favoriteBoards = []
        await fetchFavoriteBoardsRecursive()
    }

    private func fetchFavoriteBoardsRecursive() async {
        do {
            let response = try await apiClient.favoritesBoards(startIndex: favoriteStartIndex, limit: 200)
            favoriteBoards += response.list
            favoriteStartIndex = response.next_idx ?? ""
            if !favoriteStartIndex.isEmpty {
                await fetchFavoriteBoardsRecursive()
            }
        } catch {
            if let apiError = error as? APIError,
               case let .requestFailed(statusCode, _) = apiError,
               statusCode == 403,
               listType == .favorite {
                uiDelegate?.inValidUser()
            }
        }
    }

    private func fetchPopularBoards() async {
        do {
            let response = try await apiClient.popularBoards()
            if startIndex == "" {
                list = response.list
            } else {
                list += response.list
            }
            startIndex = response.next_idx ?? ""
            uiDelegate?.listDidUpdate()
        } catch {
            uiDelegate?.show(error: error)
        }
    }
}

extension BoardListViewModel: BoardSearchDelegate {
    func boardDidAddToFavorite(info: APIModel.BoardInfo) {
        list.append(info)
        uiDelegate?.listDidUpdate()
    }
}
