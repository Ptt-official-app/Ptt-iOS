//
//  BoardListViewModel.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/12.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Combine
import Foundation

protocol BoardListUIProtocol: AnyObject {
    func show(error: Error)
    func listDidUpdate()
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
    let favoriteBoardManager: FavoriteBoardManagerProtocol
    private var cancellable: AnyCancellable?
    private var startIndex = ""
    private(set) var list: [APIModel.BoardInfo] = [] {
        didSet {
            guard oldValue != list else { return }
            uiDelegate?.listDidUpdate()
        }
    }
    weak var uiDelegate: BoardListUIProtocol?

    init(
        listType: ListType,
        apiClient: APIClientProtocol = APIClient.shared,
        favoriteBoardManager: FavoriteBoardManagerProtocol = FavoriteBoardManager.shared
    ) {
        self.listType = listType
        self.apiClient = apiClient
        self.favoriteBoardManager = favoriteBoardManager
        observeFavoriteBoard()
    }

    func fetchPopularBoards() {
        if case .popular = listType {
            Task { await fetchPopularBoards() }
        }
    }

    func pullDownToRefresh() {
        switch listType {
        case .favorite:
            Task {
                do {
                    try await favoriteBoardManager.fetchAllFavoriteBoards()
                } catch {
                    uiDelegate?.show(error: error)
                }
            }
        case.popular:
            startIndex = ""
            fetchPopularBoards()
        }
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
                try await favoriteBoardManager.deleteBoardFromFavorite(board: board)
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
    private func fetchPopularBoards() async {
        do {
            let response = try await apiClient.popularBoards()
            if startIndex.isEmpty {
                list = response.list
            } else {
                list += response.list
            }
            startIndex = response.next_idx ?? ""
        } catch {
            uiDelegate?.show(error: error)
        }
    }

    private func handlePossibleTokenExpire(error: Error?) {
        if let apiError = error as? APIError,
           case let .requestFailed(statusCode, _) = apiError,
           statusCode == 403,
           listType == .favorite {
            uiDelegate?.inValidUser()
        }
    }

    private func observeFavoriteBoard() {
        self.cancellable = favoriteBoardManager.boards.sink { [weak self] boards in
            guard let boards = boards else {
                Task { [weak self] in
                    let error = await favoriteBoardManager.getFetchError()
                    self?.handlePossibleTokenExpire(error: error)
                }
                return
            }
            if case .favorite = self?.listType {
                self?.list = boards
            }
        }
    }
}
