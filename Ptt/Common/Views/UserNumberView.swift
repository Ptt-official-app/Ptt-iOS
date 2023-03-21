//
//  UserNumberView.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/10.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

final class UserNumberView: UIView {
    private let iconView: UIImageView = UserNumberView.icon()
    private let numberLabel: UILabel = UserNumberView.numberLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpSubViews()
    }

    func set(number: Int) {
        numberLabel.text = "\(number.easyRead)"
        iconView.isHidden = false
        switch number {
        case 1...1999:
            iconView.tintColor = .white
        case 2000...4999:
            iconView.tintColor = PttColors.coral.color
        case 5000...9999:
            iconView.tintColor = PttColors.darkPeriwinkle.color
        case 10000...29999:
            iconView.tintColor = PttColors.robinSEgg.color
        case 30000...59999:
            iconView.tintColor = PttColors.darkMint.color
        case 6000...99999:
            iconView.tintColor = PttColors.dandelion.color
        case 100000...Int.max:
            iconView.tintColor = PttColors.brightLilac.color
        default:
            iconView.isHidden = true
        }
    }
}

extension UserNumberView {
    private func setUpSubViews() {
        addSubview(iconView)
        [
            iconView.heightAnchor.constraint(equalToConstant: 14),
            iconView.widthAnchor.constraint(equalToConstant: 14),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ].active()

        addSubview(numberLabel)
        [
            numberLabel.topAnchor.constraint(equalTo: topAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 3),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ].active()
    }
}

extension UserNumberView {
    private static func icon() -> UIImageView {
        let image = StyleKit.imageOfProfile()
        let view = UIImageView(image: image)
        return view
    }

    private static func numberLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = PttColors.paleGrey.color
        label.font = .systemFont(ofSize: 12)
        return label
    }
}
