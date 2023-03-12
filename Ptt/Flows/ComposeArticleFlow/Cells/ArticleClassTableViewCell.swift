//
//  ArticleClassTableViewCell.swift
//  Ptt
//
//  Created by marcus fu on 2021/6/25.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

class ArticleClassTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        // Init title label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = titleLabel.font.withSize(18)
        titleLabel.textColor = GlobalAppearance.tintColor
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = UIColor(red: 34 / 255, green: 34 / 255, blue: 36 / 255, alpha: 1.0)
        contentView.addSubview(self.titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Title label constrainst
        NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }

    func configure(index: Int, listLimit: Int, value: String) {
        titleLabel.text = value
        titleLabel.textColor = (listLimit == index) ? UIColor(red: 136 / 255, green: 136 / 255, blue: 148 / 255, alpha: 1.0) : GlobalAppearance.tintColor
    }
}
