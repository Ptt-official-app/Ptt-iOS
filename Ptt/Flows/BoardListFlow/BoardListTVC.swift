//
//  BoardListTVC.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/12.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

protocol BoardListView: BaseView {
    var onBoardSelect: ((String) -> Void)? { get set }
    var onLogout: (() -> Void)? { get set }
}

final class BoardListTVC: UITableViewController, BoardListView {
    var onBoardSelect: ((String) -> Void)?
    var onLogout: (() -> Void)?

    private let viewModel: BoardListViewModel
    private let keyChainItem: PTTKeyChain
    private let boardSearchVC: BoardSearchViewController
    private let searchController: UISearchController
    private var scrollDirection: Direction = .unknown

    init(viewModel: BoardListViewModel, keyChainItem: PTTKeyChain = KeyChainItem.shared) {
        self.viewModel = viewModel
        self.keyChainItem = keyChainItem
        self.boardSearchVC = BoardSearchViewController(apiClient: viewModel.apiClient)
        self.searchController = UISearchController(searchResultsController: boardSearchVC)
        super.init(style: .plain)
        self.boardSearchVC.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        viewModel.fetchPopularBoards()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: BoardsTableViewCell.cellID, for: indexPath) as? BoardsTableViewCell, indexPath.row < viewModel.list.count
        else {
            return UITableViewCell()
        }
        let data = viewModel.list[indexPath.row]
        cell.config(boardName: data.brdname, title: data.title, numberOfUsers: data.nuser)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onBoardSelect?(viewModel.list[indexPath.row].brdname)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch viewModel.listType {
        case .favorite:
            return true
        case .popular:
            return false
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        switch viewModel.listType {
        case .favorite:
            return true
        case .popular:
            return false
        }
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            viewModel.removeBoard(at: indexPath.row)
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        viewModel.moveBoard(from: fromIndexPath.row, to: to.row)
    }

    override func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let velocity = tableView.panGestureRecognizer.velocity(in: tableView).y
        if velocity < 0 {
            scrollDirection = .bottom
        } else if velocity > 0 {
            scrollDirection = .up
        }

        if indexPath.row == viewModel.list.count - 3 && scrollDirection == .bottom {
            viewModel.fetchMoreData()
        }
    }
}

extension BoardListTVC {
    @objc
    private func debug_logout() {
        print("Debug logout button press")

        DispatchQueue.main.async {
            self.keyChainItem.delete(for: .loginToken)
            self.onLogout?()
        }
    }

    @objc
    private func pullDownToRefresh() {
        viewModel.pullDownToRefresh()
    }
}

extension BoardListTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        boardSearchVC.search(keyword: searchText)
    }
}

extension BoardListTVC: BoardListUIProtocol {
    func show(error: Error) {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            let message = error.localizedDescription
            let alert = UIAlertController(title: L10n.error, message: message, preferredStyle: .alert)
            let confirm = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func listDidUpdate() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }

    func stopRefreshing() {
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    func inValidUser() {
        DispatchQueue.main.async {
            self.debug_logout()
        }
    }
}

extension BoardListTVC {
    private func setUpView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = GlobalAppearance.backgroundColor
        switch viewModel.listType {
        case .favorite:
            title = L10n.favoriteBoards
#if DEVELOP // Disable editing for favorite, for now
            navigationItem.setRightBarButton(editButtonItem, animated: true)
#endif
            let logoutBarItem = UIBarButtonItem(
                title: "Logout",
                style: .plain,
                target: self,
                action: #selector(debug_logout)
            )

            navigationItem.setLeftBarButton(logoutBarItem, animated: true)
        case .popular:
            title = L10n.popularBoards
        }
        setUpTableView()
        setUpSearchController()
    }

    private func setUpTableView() {
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag // to dismiss from search bar
        tableView.register(BoardsTableViewCell.self, forCellReuseIdentifier: BoardsTableViewCell.cellID)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullDownToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setUpSearchController() {
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.searchBar.searchTextField.textColor = PttColors.paleGrey.color
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension BoardListTVC: BoardSearchViewProtocol {
    func showBoard(boardName: String) {
        onBoardSelect?(boardName)
    }
}
