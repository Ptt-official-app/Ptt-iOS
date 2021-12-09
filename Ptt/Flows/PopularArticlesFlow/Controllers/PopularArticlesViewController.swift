//
//  PopularArticlesViewController.swift
//  Ptt
//
//  Created by Anson on 2021/12/5.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

protocol PopularArticlesView: BaseView {
    func startSpinning(isPullDownToRefresh: Bool)
    func stopSpinning(isPullDownToRefresh: Bool)
    func isLoading() -> Bool
    func show(error: Error)
    func reloadTable()
    func insert(rows: [IndexPath])
}

enum ArticleTypes {
    case All

    var title: String {
        switch self {
        case .All: return NSLocalizedString("ALL", comment: "")
        }
    }
}

final class PopularArticlesViewController: UITableViewController {

    private var viewModel: PopularArticlesVMProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(self.viewModel != nil)
        self.setupTitle(type: .All)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.setupTableView()
        self.setupRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.viewModel.data.isEmpty {
            self.viewModel.fetchData(isPullDownToRefresh: true)
        }
    }

    func setup(viewModel: PopularArticlesVMProtocol) {
        self.viewModel = viewModel
    }

    private func setupTitle(type: ArticleTypes) {
        self.navigationController?.navigationBar.topItem?.title = type.title
    }

    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor(named: "blackColor-23-23-23")
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 113
        self.tableView.register(PopularArticleCell.nib,
                                forCellReuseIdentifier: PopularArticleCell.reuseID)
    }

    private func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self,
                                       action: #selector(self.pullDownToRefresh),
                                       for: .valueChanged)
    }

    @objc private func pullDownToRefresh() {
        self.viewModel.fetchData(isPullDownToRefresh: true)
    }
}

extension PopularArticlesViewController: PopularArticlesView {
    func startSpinning(isPullDownToRefresh: Bool) {
        if isPullDownToRefresh {
            self.refreshControl?.beginRefreshing()
        } else {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.startAnimating()
            spinner.color = UIColor.darkGray
            spinner.hidesWhenStopped = true
            tableView.tableFooterView = spinner
            self.viewModel.fetchData(isPullDownToRefresh: false)
        }
    }

    func stopSpinning(isPullDownToRefresh: Bool) {
        DispatchQueue.main.async {
            if isPullDownToRefresh {
                self.refreshControl?.endRefreshing()
            } else {
                self.tableView.tableFooterView = nil
            }
        }
    }

    func isLoading() -> Bool {
        (self.refreshControl?.isRefreshing ?? false) || self.tableView.tableFooterView != nil
    }

    func show(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
            let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
            alert.addAction(confirm)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func insert(rows: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: rows, with: .automatic)
            self.tableView.endUpdates()
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension PopularArticlesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularArticleCell.reuseID, for: indexPath) as? PopularArticleCell else {
            return UITableViewCell()
        }
        let info = self.viewModel.data[indexPath.row]
        cell.config(by: info)
        return cell
    }
}

extension PopularArticlesViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height),
        self.viewModel.shouldFetchData(isPullDownToRefresh: false) else {
            return
        }
        self.startSpinning(isPullDownToRefresh: false)
    }
}
