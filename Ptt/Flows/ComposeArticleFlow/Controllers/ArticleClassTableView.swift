//
//  ArticleClassTableView.swift
//  Ptt
//
//  Created by marcus fu on 2021/6/7.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

protocol ArticleClassTableViewDelegate {
    func setArticleClass(classText: String)
}

class ArticleClassTableView: UITableView {
    private let cellHeight: CGFloat = 47
    private let classList = [
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
    var articleClassTableViewDelegate: ArticleClassTableViewDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = GlobalAppearance.backgroundColor
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        tableFooterView = UIView()
        initTableHeaderView()
//        separatorStyle = .singleLine
//        self.estimatedRowHeight = 47.0
        separatorInset = UIEdgeInsets.zero
        register(ArticleClassTableViewCell.self, forCellReuseIdentifier: ArticleClassTableViewCell.cellIdentifier())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func initTableHeaderView() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 74.5))
        label.textAlignment = .center
        label.textColor = UIColor(named: "textColor-240-240-247")
        label.text = "分類選擇"
        label.backgroundColor = UIColor(red:34/255, green:34/255, blue:36/255, alpha:1.0)
        label.setBottomBorder()
        self.tableHeaderView = label
    }
}

extension ArticleClassTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleClassTableViewCell.cellIdentifier()) as! ArticleClassTableViewCell
        cell.configure(index: indexPath.row, listLimit: classList.count-1, value: classList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articleClassTableViewDelegate?.setArticleClass(classText: classList[indexPath.row])
    }
    
}

extension ArticleClassTableView: UITableViewDelegate {
}
