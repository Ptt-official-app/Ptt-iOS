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
//    private lazy var resultsTableController = configureResultsTableController()
    
    private var allBoards : [String]? = nil
    private var boardListDict : [String: Any]? = nil
    
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
//        tableview.backgroundColor = GlobalAppearance.backgroundColor
        
        if #available(iOS 13.0, *) {
        } else {
            tableview.indicatorStyle = .white
        }
//        tableview.estimatedRowHeight = 80.0
//        tableview.separatorStyle = .none
//        tableview.keyboardDismissMode = .onDrag // to dismiss from search bar
        
        return tableview
    }()
    
//    lazy var searchController : UISearchController = {
//        // For if #available(iOS 11.0, *), no need to set searchController as property (local variable is fine).
//        let searchController = UISearchController(searchResultsController: resultsTableController)
//        searchController.delegate = self
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
//        return searchController
//    }()
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableview.setEditing(editing, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initBinding()
        setConstraint()
    }
    
    func initView() {
        title = NSLocalizedString("Popular Boards", comment: "")
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.setRightBarButton(editButtonItem, animated: true)

        view.backgroundColor = GlobalAppearance.backgroundColor
        definesPresentationContext = true
//        if #available(iOS 13.0, *) {
//            searchController.searchBar.searchTextField.textColor = UIColor(named: "textColor-240-240-247")
//            // otherwise covered in GlobalAppearance
//        }
//        if #available(iOS 11.0, *) {
//            navigationItem.searchController = searchController
//            navigationItem.hidesSearchBarWhenScrolling = false
//        } else {
//            tableview.tableHeaderView = searchController.searchBar
//            searchController.searchBar.barStyle = .black
//            tableview.backgroundView = UIView() // See: https://stackoverflow.com/questions/31463381/background-color-for-uisearchcontroller-in-uitableview
//        }
    }
    
    func initBinding() {
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("didUpdatePopularBoards"), object: nil)
        
//        viewModel.pageLinkDataDictionary.addObserver(fireNow: false) { [weak self] (pageLinkDataDictionary) in
//            self?.tableview.reloadData()
//        }
    }
    
    func setConstraint() {
    }
    
    @objc private func refresh() {
        tableview.reloadData()
    }

    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.popularBoards.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopularBoardsTableViewCell.cellIdentifier()) as! PopularBoardsTableViewCell
//        cell.delegate = self
//        cell.configure(viewModel, index: indexPath.row)//(viewModel.imageUrls.value[indexPath.row])
        return cell
        
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: PopularBoardsTableViewCell.cellIdentifier(), for: indexPath) as! PopularBoardsTableViewCell
        //        let index = indexPath.row
        //        if index < Favorite.boards.count {
        //            cell.boardName = Favorite.boards[index].name
        //            cell.boardTitle = Favorite.boards[index].title
        //        }
        //        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let index = indexPath.row
//        if index < Favorite.boards.count {
//            onBoardSelect?(Favorite.boards[index].name)
//        }
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            Favorite.boards.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
//    private func configureResultsTableController() -> ResultsTableController {
//        let controller = ResultsTableController(style: .plain)
//        controller.onBoardSelect = onBoardSelect
//        return controller
//    }
}

extension PopularBoardsViewController: PopularBoardsViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }
}

extension UITableViewCell {
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
