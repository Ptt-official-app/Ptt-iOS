//
//  BoardViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit
import SafariServices
import AsyncDisplayKit

protocol BoardView: BaseView {}

final class BoardViewController: ASDKViewController<ASTableNode>, FullscreenSwipeable, BoardView {

    private let tableNode = ASTableNode(style: .plain)
    private var tableView : UITableView {
        return tableNode.view
    }
    private let apiClient: APIClientProtocol

    private var boardName : String
    private var board : APIModel.Board? = nil
    private var isRequesting = false
    private var receivedPage : Int = 0
    private let cellReuseIdentifier = "BoardPostCell"

    private let bottomView = UIView()
    private let toolBar = UIToolbar()
    private let activityIndicator = UIActivityIndicatorView()
    private var bottomViewHeightConstraint : NSLayoutConstraint? = nil

    init(boardName: String, apiClient: APIClientProtocol=APIClient.shared) {
        self.apiClient = apiClient
        self.boardName = boardName
        super.init(node: tableNode)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = boardName
        enableFullscreenSwipeBack()

        tableNode.backgroundColor = GlobalAppearance.backgroundColor
        tableNode.dataSource = self
        tableNode.delegate = self
        if #available(iOS 13.0, *) {
        } else {
            tableView.indicatorStyle = .white
        }
        tableView.separatorStyle = .none

        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            tableView.refreshControl = refreshControl
        } else {
            let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
            navigationItem.rightBarButtonItem = refreshItem
        }

        activityIndicator.color = .lightGray
        tableView.ptt_add(subviews: [activityIndicator])
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20.0),
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])

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

        // TODO:
        /*
        if toolBar.superview == nil {
            toolBar.frame = CGRect(x: 0, y: 0, width: bottomView.frame.width, height: toolBarHeight)
            toolBar.barTintColor = GlobalAppearance.backgroundColor
            bottomView.ptt_add(subviews: [toolBar])
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

            let refreshItem = UIBarButtonItem(image: StyleKit.imageOfRefresh().withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(refresh))
            refreshItem.accessibilityLabel = NSLocalizedString("Refresh", comment: "")
            let searchItem = UIBarButtonItem(image: StyleKit.imageOfSearch().withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
            searchItem.accessibilityLabel = NSLocalizedString("Search", comment: "")
            let composeItem = UIBarButtonItem(image: StyleKit.imageOfCompose().withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
            composeItem.accessibilityLabel = NSLocalizedString("Compose", comment: "")
            let infoItem = UIBarButtonItem(image: StyleKit.imageOfMoreH().withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
            infoItem.accessibilityLabel = NSLocalizedString("More actions", comment: "")
            let flexible1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let flexible2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let flexible3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let flexible4 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let flexible5 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.setItems([flexible1, refreshItem, flexible2, searchItem, flexible3, composeItem, flexible4, infoItem, flexible5], animated: false)
        }
         */
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
        tableNode.reloadData()
        if #available(iOS 10.0, *) {
            if let refreshControl = tableView.refreshControl {
                if !refreshControl.isRefreshing {
                    activityIndicator.startAnimating()
                }
            }
        } else {
            activityIndicator.startAnimating()
        }
    }

    private func requestNewPost(page: Int, context: ASBatchContext) {
        if self.isRequesting {
            return
        }
        self.isRequesting = true
        context.beginBatchFetching()
        self.apiClient.getNewPostlist(board: boardName, page: page) { (result) in
            switch result {
            case .failure(error: let apiError):
                context.cancelBatchFetching()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: apiError.message, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: {
                        self.activityIndicator.stopAnimating()
                        if #available(iOS 10.0, *) {
                            if let refreshControl = self.tableView.refreshControl, refreshControl.isRefreshing {
                                refreshControl.endRefreshing()
                            }
                        }
                    })
                    self.isRequesting = false
                }
                return
            case .success(board: let board):
                if self.board == nil {
                    self.receivedPage = page
                    self.board = board
                    var indexPaths = [IndexPath]()
                    for (index, _) in board.postList.enumerated() {
                        indexPaths.append(IndexPath(row: index, section: 0))
                    }
                    DispatchQueue.main.async {
                        self.tableNode.insertRows(at: indexPaths, with: .none)
                        context.completeBatchFetching(true)
                    }
                } else {
                    // Only allow adding next page data, once
                    if page == self.receivedPage + 1 {
                        self.receivedPage = page
                        var indexPaths = [IndexPath]()
                        if let oldCount = self.board?.postList.count {
                            for (index, _) in board.postList.enumerated() {
                                indexPaths.append(IndexPath(row: index + oldCount, section: 0))
                            }
                        }
                        self.board?.postList += board.postList
                        DispatchQueue.main.async {
                            self.tableNode.insertRows(at: indexPaths, with: .none)
                            context.completeBatchFetching(true)
                        }
                    }
                }
                self.isRequesting = false
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if #available(iOS 10.0, *) {
                        if let refreshControl = self.tableView.refreshControl, refreshControl.isRefreshing {
                            refreshControl.endRefreshing()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - ASTableDataSource

extension BoardViewController: ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        guard let board = self.board else {
            return 0
        }
        return board.postList.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let row = indexPath.row
        guard let board = self.board, row < board.postList.count else {
            let nodeBlock: ASCellNodeBlock = {
                return ASCellNode()
            }
            return nodeBlock
        }
        let post = board.postList[row]
        let nodeBlock: ASCellNodeBlock = {
            let cell = BoardCellNode(post: post)
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
        return nodeBlock
    }
}

extension BoardViewController: ASTableDelegate {

    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }

    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        requestNewPost(page: receivedPage + 1, context: context)
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        guard let board = self.board, row < board.postList.count else {
            return
        }
        let post = board.postList[row]
        let postViewController = PostViewController(post: post, boardName: boardName)
        show(postViewController, sender: self)
    }
}

private class BoardCellNode: ASCellNode {

    private var titleAttributes : [NSAttributedString.Key : Any] {
        let textColor : UIColor
        if #available(iOS 11.0, *) {
            textColor = UIColor(named: "textColor-240-240-247")!
        } else {
            textColor = UIColor(red:240/255, green:240/255, blue:247/255, alpha:1.0)
        }
        let attrs : [NSAttributedString.Key : Any] =
            [.font: UIFont.preferredFont(forTextStyle: .title3),
             .foregroundColor: textColor]
        return attrs
    }
    private var metadataAttributes : [NSAttributedString.Key : Any] {
        let textColor : UIColor
        if #available(iOS 11.0, *) {
            textColor = UIColor(named: "textColorGray")!
        } else {
            textColor = .systemGray
        }
        let attrs : [NSAttributedString.Key : Any] =
            [.font: UIFont.preferredFont(forTextStyle: .footnote),
             .foregroundColor: textColor]
        return attrs
    }
    private let categoryImageNode = ASImageNode()
    private let categoryNode = ASTextNode()
    private let clockImageNode = ASImageNode()
    private let dateNode = ASTextNode()
    private let authorImageNode = ASImageNode()
    private let authorNameNode = ASTextNode()

    private let titleNode = ASTextNode()
    private let moreButtonNode = ASButtonNode()

    init(post: APIModel.BoardPost) {
        super.init()

        automaticallyManagesSubnodes = true

        categoryNode.attributedText = NSAttributedString(string: post.category, attributes: metadataAttributes)
        dateNode.attributedText = NSAttributedString(string: post.date, attributes: metadataAttributes)
        authorNameNode.attributedText = NSAttributedString(string: post.author, attributes: metadataAttributes)
        titleNode.attributedText = NSAttributedString(string: post.titleWithoutCategory, attributes: titleAttributes)

        categoryImageNode.image = StyleKit.imageOfCategory()
        clockImageNode.image = StyleKit.imageOfClock()
        authorImageNode.image = StyleKit.imageOfAuthor()

        moreButtonNode.setImage(StyleKit.imageOfMoreV(), for: .normal)
        moreButtonNode.accessibilityLabel = NSLocalizedString("More actions", comment: "")
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let categoryStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                  spacing: 7,
                                                  justifyContent: .start,
                                                  alignItems: .center,
                                                  children: [categoryImageNode, categoryNode])
        let dateStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                              spacing: 7,
                                              justifyContent: .start,
                                              alignItems: .center,
                                              children: [clockImageNode, dateNode])
        let authorStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                spacing: 7,
                                                justifyContent: .start,
                                                alignItems: .center,
                                                children: [authorImageNode, authorNameNode])
        let metadataStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                  spacing: 14,
                                                  justifyContent: .start,
                                                  alignItems: .start,
                                                  children: [categoryStackSpec, dateStackSpec, authorStackSpec])
        let contentStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                 spacing: 6,
                                                 justifyContent: .start,
                                                 alignItems: .start,
                                                 children: [metadataStackSpec, titleNode])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 10), child: contentStackSpec)
    }
}
