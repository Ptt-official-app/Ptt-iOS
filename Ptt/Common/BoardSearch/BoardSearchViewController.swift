//
//  BoardSearchViewController.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/10.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

protocol BoardSearchDelegate: AnyObject {
    func boardDidAddToFavorite(info: APIModel.BoardInfo)
}

final class BoardSearchViewController: UITableViewController {
    private let apiClient: APIClientProtocol
    private var favoriteBoardNames: [String] = []
    private var boards: [APIModel.BoardInfo] = []
    private var startIdx = ""
    private var scrollDirection: Direction = .unknown
    private var keyword = ""
    weak var delegate: BoardSearchDelegate?

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
        super.init(style: .plain)
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

    func update(favoriteBoardNames: [String]) {
        self.favoriteBoardNames = favoriteBoardNames
        tableView.reloadData()
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
        let isFavorite = favoriteBoardNames.contains(data.brdname)
        cell.config(boardName: data.brdname, isFavorite: isFavorite)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
#if DEVELOP // Disable editing, for now
        let data = boards[indexPath.row]
        if let _ = favoriteBoardNames.firstIndex(of: data.brdname) {
            // Remove board from favorite
        } else {
            addBoardToFavorite(board: data, indexPath: indexPath)
        }
#else
        // TBD: expected behavior should be showBoardView()
#endif
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
                let levelIndex = board.level_idx ?? ""
                let response = try await apiClient.addBoardToFavorite(levelIndex: levelIndex, bid: board.bid)
                delegate?.boardDidAddToFavorite(info: response)
                await MainActor.run {
                    favoriteBoardNames.append(board.brdname)
                    tableView.beginUpdates()
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
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
}
