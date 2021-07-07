//
//  ComposeArticleViewController.swift
//  Ptt
//
//  Created by marcus fu on 2021/5/11.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol ComposeArticleView: BaseView {
}

class ComposeArticleViewController: ASDKViewController<ASDisplayNode>, FullscreenSwipeable, ComposeArticleView {
    
    private let apiClient: APIClientProtocol
    private var boardName : String
    var classButtonLabelText = "分類選擇"
    
    lazy var classSelectButton: UIButton = {
        let classSelectButton = UIButton()
        classSelectButton.translatesAutoresizingMaskIntoConstraints = false
        classSelectButton.setTitle(classButtonLabelText, for: .normal)
        classSelectButton.setTitleColor(UIColor(red:240/255, green:240/255, blue:247/255, alpha:1.0), for: .normal)
        classSelectButton.titleLabel?.font = classSelectButton.titleLabel?.font.withSize(16)
        classSelectButton.addTarget(self, action: #selector(classSelect), for: .touchUpInside)
        classSelectButton.contentHorizontalAlignment = .left
//        classSelectButton.backgroundColor = .black
        view.addSubview(classSelectButton)
        return classSelectButton
    }()
    
    lazy var articleTitle: UITextField = {
        var articleTitle = UITextField()
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        articleTitle.attributedPlaceholder = NSAttributedString(string:"請輸入文章標題", attributes:[NSAttributedString.Key.foregroundColor: UIColor(red:56/255, green:56/255, blue:61/255, alpha:1.0), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
//        articleTitle.backgroundColor = .black
        view.addSubview(articleTitle)
        return articleTitle
    }()
    
    lazy var contentView: UITextView = {
        let contentView = UITextView()
        contentView.font = UIFont.systemFont(ofSize: 18)
//        textView.autocorrectionType = UITextAutocorrectionType.no
//        textView.keyboardType = .default
//        textView.returnKeyType = UIReturnKeyType.done
        contentView.delegate = self
        contentView.translatesAutoresizingMaskIntoConstraints = false
//        textView.textAlignment = NSTextAlignment.justified
        contentView.textAlignment = .left
        contentView.backgroundColor = .black
        contentView.text = placeholderText
        contentView.textColor = UIColor(red:56/255, green:56/255, blue:61/255, alpha:1.0)
        contentView.backgroundColor = UIColor(named: "blackColor-23-23-23")
        view.addSubview(contentView)
        return contentView
    }()
    
    lazy var articleClassContentView: UIView = {
        let articleClassContentView = UIView()
        articleClassContentView.backgroundColor = UIColor(named: "blackColor-23-23-23")
        articleClassContentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(articleClassContentView)
        articleClassContentView.isHidden = true
        return articleClassContentView
    }()
    
    lazy var articleClassTableView: ArticleClassTableView =  {
        let articleClassTableView = ArticleClassTableView()
        articleClassTableView.translatesAutoresizingMaskIntoConstraints = false
        articleClassTableView.articleClassTableViewDelegate = self
        articleClassContentView.addSubview(articleClassTableView)
//        articleClassTableView.isHidden = true
        return articleClassTableView
    }()
    
    lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        var items = [UIBarButtonItem]()
        
        items.append(
            UIBarButtonItem.menuButton(self, action: #selector(classSelect), imageName: "trash.fill")
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem.menuButton(self, action: #selector(classSelect), imageName: "square.and.pencil")
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem.menuButton(self, action: #selector(classSelect), imageName: "square.and.arrow.down.fill")
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        )
        items.append(
            UIBarButtonItem.menuButton(self, action: #selector(classSelect), imageName: "paperplane.fill")
        )
        toolBar.setItems(items, animated: true)
//        toolBar.tintColor = .red
        toolBar.barTintColor = GlobalAppearance.backgroundColor
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolBar)
        return toolBar
    }()
    
    lazy var leftBarButton: UIButton = {
        let leftBarButton = UIButton()
        leftBarButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftBarButton.imageView?.layer.transform = CATransform3DMakeScale(1.3 , 1.3 , 1.3)
        leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        
        leftBarButton.setTitle("編輯文章", for: .normal)
//        leftBarButton.sizeToFit()
        leftBarButton.addTarget(self, action: #selector(back), for: .touchUpInside)
//        leftBarButton.frame.size = CGSize(width: 100, height: 30)
        return leftBarButton
        
//        var chatImage: UIImage  = UIImage(systemName: "chevron.left")
//        var rightButton : UIButton = UIButton(type: UIButtonType.custom)
//        rightButton.setBackgroundImage(rightImage, for: .normal)
//        rightButton.setTitle(title, for: .normal)
//        rightButton.frame.size = CGSize(width: 100, height: 30)
    }()
    
    let placeholderText = "請輸入文章內容"
    
    init(boardName: String, apiClient: APIClientProtocol=APIClient.shared) {
        self.apiClient = apiClient
        self.boardName = boardName
        super.init()
        hidesBottomBarWhenPushed = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
//        initBinding()
        setConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        articleTitle.setBottomBorder()
    }
    
    func initView() {
//        title = NSLocalizedString("編輯文章", comment: "")
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//        }
        view.backgroundColor = GlobalAppearance.backgroundColor
        navigationController?.navigationBar.isTranslucent = false
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func classSelect() {
        articleClassContentView.isHidden = false
    }
    
    func setConstraint() {
        NSLayoutConstraint(item: classSelectButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: classSelectButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: classSelectButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: classSelectButton, attribute: .height, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 54).isActive = true
        
        NSLayoutConstraint(item: articleTitle, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleTitle, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleTitle, attribute: .top, relatedBy: .equal, toItem: classSelectButton, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleTitle, attribute: .height, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 29).isActive = true
        
        NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: articleTitle, attribute: .bottom, multiplier: 1.0, constant: 29).isActive = true
        
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            toolBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            toolBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
            toolBar.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        }
        else {
            NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: toolBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: toolBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        }
        toolBar.heightAnchor.constraint(equalToConstant: 49).isActive = true
        
        NSLayoutConstraint(item: articleClassContentView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassContentView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassContentView, attribute: .bottom, relatedBy: .equal, toItem: toolBar, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassContentView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: articleClassTableView, attribute: .centerX, relatedBy: .equal, toItem: articleClassContentView, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassTableView, attribute: .leading, relatedBy: .equal, toItem: articleClassContentView, attribute: .leading, multiplier: 1.0, constant: 55).isActive = true
        NSLayoutConstraint(item: articleClassTableView, attribute: .bottom, relatedBy: .equal, toItem: articleClassContentView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassTableView, attribute: .top, relatedBy: .equal, toItem: articleClassContentView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension ComposeArticleViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentView.text == placeholderText {
            contentView.text = ""
            contentView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentView.text.isEmpty {
            contentView.text = placeholderText
            contentView.textColor = UIColor(red:56/255, green:56/255, blue:61/255, alpha:1.0)
        }
    }
}

extension ComposeArticleViewController: ArticleClassTableViewDelegate {
    func setArticleClass(classText: String) {
        
//        classSelectButton.setTitle(classText, for: .normal)
        classButtonLabelText = classText
        print("TTTTTTTTT    ", classButtonLabelText)
        
        
//        classSelectButton.setTitle(classText, for: .normal)
//        classSelectButton.setTitleColor(GlobalAppearance.tintColor, for: .normal)
    }
}
