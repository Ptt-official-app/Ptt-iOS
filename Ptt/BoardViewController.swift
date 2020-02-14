//
//  BoardViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit
import SafariServices

final class BoardViewController: UIViewController {

    private var boardName : String
    private var board : APIClient.Board? = nil
    private var isRequesting = false
    private var receivedPage : Int = 0
    private let cellReuseIdentifier = "BoardPostCell"

    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    private let bottomView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    private var bottomViewHeightConstraint : NSLayoutConstraint? = nil

    init(boardName: String) {
        self.boardName = boardName
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = boardName
        tableView.backgroundColor = GlobalAppearance.backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        if #available(iOS 13.0, *) {
        } else {
            tableView.indicatorStyle = .white
        }
        tableView.estimatedRowHeight = 80.0
        tableView.separatorStyle = .none

        tableView.register(BoardPostTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)
        let viewsDict = ["tableView": tableView, "bottomView": bottomView]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [], metrics: nil, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[bottomView]|", options: [], metrics: nil, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView][bottomView]|", options: [], metrics: nil, views: viewsDict)
        let bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: 0)
        constraints.append(bottomViewHeightConstraint)
        self.bottomViewHeightConstraint = bottomViewHeightConstraint
        NSLayoutConstraint.activate(constraints)

        activityIndicator.color = .lightGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20.0),
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
        activityIndicator.startAnimating()
        refresh()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let toolBarHeight : CGFloat = 49.0
        let safeAreaBottomHeight : CGFloat = {
            if #available(iOS 11.0, *) {
                return view.safeAreaInsets.bottom   // only available after viewDidLayoutSubviews
            } else {
                return 0
            }
        }()
        bottomViewHeightConstraint?.constant = toolBarHeight + safeAreaBottomHeight

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: toolBarHeight))
        toolBar.barTintColor = GlobalAppearance.backgroundColor
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(toolBar)
        NSLayoutConstraint.activate([
            toolBar.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: toolBarHeight)
        ])
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                toolBar.bottomAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                toolBar.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor)
            ])
        }

        let refreshItem = UIBarButtonItem(title: "重整", style: .plain, target: self, action: #selector(refresh))
        let searchItem = UIBarButtonItem(title: "搜尋", style: .plain, target: nil, action: nil)
        let composeItem = UIBarButtonItem(title: "發文", style: .plain, target: nil, action: nil)
        let infoItem = UIBarButtonItem(title: "看板資訊", style: .plain, target: nil, action: nil)
        let flexible1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexible2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexible3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexible4 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexible5 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexible1, refreshItem, flexible2, searchItem, flexible3, composeItem, flexible4, infoItem, flexible5], animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    @objc private func refresh() {
        self.board = nil
        self.receivedPage = 0
        tableView.reloadData()
        if let refreshControl = tableView.refreshControl {
            if !refreshControl.isRefreshing {
                activityIndicator.startAnimating()
            }
        }
        requestNewPost(page: 1)
    }

    private func requestNewPost(page: Int) {
        if self.isRequesting {
            return
        }
        self.isRequesting = true
        APIClient.getNewPostlist(board: boardName, page: page) { (error, board) in
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.message, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: {
                        self.activityIndicator.stopAnimating()
                        self.tableView.refreshControl?.endRefreshing()
                    })
                    self.isRequesting = false
                }
                return
            }
            if self.board == nil {
                self.receivedPage = page
                self.board = board
            } else if let newPostList = board?.PostList {
                // Only allow adding next page data, once
                if page == self.receivedPage + 1 {
                    self.receivedPage = page
                    self.board?.PostList += newPostList
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.isRequesting = false
                if let board = board, board.PostList.count != 0 &&
                    board.PostList.count == self.tableView.visibleCells.count {
                    // A special case that returns latest posts but less than one page
                    // Automatically request next page
                    self.requestNewPost(page: page + 1)
                } else {
                    self.activityIndicator.stopAnimating()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension BoardViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let board = self.board else {
            return 0
        }
        return board.PostList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}

// MARK: UITableViewDelegate

extension BoardViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        guard let board = self.board, row < board.PostList.count else {
            return
        }
        let post = board.PostList[row]
        var urlComponents = APIClient.pttURLComponents
        urlComponents.path = post.Href
        guard let url = urlComponents.url else {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: "wrong url", preferredStyle: .alert)
            let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSourcePrefetching

extension BoardViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let postList = self.board?.PostList else {
            return
        }
        for indexPath in indexPaths {
            if indexPath.row == postList.count - 1 {    // about to scroll to last row
                requestNewPost(page: receivedPage + 1)
            }
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
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
