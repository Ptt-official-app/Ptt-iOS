//
//  BoardViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit
import SafariServices

final class BoardViewController: UITableViewController {

    private var boardName : String
    private var board : APIClient.Board? = nil
    private let cellReuseIdentifier = "BoardPostCell"

    init(boardName: String) {
        self.boardName = boardName
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = boardName
        view.backgroundColor = GlobalAppearance.backgroundColor
        tableView.estimatedRowHeight = 80.0
        tableView.separatorStyle = .none

        tableView.register(BoardPostTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        refresh()
    }

    @objc private func refresh() {
        APIClient.getNewPostlist(board: boardName) { (error, board) in
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.message, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            self.board = board
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let board = self.board else {
            return 0
        }
        return board.PostList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! BoardPostTableViewCell
        let row = indexPath.row
        guard let board = self.board, row < board.PostList.count else {
            return cell
        }
        let post = board.PostList[row]
        cell.dateString = post.Date
        cell.authorName = post.Author
        cell.title = post.Title
        if row % 2 == 0 {
            if #available(iOS 11.0, *) {
                cell.backgroundColor = UIColor(named: "blackColor-28-28-31")
            } else {
                cell.backgroundColor = UIColor(red: 28/255, green: 28/255, blue: 31/255, alpha: 1.0)
            }
        } else {
            cell.backgroundColor = GlobalAppearance.backgroundColor
        }
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        guard let board = self.board, row < board.PostList.count else {
            return
        }
        let post = board.PostList[row]
        var urlComponents = APIClient.pttURLComponents
        urlComponents.path = post.Href
        guard let url = urlComponents.url else {
            let alert = UIAlertController(title: "Error", message: "wrong url", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

private class BoardPostTableViewCell: UITableViewCell {

    var dateString : String? {
        didSet {
            dateLabel.text = dateString
        }
    }
    var authorName : String? {
        didSet {
            authorNameLabel.text = authorName
        }
    }
    var title : String? {
        didSet {
            titleLabel.text = title
        }
    }
    private let dateLabel = UILabel()
    private let authorNameLabel = UILabel()
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        dateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        authorNameLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.numberOfLines = 0
        if #available(iOS 11.0, *) {
            dateLabel.textColor = UIColor(named: "textColorGray")
            authorNameLabel.textColor = UIColor(named: "textColorGray")
            titleLabel.textColor = UIColor(named: "textColor-240-240-247")
        } else {
            dateLabel.textColor = .systemGray
            authorNameLabel.textColor = .systemGray
            titleLabel.textColor = UIColor(red:240/255, green:240/255, blue:247/255, alpha:1.0)
        }

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        contentView.addSubview(authorNameLabel)
        contentView.addSubview(titleLabel)
        let viewsDict = ["dateLabel": dateLabel, "authorNameLabel": authorNameLabel, "titleLabel": titleLabel]
        let metrics = ["hp": 20, "vp": 16, "vps": 6]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hp)-[dateLabel]-(vps)-[authorNameLabel]-(hp)-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hp)-[titleLabel]-(hp)-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vp)-[dateLabel]-(vps)-[titleLabel]-(vp)-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vp)-[authorNameLabel]-(vps)-[titleLabel]-(vp)-|",
        options: [], metrics: metrics, views: viewsDict)
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
