//
//  SingleArticleViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import SafariServices
import UIKit

final class SingleArticleViewController: UITableViewController, FullscreenSwipeable, ArticleView {

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let apiClient: APIClientProtocol

    private let boardArticle: BoardArticle
    private var article: APIModel.FullArticle?
    private var isRequesting = false

    init(article: BoardArticle, apiClient: APIClientProtocol = APIClient.shared) {
        self.boardArticle = article
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = boardArticle.article.title
        enableFullscreenSwipeBack()

        tableView.backgroundColor = PttColors.black.color
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(ArticleMetaDataCell.self, forCellReuseIdentifier: "ArticleMetaDataCell")
        tableView.register(ArticleContentCell.self, forCellReuseIdentifier: "ArticleContentCell")

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        tableView.ptt_add(subviews: [activityIndicator])
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 80.0),
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("didPostNewArticle"), object: nil)

        refresh()
    }

    private func requestArticle() {
        if self.isRequesting {
            return
        }
        self.isRequesting = true
        self.apiClient.getArticle(of: ArticleParams.go_pttbbs(bid: boardArticle.article.boardID, aid: boardArticle.article.articleID)) { result in
            self.isRequesting = false
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
                })
                return
            case .success(board: let article):
                guard let article = article as? APIModel.FullArticle else {
                    return
                }
                self.article = article
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    if let refreshControl = self.tableView.refreshControl, refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                })
            }
        }
    }

    // MARK: Button actions

    @objc
    private func refresh() {
        self.article = nil
        requestArticle()
        if let refreshControl = tableView.refreshControl {
            if !refreshControl.isRefreshing {
                activityIndicator.startAnimating()
            }
        }
    }

    @objc
    private func upvote() {
    }

    @objc
    private func reply() {
    }

    @objc
    private func share() {
    }

    @objc
    private func more() {
    }
}

// MARK: - ASTableDataSource

extension SingleArticleViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let article = self.article else {
            return UITableViewCell()
        }
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleMetaDataCell", for: indexPath) as! ArticleMetaDataCell
            cell.article = article
            cell.backgroundColor = PttColors.black.color
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleContentCell", for: indexPath) as! ArticleContentCell
            cell.article = article
            cell.backgroundColor = PttColors.codGray.color
            return cell
        }
    }
}

private final class ArticleMetaDataCell: UITableViewCell {

    private let categoryImageView = UIImageView()
    private let categoryLabel = UILabel()
    private let clockImageView = UIImageView()
    private let dateLabel = UILabel()
    private let authorImageView = UIImageView()
    private let authorNameLabel = UILabel()

    var article: APIModel.FullArticle? = nil {
        didSet {
            if let article {
                if let category = article.category {
                    categoryLabel.text = "\(article.board) / \(category)"
                } else {
                    categoryLabel.text = article.board
                }
                dateLabel.text = article.date
                authorNameLabel.text = "\(article.author) (\(article.nickname))"
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        categoryImageView.image = StyleKit.imageOfBoardCategory()
        clockImageView.image = StyleKit.imageOfClock()
        authorImageView.image = StyleKit.imageOfAuthor()

        categoryLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        authorNameLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        categoryLabel.textColor = .systemGray
        dateLabel.textColor = .systemGray
        authorNameLabel.textColor = .systemGray

        contentView.ptt_add(subviews: [categoryImageView, categoryLabel, clockImageView, dateLabel, authorImageView, authorNameLabel])
        let viewsDict = ["categoryImageView": categoryImageView, "categoryLabel": categoryLabel, "clockImageView": clockImageView, "dateLabel": dateLabel, "authorImageView": authorImageView, "authorNameLabel": authorNameLabel]
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-[categoryImageView]-(10)-[authorImageView]-(10)-[clockImageView]-|", metrics: nil, views: viewsDict) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(44)-[categoryImageView]-[categoryLabel]", metrics: nil, views: viewsDict) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(44)-[authorImageView]-[authorNameLabel]", metrics: nil, views: viewsDict) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(44)-[clockImageView]-[dateLabel]", metrics: nil, views: viewsDict) +
            [categoryImageView.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
             authorImageView.centerYAnchor.constraint(equalTo: authorNameLabel.centerYAnchor),
             clockImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)]
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class ArticleContentCell: UITableViewCell {

    private let contentTextView = UITextView()
    var article: APIModel.FullArticle? = nil {
        didSet {
            if let article {
                contentTextView.text = article.content
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentTextView.backgroundColor = PttColors.codGray.color
        contentTextView.font = UIFont.preferredFont(forTextStyle: .body)
        contentTextView.textColor = PttColors.paleGrey.color
        contentTextView.dataDetectorTypes = .all
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        // See: https://stackoverflow.com/a/28589384/3796488
        contentTextView.accessibilityTraits = .staticText
        contentView.ptt_add(subviews: [contentTextView])
        let viewsDict = ["contentTextView": contentTextView]
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(24)-[contentTextView]-(24)-|", metrics: nil, views: viewsDict) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(18)-[contentTextView]-(18)-|", metrics: nil, views: viewsDict)
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
