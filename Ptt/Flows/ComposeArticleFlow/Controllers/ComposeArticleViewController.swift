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

class ComposeArticleViewController: UIViewController, ComposeArticleView {
    var classText = ""
    var noticeText = ""
    let placeholderText = "請輸入文章內容"
    var boardName = ""
    
    lazy var classSelectButton: UIButton = {
        var classSelectButton = UIButton()
        classSelectButton.translatesAutoresizingMaskIntoConstraints = false
        classSelectButton.setTitle("分類選擇", for: .normal)
        classSelectButton.setTitleColor(UIColor(red:240/255, green:240/255, blue:247/255, alpha:1.0), for: .normal)
        classSelectButton.titleLabel?.font = classSelectButton.titleLabel?.font.withSize(16)
        classSelectButton.addTarget(self, action: #selector(classSelect), for: .touchUpInside)
        classSelectButton.contentHorizontalAlignment = .left
        view.addSubview(classSelectButton)
        return classSelectButton
    }()
    
    lazy var articleTitle: UITextField = {
        var articleTitle = UITextField()
        articleTitle.translatesAutoresizingMaskIntoConstraints = false
        articleTitle.attributedPlaceholder = NSAttributedString(string:"請輸入文章標題", attributes:[NSAttributedString.Key.foregroundColor: UIColor(red:56/255, green:56/255, blue:61/255, alpha:1.0), NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
        articleTitle.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(articleTitle)
        return articleTitle
    }()
    
    lazy var contentView: UITextView = {
        let contentView = UITextView()
        contentView.font = UIFont.systemFont(ofSize: 18)
        contentView.delegate = self
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
        return articleClassTableView
    }()
    
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isHidden = true
        view.addSubview(loadingView)
        return loadingView
    }()
    
    lazy var confirmComposeAlertViewController: UIAlertController = {
        let confirmComposeAlertViewController = UIAlertController(title: "確認發佈文章？", message: "", preferredStyle: UIAlertController.Style.alert)
        
        confirmComposeAlertViewController.addAction(UIAlertAction(title: "發佈", style: UIAlertAction.Style.default, handler: {action in
            
            let createArticle = APIModel.CreateArticle(className: self.classText, title: self.articleTitle.text ?? "", content: self.viewModel.getContentPropertyOutSideArray())
            
            self.loadingView.isHidden = false
            self.navigationController?.isToolbarHidden = true
            
            APIClient.shared.createArticle(boardId: self.boardName, article: createArticle) { (result) in
                DispatchQueue.main.async {
                    self.loadingView.isHidden = true
                }
                switch (result) {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.navigationController?.isToolbarHidden = false
                        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.message, preferredStyle: .alert)
                        let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
                        alert.addAction(confirm)
                        self.present(alert, animated: true, completion: nil)
                    }
                case .success(let response):
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: false)
                    }
                }
            }
        }))
        
        confirmComposeAlertViewController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        return confirmComposeAlertViewController
    }()
    
    lazy var deleteComposeAlertViewController: UIAlertController = {
        let deleteComposeAlertViewController = UIAlertController(title: "確認放棄文章？", message: "", preferredStyle: UIAlertController.Style.alert)
        
        deleteComposeAlertViewController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: {action in
        }))
        
        deleteComposeAlertViewController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        return deleteComposeAlertViewController
    }()
    
    lazy var noticeAlertViewController: UIAlertController = {
        let noticeAlertViewController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
        
        noticeAlertViewController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.cancel, handler: nil))
        return noticeAlertViewController
    }()
    
    lazy var leftBarButton: UIButton = {
        let leftBarButton = UIButton()
        leftBarButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftBarButton.imageView?.layer.transform = CATransform3DMakeScale(1.3 , 1.3 , 1.3)
        leftBarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        
        leftBarButton.setTitle("編輯文章", for: .normal)
        leftBarButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        return leftBarButton
    }()
    
    let barSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    
    let viewModel = ComposeArticleViewModel()
    
    @objc private func deleteCompose() {
        print("deleteCompose")
        present(deleteComposeAlertViewController, animated: true)
    }
    
    @objc private func loadDraft() {
        print("loadDraft")
    }
    
    @objc private func saveDraft() {
        print("saveDraft")
    }
    
    @objc private func photoUpload() {
        
    }
    
    @objc private func openPaintpalette() {
        
    }
    
    @objc private func sendCompose() {
        if (self.contentView.text == "" || self.classText == "" || self.articleTitle.text == "") {
            noticeAlertViewController.title = (self.classText == "") ? "請選擇分類" : "請輸入標題或內容"
            present(noticeAlertViewController, animated: true)
        }
        else {
            present(confirmComposeAlertViewController, animated: true)
        }
    }
    
    init(boardName: String) {
        self.boardName = boardName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initToolBar()
        initKeyboardToolBar()
        setConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        articleTitle.setBottomBorder()
    }
    
    func initView() {
        view.backgroundColor = GlobalAppearance.backgroundColor
        navigationController?.navigationBar.isTranslucent = false
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
    }
    
    func initToolBar() {
        navigationController?.isToolbarHidden = false
        
        let deleteComposeButton =  UIBarButtonItem(image: UIImage(systemName: "trash.fill"),
                   style: .plain, target:self,
                   action: #selector(deleteCompose))
        
        let loadDraftButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
           style: .plain, target:self,
           action: #selector(loadDraft))

        let saveDraftButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down.fill"),
           style: .plain, target:self,
           action: #selector(saveDraft))

        let sendComposeButton = UIBarButtonItem(image:UIImage(systemName: "paperplane.fill"),
           style: .plain, target:self,
           action: #selector(sendCompose))
        
        deleteComposeButton.tintColor = .lightGray
        loadDraftButton.tintColor = .lightGray
        saveDraftButton.tintColor = .lightGray
        sendComposeButton.tintColor = .lightGray
        
        self.toolbarItems = [barSpace, deleteComposeButton, barSpace, loadDraftButton, barSpace, saveDraftButton, barSpace, sendComposeButton, barSpace]
    }
    
    func initKeyboardToolBar() {
        let bar = UIToolbar(frame:CGRect(x:0, y:0, width:100, height:100))
        let photo = UIBarButtonItem(image: UIImage(systemName: "photo.fill"),
            style: .plain, target:self,
            action: #selector(photoUpload))

        let paintpalette = UIBarButtonItem(image: UIImage(systemName: "paintpalette.fill"),
            style: .plain, target:self,
            action: #selector(openPaintpalette))

        let paperplane = UIBarButtonItem(image:UIImage(systemName: "paperplane.fill"),
           style: .plain, target:self,
           action: #selector(sendCompose))

        photo.tintColor = .lightGray
        paintpalette.tintColor = .lightGray
        paperplane.tintColor = .lightGray

        bar.items = [barSpace, photo, barSpace, paintpalette, barSpace, paperplane, barSpace]
        bar.sizeToFit()
        
        articleTitle.inputAccessoryView = bar
        contentView.inputAccessoryView = bar
    }
    
    @objc private func back() {
        navigationController?.isToolbarHidden = true
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

        NSLayoutConstraint(item: articleClassContentView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassContentView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassContentView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassContentView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true

        NSLayoutConstraint(item: articleClassTableView, attribute: .centerX, relatedBy: .equal, toItem: articleClassContentView, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassTableView, attribute: .leading, relatedBy: .equal, toItem: articleClassContentView, attribute: .leading, multiplier: 1.0, constant: 55).isActive = true
        NSLayoutConstraint(item: articleClassTableView, attribute: .bottom, relatedBy: .equal, toItem: articleClassContentView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassTableView, attribute: .top, relatedBy: .equal, toItem: articleClassContentView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: loadingView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: loadingView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        viewModel.insertContent(text)
        return true
    }
}

extension ComposeArticleViewController: ArticleClassTableViewDelegate {
    func setArticleClass(classText: String) {
        if (classText != "無" && classText != "取消") {
            self.classText = classText
            classSelectButton.setTitle(classText, for: .normal)
            classSelectButton.setTitleColor(GlobalAppearance.tintColor, for: .normal)
        }
        articleClassContentView.isHidden = true
    }
}
