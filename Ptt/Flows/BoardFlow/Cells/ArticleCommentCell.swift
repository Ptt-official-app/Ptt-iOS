//
//  ArticleCommentCell.swift
//  Ptt
//
//  Created by denkeni on 2026/5/11.
//  Copyright © 2026 Ptt. All rights reserved.
//

import UIKit

struct ArticleCommentConfiguration: UIContentConfiguration {

    var comment: APIModel.BoardArticleComment?

    func makeContentView() -> UIView & UIContentView {
        ArticleCommentContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> ArticleCommentConfiguration {
        self
    }
}

final class ArticleCommentContentView: UIView, UIContentView {

    private let typeLabel = UILabel()
    private let ownerLabel = UILabel()
    private let contentLabel = UILabel()
    private let timeLabel = UILabel()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter
    }()

    private static let defaultContentColor = UIColor(red: 0.62, green: 0.59, blue: 0.16, alpha: 1.00) // #9D972A

    var configuration: UIContentConfiguration {
        didSet {
            guard let configuration = configuration as? ArticleCommentConfiguration else { return }
            apply(configuration)
        }
    }

    init(configuration: ArticleCommentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setUpViews()
        apply(configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpViews() {
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2, leading: 24, bottom: 2, trailing: 24)

        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        let boldFont = bodyFont.withTraits(.traitBold)
        typeLabel.font = boldFont
        ownerLabel.font = boldFont
        ownerLabel.textColor = UIColor(red: 1.00, green: 0.99, blue: 0.48, alpha: 1.00) // #FFFC7A
        contentLabel.font = bodyFont
        contentLabel.textColor = Self.defaultContentColor
        timeLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        timeLabel.textColor = .systemGray

        // contentLabel is the only label that wraps; it yields width freely so it absorbs the
        // remaining space between its compact neighbours.
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        contentLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        contentLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // type / owner / time stay on a single line and are pinned to their intrinsic width:
        // single line + required hugging (won't grow) + required compression resistance
        // (won't shrink).
        for label in [typeLabel, ownerLabel, timeLabel] {
            label.numberOfLines = 1
            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        ptt_add(subviews: [typeLabel, ownerLabel, contentLabel, timeLabel])
        let readable = readableContentGuide
        let margins = layoutMarginsGuide

        // typeLabel + ownerLabel hug the leading edge and timeLabel hugs the trailing edge,
        // each staying as compact as its content (required horizontal hugging above).
        // contentLabel is pinned to both neighbours with equality, so it takes every point of
        // the remaining width between them and wraps onto as many lines as it needs.
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
            typeLabel.firstBaselineAnchor.constraint(equalTo: contentLabel.firstBaselineAnchor),

            ownerLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 4),
            ownerLabel.firstBaselineAnchor.constraint(equalTo: contentLabel.firstBaselineAnchor),

            contentLabel.leadingAnchor.constraint(equalTo: ownerLabel.trailingAnchor, constant: 6),
            contentLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -6),
            contentLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),

            timeLabel.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
            timeLabel.firstBaselineAnchor.constraint(equalTo: contentLabel.firstBaselineAnchor)
        ])
    }

    private func apply(_ configuration: ArticleCommentConfiguration) {
        guard let comment = configuration.comment else { return }
        typeLabel.text = Self.symbol(for: comment.type)
        typeLabel.textColor = Self.color(for: comment.type)
        ownerLabel.text = comment.owner
        contentLabel.text = comment.plainContent
        contentLabel.textColor = comment.type == .reply ? PttColors.paleGrey.color : Self.defaultContentColor
        timeLabel.text = Self.timeFormatter.string(from: comment.createTime)
    }

    // Symbols per go-pttbbs/ptttype/comment_type.go (CommentType.Bytes):
    // only RECOMMEND/BOO/COMMENT have on-screen marks; others return nil.
    private static func symbol(for type: APIModel.CommentType) -> String {
        switch type {
        case .recommend:
            return "推"
        case .boo:
            return "噓"
        case .comment:
            return "→"
        default:
            return ""
        }
    }

    // Colors per Ptt Web convention.
    private static func color(for type: APIModel.CommentType) -> UIColor {
        switch type {
        case .recommend:
            return .white
        case .boo:
            return .systemRed
        case .comment:
            return UIColor(red: 0xCC / 255.0, green: 0, blue: 0, alpha: 1) // #c00
        default:
            return .systemGray
        }
    }
}

private extension UIFont {
    func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
