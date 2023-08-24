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
    func selectBoard(info: APIModel.BoardInfo)
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
    private(set) var favoriteBoards: [APIModel.BoardInfo] = []
    private var favoriteStartIndex = ""
    weak var uiDelegate: BoardListUIProtocol?

    init(listType: ListType, apiClient: APIClientProtocol = APIClient.shared) {
        self.listType = listType
        self.apiClient = apiClient
    }

    func fetchListData() {
        switch listType {
        case .popular:
            Task { await fetchPopularBoards() }
        case .favorite:
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
        Task {
            let board = list[index]
            do {
                let isSuccess = try await apiClient.deleteBoardFromFavorite(
                    levelIndex: board.level_idx ?? "",
                    index: board.idx
                )
                // Failure will throw catch
                list.remove(at: index)
                favoriteBoards = list
                uiDelegate?.favoriteBoardsDidUpdate()
                uiDelegate?.listDidUpdate()
            } catch {
                uiDelegate?.show(error: error)
            }
        }
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
    func boardDidSelect(info: APIModel.BoardInfo) {
        uiDelegate?.selectBoard(info: info)
    }

    func boardDidAddToFavorite(info: APIModel.BoardInfo) {
        list.append(info)
        uiDelegate?.listDidUpdate()
    }

    func boardDidDeleteFromFavorite(info: APIModel.BoardInfo) {
        list.removeAll(where: { $0.bid == info.bid })
        uiDelegate?.listDidUpdate()
    }
}
