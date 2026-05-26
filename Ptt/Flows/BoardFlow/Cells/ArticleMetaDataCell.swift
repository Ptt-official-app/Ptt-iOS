//
//  ArticleMetaDataCell.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

final class ArticleMetaDataCell: UICollectionViewListCell {

    private let categoryImageView = UIImageView()
    private let categoryLabel = UILabel()
    private let clockImageView = UIImageView()
    private let dateLabel = UILabel()
    private let authorImageView = UIImageView()
    private let authorNameLabel = UILabel()

    var article: APIModel.FullArticle? {
        didSet {
            if let article {
                if !article.`class`.isEmpty {
                    categoryLabel.text = "\(article.board) / \(article.`class`)"
                } else {
                    categoryLabel.text = article.board
                }
                dateLabel.text = article.date
                authorNameLabel.text = "\(article.owner) (\(article.nickname))"
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

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
        let readable = contentView.readableContentGuide
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-[categoryImageView]-(10)-[authorImageView]-(10)-[clockImageView]-|", metrics: nil, views: viewsDict) +
            [
                categoryImageView.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
                authorImageView.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
                clockImageView.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
                categoryLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 8),
                authorNameLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: 8),
                dateLabel.leadingAnchor.constraint(equalTo: clockImageView.trailingAnchor, constant: 8),
                categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: readable.trailingAnchor),
                authorNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: readable.trailingAnchor),
                dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: readable.trailingAnchor),
                categoryImageView.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
                authorImageView.centerYAnchor.constraint(equalTo: authorNameLabel.centerYAnchor),
                clockImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
            ]
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
