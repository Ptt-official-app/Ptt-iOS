//
//  FavoriteViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/1/7.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

final class FavoriteViewController: UITableViewController {

    private static let cellReuseIdentifier = "FavoriteCell"
    private var backgroundColor : UIColor? {
        if #available(iOS 11.0, *) {
            return UIColor(named: "blackColor-23-23-23")
        } else {
            return UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Favorite Boards", comment: "")
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = backgroundColor
        tableView.estimatedRowHeight = 80.0
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
        } else {
            tableView.keyboardDismissMode = .onDrag // to dismiss from search bar
        }
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: FavoriteViewController.cellReuseIdentifier)

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

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteViewController.cellReuseIdentifier, for: indexPath) as! FavoriteTableViewCell
        cell.boardName = "Test"
        cell.boardTitle = "[測試] 每週定期清除本板文章"
        cell.backgroundColor = backgroundColor
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

        boardNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        boardTitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        if #available(iOS 11.0, *) {
            boardNameLabel.textColor = UIColor(named: "textColorWhite")
            boardTitleLabel.textColor = UIColor(named: "textColorGray")
        } else {
            boardNameLabel.textColor = .white
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
