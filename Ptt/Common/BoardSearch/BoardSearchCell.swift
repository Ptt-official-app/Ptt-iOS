//
//  BoardSearchCell.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/10.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

protocol BoardSearchCellProtocol: AnyObject {
    func clickFavoriteButton(boardID: String, changeToFavorite: Bool)
}

final class BoardSearchCell: UITableViewCell {
    private let container = BoardSearchCell.container()
    private let boardNameLabel = BoardSearchCell.boardNameLabel()
    private let favoriteButton = BoardSearchCell.favoriteButton()
    private let favoriteIcon = BoardSearchCell.favoriteIconView()
    private var boardID: String?
    private var isFavorite = false
    weak var delegate: BoardSearchCellProtocol?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        container.layoutIfNeeded()
        container.layer.cornerRadius = container.frame.height / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        boardID = nil
        boardNameLabel.text = ""
        setFavoriteButton(isFavorite: false)
    }

    func config(boardName: String, isFavorite: Bool, boardID: String, delegate: BoardSearchCellProtocol) {
        boardNameLabel.text = boardName
        self.delegate = delegate
        self.boardID = boardID
        self.isFavorite = isFavorite
        setFavoriteButton(isFavorite: isFavorite)
    }

    @objc
    private func clickFavoriteButton() {
        guard let boardID = self.boardID else { return }
        delegate?.clickFavoriteButton(boardID: boardID, changeToFavorite: !isFavorite)
    }
}

extension BoardSearchCell {
    private func setUpSubViews() {
        selectionStyle = .none
        setUpContainer()
        setUpBoardNameLabel()
#if DEVELOP // Disable adding and removing favorite, for now
        setUpFavoriteIcon()
        setUpFavoriteButton()
        favoriteButton.addTarget(
            self,
            action: #selector(self.clickFavoriteButton),
            for: .touchUpInside
        )
#endif
    }

    private func setUpContainer() {
        contentView.addSubview(container)
        [
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22.5),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22.5),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ].active()
    }

    private func setUpBoardNameLabel() {
        container.addSubview(boardNameLabel)
        [
            boardNameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 7),
            boardNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 17.5),
            boardNameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -7)
        ].active()
    }

    private func setUpFavoriteIcon() {
        container.addSubview(favoriteIcon)

        [
            favoriteIcon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            favoriteIcon.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15.5),
            favoriteIcon.leadingAnchor.constraint(equalTo: boardNameLabel.trailingAnchor, constant: 8)
        ].active()
    }

    private func setUpFavoriteButton() {
        container.addSubview(favoriteButton)

        [
            favoriteButton.topAnchor.constraint(equalTo: container.topAnchor),
            favoriteButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            favoriteButton.leadingAnchor.constraint(equalTo: boardNameLabel.trailingAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ].active()
    }

    private func setFavoriteButton(isFavorite: Bool) {
        let color = isFavorite ? PttColors.dandelion : PttColors.slateGrey
        favoriteIcon.tintColor = color.color
    }
}

extension BoardSearchCell {
    private static func container() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = PttColors.darkGrey.color
        return view
    }

    private static func boardNameLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = PttColors.paleGrey.color
        label.font = .systemFont(ofSize: 14)
        return label
    }

    private static func favoriteButton() -> UIButton {
        let button = UIButton()
        return button
    }

    private static func favoriteIconView() -> UIImageView {
        let image = UIImage(systemName: "heart.fill")
        let view = UIImageView(image: image)
        return view
    }
}
