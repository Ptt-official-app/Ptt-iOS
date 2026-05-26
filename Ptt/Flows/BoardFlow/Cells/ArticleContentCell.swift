//
//  ArticleContentCell.swift
//  Ptt
//
//  Created by denkeni on 2020/1/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

struct ArticleContentConfiguration: UIContentConfiguration {

    var article: APIModel.FullArticle?
    weak var linkDelegate: (any UITextViewDelegate)?

    func makeContentView() -> UIView & UIContentView {
        ArticleContentContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> ArticleContentConfiguration {
        self
    }
}

final class ArticleContentContentView: UIView, UIContentView {

    private let contentTextView = UITextView()

    // Same green used in LegacyArticleViewController for ※-prefixed system lines.
    private static let systemLineColor = UIColor(red: 0.00, green: 0.60, blue: 0.00, alpha: 1.00)
    private static let commentLineColor = UIColor(red: 0.00, green: 0.60, blue: 0.60, alpha: 1.00)

    var configuration: UIContentConfiguration {
        didSet {
            guard let configuration = configuration as? ArticleContentConfiguration else { return }
            apply(configuration)
        }
    }

    init(configuration: ArticleContentConfiguration) {
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
        contentTextView.backgroundColor = PttColors.codGray.color
        contentTextView.dataDetectorTypes = .all
        contentTextView.isEditable = false
        contentTextView.isScrollEnabled = false
        // See: https://stackoverflow.com/a/28589384/3796488
        contentTextView.accessibilityTraits = .staticText
        ptt_add(subviews: [contentTextView])
        let readable = readableContentGuide
        NSLayoutConstraint.activate([
            contentTextView.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
            contentTextView.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
            contentTextView.topAnchor.constraint(equalTo: topAnchor, constant: 18),
            contentTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18)
        ])
    }

    private func apply(_ configuration: ArticleContentConfiguration) {
        contentTextView.delegate = configuration.linkDelegate
        guard let article = configuration.article else { return }
        contentTextView.attributedText = Self.attributedText(for: article)
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
