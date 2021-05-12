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
    
    lazy var actionButton: UIButton = {
        let actionButton = UIButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle("分類選擇", for: .normal)
        actionButton.setTitleColor(UIColor(red:240/255, green:240/255, blue:247/255, alpha:1.0), for: .normal)
        actionButton.titleLabel?.font = actionButton.titleLabel?.font.withSize(16)
        actionButton.addTarget(self, action: #selector(classSelect), for: .touchUpInside)
        
        return actionButton
    }()
    
//    lazy var articleTitle: UITextField = {
//        var articleTitle = UITextField()
//        articleTitle.translatesAutoresizingMaskIntoConstraints = false
//        articleTitle.autocorrectionType = .no
//        articleTitle.delegate = self
//        articleTitle = UIFont.tableContent
//        articleTitle = UIColor.steel
//        articleTitle.addTarget(self, action: #selector(didTextfieldValueChanged(_:)), for: .editingChanged)
////        self.addSubview(self.textField)
//        return articleTitle
//    }()
    
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
    
    func initView() {
//        title = NSLocalizedString("分類選擇", comment: "")
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }

        view.backgroundColor = GlobalAppearance.backgroundColor
        definesPresentationContext = true
    }
    
    @objc private func classSelect() {
        print("XXXXXXXX");
    }
    
    func setConstraint() {
        view.addSubview(actionButton)
        NSLayoutConstraint(item: actionButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: actionButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: actionButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: actionButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
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
