//
//  ArticleMetaDataCell.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

final class ArticleMetaDataCell: UITableViewCell {

    private let categoryImageView = UIImageView()
    private let categoryLabel = UILabel()
    private let clockImageView = UIImageView()
    private let dateLabel = UILabel()
    private let authorImageView = UIImageView()
    private let authorNameLabel = UILabel()

    var article: APIModel.FullArticle? {
        didSet {
            if let article {
                if let category = article.category {
                    categoryLabel.text = "\(article.board) / \(category)"
                } else {
                    categoryLabel.text = article.board
                }
                dateLabel.text = article.date
                authorNameLabel.text = "\(article.author) (\(article.nickname))"
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        categoryImageView.image = StyleKit.imageOfBoardCategory()
        clockImageView.image = StyleKit.imageOfClock()
        authorImageView.image = StyleKit.imageOfAuthor()

        categoryLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        authorNameLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        categoryLabel.textColor = .systemGray
        dateLabel.textColor = .systemGray
        authorNameLabel.textColor = .systemGray

        contentView.ptt_add(subviews: [categoryImageView, categoryLabel, clockImageView, dateLabel, authorImageView, authorNameLabel])
        let viewsDict = ["categoryImageView": categoryImageView, "categoryLabel": categoryLabel, "clockImageView": clockImageView, "dateLabel": dateLabel, "authorImageView": authorImageView, "authorNameLabel": authorNameLabel]
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-[categoryImageView]-(10)-[authorImageView]-(10)-[clockImageView]-|", metrics: nil, views: viewsDict) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(44)-[categoryImageView]-[categoryLabel]", metrics: nil, views: viewsDict) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(44)-[authorImageView]-[authorNameLabel]", metrics: nil, views: viewsDict) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(44)-[clockImageView]-[dateLabel]", metrics: nil, views: viewsDict) +
            [categoryImageView.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
             authorImageView.centerYAnchor.constraint(equalTo: authorNameLabel.centerYAnchor),
             clockImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)]
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
