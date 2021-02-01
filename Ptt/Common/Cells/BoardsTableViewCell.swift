//
//  BoardsTableViewCell.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/20.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

class BoardsTableViewCell: UITableViewCell {
    var boardName : String? {
        didSet {
            boardNameLabel.text = boardName
        }
    }
    var boardTitle : String? {
        didSet {
            boardTitleLabel.text = boardTitle
        }
    }
    
    lazy var favoriteButton : FavoriteButton = {
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
            boardNameLabel.textColor = UIColor(named: "textColor-240-240-247")
            boardTitleLabel.textColor = UIColor(named: "textColorGray")
        } else {
            boardNameLabel.textColor = UIColor(red: 240/255, green: 240/255, blue: 247/255, alpha: 1.0)
            boardTitleLabel.textColor = .systemGray
        }

        contentView.ptt_add(subviews: [boardNameLabel, boardTitleLabel])
        let viewsDict = ["boardNameLabel": boardNameLabel, "boardTitleLabel": boardTitleLabel]
        let metrics = ["hp": 20, "vp": 10, "vps": 4]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hp)-[boardNameLabel]-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-(hp)-[boardTitleLabel]-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(vp)-[boardNameLabel]-(vps)-[boardTitleLabel]-(vp)-|",
                                                      options: [], metrics: metrics, views: viewsDict)
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FavoriteButton: UIButton {

    var board : APIModel.BoardInfoV2? = nil {
        didSet {
            if let board = self.board, Favorite.boards.contains(where: { $0.brdname == board.brdname }) {
                isSelected = true
            } else {
                isSelected = false
            }
        }
    }
    override var isSelected : Bool {
        didSet {
            if isSelected {
                imageView?.tintColor = GlobalAppearance.tintColor
                if let boardName = board?.brdname {
                    accessibilityLabel = boardName + NSLocalizedString("In favorite", comment: "")
                    accessibilityHint = NSLocalizedString("Removes", comment: "") + boardName + NSLocalizedString("from favorite.", comment: "")
                }
            } else {
                imageView?.tintColor = UIColor(hue: 0.667, saturation: 0.079, brightness: 0.4, alpha: 1)
                if let boardName = board?.brdname {
                    accessibilityLabel = boardName + NSLocalizedString("Not in favorite", comment: "")
                    accessibilityHint = NSLocalizedString("Adds", comment: "") + boardName + NSLocalizedString("to favorite.", comment: "")
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
