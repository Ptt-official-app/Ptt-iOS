//
//  BoardViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import SafariServices
import UIKit

struct BoardArticle {
    let article: APIModel.BoardArticle
    let flag: APIModel.BoardAttribute
    let boardName: String
}

protocol BoardView: BaseView {
    var onArticleSelect: ((BoardArticle) -> Void)? { get set }
    var composeArticle: ((String, [String]) -> Void)? { get set }
}

final class BoardViewController: UIViewController, FullscreenSwipeable, BoardView {

    var onArticleSelect: ((BoardArticle) -> Void)?
    var composeArticle: ((String, [String]) -> Void)?

    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let apiClient: APIClientProtocol

    private var boardName: String
    private var board: APIModel.BoardModel?
    private var boardDetail: APIModel.BoardDetail?
    private var isRequesting = false
    private var nextIndex: String?
    private let cellReuseIdentifier = "BoardArticleCell"

    init(boardName: String, apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
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
        enableFullscreenSwipeBack()

        tableView.backgroundColor = GlobalAppearance.backgroundColor
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.separatorStyle = .none
        tableView.register(BoardCell.self, forCellReuseIdentifier: "BoardCell")

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        view.ptt_add(subviews: [tableView, activityIndicator])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        setupToolBar()

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didPostNewArticle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didDeleteArticle, object: nil)
        requestBoardDetail()
        refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
        toolbarItems = []
    }

    private func requestArticles(startIndex: String?) {
        if self.isRequesting {
            return
        }
        // End of articles
        if let startIndex, startIndex.isEmpty {
            return
        }
        self.isRequesting = true

        self.apiClient.getBoardArticles(of: .go_pttbbs(bid: boardName, startIdx: startIndex)) { result in
            switch result {
            case .failure(error: let apiError):
                DispatchQueue.main.async(execute: {
                    let alert = UIAlertController(title: L10n.error, message: apiError.message, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: {
                        self.activityIndicator.stopAnimating()
                        if let refreshControl = self.tableView.refreshControl, refreshControl.isRefreshing {
                            refreshControl.endRefreshing()
                        }
                    })
                    self.isRequesting = false
                })
                return
            case .success(board: let board):
                self.nextIndex = board.next
                if self.board == nil {
                    self.board = board
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                } else {
                    var indexPaths = [IndexPath]()
                    if let oldCount = self.board?.articleList.count {
                        for index in board.articleList.indices {
                            indexPaths.append(IndexPath(row: index + oldCount, section: 0))
                        }
                    }
                    self.board?.articleList += board.articleList
                    DispatchQueue.main.async(execute: {
                        self.tableView.insertRows(at: indexPaths, with: .none)
                    })
                }
                self.isRequesting = false
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                    if let refreshControl = self.tableView.refreshControl, refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                })
            }
        }
    }

    private func requestBoardDetail() {
        Task {
            self.boardDetail = try await apiClient.boardDetail(boardID: boardName)
        }
    }

    private func setupToolBar() {
        let refreshButtonItem = UIBarButtonItem(image: StyleKit.imageOfRefresh(), style: .plain, target: self, action: #selector(refresh))
        let searchButtonItem = UIBarButtonItem(image: StyleKit.imageOfSearch(), style: .plain, target: self, action: #selector(search))
        let composeButtonItem = UIBarButtonItem(image: StyleKit.imageOfCompose(), style: .plain, target: self, action: #selector(compose))
        let moreButtonItem = UIBarButtonItem(image: StyleKit.imageOfMoreH(), style: .plain, target: self, action: #selector(refresh))
        // TODO: Only add working buttons, for now.
        let flexible1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexible2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let flexible3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        let items = [flexible1, refreshButtonItem, flexible2, composeButtonItem, flexible3]
        navigationController?.isToolbarHidden = false
        toolbarItems = items
    }

    // MARK: Button actions
    @objc
    private func refresh() {
        self.board = nil
        self.nextIndex = nil
        self.tableView.reloadData()
        requestArticles(startIndex: nil)
        activityIndicator.startAnimating()
    }

    @objc
     private func search() {
    }

    @objc
     private func compose() {
        composeArticle?(boardName, boardDetail?.postTypes ?? [])
    }

    @objc
     private func more() {
    }
}

// MARK: - UITableViewDataSource

extension BoardViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let board = self.board else {
            return 0
        }
        return board.articleList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let board = self.board, row < board.articleList.count else {
            return UITableViewCell()
        }
        let article = board.articleList[row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as! BoardCell
        cell.article = article
        if row % 2 == 0 {
            cell.backgroundColor = PttColors.shark.color
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
        guard 
            let board = self.board,
            row < board.articleList.count,
            let rawFlag = boardDetail?.flag
        else { return }
        let flag = APIModel.BoardAttribute(rawValue: UInt32(rawFlag))
        let article = board.articleList[row]
        onArticleSelect?(BoardArticle(article: article, flag: flag, boardName: boardName))
    }
}

// MARK: UITableDelegate

extension BoardViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let board = self.board, let lastIndexPath = indexPaths.last else {
            return
        }
        let receivedLastRowIndex = board.articleList.count - 1
        let prefetchRangeBeforeEnd = 20
        if lastIndexPath.row + prefetchRangeBeforeEnd > receivedLastRowIndex {
            requestArticles(startIndex: self.nextIndex)
        }
    }
}

// MARK: -

private class BoardCell: UITableViewCell {

    private var titleAttributes: [NSAttributedString.Key: Any] {
        let textColor = PttColors.paleGrey.color
        let attrs: [NSAttributedString.Key: Any] =
            [.font: UIFont.preferredFont(forTextStyle: .title3),
             .foregroundColor: textColor]
        return attrs
    }
    private var metadataAttributes: [NSAttributedString.Key: Any] {
        let textColor: UIColor = .systemGray
        let attrs: [NSAttributedString.Key: Any] =
            [.font: UIFont.preferredFont(forTextStyle: .footnote),
             .foregroundColor: textColor]
        return attrs
    }
    private let categoryImageView = UIImageView()
    private let categoryLabel = UILabel()
    private let clockImageView = UIImageView()
    private let dateLabel = UILabel()
    private let authorImageView = UIImageView()
    private let authorNameLabel = UILabel()

    private let titleLabel = UILabel()
    private let moreButton = UIButton()
    var article: APIModel.BoardArticle? = nil {
        didSet {
            if let article, let category = article.category {
                categoryLabel.attributedText = NSAttributedString(string: category, attributes: metadataAttributes)
                dateLabel.attributedText = NSAttributedString(string: article.date, attributes: metadataAttributes)
                authorNameLabel.attributedText = NSAttributedString(string: article.author, attributes: metadataAttributes)
                titleLabel.attributedText = NSAttributedString(string: article.titleWithoutCategory, attributes: titleAttributes)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.numberOfLines = 2
        categoryImageView.image = StyleKit.imageOfCategory()
        clockImageView.image = StyleKit.imageOfClock()
        authorImageView.image = StyleKit.imageOfAuthor()

        moreButton.setImage(StyleKit.imageOfMoreV(), for: .normal)
        moreButton.accessibilityLabel = L10n.moreActions

        contentView.ptt_add(subviews: [categoryImageView, categoryLabel, clockImageView, dateLabel, authorImageView, authorNameLabel, titleLabel])
        let viewsDict = ["categoryImageView": categoryImageView, "categoryLabel": categoryLabel, "clockImageView": clockImageView, "dateLabel": dateLabel, "authorImageView": authorImageView, "authorNameLabel": authorNameLabel, "titleLabel": titleLabel]
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(20)-[categoryImageView]-[titleLabel]-(15)-|", metrics: nil, views: viewsDict) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[categoryImageView]-[categoryLabel]-[clockImageView]-[dateLabel]-[authorImageView]-[authorNameLabel]", metrics: nil, views: viewsDict) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]-|", metrics: nil, views: viewsDict) +
            [
                categoryLabel.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor),
                clockImageView.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor),
                dateLabel.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor),
                authorImageView.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor),
                authorNameLabel.centerYAnchor.constraint(equalTo: categoryImageView.centerYAnchor)
            ]
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
