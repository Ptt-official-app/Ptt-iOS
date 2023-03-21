//
//  ButtonNode.swift
//  Ptt
//
//  Created by Denken Chen on 2021/12/22.
//  Copyright © 2021 Ptt. All rights reserved.
//

import AsyncDisplayKit

enum ButtonNodeType {
    case primary, secondary
}

final class ButtonNode: ASButtonNode {

    var type: ButtonNodeType
    var title: String? {
        didSet {
            guard let title = title else { return }
            setTitle(
                title,
                with: .preferredFont(forTextStyle: .caption1),
                with: PttColors.codGray.color,
                for: .normal
            )
            setTitle(
                title,
                with: .preferredFont(forTextStyle: .caption1),
                with: tintColor,
                for: .disabled
            )
        }
    }

    init(type: ButtonNodeType) {
        self.type = type
        super.init()

        switch type {
        case .primary:
            tintColor = PttColors.tangerine.color
        case .secondary:
            tintColor = PttColors.slateGrey.color
        }
        setBackgroundImage(UIImage.backgroundImg(from: tintColor), for: .normal)
        setBackgroundImage(UIImage.backgroundImg(from: .clear), for: .disabled)
        borderColor = tintColor.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        layer.masksToBounds = true
        isEnabled = true
    }
}
