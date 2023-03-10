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
        setUpBoardName()
        setUpTitleLabel()
        setUpUserNumberView()
    }

    private func setUpBoardName() {
        contentView.addSubview(boardNameLabel)
        [
            boardNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            boardNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 23),
            boardNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            boardNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ].active()
    }

    private func setUpTitleLabel() {
        contentView.addSubview(titleLabel)
        [
            titleLabel.topAnchor.constraint(equalTo: boardNameLabel.bottomAnchor, constant: 9),
            titleLabel.leadingAnchor.constraint(equalTo: boardNameLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: boardNameLabel.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ].active()
    }

    private func setUpUserNumberView() {
        addSubview(userNumberView)
        [
            userNumberView.centerYAnchor.constraint(equalTo: boardNameLabel.centerYAnchor),
            userNumberView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23)
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
