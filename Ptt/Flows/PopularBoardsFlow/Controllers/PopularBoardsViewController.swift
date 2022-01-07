//
//  PopularBoardsViewController.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/7.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

protocol PopularBoardsView: BaseView {
    var onBoardSelect: ((String) -> Void)? { get set }
}

class PopularBoardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PopularBoardsView {
    
    var onBoardSelect: ((String) -> Void)?
    var boardListDict: [APIModel.BoardInfo]? = nil
    
    lazy var resultsTableController = configureResultsTableController()
    
    lazy var viewModel: PopularBoardsViewModel = {
        let viewModel = PopularBoardsViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.register(PopularBoardsTableViewCell.self, forCellReuseIdentifier: PopularBoardsTableViewCell.cellIdentifier())
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.delegate = self
        tableview.backgroundColor = GlobalAppearance.backgroundColor
        
        if #available(iOS 13.0, *) {
        } else {
            tableview.indicatorStyle = .white
        }
        tableview.estimatedRowHeight = 80.0
        tableview.separatorStyle = .none
        tableview.keyboardDismissMode = .onDrag // to dismiss from search bar
        
        return tableview
    }()
    
    lazy var searchController : UISearchController = {
        // For if #available(iOS 11.0, *), no need to set searchController as property (local variable is fine).
        let searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
        setConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.start()
    }
    
    func initView() {
        title = L10n.popularBoards
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }

        view.backgroundColor = GlobalAppearance.backgroundColor
        definesPresentationContext = true
        
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.textColor = PttColors.paleGrey.color
            // otherwise covered in GlobalAppearance
        }
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableview.tableHeaderView = searchController.searchBar
            searchController.searchBar.barStyle = .black
            tableview.backgroundView = UIView() // See: https://stackoverflow.com/questions/31463381/background-color-for-uisearchcontroller-in-uitableview
        }
    }
    
    func initBinding() {
        viewModel.popularBoards.addObserver(fireNow: false) { [weak self] (popularBoards) in
            if (popularBoards.count > 0) {
                self?.tableview.reloadData()
            }
        }
    }
    
    func setConstraint() {
        view.addSubview(tableview)
        NSLayoutConstraint(item: tableview, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tableview, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tableview, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: tableview, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.popularBoards.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopularBoardsTableViewCell.cellIdentifier()) as! PopularBoardsTableViewCell
        cell.configure(viewModel, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index < viewModel.popularBoards.value.count {
            onBoardSelect?(viewModel.popularBoards.value[index].brdname)
        }
    }
    
    private func configureResultsTableController() -> ResultsTableController {
        let controller = ResultsTableController(style: .plain)
        controller.onBoardSelect = onBoardSelect
        return controller
    }
}

extension PopularBoardsViewController: PopularBoardsViewModelDelegate {
    func showErrorAlert(errorMessage: String) {
        Dispatch.DispatchQueue.main.async {
            let alert = UIAlertController(title: L10n.error, message: errorMessage, preferredStyle: .alert)
            let confirm = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension PopularBoardsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0  else { return }
        resultsTableController.activityIndicator.startAnimating()
        APIClient.shared.getBoardList(token: "", keyword: searchText) { [weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
                case .failure(error: let error):
                    DispatchQueue.main.async {
                        weakSelf.resultsTableController.activityIndicator.stopAnimating()
                        weakSelf.searchController.isActive = false
                        let alert = UIAlertController(title: L10n.error, message: error.message, preferredStyle: .alert)
                        let confirm = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
                        alert.addAction(confirm)
                        weakSelf.present(alert, animated: true, completion: nil)
                    }
                case .success(data: let data):
                    
                    weakSelf.resultsTableController.filteredBoards = data.list
                    DispatchQueue.main.async {
                        // Only update UI for the matching result
                        weakSelf.resultsTableController.activityIndicator.stopAnimating()
                        weakSelf.resultsTableController.tableView.reloadData()
                    }
            }
        }
    }
}

