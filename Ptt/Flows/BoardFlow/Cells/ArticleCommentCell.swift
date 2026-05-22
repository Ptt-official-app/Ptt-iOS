//
//  ArticleCommentCell.swift
//  Ptt
//
//  Created by denkeni on 2026/5/11.
//  Copyright © 2026 Ptt. All rights reserved.
//

import UIKit

final class ArticleCommentCell: UICollectionViewListCell {

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

    var comment: APIModel.BoardArticleComment? {
        didSet {
            guard let comment else { return }
            typeLabel.text = Self.symbol(for: comment.type)
            typeLabel.textColor = Self.color(for: comment.type)
            ownerLabel.text = comment.owner
            contentLabel.text = comment.plainContent
            contentLabel.textColor = comment.type == .reply ? PttColors.paleGrey.color : Self.defaultContentColor
            timeLabel.text = Self.timeFormatter.string(from: comment.createTime)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = PttColors.codGray.color
        contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2, leading: 24, bottom: 2, trailing: 24)

        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        let boldFont = bodyFont.withTraits(.traitBold)
        typeLabel.font = boldFont
        ownerLabel.font = boldFont
        ownerLabel.textColor = UIColor(red: 1.00, green: 0.99, blue: 0.48, alpha: 1.00) // #FFFC7A
        contentLabel.font = bodyFont
        contentLabel.textColor = Self.defaultContentColor
        timeLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        timeLabel.textColor = .systemGray

        for label in [typeLabel, ownerLabel, contentLabel, timeLabel] {
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.setContentCompressionResistancePriority(.required, for: .vertical)
        }
        for label in [typeLabel, ownerLabel, timeLabel] {
            label.setContentHuggingPriority(.required, for: .horizontal)
            label.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        contentView.ptt_add(subviews: [typeLabel, ownerLabel, contentLabel, timeLabel])
        let margins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            typeLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            typeLabel.firstBaselineAnchor.constraint(equalTo: contentLabel.firstBaselineAnchor),

            ownerLabel.leadingAnchor.constraint(equalTo: typeLabel.trailingAnchor, constant: 4),
            ownerLabel.firstBaselineAnchor.constraint(equalTo: contentLabel.firstBaselineAnchor),

            contentLabel.leadingAnchor.constraint(equalTo: ownerLabel.trailingAnchor, constant: 6),
            contentLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -6),
            contentLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),

            timeLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            timeLabel.firstBaselineAnchor.constraint(equalTo: contentLabel.firstBaselineAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
