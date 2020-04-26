//
//  PostViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/3/30.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit
import SafariServices

final class PostViewController: UIViewController {

    private var boardName : String?
    private var filename : String?
    private var url : URL? {
        if let boardName = boardName, let filename = filename {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "www.ptt.cc"
            urlComponents.path = "/bbs/\(boardName)/\(filename).html"
            return urlComponents.url
        }
        return nil
    }

    private let textView = UITextView()
    private let activityIndicator = UIActivityIndicatorView()

    private var post : Post? = nil {
        didSet {
            if post != nil {
                guard let post = self.post as? APIClient.FullPost else {
                    return
                }
                DispatchQueue.main.async {
                    self.title = post.Title
                    // lower level tip for NSAttributedString
                    // See: https://developer.apple.com/videos/play/wwdc2017/244/?time=2130
                    let attributedText = NSMutableAttributedString()
                    // Header
                    attributedText.append(self.headerAttributedString(of: post))
                    // Content
                    let contentParagraphStyle = NSMutableParagraphStyle()
                    let hPadding : CGFloat = {
                        if self.view.bounds.width > 320.0 {
                            return 20.0
                        } else {
                            // 4-inch screen
                            return 10.0
                        }
                    }()
                    contentParagraphStyle.firstLineHeadIndent = hPadding
                    contentParagraphStyle.headIndent = hPadding
                    contentParagraphStyle.tailIndent = -hPadding
                    contentParagraphStyle.baseWritingDirection = .leftToRight
                    contentParagraphStyle.lineHeightMultiple = 1.1
                    contentParagraphStyle.alignment = .left
                    var contentAttributes : [NSAttributedString.Key : Any] = [
                        .font: UIFont.preferredFont(forTextStyle: .body),
                        .paragraphStyle: contentParagraphStyle
                    ]
                    if #available(iOS 11.0, *) {
                        contentAttributes[.foregroundColor] = UIColor(named: "textColor-240-240-247")
                    } else {
                        contentAttributes[.foregroundColor] = UIColor(red:240/255, green:240/255, blue:247/255, alpha:1.0)
                    }
                    attributedText.append(NSAttributedString(string: post.Content, attributes: contentAttributes))
                    // Comments
                    let commentsAttributedString = NSMutableAttributedString()
                    let commentAuthorAttributes : [NSAttributedString.Key : Any] = [
                        .font: UIFont.preferredFont(forTextStyle: .body),
                        .paragraphStyle: contentParagraphStyle,
                        .foregroundColor: UIColor(red: 1.00, green: 0.99, blue: 0.48, alpha: 1.00)  // #FFFC7A
                    ]
                    let commentContentAttributes : [NSAttributedString.Key : Any] = [
                        .font: UIFont.preferredFont(forTextStyle: .body),
                        .paragraphStyle: contentParagraphStyle,
                        .foregroundColor: UIColor(red: 0.62, green: 0.59, blue: 0.16, alpha: 1.00)   // #9D972A
                    ]
                    // Note: tabStops https://stackoverflow.com/a/33029957/3796488 or
                    // paragraphSpacingBefore https://stackoverflow.com/a/49427510/3796488
                    // those solutions don't work well; giving up.
                    var commentDateAttributes : [NSAttributedString.Key : Any] = [
                        .font: UIFont.preferredFont(forTextStyle: .body),
                        .paragraphStyle: contentParagraphStyle
                    ]
                    if #available(iOS 11.0, *) {
                        commentDateAttributes[.foregroundColor] = UIColor(named: "textColorGray")
                    } else {
                        commentDateAttributes[.foregroundColor] = UIColor.systemGray
                    }
                    for push in post.Pushs {
                        commentsAttributedString.append(NSAttributedString(string: push.Userid, attributes: commentAuthorAttributes))
                        commentsAttributedString.append(NSAttributedString(string: push.Content, attributes: commentContentAttributes))
                        commentsAttributedString.append(NSAttributedString(string: " " + push.IPdatetime, attributes: commentDateAttributes))
                    }
                    attributedText.append(commentsAttributedString)
                    self.textView.attributedText = attributedText
                }
            }
        }
    }
    private let cellReuseIdentifier = "CommentCell"

    init(post: Post, boardName: String) {
        self.post = post
        self.boardName = boardName
        let (_, filename) = Utility.info(from: post.Href)
        self.filename = filename
        super.init(nibName: nil, bundle: nil)
        self.title = post.Title
        hidesBottomBarWhenPushed = true

        // Because self.post didSet will not be called in initializer
        textView.attributedText = headerAttributedString(of: post)
    }

    init(url: URL) {
        let (boardName, filename) = Utility.info(from: url.path)
        self.boardName = boardName
        self.filename = filename
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }

        textView.backgroundColor = GlobalAppearance.backgroundColor
        textView.adjustsFontForContentSizeCategory = true
        if #available(iOS 13.0, *) {
        } else {
            textView.indicatorStyle = .white
        }
        // For UITextView, noncontinuous layout is turned on by default, and requires scrolling to be enabled.
        // See: https://developer.apple.com/videos/play/wwdc2018/221/?time=1863
        textView.isEditable = false
        textView.dataDetectorTypes = .all
        textView.alwaysBounceVertical = true
        textView.delegate = self
        // See: https://stackoverflow.com/a/28589384/3796488
        textView.accessibilityTraits = .staticText
        view.ptt_add(subviews: [textView])
        // "So, with auto layout in particular, that text system caches some layout information. And this can really improve performance."
        // See: https://developer.apple.com/videos/play/wwdc2017/244/?time=2029
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[textView]|",
                                                      options: [], metrics: nil, views: ["textView": textView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[textView]|",
                                                      options: [], metrics: nil, views: ["textView": textView])
        NSLayoutConstraint.activate(constraints)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        textView.refreshControl = refreshControl

        activityIndicator.color = .lightGray
        textView.ptt_add(subviews: [activityIndicator])
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: textView.topAnchor, constant: 100.0),
            activityIndicator.centerXAnchor.constraint(equalTo: textView.centerXAnchor)
        ])

        let shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.rightBarButtonItem = shareButtonItem

        refresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // iOS Handoff: Native App–to–Web Browser
        // See: https://forums.developer.apple.com/thread/43115#thread-message-125691
        let activity = NSUserActivity(activityType: "org.ptt.ptt")
        activity.webpageURL = url
        userActivity = activity
        userActivity?.becomeCurrent()
    }

    @objc private func refresh() {
        guard let boardName = boardName, let filename = filename else {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: "wrong parameters", preferredStyle: .alert)
            let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let refreshControl = textView.refreshControl {
            if !refreshControl.isRefreshing {
                activityIndicator.startAnimating()
            }
        }
        APIClient.getPost(board: boardName, filename: filename) { (result) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.textView.refreshControl?.endRefreshing()
            }
            switch result {
            case .failure(error: let apiError):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: apiError.message, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: nil)
                }
            case .success(post: let post):
                self.post = post
            }
        }
    }

    @objc private func share(sender: UIBarButtonItem) {
        var shareUrl : URL? = nil
        if let post = post as? APIClient.FullPost {
            shareUrl = URL(string: post.Href)
        } else {
            shareUrl = url
        }
        if let shareUrl = shareUrl {
            let vc = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
            vc.popoverPresentationController?.barButtonItem = sender
            present(vc, animated: true, completion: nil)
        }
    }

    private func headerAttributedString(of post: Post) -> NSAttributedString {
        let headParagraphStyle = NSMutableParagraphStyle()
        let hPadding : CGFloat = 26.0
        headParagraphStyle.firstLineHeadIndent = hPadding
        headParagraphStyle.headIndent = hPadding
        headParagraphStyle.tailIndent = -hPadding
        headParagraphStyle.baseWritingDirection = .leftToRight
        headParagraphStyle.alignment = .left
        headParagraphStyle.lineSpacing = 4.0
        var headAttributes : [NSAttributedString.Key : Any] = [
            .font: UIFont.preferredFont(forTextStyle: .headline),
            .paragraphStyle: headParagraphStyle
        ]
        if #available(iOS 11.0, *) {
            headAttributes[.foregroundColor] = UIColor(named: "textColorGray")
        } else {
            headAttributes[.foregroundColor] = UIColor.systemGray
        }
        let headerAttributedString = NSMutableAttributedString()
        let categoryAttachment : NSTextAttachment
        let authorAttachment : NSTextAttachment
        let dateAttachment : NSTextAttachment
        if #available(iOS 13.0, *) {
            categoryAttachment = NSTextAttachment(image: StyleKit.imageOfBoardCategory())
            authorAttachment = NSTextAttachment(image: StyleKit.imageOfAuthor())
            dateAttachment = NSTextAttachment(image: StyleKit.imageOfClock())
        } else {
            categoryAttachment = NSTextAttachment()
            categoryAttachment.image = StyleKit.imageOfBoardCategory()
            authorAttachment = NSTextAttachment()
            authorAttachment.image = StyleKit.imageOfAuthor()
            dateAttachment = NSTextAttachment()
            dateAttachment.image = StyleKit.imageOfClock()
        }
        headerAttributedString.append(NSAttributedString(attachment: categoryAttachment))
        // Workaround: We cannot vertically center align attachments easily, so use tab to align text.
        if let _post = post as? APIClient.BoardPost, let boardName = self.boardName {
            headerAttributedString.append(NSAttributedString(string: "\t\(boardName) / \(_post.Category)\n"))
        } else if let _post = post as? APIClient.FullPost {
            headerAttributedString.append(NSAttributedString(string: "\t\(_post.Board) / \(_post.Category)\n"))
        }
        headerAttributedString.append(NSAttributedString(attachment: authorAttachment))
        if let _post = post as? APIClient.FullPost {
            headerAttributedString.append(NSAttributedString(string: "\t\(post.Author) (\(_post.Nickname))\n"))
        } else {
            headerAttributedString.append(NSAttributedString(string: "\t\(post.Author)\n"))
        }
        headerAttributedString.append(NSAttributedString(attachment: dateAttachment))
        if let _ = post as? APIClient.BoardPost {
            headerAttributedString.append(NSAttributedString(string: "\t\(post.Date.dropFirst())\n\n"))
        } else {
            headerAttributedString.append(NSAttributedString(string: "\t\(post.Date)\n\n"))
        }
        headerAttributedString.addAttributes(headAttributes, range: NSRange(location: 0, length: headerAttributedString.length))
        return headerAttributedString
    }
}

// MARK: - UITextViewDelegate

extension PostViewController : UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if Utility.isPttArticle(url: URL) {
            let postViewController = PostViewController(url: URL)
            show(postViewController, sender: self)
            return false
        }
        if URL.scheme == "http" || URL.scheme == "https" {
            let safariViewController = SFSafariViewController(url: URL)
            safariViewController.preferredControlTintColor = GlobalAppearance.tintColor
            if #available(iOS 13.0, *) {
            } else {
                safariViewController.preferredBarTintColor = GlobalAppearance.backgroundColor
            }
            if #available(iOS 11.0, *) {
                safariViewController.dismissButtonStyle = .close
            }
            present(safariViewController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
