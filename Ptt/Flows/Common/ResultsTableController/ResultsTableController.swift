//
//  ResultsTableController.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/21.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

class ResultsTableController : UITableViewController, FavoriteView {

    var onBoardSelect: ((String) -> Void)?
    var filteredBoards = [Board]()
    let activityIndicator = UIActivityIndicatorView()

    private let cellReuseIdentifier = "FavoriteCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = GlobalAppearance.backgroundColor
        if #available(iOS 13.0, *) {
        } else {
            tableView.indicatorStyle = .white
        }
        tableView.estimatedRowHeight = 80.0
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag // to dismiss from search bar
        tableView.register(BoardsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        activityIndicator.color = .lightGray
        tableView.ptt_add(subviews: [activityIndicator])
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20.0),
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }

    @objc private func addToFavorite(sender: FavoriteButton) {
        switch sender.isSelected {
        case false:
            sender.isSelected = true
            if let boardToAdded = sender.board {
                Favorite.boards.append(boardToAdded)
            }
        case true:
            sender.isSelected = false
            if let boardToRemoved = sender.board,
                let indexToRemoved = Favorite.boards.firstIndex(where: {$0.name == boardToRemoved.name}) {
                Favorite.boards.remove(at: indexToRemoved)
            }
        }
        NotificationCenter.default.post(name: NSNotification.Name("didUpdateFavoriteBoards"), object: nil)
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBoards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! BoardsTableViewCell
        cell.favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        let index = indexPath.row
        if index < filteredBoards.count {
            cell.boardName = filteredBoards[index].name
            cell.boardTitle = filteredBoards[index].title
            cell.favoriteButton.board = filteredBoards[index]
        }
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index < filteredBoards.count {
            onBoardSelect?(filteredBoards[index].name)
        }
    }
}
