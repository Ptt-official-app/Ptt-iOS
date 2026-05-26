//
//  ArticleMetaDataCell.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

struct ArticleMetaDataConfiguration: UIContentConfiguration {

    var article: APIModel.FullArticle?

    func makeContentView() -> UIView & UIContentView {
        ArticleMetaDataContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> ArticleMetaDataConfiguration {
        self
    }
}

final class ArticleMetaDataContentView: UIView, UIContentView {

    private let categoryImageView = UIImageView()
    private let categoryLabel = UILabel()
    private let clockImageView = UIImageView()
    private let dateLabel = UILabel()
    private let authorImageView = UIImageView()
    private let authorNameLabel = UILabel()

    var configuration: UIContentConfiguration {
        didSet {
            guard let configuration = configuration as? ArticleMetaDataConfiguration else { return }
            apply(configuration)
        }
    }

    init(configuration: ArticleMetaDataConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        preservesSuperviewLayoutMargins = true
        setUpViews()
        apply(configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        categoryImageView.image = StyleKit.imageOfBoardCategory()
        clockImageView.image = StyleKit.imageOfClock()
        authorImageView.image = StyleKit.imageOfAuthor()

        categoryLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        authorNameLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        categoryLabel.textColor = .systemGray
        dateLabel.textColor = .systemGray
        authorNameLabel.textColor = .systemGray

        ptt_add(subviews: [categoryImageView, categoryLabel, clockImageView, dateLabel, authorImageView, authorNameLabel])
        let viewsDict = ["categoryImageView": categoryImageView, "categoryLabel": categoryLabel, "clockImageView": clockImageView, "dateLabel": dateLabel, "authorImageView": authorImageView, "authorNameLabel": authorNameLabel]
        let readable = readableContentGuide
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

    private func apply(_ configuration: ArticleMetaDataConfiguration) {
        guard let article = configuration.article else { return }
        if !article.`class`.isEmpty {
            categoryLabel.text = "\(article.board) / \(article.`class`)"
        } else {
            categoryLabel.text = article.board
        }
        dateLabel.text = article.date
        authorNameLabel.text = "\(article.owner) (\(article.nickname))"
    }
}
