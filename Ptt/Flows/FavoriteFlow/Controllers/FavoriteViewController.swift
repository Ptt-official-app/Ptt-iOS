//
//  FavoriteViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/7.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

struct Favorite {

    // TODO: Switch to Ptt API later
    private static let savePath : URL? = {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent("favoriteBoardsData")
            return path
        }
        assertionFailure()
        return nil
    }()
    static var boards : [Board] = {
        guard let url = savePath,
            let data = try? Data(contentsOf: url),
            let boards = try? JSONDecoder().decode([Board].self, from: data) else {
                return [Board(name: "Gossiping", title: "【八卦】 請協助置底協尋"),
                        Board(name: "C_Chat", title: "[希洽] 養成好習慣 看文章前先ID"),
                        Board(name: "NBA", title: "[NBA] R.I.P. Mr. David Stern"),
                        Board(name: "Lifeismoney", title: "[省錢] 省錢板"),
                        Board(name: "Stock", title: "[股版]發文請先詳閱版規"),
                        Board(name: "HatePolitics", title: "[政黑] 第三勢力先知王kusanagi02"),
                        Board(name: "Baseball", title: "[棒球] 2020東奧六搶一在台灣"),
                        Board(name: "Tech_Job", title: "[科技] 修機改善是設備終生職責"),
                        Board(name: "LoL", title: "[LoL] PCS可憐哪"),
                        Board(name: "Beauty", title: "《表特板》發文附圖")]
        }
        return boards
        }() {
        willSet {
            guard let data = try? JSONEncoder().encode(newValue), let url = savePath else {
                assertionFailure()
                return
            }
            do {
                try data.write(to: url)
            } catch (let error) {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

// MARK: -

protocol FavoriteView: BaseView {
    var onBoardSelect: ((String) -> Void)? { get set }
}

final class FavoriteViewController: UITableViewController, FavoriteView {
    
    var onBoardSelect: ((String) -> Void)?

    private let cellReuseIdentifier = "FavoriteCell"
    private lazy var resultsTableController = configureResultsTableController()
    private lazy var searchController : UISearchController = {
        // For if #available(iOS 11.0, *), no need to set searchController as property (local variable is fine).
       return UISearchController(searchResultsController: resultsTableController)
    }()
    private var allBoards : [String]? = nil
    private var boardListDict : [String: Any]? = nil

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Favorite Boards", comment: "")
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
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.textColor = UIColor(named: "textColor-240-240-247")
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
            cell.boardName = Favorite.boards[index].name
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
            onBoardSelect?(Favorite.boards[index].name)
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

extension FavoriteViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if boardListDict != nil {
            return
        }
        resultsTableController.activityIndicator.startAnimating()
        var array = [String]()
        APIClient.shared.getBoardList { [weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
            case .failure(error: let error):
                DispatchQueue.main.async {
                    weakSelf.resultsTableController.activityIndicator.stopAnimating()
                    weakSelf.searchController.isActive = false
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.message, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
                    alert.addAction(confirm)
                    weakSelf.present(alert, animated: true, completion: nil)
                }
            case .success(data: let data):
                if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    for (key, _) in dict {
                        array.append(key)
                    }
                    weakSelf.boardListDict = dict
                }
                weakSelf.allBoards = array
                DispatchQueue.main.async {
                    weakSelf.resultsTableController.activityIndicator.stopAnimating()
                    // Update UI for current typed search text
                    if let searchText = searchBar.text, searchText.count > 0 && weakSelf.resultsTableController.filteredBoards.count == 0 {
                        weakSelf.updateSearchResults(for: weakSelf.searchController)
                    }
                }
            }
        }
    }
}

extension FavoriteViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, let allBoards = self.allBoards, let boardListDict = self.boardListDict else {
            return
        }
        resultsTableController.activityIndicator.startAnimating()
        // Note: Using GCD here is imperfect but elegant. We'll have Search API later.
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let weakSelf = self else { return }
            let filteredBoards = allBoards.filter { $0.localizedCaseInsensitiveContains(searchText) }
            var result = [Board]()
            for filteredBoard in filteredBoards {
                if let boardDesc = boardListDict[filteredBoard] as? [String: Any], let desc = boardDesc["中文敘述"] as? String {
                    result.append(Board(name: filteredBoard, title: desc))
                }
            }
            weakSelf.resultsTableController.filteredBoards = result
            DispatchQueue.main.async {
                // Only update UI for the matching result
                if searchText == searchController.searchBar.text {
                    weakSelf.resultsTableController.activityIndicator.stopAnimating()
                    weakSelf.resultsTableController.tableView.reloadData()
                }
            }
        }
    }
}
