//
//  LoginButton.swift
//  Ptt
//
//  Created by Denken Chen on 2021/12/22.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

enum LoginButtonType {
    case primary, secondary
}

final class LoginButton: UIButton {

    var type: LoginButtonType
    var title: String? {
        didSet {
            guard let title = title else { return }
            setTitle(title, for: .normal)
        }
    }

    init(type: LoginButtonType) {
        self.type = type
        super.init(frame: CGRect.zero)

        switch type {
        case .primary:
            tintColor = PttColors.tangerine.color
        case .secondary:
            tintColor = PttColors.slateGrey.color
        }
        titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        setTitleColor(PttColors.codGray.color, for: .normal)
        setTitleColor(tintColor, for: .disabled)
        setBackgroundImage(UIImage.backgroundImg(from: tintColor), for: .normal)
        setBackgroundImage(UIImage.backgroundImg(from: .clear), for: .disabled)
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        isEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
