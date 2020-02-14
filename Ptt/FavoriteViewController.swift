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
        if #available(iOS 11.0, *) {
        } else {
            tableView.keyboardDismissMode = .onDrag // to dismiss from search bar
        }
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        let searchResultsController = UITableViewController(style: .plain)
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
            searchController.searchBar.barStyle = .black
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }

    // MARK: - UITableViewDataSource

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

extension FavoriteViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension FavoriteViewController: UISearchBarDelegate {

}

private class FavoriteTableViewCell: UITableViewCell {

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
