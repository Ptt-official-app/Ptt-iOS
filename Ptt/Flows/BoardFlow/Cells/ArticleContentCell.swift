//
//  ArticleContentCell.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

final class ArticleContentCell: UITableViewCell {

    private let contentTextView = UITextView()
    var article: APIModel.FullArticle? = nil {
        didSet {
            if let article {
                contentTextView.text = article.content
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentTextView.backgroundColor = PttColors.codGray.color
        contentTextView.font = UIFont.preferredFont(forTextStyle: .body)
        contentTextView.textColor = PttColors.paleGrey.color
        contentTextView.dataDetectorTypes = .all
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        // See: https://stackoverflow.com/a/28589384/3796488
        contentTextView.accessibilityTraits = .staticText
        contentView.ptt_add(subviews: [contentTextView])
        let viewsDict = ["contentTextView": contentTextView]
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(24)-[contentTextView]-(24)-|", metrics: nil, views: viewsDict) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-(18)-[contentTextView]-(18)-|", metrics: nil, views: viewsDict)
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
