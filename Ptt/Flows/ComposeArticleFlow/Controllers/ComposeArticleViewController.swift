//
//  ComposeArticleViewController.swift
//  Ptt
//
//  Created by marcus fu on 2021/5/11.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

protocol ComposeArticleView: BaseView {
}

class ComposeArticleViewController: UIViewController, ComposeArticleView {
    
    private let apiClient: APIClientProtocol
    private var boardName : String
    
    lazy var classSelectButton: UIButton = {
        let classSelectButton = UIButton()
        classSelectButton.translatesAutoresizingMaskIntoConstraints = false
        classSelectButton.setTitle("分類選擇", for: .normal)
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
        contentView.backgroundColor = UIColor(red:23/255, green:23/255, blue:23/255, alpha:1.0)
        view.addSubview(contentView)
        return contentView
    }()
    
    let placeholderText = "請輸入文章內容"
    
    init(boardName: String, apiClient: APIClientProtocol=APIClient.shared) {
        self.apiClient = apiClient
        self.boardName = boardName
        super.init(nibName: nil, bundle: nil)
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
        title = NSLocalizedString("編輯文章", comment: "")
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = GlobalAppearance.backgroundColor
        navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc private func classSelect() {
        print("XXXXXXXX");
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

//extension PopularBoardsViewController: PopularBoardsViewModelDelegate {
//    func showErrorAlert(errorMessage: String) {
//        Dispatch.DispatchQueue.main.async {
//            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
//            let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
//            alert.addAction(confirm)
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//}

//extension PopularBoardsViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchText = searchController.searchBar.text, searchText.count > 0  else { return }
//        resultsTableController.activityIndicator.startAnimating()
//        APIClient.shared.getBoardListV2(token: "", keyword: searchText) { [weak self] (result) in
//            guard let weakSelf = self else { return }
//            switch result {
//                case .failure(error: let error):
//                    DispatchQueue.main.async {
//                        weakSelf.resultsTableController.activityIndicator.stopAnimating()
//                        weakSelf.searchController.isActive = false
//                        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.message, preferredStyle: .alert)
//                        let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
//                        alert.addAction(confirm)
//                        weakSelf.present(alert, animated: true, completion: nil)
//                    }
//                case .success(data: let data):
//
//                    weakSelf.resultsTableController.filteredBoards = data.list
//                    DispatchQueue.main.async {
//                        // Only update UI for the matching result
//                        weakSelf.resultsTableController.activityIndicator.stopAnimating()
//                        weakSelf.resultsTableController.tableView.reloadData()
//                    }
//            }
//        }
//    }
//}
