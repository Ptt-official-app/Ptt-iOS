//
//  SingleArticleViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import SafariServices
import UIKit

final class SingleArticleViewController: UIViewController, FullscreenSwipeable, ArticleView {

    private enum Section: Hashable {
        case metadata
        case content
        case comments
    }

    private enum Item: Hashable {
        case metadata
        case content
        case comment(String) // BoardArticleComment.idx
    }

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    private let apiClient: APIClientProtocol
    private let keyChainItem: PTTKeyChain

    private let boardArticle: BoardArticle
    private var article: APIModel.FullArticle?
    private var comments: [APIModel.BoardArticleComment] = []
    private var commentIndex: [String: APIModel.BoardArticleComment] = [:]
    private var nextIdx: String? = nil
    private var hasMoreComments = true
    private var isRequesting = false
    private var isLoadingMoreComments = false

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private let refreshControl = UIRefreshControl()

    private static let commentsPrefetchThreshold = 10

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
        configureDataSource()

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didPostNewArticle, object: nil)

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
                        if self.refreshControl.isRefreshing {
                            self.refreshControl.endRefreshing()
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
#if READ_ONLY
#else
                    self.setupBottomToolBar()
#endif
                    self.applySnapshot()
                    self.activityIndicator.stopAnimating()
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    self.loadMoreCommentsIfNeeded()
                })
            }
        }
    }

    private func loadMoreCommentsIfNeeded() {
        guard !isLoadingMoreComments, hasMoreComments else { return }
        isLoadingMoreComments = true
        let bid = boardArticle.article.boardID
        let aid = boardArticle.article.articleID
        let startIdx = nextIdx
        Task { @MainActor [weak self] in
            guard let self else { return }
            defer { self.isLoadingMoreComments = false }
            do {
                let page = try await apiClient.getArticleComments(
                    bid: bid,
                    aid: aid,
                    startIndex: startIdx
                )
                let newComments = page.list.filter { commentIndex[$0.idx] == nil }
                for comment in newComments {
                    commentIndex[comment.idx] = comment
                }
                comments.append(contentsOf: newComments.filter { $0.type != .edit })
                if page.nextIdx.isEmpty || page.nextIdx == startIdx || newComments.isEmpty {
                    hasMoreComments = false
                } else {
                    nextIdx = page.nextIdx
                }
                applySnapshot()
            } catch {
                let message = (error as? APIError)?.message ?? error.localizedDescription
                presentErrorAlert(message: message)
            }
        }
    }
}

// MARK: - Diffable data source

extension SingleArticleViewController {

    private func configureDataSource() {
        let metadataRegistration = UICollectionView.CellRegistration<ArticleMetaDataCell, Void> { [weak self] cell, _, _ in
            cell.article = self?.article
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = PttColors.black.color
            cell.backgroundConfiguration = backgroundConfig
        }

        let contentRegistration = UICollectionView.CellRegistration<ArticleContentCell, Void> { [weak self] cell, _, _ in
            cell.article = self?.article
            cell.setLinkDelegate(self)
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = PttColors.codGray.color
            cell.backgroundConfiguration = backgroundConfig
        }

        let commentRegistration = UICollectionView.CellRegistration<ArticleCommentCell, APIModel.BoardArticleComment> { cell, _, comment in
            cell.comment = comment
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = PttColors.codGray.color
            cell.backgroundConfiguration = backgroundConfig
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item in
            switch item {
            case .metadata:
                return collectionView.dequeueConfiguredReusableCell(using: metadataRegistration, for: indexPath, item: ())
            case .content:
                return collectionView.dequeueConfiguredReusableCell(using: contentRegistration, for: indexPath, item: ())
            case .comment(let idx):
                guard let comment = self?.commentIndex[idx] else { return UICollectionViewCell() }
                return collectionView.dequeueConfiguredReusableCell(using: commentRegistration, for: indexPath, item: comment)
            }
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        guard article != nil else {
            dataSource.apply(snapshot, animatingDifferences: false)
            return
        }
        snapshot.appendSections([.metadata, .content])
        snapshot.appendItems([.metadata], toSection: .metadata)
        snapshot.appendItems([.content], toSection: .content)
        if !comments.isEmpty {
            snapshot.appendSections([.comments])
            snapshot.appendItems(comments.map { .comment($0.idx) }, toSection: .comments)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Prefetching

extension SingleArticleViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard hasMoreComments, !comments.isEmpty else { return }
        let threshold = comments.count - Self.commentsPrefetchThreshold
        let shouldLoadMore = indexPaths.contains { indexPath in
            guard case .comment = dataSource.itemIdentifier(for: indexPath) else { return false }
            return indexPath.item >= threshold
        }
        if shouldLoadMore {
            loadMoreCommentsIfNeeded()
        }
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // No-op: pagination work is page-scoped, not per-item.
    }
}

// MARK: - Actions

extension SingleArticleViewController {
    @objc
    private func refresh() {
        self.article = nil
        self.comments = []
        self.commentIndex = [:]
        self.nextIdx = nil
        self.hasMoreComments = true
        self.isLoadingMoreComments = false
        applySnapshot()
        requestArticle()
        if !refreshControl.isRefreshing {
            activityIndicator.startAnimating()
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

        setupCollectionView()
#if READ_ONLY
        navigationController?.isToolbarHidden = true
#else
        navigationController?.isToolbarHidden = false
#endif
    }

    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.backgroundColor = PttColors.black.color
            config.showsSeparators = false
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = PttColors.black.color
        collectionView.allowsSelection = false
        collectionView.isPrefetchingEnabled = true
        collectionView.prefetchDataSource = self

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl

        view.addSubview(collectionView)
        view.ptt_add(subviews: [activityIndicator])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80.0),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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

extension SingleArticleViewController: UITextViewDelegate {
    func textView(
        _ textView: UITextView,
        shouldInteractWith URL: URL,
        in characterRange: NSRange,
        interaction: UITextItemInteraction
    ) -> Bool {
        guard interaction == .invokeDefaultAction,
              let scheme = URL.scheme?.lowercased(),
              scheme == "http" || scheme == "https" else {
            return true
        }
        let safari = SFSafariViewController(url: URL)
        present(safari, animated: true)
        return false
    }
}
