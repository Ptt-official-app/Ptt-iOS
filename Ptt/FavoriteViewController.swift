//
//  FavoriteViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/7.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

final class FavoriteViewController: UITableViewController {

    private let cellReuseIdentifier = "FavoriteCell"
    private var boards = [("Gossiping", "【八卦】 請協助置底協尋"),
                          ("C_Chat", "[希洽] 養成好習慣 看文章前先ID"),
                          ("NBA", "[NBA] R.I.P. Mr. David Stern"),
                          ("Lifeismoney", "[省錢] 省錢板"),
                          ("Stock", "[股版]發文請先詳閱版規"),
                          ("HatePolitics", "[政黑] 第三勢力先知王kusanagi02"),
                          ("Baseball", "[棒球] 2020東奧六搶一在台灣"),
                          ("Tech_Job", "[科技] 修機改善是設備終生職責"),
                          ("LoL", "[LoL] PCS可憐哪"),
                          ("Beauty", "《表特板》發文附圖")]
    private let resultsTableController = ResultsTableController(style: .plain)
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
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! FavoriteTableViewCell
        let index = indexPath.row
        if index < boards.count {
            cell.boardName = boards[index].0
            cell.boardTitle = boards[index].1
        }
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            boards.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let fromRow = fromIndexPath.row
        let toRow = to.row
        let element = boards.remove(at: fromRow)
        boards.insert(element, at: toRow)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index < boards.count {
            let boardViewController = BoardViewController(boardName: boards[index].0)
            show(boardViewController, sender: self)
        }
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
        APIClient.getBoardList { [weak self] (result) in
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
            var result = [(String, String)]()
            for filteredBoard in filteredBoards {
                if let boardDesc = boardListDict[filteredBoard] as? [String: Any], let desc = boardDesc["中文敘述"] as? String {
                    result.append((filteredBoard, desc))
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

// MARK: - ResultsTableController

private final class ResultsTableController : UITableViewController {

    var filteredBoards = [(String, String)]()
    let activityIndicator = UIActivityIndicatorView()

    private let cellReuseIdentifier = "FavoriteCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = GlobalAppearance.backgroundColor
        if #available(iOS 13.0, *) {
        } else {
            tableView.indicatorStyle = .white
        }
        tableView.estimatedRowHeight = 80.0
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag // to dismiss from search bar
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        activityIndicator.color = .lightGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 20.0),
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor)
        ])
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBoards.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! FavoriteTableViewCell
        let index = indexPath.row
        if index < filteredBoards.count {
            cell.boardName = filteredBoards[index].0
            cell.boardTitle = filteredBoards[index].1
        }
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index < filteredBoards.count {
            let boardViewController = BoardViewController(boardName: filteredBoards[index].0)
            presentingViewController?.show(boardViewController, sender: self)
        }
    }
}

// MARK: - FavoriteTableViewCell

private final class FavoriteTableViewCell: UITableViewCell {

    var boardName : String? {
        didSet {
            boardNameLabel.text = boardName
        }
    }
    var boardTitle : String? {
        didSet {
            boardTitleLabel.text = boardTitle
        }
    }
    private let boardNameLabel = UILabel()
    private let boardTitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        backgroundColor = GlobalAppearance.backgroundColor
        boardNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        boardTitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        if #available(iOS 11.0, *) {
            boardNameLabel.textColor = UIColor(named: "textColor-240-240-247")
            boardTitleLabel.textColor = UIColor(named: "textColorGray")
        } else {
            boardNameLabel.textColor = UIColor(red: 240/255, green: 240/255, blue: 247/255, alpha: 1.0)
            boardTitleLabel.textColor = .systemGray
        }

        boardNameLabel.translatesAutoresizingMaskIntoConstraints = false
        boardTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(boardNameLabel)
        contentView.addSubview(boardTitleLabel)
        let viewsDict = ["boardNameLabel": boardNameLabel, "boardTitleLabel": boardTitleLabel]
        let metrics = ["hp": 20, "vp": 10, "vps": 4]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hp)-[boardNameLabel]-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hp)-[boardTitleLabel]-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vp)-[boardNameLabel]-(vps)-[boardTitleLabel]-(vp)-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
