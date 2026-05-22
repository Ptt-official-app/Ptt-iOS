//
//  BoardsTableViewCell.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/20.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

final class BoardsTableViewCell: UITableViewCell {
    private let boardNameLabel = BoardsTableViewCell.boardNameLabel()
    private let titleLabel = BoardsTableViewCell.titleLabel()
    private let userNumberView = UserNumberView(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(boardName: String, title: String, numberOfUsers: Int) {
        boardNameLabel.text = boardName
        titleLabel.text = title
        userNumberView.set(number: numberOfUsers)
    }
}

extension BoardsTableViewCell {
    private func setUpSubViews() {
        backgroundColor = .clear
        contentView.addSubview(boardNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(userNumberView)
        let margins = contentView.layoutMarginsGuide
        [
            boardNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            boardNameLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            boardNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: userNumberView.leadingAnchor, constant: -8),
            boardNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),

            titleLabel.topAnchor.constraint(equalTo: boardNameLabel.bottomAnchor, constant: 9),
            titleLabel.leadingAnchor.constraint(equalTo: boardNameLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            userNumberView.centerYAnchor.constraint(equalTo: boardNameLabel.centerYAnchor),
            userNumberView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ].active()
    }
}

extension BoardsTableViewCell {
    private static func boardNameLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = PttColors.paleGrey.color
        label.font = .systemFont(ofSize: 19)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }

    private static func titleLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = PttColors.blueGrey.color
        label.font = .systemFont(ofSize: 12)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }
}
