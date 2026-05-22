//
//  BoardsTableViewCell.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/20.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

class BoardsTableViewCell: UITableViewCell {
    var boardName: String? {
        didSet {
            boardNameLabel.text = boardName
        }
    }
    var boardTitle: String? {
        didSet {
            boardTitleLabel.text = boardTitle
        }
    }

    lazy var favoriteButton: FavoriteButton = {
        let button = FavoriteButton()
        contentView.ptt_add(subviews: [button])
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.widthAnchor.constraint(equalTo: button.heightAnchor)
        ])
        return button
    }()

    private let boardNameLabel = UILabel()
    private let boardTitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        backgroundColor = GlobalAppearance.backgroundColor
        boardNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        boardTitleLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        if #available(iOS 11.0, *) {
            boardNameLabel.textColor = PttColors.paleGrey.color
            boardTitleLabel.textColor = .systemGray
        } else {
            boardNameLabel.textColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 247 / 255, alpha: 1.0)
            boardTitleLabel.textColor = .systemGray
        }

        contentView.ptt_add(subviews: [boardNameLabel, boardTitleLabel])
        let margins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            boardNameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            boardNameLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            boardTitleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            boardTitleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            boardNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            boardTitleLabel.topAnchor.constraint(equalTo: boardNameLabel.bottomAnchor, constant: 4),
            boardTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FavoriteButton: UIButton {

    var board: APIModel.BoardInfo? {
        didSet {
            if let board = self.board, Favorite.boards.contains(where: { $0.brdname == board.brdname }) {
                isSelected = true
            } else {
                isSelected = false
            }
        }
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView?.tintColor = GlobalAppearance.tintColor
                if let boardName = board?.brdname {
                    accessibilityLabel = boardName + L10n.inFavorite
                    accessibilityHint = L10n.removes + boardName + L10n.fromFavorite
                }
            } else {
                imageView?.tintColor = UIColor(hue: 0.667, saturation: 0.079, brightness: 0.4, alpha: 1)
                if let boardName = board?.brdname {
                    accessibilityLabel = boardName + L10n.notInFavorite
                    accessibilityHint = L10n.adds + boardName + L10n.toFavorite
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let image = StyleKit.imageOfFavorite()
        setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        isSelected = false
        showsTouchWhenHighlighted = true    // comment me for easier view hierarchy debugging
        if #available(iOS 11.0, *) {
            adjustsImageSizeForAccessibilityContentSizeCategory = true
        } else {
            // Sorry, iOS 10.
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
