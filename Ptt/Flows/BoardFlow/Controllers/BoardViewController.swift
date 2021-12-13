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

struct BoardArticle {
    let article: APIModel.BoardArticle
    let boardName: String
}

protocol BoardView: BaseView {
    var onArticleSelect: ((BoardArticle) -> Void)? { get set }
    var composeArticle: ((String) -> Void)? {get set}
}

final class BoardViewController: ASDKViewController<ASDisplayNode>, FullscreenSwipeable, BoardView {
    
    var onArticleSelect: ((BoardArticle) -> Void)?
    var composeArticle: ((String) -> Void)?

    private let boardNode = BoardNode()
    private var tableNode : ASTableNode {
        return boardNode.tableNode
    }
    private var tableView : UITableView {
        return tableNode.view
    }
    private var activityIndicator : UIActivityIndicatorView {
        return boardNode.activityIndicatorNode.view as! UIActivityIndicatorView
    }
    private var toolbarNode : ToolbarNode {
        return boardNode.bottomToolbarNode.toolbarAreaNode
    }

    private let apiClient: APIClientProtocol

    private var boardName : String
    private var board : APIModel.BoardModel? = nil
    private var isRequesting = false
    private var receivedPage : Int = 0
    private let cellReuseIdentifier = "BoardArticleCell"

    init(boardName: String, apiClient: APIClientProtocol=APIClient.shared) {
        self.apiClient = apiClient
        self.boardName = boardName
        super.init(node: boardNode)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = boardName
        enableFullscreenSwipeBack()

        tableNode.dataSource = self
        tableNode.delegate = self
        tableView.separatorStyle = .none
        let edgeInsetsForToolbar = UIEdgeInsets(top: 0, left: 0, bottom: toolbarNode.toolbarHeight, right: 0)
        tableView.contentInset = edgeInsetsForToolbar
        tableView.scrollIndicatorInsets = edgeInsetsForToolbar

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        toolbarNode.refreshNode.addTarget(self, action: #selector(refresh), forControlEvents: .touchUpInside)
        toolbarNode.searchNode.addTarget(self, action: #selector(search), forControlEvents: .touchUpInside)
        toolbarNode.composeNode.addTarget(self, action: #selector(compose), forControlEvents: .touchUpInside)
        toolbarNode.moreNode.addTarget(self, action: #selector(more), forControlEvents: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("didPostNewArticle"), object: nil)
        
        refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    private func requestArticles(page: Int, context: ASBatchContext) {
        if self.isRequesting {
            return
        }
        self.isRequesting = true
        context.beginBatchFetching()
        
        self.apiClient.getBoardArticles(of: .go_pttbbs(bid: boardName, startIdx: "")) { (result) in
            switch result {
            case .failure(error: let apiError):
                context.cancelBatchFetching()
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: apiError.message, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: {
                        self.activityIndicator.stopAnimating()
                        if let refreshControl = self.tableView.refreshControl, refreshControl.isRefreshing {
                            refreshControl.endRefreshing()
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
                    for (index, _) in board.articleList.enumerated() {
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
                        if let oldCount = self.board?.articleList.count {
                            for (index, _) in board.articleList.enumerated() {
                                indexPaths.append(IndexPath(row: index + oldCount, section: 0))
                            }
                        }
                        self.board?.articleList += board.articleList
                        DispatchQueue.main.async {
                            self.tableNode.insertRows(at: indexPaths, with: .none)
                            context.completeBatchFetching(true)
                        }
                    }
                }
                self.isRequesting = false
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if let refreshControl = self.tableView.refreshControl, refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
    }

    // MARK: Button actions

    @objc private func refresh() {
        self.board = nil
        self.receivedPage = 0
        tableNode.reloadData()
        if let refreshControl = tableView.refreshControl {
            if !refreshControl.isRefreshing {
                activityIndicator.startAnimating()
            }
        }
    }

    @objc private func search() {
    }

    @objc private func compose() {
        composeArticle?(boardName)
    }

    @objc private func more() {
    }
}

// MARK: - ASTableDataSource

extension BoardViewController: ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        guard let board = self.board else {
            return 0
        }
        return board.articleList.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let row = indexPath.row
        guard let board = self.board, row < board.articleList.count else {
            let nodeBlock: ASCellNodeBlock = {
                return ASCellNode()
            }
            return nodeBlock
        }
        let article = board.articleList[row]
        let nodeBlock: ASCellNodeBlock = {
            let cell = BoardCellNode(article: article)
            if row % 2 == 0 {
                cell.backgroundColor = UIColor(named: "blackColor-28-28-31")
            } else {
                cell.backgroundColor = GlobalAppearance.backgroundColor
            }
            return cell
        }
        return nodeBlock
    }
}

// MARK: ASTableDelegate

extension BoardViewController: ASTableDelegate {

    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }

    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        requestArticles(page: receivedPage + 1, context: context)
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        guard let board = self.board, row < board.articleList.count else {
            return
        }
        let article = board.articleList[row]
        onArticleSelect?(BoardArticle(article: article, boardName: boardName))
    }
}

// MARK: -

private class BoardNode: ASDisplayNode {

    let tableNode = ASTableNode(style: .plain)
    let activityIndicatorNode = ASDisplayNode { () -> UIView in
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .lightGray
        return activityIndicator
    }
    let bottomToolbarNode = BottomToolbarNode()

    override init() {
        super.init()

        automaticallyManagesSubnodes = true
        tableNode.backgroundColor = GlobalAppearance.backgroundColor
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let insets = UIEdgeInsets(top: .infinity,
                                  left: 0,
                                  bottom: 0,
                                  right: 0)
        let toolbarInsetSpec = ASInsetLayoutSpec(insets: insets, child: bottomToolbarNode)
        let tableNodeSpec = ASOverlayLayoutSpec(child: tableNode, overlay: toolbarInsetSpec)
        return ASOverlayLayoutSpec(child: tableNodeSpec, overlay: activityIndicatorNode)
    }
}

private class BottomToolbarNode: ASDisplayNode {

    private let topBorderNode = ASDisplayNode()
    let toolbarAreaNode = ToolbarNode()
    private let safeAreaNode = ASDisplayNode()

    override init() {
        super.init()

        automaticallyManagesSubnodes = true
        automaticallyRelayoutOnSafeAreaChanges = true

        topBorderNode.backgroundColor = UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 1.00)    // #3A3A3A
        topBorderNode.style.height = ASDimensionMake(0.5)
        safeAreaNode.backgroundColor = GlobalAppearance.backgroundColor
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let safeAreaInsets = self.safeAreaInsets
        safeAreaNode.style.height = ASDimensionMake(safeAreaInsets.top + safeAreaInsets.bottom)
        return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .stretch, children: [topBorderNode, toolbarAreaNode, safeAreaNode])
    }
}

private class ToolbarNode: ASDisplayNode {

    let refreshNode = ASButtonNode()
    let searchNode = ASButtonNode()
    let composeNode = ASButtonNode()
    let moreNode = ASButtonNode()
    let toolbarHeight : CGFloat = 49.0

    override init() {
        super.init()

        automaticallyManagesSubnodes = true
        style.height = ASDimensionMake(toolbarHeight)
        backgroundColor = GlobalAppearance.backgroundColor

        refreshNode.setImage(StyleKit.imageOfRefresh().withRenderingMode(.alwaysOriginal), for: .normal)
        refreshNode.setImage(StyleKit.imageOfRefresh().withRenderingMode(.alwaysTemplate), for: .highlighted)
        refreshNode.accessibilityLabel = NSLocalizedString("Refresh", comment: "")
        searchNode.setImage(StyleKit.imageOfSearch().withRenderingMode(.alwaysOriginal), for: .normal)
        searchNode.setImage(StyleKit.imageOfSearch().withRenderingMode(.alwaysTemplate), for: .highlighted)
        searchNode.accessibilityLabel = NSLocalizedString("Search", comment: "")
        composeNode.setImage(StyleKit.imageOfCompose().withRenderingMode(.alwaysOriginal), for: .normal)
        composeNode.setImage(StyleKit.imageOfCompose().withRenderingMode(.alwaysTemplate), for: .highlighted)
        composeNode.accessibilityLabel = NSLocalizedString("Compose", comment: "")
        moreNode.setImage(StyleKit.imageOfMoreH().withRenderingMode(.alwaysOriginal), for: .normal)
        moreNode.setImage(StyleKit.imageOfMoreH().withRenderingMode(.alwaysTemplate), for: .highlighted)
        moreNode.accessibilityLabel = NSLocalizedString("More actions", comment: "")
        for buttonNode in [refreshNode, searchNode, composeNode, moreNode] {
            buttonNode.style.width = ASDimensionMake(toolbarHeight + 30)
            buttonNode.style.height = ASDimensionMake(toolbarHeight)
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .center, alignItems: .stretch, children: [refreshNode, searchNode, composeNode, moreNode])
    }
}

private class BoardCellNode: ASCellNode {

    private var titleAttributes : [NSAttributedString.Key : Any] {
        let textColor : UIColor
        textColor = UIColor(named: "textColor-240-240-247")!
        let attrs : [NSAttributedString.Key : Any] =
            [.font: UIFont.preferredFont(forTextStyle: .title3),
             .foregroundColor: textColor]
        return attrs
    }
    private var metadataAttributes : [NSAttributedString.Key : Any] {
        let textColor : UIColor
        textColor = UIColor(named: "textColorGray")!
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

    init(article: APIModel.BoardArticle) {
        super.init()

        automaticallyManagesSubnodes = true

        categoryNode.attributedText = NSAttributedString(string: article.category, attributes: metadataAttributes)
        dateNode.attributedText = NSAttributedString(string: article.date, attributes: metadataAttributes)
        authorNameNode.attributedText = NSAttributedString(string: article.author, attributes: metadataAttributes)
        titleNode.attributedText = NSAttributedString(string: article.titleWithoutCategory, attributes: titleAttributes)

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
