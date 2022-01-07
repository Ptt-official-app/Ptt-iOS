//
//  FavoriteViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/7.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

protocol FavoriteView: BaseView {
    var onBoardSelect: ((String) -> Void)? { get set }
    var onLogout:(() -> Void)? { get set }
}

final class FavoriteViewController: UITableViewController, FavoriteView {
    var onBoardSelect: ((String) -> Void)?
    var onLogout: (() -> Void)?

    private let cellReuseIdentifier = "FavoriteCell"
    private lazy var resultsTableController = configureResultsTableController()
    private lazy var searchController : UISearchController = {
        // For if #available(iOS 11.0, *), no need to set searchController as property (local variable is fine).
       return UISearchController(searchResultsController: resultsTableController)
    }()
    
    private var boardListDict : [APIModel.BoardInfo]? = nil

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.favoriteBoards
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        
        navigationItem.setRightBarButton(editButtonItem, animated: true)

        view.backgroundColor = GlobalAppearance.backgroundColor
        if #available(iOS 13.0, *) {
        } else {
            tableView.indicatorStyle = .white
        }
        tableView.estimatedRowHeight = 80.0
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag // to dismiss from search bar
        tableView.register(BoardsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        searchController.delegate = self
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.textColor = PttColors.paleGrey.color
            // otherwise covered in GlobalAppearance
        }
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
            searchController.searchBar.barStyle = .black
            tableView.backgroundView = UIView() // See: https://stackoverflow.com/questions/31463381/background-color-for-uisearchcontroller-in-uitableview
        }

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("didUpdateFavoriteBoards"), object: nil)
        
        
        
        let logoutBarItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(debug_logout))
        
        navigationItem.setLeftBarButton(logoutBarItem, animated: true)
    }
    
    @objc
    func debug_logout() {
        print("Debug logout button press")
        
        DispatchQueue.main.async {
            _ = LoginKeyChainItem.shared.removeToken()
            self.onLogout?()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    @objc private func refresh() {
        tableView.reloadData()
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favorite.boards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! BoardsTableViewCell
        let index = indexPath.row
        if index < Favorite.boards.count {
            cell.boardName = Favorite.boards[index].brdname
            cell.boardTitle = Favorite.boards[index].title
        }
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Favorite.boards.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let fromRow = fromIndexPath.row
        let toRow = to.row
        let element = Favorite.boards.remove(at: fromRow)
        Favorite.boards.insert(element, at: toRow)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index < Favorite.boards.count {
            onBoardSelect?(Favorite.boards[index].brdname)
        }
    }
    
    private func configureResultsTableController() -> ResultsTableController {
        let controller = ResultsTableController(style: .plain)
        controller.onBoardSelect = onBoardSelect
        return controller
    }
}

extension FavoriteViewController: UISearchControllerDelegate {

}

extension FavoriteViewController: UISearchResultsUpdating {
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
