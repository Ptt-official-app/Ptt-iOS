//
//  FavoriteBoardManager.swift
//  Ptt
//
//  Created by AnsonChen on 2023/7/28.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Combine
import Foundation

protocol FavoriteBoardManagerProtocol {
    var boards: CurrentValueSubject<[APIModel.BoardInfo]?, Error> { get }

    func addBoardToFavorite(board: APIModel.BoardInfo) async throws
    func deleteBoardFromFavorite(board: APIModel.BoardInfo) async throws
    func fetchAllFavoriteBoards() async throws
}

actor FavoriteBoardDataStore {
    var favoritedBoards: [APIModel.BoardInfo]?
    var favoriteStartIndex = ""
    var isFetching = false

    func addBoardToFavorite(board: APIModel.BoardInfo) {
        var boards = favoritedBoards ?? []
        boards.append(board)
        favoritedBoards = boards
    }

    func deleteBoardFromFavorite(board: APIModel.BoardInfo) {
        var boards = favoritedBoards ?? []
        boards.removeAll(where: { $0.brdname == board.brdname })
        favoritedBoards = boards
    }

    func setFavoriteBoards(boards: [APIModel.BoardInfo]) {
        favoritedBoards = boards
    }

    func update(favoriteStartIndex: String) {
        self.favoriteStartIndex = favoriteStartIndex
    }

    func update(isFetching: Bool) {
        self.isFetching = isFetching
    }
}

final class FavoriteBoardManager: FavoriteBoardManagerProtocol {
    static let shared: FavoriteBoardManager = .init()
    let apiClient: APIClientProtocol
    let dataStore: FavoriteBoardDataStore
    let boards = CurrentValueSubject<[APIModel.BoardInfo]?, Error>(nil)

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
        self.dataStore = FavoriteBoardDataStore()
    }

    func addBoardToFavorite(board: APIModel.BoardInfo) async throws {
        let levelIndex = board.level_idx ?? ""
        let response = try await apiClient.addBoardToFavorite(levelIndex: levelIndex, bid: board.bid)
        await dataStore.addBoardToFavorite(board: response)
        await boards.send(dataStore.favoritedBoards)
    }

    func deleteBoardFromFavorite(board: APIModel.BoardInfo) async throws {
        guard await dataStore.favoritedBoards != nil else { return }
        _ = try await apiClient.deleteBoardFromFavorite(
            levelIndex: board.level_idx ?? "",
            index: board.idx
        )
        await dataStore.deleteBoardFromFavorite(board: board)
        await boards.send(dataStore.favoritedBoards)
    }

    func fetchAllFavoriteBoards() async {
        do {
            if await dataStore.isFetching { return }
            await dataStore.update(isFetching: true)
            await dataStore.update(favoriteStartIndex: "")
            var favoriteBoards = try await fetchFavoriteBoardsRecursive()
            while await !dataStore.favoriteStartIndex.isEmpty {
                let responseList = try await fetchFavoriteBoardsRecursive()
                favoriteBoards += responseList
            }
            await dataStore.setFavoriteBoards(boards: favoriteBoards)
            await boards.send(dataStore.favoritedBoards)
            await dataStore.update(isFetching: false)
        } catch {
            boards.send(completion: .failure(error))
            await dataStore.update(isFetching: false)
        }
    }

    private func fetchFavoriteBoardsRecursive() async throws -> [APIModel.BoardInfo] {
        let index = await dataStore.favoriteStartIndex
        let response = try await apiClient.favoritesBoards(startIndex: index, limit: 200)
        await dataStore.update(favoriteStartIndex: response.next_idx ?? "")
        return response.list
    }
}
