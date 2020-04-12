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

    private let textView = UITextView()
    private let activityIndicator = UIActivityIndicatorView()

    let headAttributes : [NSAttributedString.Key : Any] = {
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
        return headAttributes
    }()

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
                    let string = "\(post.Board) / \(post.Category)\n\(post.Author) (\(post.Nickname))\n\(post.Date)\n\n"
                    attributedText.append(NSAttributedString(string: string, attributes: self.headAttributes))
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
                    var commentMetadataAttributes : [NSAttributedString.Key : Any] = [
                        .font: UIFont.preferredFont(forTextStyle: .body),
                        .paragraphStyle: contentParagraphStyle,
                    ]
                    if #available(iOS 11.0, *) {
                        commentMetadataAttributes[.foregroundColor] = UIColor(named: "textColorGray")
                    } else {
                        commentMetadataAttributes[.foregroundColor] = UIColor.systemGray
                    }
                    var commentContentAttributes : [NSAttributedString.Key : Any] = [
                        .font: UIFont.preferredFont(forTextStyle: .body),
                        .paragraphStyle: contentParagraphStyle
                    ]
                    if #available(iOS 11.0, *) {
                        commentContentAttributes[.foregroundColor] = UIColor(named: "textColor-240-240-247")
                    } else {
                        commentContentAttributes[.foregroundColor] = UIColor(red:240/255, green:240/255, blue:247/255, alpha:1.0)
                    }
                    for push in post.Pushs {
                        commentsAttributedString.append(NSAttributedString(string: push.Userid, attributes: commentMetadataAttributes))
                        commentsAttributedString.append(NSAttributedString(string: push.Content, attributes: commentContentAttributes))
                        commentsAttributedString.append(NSAttributedString(string: " " + push.IPdatetime, attributes: commentMetadataAttributes))
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
        if let _post = post as? APIClient.BoardPost {
            let string = "\(boardName) / \(_post.Category)\n\(_post.Author) ()\n\(_post.Date)\n"
            textView.attributedText = NSAttributedString(string: string, attributes: headAttributes)
        }
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

        refresh()
    }

    @objc func refresh() {
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
