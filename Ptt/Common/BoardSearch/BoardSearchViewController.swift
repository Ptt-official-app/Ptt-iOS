//
//  BoardSearchViewController.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/10.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Combine
import UIKit

protocol BoardSearchViewProtocol: AnyObject {
    func showBoard(boardName: String)
}

final class BoardSearchViewController: UITableViewController {
    private let apiClient: APIClientProtocol
    private let favoriteBoardsManager: FavoriteBoardManagerProtocol
    private var cancellable: AnyCancellable?
    private var favoriteBoards: [APIModel.BoardInfo] = []
    private var boards: [APIModel.BoardInfo] = []
    private var startIdx = ""
    private var scrollDirection: Direction = .unknown
    private var keyword = ""
    weak var delegate: BoardSearchViewProtocol?

    init(
        apiClient: APIClientProtocol = APIClient.shared,
        favoriteBoardsManager: FavoriteBoardManagerProtocol = FavoriteBoardManager.shared
    ) {
        self.apiClient = apiClient
        self.favoriteBoardsManager = favoriteBoardsManager
        super.init(style: .plain)
        observeFavoriteBoards()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(BoardSearchCell.self, forCellReuseIdentifier: BoardSearchCell.cellID)
    }

    func search(keyword: String) {
        startIdx = ""
        boards = []
        getBoardList(keyword: keyword)
    }

    // MARK: - TableView delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        boards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BoardSearchCell.cellID,
                for: indexPath
            ) as? BoardSearchCell
        else {
            return UITableViewCell()
        }
        let data = boards[indexPath.row]
        let isFavorite = favoriteBoards.contains(where: { $0.brdname == data.brdname })
        cell.config(boardName: data.brdname, isFavorite: isFavorite, boardID: data.bid, delegate: self)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = boards[indexPath.row]
        delegate?.showBoard(boardName: data.brdname)
    }

    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let velocity = tableView.panGestureRecognizer.velocity(in: tableView).y
        if velocity < 0 {
            scrollDirection = .bottom
        } else if velocity > 0 {
            scrollDirection = .up
        }

        if indexPath.row == boards.count - 3 &&
            scrollDirection == .bottom &&
            !startIdx.isEmpty {
            getBoardList(keyword: keyword)
        }
    }
}

// MARK: - API
extension BoardSearchViewController {
    private func getBoardList(keyword: String) {
        self.keyword = keyword
        apiClient.getBoardList(keyword: keyword, startIdx: startIdx, max: 200) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    let message = error.localizedDescription
                    let alert = UIAlertController(title: L10n.error, message: message, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
                    alert.addAction(confirm)
                    self?.present(alert, animated: true, completion: nil)
                case .success(let response):
                    if let index = response.next_idx {
                        self?.startIdx = index
                    }
                    self?.boards += response.list
                    self?.tableView.reloadData()
                }
            }
        }
    }

    private func addBoardToFavorite(board: APIModel.BoardInfo, indexPath: IndexPath) {
        Task {
            do {
                try await favoriteBoardsManager.addBoardToFavorite(board: board)
            } catch {
                await MainActor.run(body: {
                    showError(message: error.localizedDescription)
                })
            }
        }
    }

    private func deleteBoardFromFavorite(board: APIModel.BoardInfo, indexPath: IndexPath) {
        Task {
            do {
                try await favoriteBoardsManager.deleteBoardFromFavorite(board: board)
            } catch {
                await MainActor.run(body: {
                    showError(message: error.localizedDescription)
                })
            }
        }
    }
}

extension BoardSearchViewController {
    private func showError(message: String) {
        let alert = UIAlertController(title: L10n.error, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }

    private func observeFavoriteBoards() {
        cancellable = favoriteBoardsManager.boards
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.observeFavoriteBoards()
                default:
                    break
                }
            }, receiveValue: { [weak self] boards in
                self?.favoriteBoards = boards ?? []
                self?.tableView.reloadData()
            })
    }
}

extension BoardSearchViewController: BoardSearchCellProtocol {
    func clickFavoriteButton(boardID: String, changeToFavorite: Bool) {
        guard let index = boards.firstIndex(where: { $0.bid == boardID }) else { return }
        let data = boards[index]
        let indexPath = IndexPath(row: index, section: 0)
        if changeToFavorite {
            addBoardToFavorite(board: data, indexPath: indexPath)
        } else {
            deleteBoardFromFavorite(board: data, indexPath: indexPath)
        }
    }
}
