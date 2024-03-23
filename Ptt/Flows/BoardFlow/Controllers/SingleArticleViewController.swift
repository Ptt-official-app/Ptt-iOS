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
    private let keyChainItem: PTTKeyChain

    private let boardArticle: BoardArticle
    private var article: APIModel.FullArticle?
    private var isRequesting = false

    init(
        article: BoardArticle,
        keyChainItem: PTTKeyChain = KeyChainItem.shared,
        apiClient: APIClientProtocol = APIClient.shared
    ) {
        self.boardArticle = article
        self.keyChainItem = keyChainItem
        self.apiClient = apiClient
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didPostNewArticle, object: nil)
//        navigationController?.isToolbarHidden = false
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
                    self.setupBottomToolBar()
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                    if let refreshControl = self.tableView.refreshControl, refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                })
            }
        }
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

// MARK: - Actions
extension SingleArticleViewController {
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
        guard let article else { return }
        let item = [article.url]
        let activityViewController = UIActivityViewController(activityItems: item, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view

        present(activityViewController, animated: true, completion: nil)
    }

    @objc
    private func more() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: L10n.deleteArticle, style: .default) { [weak self] _ in
            self?.presentDeleteArticleConfirmation()
        }
        let cancel = UIAlertAction(title: L10n.cancel, style: .cancel)
        [deleteAction, cancel].forEach(alert.addAction)
        present(alert, animated: true)
    }

    private func amIAuthor() -> Bool {
        guard let loginToken: APIModel.LoginToken = keyChainItem.readObject(for: .loginToken) else { return false }
        return loginToken.user_id == article?.author
    }

    private func deleteArticle() {
        Task {
            guard let article else { return }
            await MainActor.run {
                view.isUserInteractionEnabled = false
                addLoadingView()
            }
            do {
                let result = try await apiClient.deleteArticle(boardID: article.bid, articleIDs: [article.aid])
                if result.success {
                    NotificationCenter.default.post(name: .didDeleteArticle, object: nil)
                    navigationController?.popViewController(animated: true)
                }
            } catch {
                await MainActor.run {
                    view.isUserInteractionEnabled = true
                    removeLoadingView()
                    presentErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - View
extension SingleArticleViewController {
    private func setupViews() {
        title = boardArticle.article.title
        enableFullscreenSwipeBack()

        setupTableView()
        navigationController?.isToolbarHidden = false
    }

    private func setupTableView() {
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
    }

    private func setupBottomToolBar() {
        let flex = UIBarButtonItem(systemItem: .flexibleSpace)
        let shareItem = makeBarButtonItem(imageName: "square.and.arrow.up", action: #selector(self.share))
        let moreItem = makeBarButtonItem(imageName: "ellipsis", action: #selector(self.more))
        var items = [flex, shareItem]
        if amIAuthor() && !boardArticle.flag.contains(.noSelfDeletePost) {
            items.append(moreItem)
        }
        self.setToolbarItems(items, animated: false)
    }

    private func makeBarButtonItem(imageName: String, action: Selector) -> UIBarButtonItem {
        let item = UIBarButtonItem(
            image: UIImage(systemName: imageName),
            style: .plain,
            target: self,
            action: action
        )
        item.tintColor = PttColors.slateGrey.color
        return item
    }

    private func presentDeleteArticleConfirmation() {
        let alert = UIAlertController(
            title: L10n.deleteArticle,
            message: L10n.areYouSureToDeleteIt,
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(title: L10n.delete, style: .default) { [weak self] _ in
            self?.deleteArticle()
        }
        let cancel = UIAlertAction(title: L10n.cancel, style: .cancel)
        [deleteAction, cancel].forEach(alert.addAction)
        present(alert, animated: true)
    }
}
