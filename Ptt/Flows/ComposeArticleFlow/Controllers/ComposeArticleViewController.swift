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
    var classButtonLabelText = "分類選擇"
    
    lazy var classSelectButton: UIButton = {
        var classSelectButton = UIButton()
        classSelectButton.translatesAutoresizingMaskIntoConstraints = false
        classSelectButton.setTitle(classButtonLabelText, for: .normal)
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
        return articleClassTableView
    }()
    
    lazy var confirmComposeAlertViewController: UIAlertController = {
        let confirmComposeAlertViewController = UIAlertController(title: "確認發佈文章？", message: "", preferredStyle: UIAlertController.Style.alert)
        
        confirmComposeAlertViewController.addAction(UIAlertAction(title: "發佈", style: UIAlertAction.Style.default, handler: {action in
            
            //test
            var contentPropertyArray: [APIModel.ContentProperty] = []
            var contentPropertyOutSideArray: [[APIModel.ContentProperty]] = []
                
            let contentProperty = APIModel.ContentProperty(text: "text123")
            contentPropertyOutSideArray.append(contentPropertyArray)
            
            
            let createArticle = APIModel.CreateArticle(className: "gg", title: "987aa", content: contentPropertyOutSideArray)
            
            APIClient.shared.createArticle(boardId: "baseball", article: createArticle) { (result) in
                print(" result", result)
                switch (result) {
                case .failure(let error):
                    print(error)
//                    DispatchQueue.main.async {
//                        self.showAlert(title: NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Login", comment: "") + NSLocalizedString("Error", comment: "") + error.message)
//                    }
                case .success(let response):
                    print(response)
                }
            }
            
//            APIClient.shared.createArticle(boardId: <#T##String#>, article: <#T##APIModel.CreateArticle#>) { [weak self] (result) in
//                guard let weakSelf = self else { return }
//                switch result {
//                    case .failure(error: let apiError):
//                        print("ErrorMessage " + apiError.message)
//                        weakSelf.delegate?.showErrorAlert(errorMessage: apiError.message)
//                        return
//                    case .success(data: let data):
//                        var tempList: [APIModel.BoardInfo] = []
//
//                        for item in data.list {
//                            tempList.append(item)
//                        }
//                        weakSelf.initViewModel()
//                        weakSelf.popularBoards.value = tempList
//                        return
//                }
//            }
            
        }))
        
        confirmComposeAlertViewController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        return confirmComposeAlertViewController
    }()
    
    lazy var deleteComposeAlertViewController: UIAlertController = {
        let deleteComposeAlertViewController = UIAlertController(title: "確認放棄文章？", message: "", preferredStyle: UIAlertController.Style.alert)
        
        deleteComposeAlertViewController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: {action in
            print("TTTTT")
        }))
        
        deleteComposeAlertViewController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
        return deleteComposeAlertViewController
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
    
    let placeholderText = "請輸入文章內容"
    
//    init(boardName: String, apiClient: APIClientProtocol=APIClient.shared) {
//        self.apiClient = apiClient
//        self.boardName = boardName
//        super.init()
//        hidesBottomBarWhenPushed = true
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
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
    
    @objc private func sendCompose() {
        print("sendCompose")
        present(confirmComposeAlertViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initToolBar()
//        initBinding()
        setConstraint()
//        print("XXXXXXXX   "+boardName)
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
    
    func initToolBar() {
        navigationController?.isToolbarHidden = false

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
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
        
        
        self.toolbarItems = [space, deleteComposeButton, space, loadDraftButton, space, saveDraftButton, space, sendComposeButton, space]
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
        
//        if #available(iOS 11.0, *) {
//            NSLayoutConstraint(item: toolBarView, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
//        } else {
//            NSLayoutConstraint(item: toolBarView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
//        }
//        
//        NSLayoutConstraint(item: toolBarView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: toolBarView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: toolBarView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 49).isActive = true

        NSLayoutConstraint(item: articleClassContentView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassContentView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassContentView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassContentView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true

        NSLayoutConstraint(item: articleClassTableView, attribute: .centerX, relatedBy: .equal, toItem: articleClassContentView, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassTableView, attribute: .leading, relatedBy: .equal, toItem: articleClassContentView, attribute: .leading, multiplier: 1.0, constant: 55).isActive = true
        NSLayoutConstraint(item: articleClassTableView, attribute: .bottom, relatedBy: .equal, toItem: articleClassContentView, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: articleClassTableView, attribute: .top, relatedBy: .equal, toItem: articleClassContentView, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        
//        if #available(iOS 11.0, *) {
//            let guide = self.view.safeAreaLayoutGuide
//            toolBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
//            toolBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
//            toolBar.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
//            toolBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
//
//        }
//        else {
//            NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
//            NSLayoutConstraint(item: toolBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
//            NSLayoutConstraint(item: toolBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
//
//            toolBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        }
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
        if (classText != "無" && classText != "取消") {
            classSelectButton.setTitle(classText, for: .normal)
            classSelectButton.setTitleColor(GlobalAppearance.tintColor, for: .normal)
            articleTitle.text = "[" + classText + "] "
        }
        articleClassContentView.isHidden = true
    }
}

//extension ComposeArticleViewController: ComposeToolBarViewDelegate {
//    func deleteCompose() {
//
//    }
//
//    func loadDraft() {
//
//    }
//
//    func saveDraft() {
//
//    }
//
//    func sendCompose() {
//        print("KKKKKKKKKKKKKK")
//        DispatchQueue.main.async(execute: {
//            self.present(self.confirmComposeAlertViewController, animated: true)
//        })
//    }
//
//
//}
