//
//  BoardSearchCell.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/10.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

final class BoardSearchCell: UITableViewCell {
    private let container = BoardSearchCell.container()
    private let boardNameLabel = BoardSearchCell.boardNameLabel()
    private let favoriteButton = BoardSearchCell.favoriteIconView()

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

    func config(boardName: String, isFavorite: Bool) {
        boardNameLabel.text = boardName
        setFavoriteButton(isFavorite: isFavorite)
    }
}

extension BoardSearchCell {
    private func setUpSubViews() {
        selectionStyle = .none
        setUpContainer()
        setUpBoardNameLabel()
#if DEVELOP // Disable adding and removing favorite, for now
        setUpFavoriteButton()
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

    private func setUpFavoriteButton() {
        container.addSubview(favoriteButton)
        [
            favoriteButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15.5),
            favoriteButton.leadingAnchor.constraint(equalTo: boardNameLabel.trailingAnchor, constant: 8)
        ].active()
    }

    private func setFavoriteButton(isFavorite: Bool) {
        let color = isFavorite ? PttColors.dandelion : PttColors.slateGrey
        favoriteButton.tintColor = color.color
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

    private static func favoriteIconView() -> UIImageView {
        let image = UIImage(systemName: "heart.fill")
        let view = UIImageView(image: image)
        return view
    }
}
