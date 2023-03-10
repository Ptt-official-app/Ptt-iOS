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

final class FavoriteViewController: UITableViewController, FavoriteView, UISearchControllerDelegate {
    var onBoardSelect: ((String) -> Void)?
    var onLogout: (() -> Void)?

    private let apiClient: APIClientProtocol
    private var list: [APIModel.BoardInfo] = []
    private var startIdx = ""
    private var scrollDirection: Direction = .unknown
    private lazy var searchTableController = configureSearchTableController()
    private lazy var searchController : UISearchController = {
        // For if #available(iOS 11.0, *), no need to set searchController as property (local variable is fine).
       return UISearchController(searchResultsController: searchTableController)
    }()

    init(apiClient: APIClientProtocol=APIClient.shared) {
        self.apiClient = apiClient
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        fetchFavoritesBoards()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: BoardsTableViewCell.cellID,
                for: indexPath
            ) as? BoardsTableViewCell
        else {
            return UITableViewCell()
        }
        let data = list[indexPath.row]
        cell.config(boardName: data.brdname, title: data.title, numberOfUsers: data.nuser)
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let fromRow = fromIndexPath.row
        let toRow = to.row
        let element = list.remove(at: fromRow)
        list.insert(element, at: toRow)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        onBoardSelect?(list[index].brdname)
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

        if indexPath.row == list.count - 3 && scrollDirection == .bottom {
            fetchFavoritesBoards()
        }
    }
}

// MARK: - UI
extension FavoriteViewController {
    private func setUpViews() {
        title = L10n.favoriteBoards
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.setRightBarButton(editButtonItem, animated: true)
        view.backgroundColor = GlobalAppearance.backgroundColor
        setUpTableView()
        setUpSearchController()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refresh),
            name: NSNotification.Name("didUpdateFavoriteBoards"),
            object: nil
        )
        let logoutBarItem = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(debug_logout)
        )

        navigationItem.setLeftBarButton(logoutBarItem, animated: true)
    }

    private func setUpTableView() {
        if #available(iOS 13.0, *) {
        } else {
            tableView.indicatorStyle = .white
        }
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
            // See: https://stackoverflow.com/questions/31463381/background-color-for-uisearchcontroller-in-uitableview
            tableView.backgroundView = UIView()
        }
    }

    private func configureSearchTableController() -> BoardSearchViewController {
        let searchVC = BoardSearchViewController()
        return searchVC
    }
}

// MARK: - Private functions
extension FavoriteViewController {
    @objc
    private func debug_logout() {
        print("Debug logout button press")

        DispatchQueue.main.async {
            KeyChainItem.delete(for: .loginToken)
            self.onLogout?()
        }
    }

    @objc
    private func refresh() {
        tableView.reloadData()
    }

    @objc
    private func pullDownToRefresh() {
        startIdx = ""
        list = []
        fetchFavoritesBoards()
    }

    private func fetchFavoritesBoards() {
        apiClient.getFavoritesBoards(startIndex: startIdx, limit: 200) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                switch result {
                case .failure(let error):
                    let message = error.localizedDescription
                    let alert = UIAlertController(title: L10n.error, message: message, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
                    alert.addAction(confirm)
                    self.present(alert, animated: true, completion: nil)
                case .success(let response):
                    self.list += response.list
                    self.startIdx = response.next_idx ?? ""
                    self.searchTableController.update(favoriteBoards: self.list)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension FavoriteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, searchText.count > 0  else { return }
        searchTableController.search(keyword: searchText)
    }
}
