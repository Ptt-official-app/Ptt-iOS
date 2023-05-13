//
//  TextFieldNode.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/15.
//  Copyright © 2022 Ptt. All rights reserved.
//

import UIKit

enum TextFieldType {
    case username, password, email
}

class LoginTextField: UITextField {

    var type: TextFieldType = .username
    lazy var lbResponse = responseLabel()
    var btnTogglePassword: UIButton?

    var title: String? {
        didSet {
            guard let title = title else { return }

            let attr: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
            ]
            self.attributedPlaceholder = NSAttributedString(string: title, attributes: attr)
        }
    }

    var textPadding = UIEdgeInsets(
        top: 0,
        left: 20,
        bottom: 0,
        right: 20
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        _init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }

    init(type: TextFieldType) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.type = type
        _init()
    }

    func _init() {
        ptt_add(subviews: [lbResponse])
        var constraints = [NSLayoutConstraint]()
        constraints.append(lbResponse.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        if type == .password {
            constraints.append(lbResponse.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16 * 2))
        } else {
            constraints.append(lbResponse.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16))
        }
        NSLayoutConstraint.activate(constraints)

        self.keyboardType = .asciiCapable
        switch type {
        case .username:
            break
        case .password:
            self.isSecureTextEntry = true
            self.rightViewMode = .always
            self.btnTogglePassword = getButton()
            self.rightView = self.btnTogglePassword
        case .email:
            keyboardType = .emailAddress
        }

        self.background = UIImage.backgroundImg(from: PttColors.shark.color)

        self.layer.cornerRadius = 15
        self.layer.borderColor = PttColors.tangerine.color.cgColor
        self.clipsToBounds = true
        self.textColor = PttColors.paleGrey.color

        self.autocapitalizationType = .none
        self.autocorrectionType = .no
    }

    func warning(msg: String?) {
        if let m = msg {
            lbResponse.text = m
            self.layer.borderWidth = 1
        } else {
            lbResponse.text = ""
            self.layer.borderWidth = 0
        }
        lbResponse.sizeToFit()
    }

    @objc
    func togglePassword() {
        print("toggle in ui event")
        if let btn = self.btnTogglePassword {
            btn.isSelected = !btn.isSelected
        }
        // self.btnTooglePassword?.isSelected = !self.btnTooglePassword?.isSelected

        self.isSecureTextEntry = !self.isSecureTextEntry
    }

    func getButton() -> UIButton {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        if #available(iOS 12.0, *) {
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }
        btn.setImage(StyleKit.imageOfPasswdVisibilitySelected(), for: UIControl.State.selected)
        btn.setImage(StyleKit.imageOfPasswdVisibility(), for: UIControl.State.normal)

        btn.addTarget(self, action: #selector(self.togglePassword), for: UIControl.Event.touchDown)
        return btn
    }

    func responseLabel() -> UILabel {
        let label = UILabel()
        label.textColor = PttColors.tangerine.color
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
        label.textAlignment = .right
        label.isUserInteractionEnabled = false
        return label
    }
}
