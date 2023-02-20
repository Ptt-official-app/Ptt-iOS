//
//  SingleArticleViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit
import SafariServices
import AsyncDisplayKit

final class SingleArticleViewController: ASDKViewController<ASDisplayNode>, FullscreenSwipeable, ArticleView {

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
    private var toolbarNode : ArticleToolbarNode {
        return boardNode.bottomToolbarNode.toolbarAreaNode
    }

    private let apiClient: APIClientProtocol

    private let boardArticle : BoardArticle
    private var article : APIModel.FullArticle? = nil
    private var isRequesting = false

    init(article: BoardArticle, apiClient: APIClientProtocol=APIClient.shared) {
        self.boardArticle = article
        self.apiClient = apiClient
        super.init(node: boardNode)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = boardArticle.article.title
        enableFullscreenSwipeBack()

        tableNode.dataSource = self

        tableView.separatorStyle = .none
        let edgeInsetsForToolbar = UIEdgeInsets(top: 0, left: 0, bottom: toolbarNode.toolbarHeight, right: 0)
        tableView.contentInset = edgeInsetsForToolbar
        tableView.scrollIndicatorInsets = edgeInsetsForToolbar

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        toolbarNode.upvoteNode.addTarget(self, action: #selector(upvote), forControlEvents: .touchUpInside)
        toolbarNode.replyNode.addTarget(self, action: #selector(reply), forControlEvents: .touchUpInside)
        toolbarNode.shareNode.addTarget(self, action: #selector(share), forControlEvents: .touchUpInside)
        toolbarNode.moreNode.addTarget(self, action: #selector(more), forControlEvents: .touchUpInside)

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("didPostNewArticle"), object: nil)

        refresh()
    }

    private func requestArticle() {
        if self.isRequesting {
            return
        }
        self.isRequesting = true
        self.apiClient.getArticle(of: ArticleParams.go_pttbbs(bid: boardArticle.article.boardID, aid: boardArticle.article.articleID)) { (result) in
            self.isRequesting = false
            switch result {
            case .failure(error: let apiError):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: L10n.error, message: apiError.message, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: {
                        self.activityIndicator.stopAnimating()
                        if #available(iOS 10.0, *) {
                            if let refreshControl = self.tableView.refreshControl, refreshControl.isRefreshing {
                                refreshControl.endRefreshing()
                            }
                        }
                    })
                }
                return
            case .success(board: let article):
                guard let article = article as? APIModel.FullArticle else {
                    return
                }
                self.article = article
                DispatchQueue.main.async {
                    self.tableNode.reloadData()
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
        self.article = nil
        requestArticle()
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

    @objc private func upvote() {
    }

    @objc private func reply() {
    }

    @objc private func share() {
    }

    @objc private func more() {
    }
}

// MARK: - ASTableDataSource

extension SingleArticleViewController: ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let row = indexPath.row
        guard let article = self.article else {
            let nodeBlock: ASCellNodeBlock = {
                return ASCellNode()
            }
            return nodeBlock
        }
        let nodeBlock: ASCellNodeBlock = {
            let cell : ASCellNode
            if row == 0 {
                cell = ArticleMetaDataCellNode(article: article)
                cell.backgroundColor = GlobalAppearance.backgroundColor
            } else {
                cell = ArticleContentCellNode(article: article)
                cell.backgroundColor = PttColors.shark.color
            }
            return cell
        }
        return nodeBlock
    }
}

// MARK: -

private final class BoardNode: ASDisplayNode {

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

private final class BottomToolbarNode: ASDisplayNode {

    private let topBorderNode = ASDisplayNode()
    let toolbarAreaNode = ArticleToolbarNode()
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
        // TODO: add back toolbarAreaNode later
        return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .stretch, children: [topBorderNode, safeAreaNode])
    }
}

private final class ArticleToolbarNode: ASDisplayNode {

    let upvoteNode = ASButtonNode()
    let commentNode = ASEditableTextNode()
    let replyNode = ASButtonNode()
    let shareNode = ASButtonNode()
    let moreNode = ASButtonNode()
    let toolbarHeight : CGFloat = 49.0

    override init() {
        super.init()

        automaticallyManagesSubnodes = true
        style.height = ASDimensionMake(toolbarHeight)
        backgroundColor = GlobalAppearance.backgroundColor

        guard let replyImage = UIImage(systemName: "arrowshape.turn.up.left.fill"), let shareImage = UIImage(systemName: "square.and.arrow.up.fill") else {
            assertionFailure()
            return
        }
        upvoteNode.setImage(StyleKit.imageOfUpvote().withRenderingMode(.alwaysOriginal), for: .normal)
        upvoteNode.setImage(StyleKit.imageOfUpvote().withRenderingMode(.alwaysTemplate), for: .highlighted)
        upvoteNode.accessibilityLabel = L10n.upvote
        commentNode.accessibilityLabel = L10n.comment
        replyNode.setImage(replyImage.withRenderingMode(.alwaysOriginal), for: .normal)
        replyNode.setImage(replyImage.withRenderingMode(.alwaysTemplate), for: .highlighted)
        replyNode.accessibilityLabel = L10n.reply
        shareNode.setImage(shareImage.withRenderingMode(.alwaysOriginal), for: .normal)
        shareNode.setImage(shareImage.withRenderingMode(.alwaysTemplate), for: .highlighted)
        shareNode.accessibilityLabel = L10n.share
        moreNode.setImage(StyleKit.imageOfMoreH().withRenderingMode(.alwaysOriginal), for: .normal)
        moreNode.setImage(StyleKit.imageOfMoreH().withRenderingMode(.alwaysTemplate), for: .highlighted)
        moreNode.accessibilityLabel = L10n.moreActions
        for buttonNode in [upvoteNode, commentNode, replyNode, shareNode, moreNode] {
            buttonNode.style.width = ASDimensionMake(toolbarHeight + 30)
            buttonNode.style.height = ASDimensionMake(toolbarHeight)
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .center, alignItems: .stretch, children: [upvoteNode, commentNode, replyNode, shareNode, moreNode])
    }
}

private final class ArticleMetaDataCellNode: ASCellNode {

    private var metadataAttributes : [NSAttributedString.Key : Any] {
        let textColor : UIColor = .systemGray
        let attrs : [NSAttributedString.Key : Any] =
            [.font: UIFont.preferredFont(forTextStyle: .caption1),
             .foregroundColor: textColor]
        return attrs
    }
    private let categoryImageNode = ASImageNode()
    private let categoryNode = ASTextNode()
    private let clockImageNode = ASImageNode()
    private let dateNode = ASTextNode()
    private let authorImageNode = ASImageNode()
    private let authorNameNode = ASTextNode()

    init(article: APIModel.FullArticle) {
        super.init()

        automaticallyManagesSubnodes = true

        if let category = article.category {
            categoryNode.attributedText = NSAttributedString(string: "\(article.board) / \(category)", attributes: metadataAttributes)
        } else {
            categoryNode.attributedText = NSAttributedString(string: article.board, attributes: metadataAttributes)
        }
        dateNode.attributedText = NSAttributedString(string: article.date, attributes: metadataAttributes)
        authorNameNode.attributedText = NSAttributedString(string: "\(article.author) (\(article.nickname))", attributes: metadataAttributes)

        categoryImageNode.image = StyleKit.imageOfBoardCategory()
        clockImageNode.image = StyleKit.imageOfClock()
        authorImageNode.image = StyleKit.imageOfAuthor()
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
        let metadataStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                  spacing: 10,
                                                  justifyContent: .start,
                                                  alignItems: .start,
                                                  children: [categoryStackSpec, authorStackSpec, dateStackSpec])
        let contentStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                 spacing: 6,
                                                 justifyContent: .start,
                                                 alignItems: .start,
                                                 children: [metadataStackSpec])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 24, bottom: 20, right: 24), child: contentStackSpec)
    }
}

private final class ArticleContentCellNode: ASCellNode {

    private var contentAttributes : [NSAttributedString.Key : Any] {
        let textColor : UIColor = PttColors.paleGrey.color
        let attrs : [NSAttributedString.Key : Any] =
            [.font: UIFont.preferredFont(forTextStyle: .body),
             .foregroundColor: textColor]
        return attrs
    }
    private let contentNode = ASEditableTextNode()

    init(article: APIModel.FullArticle) {
        super.init()
        automaticallyManagesSubnodes = true

        contentNode.attributedText = NSAttributedString(string: article.content, attributes: contentAttributes)
        DispatchQueue.main.async {
            self.contentNode.textView.isEditable = false
        }
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 18, left: 24, bottom: 18, right: 24), child: contentNode)
    }
}
