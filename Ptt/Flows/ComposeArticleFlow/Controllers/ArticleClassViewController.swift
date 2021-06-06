//
//  ArticleClassViewController.swift
//  Ptt
//
//  Created by marcus fu on 2021/6/7.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

class ArticleClassViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let classList = [
        "無",
        "問題",
        "討論",
        "心情",
        "閒聊",
        "灑花",
        "難過",
        "公告",
        "新聞",
        "取消"
    ]
    
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
        tableview.estimatedRowHeight = 47.0
        tableview.separatorStyle = .none
        tableview.keyboardDismissMode = .onDrag // to dismiss from search bar
        
        return tableview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopularBoardsTableViewCell.cellIdentifier()) as! PopularBoardsTableViewCell
//        cell.configure(viewModel, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let index = indexPath.row
//        if index < viewModel.popularBoards.value.count {
//            onBoardSelect?(viewModel.popularBoards.value[index].brdname)
//        }
    }

}
