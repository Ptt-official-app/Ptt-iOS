//
//  ArticleContentCell.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

final class ArticleContentCell: UICollectionViewListCell {

    private let contentTextView = UITextView()

    // Same green used in LegacyArticleViewController for ※-prefixed system lines.
    private static let systemLineColor = UIColor(red: 0.00, green: 0.60, blue: 0.00, alpha: 1.00)
    private static let commentLineColor = UIColor(red: 0.00, green: 0.60, blue: 0.60, alpha: 1.00)

    var article: APIModel.FullArticle? {
        didSet {
            guard let article else { return }
            contentTextView.attributedText = Self.attributedText(for: article)
        }
    }

    func setLinkDelegate(_ delegate: UITextViewDelegate?) {
        contentTextView.delegate = delegate
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentTextView.backgroundColor = PttColors.codGray.color
        contentTextView.dataDetectorTypes = .all
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        // See: https://stackoverflow.com/a/28589384/3796488
        contentTextView.accessibilityTraits = .staticText
        contentView.ptt_add(subviews: [contentTextView])
        let readable = contentView.readableContentGuide
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
            contentTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func attributedText(for article: APIModel.FullArticle) -> NSAttributedString {
        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        let body = NSMutableAttributedString(
            string: article.content,
            attributes: [
                .font: bodyFont,
                .foregroundColor: PttColors.paleGrey.color
            ]
        )
        let nsContent = article.content as NSString
        nsContent.enumerateSubstrings(in: NSRange(location: 0, length: nsContent.length), options: .byLines) { line, lineRange, _, _ in
            guard let line else { return }
            if line.hasPrefix("※") {
                body.addAttribute(.foregroundColor, value: systemLineColor, range: lineRange)
            } else if line.hasPrefix(": ") {
                body.addAttribute(.foregroundColor, value: commentLineColor, range: lineRange)
            }
        }
        body.append(NSAttributedString(
            string: "--\r\n",
            attributes: [
                .font: bodyFont,
                .foregroundColor: PttColors.paleGrey.color
            ]
        ))
        if !article.ip.isEmpty {
            body.append(NSAttributedString(
                string: L10n.from + ": \(article.ip)",
                attributes: [
                    .font: bodyFont,
                    .foregroundColor: systemLineColor
                ]
            ))
        }
        return body
    }
}
