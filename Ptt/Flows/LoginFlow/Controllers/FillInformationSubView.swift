//
//  FillInformationSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/23.
//  Copyright © 2022 Ptt. All rights reserved.
//

import UIKit

extension LoginViewController {

    func initFillInformationViews() {
        var constraints = [NSLayoutConstraint]()

        let horiLine1 = UIView()
        horiLine1.ptt_add(subviews: [tfFillRealName, tfFillBirthday])
        let spacing1: CGFloat = 10
        let metrics1 = ["w": global_width / 2 - spacing1, "s": spacing1]
        let viewsDict1 = ["tfFillRealName": tfFillRealName, "tfFillBirthday": tfFillBirthday]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[tfFillRealName(w)]-(>=s)-[tfFillBirthday(w)]|", metrics: metrics1, views: viewsDict1)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[tfFillRealName(30)]", metrics: nil, views: viewsDict1)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[tfFillBirthday(30)]", metrics: nil, views: viewsDict1)

        let horiLine2 = UIView()
        horiLine2.ptt_add(subviews: [lbNeedReason, btnOpenAccount])
        let metrics2 = ["w": global_width / 2]
        let viewsDict2 = ["lbNeedReason": lbNeedReason, "btnOpenAccount": btnOpenAccount]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[lbNeedReason(w)][btnOpenAccount(w)]|", metrics: metrics2, views: viewsDict2)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[lbNeedReason(30)]", metrics: nil, views: viewsDict2)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[btnOpenAccount(30)]", metrics: nil, views: viewsDict2)

        let viewsDict = ["lbFillTitle": lbFillTitle, "horiLine1": horiLine1, "tfFillAddress": tfFillAddress, "horiLine2": horiLine2]
        let views = [lbFillTitle, horiLine1, tfFillAddress, horiLine2]
        switchContentView.ptt_add(subviews: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbFillTitle(55)]-(30)-[horiLine1(30)]-(30)-[tfFillAddress(30)]-(30)-[horiLine2(30)]", metrics: nil, views: viewsDict)
        for view in views {
            constraints.append(view.leadingAnchor.constraint(equalTo: switchContentView.leadingAnchor))
            constraints.append(view.trailingAnchor.constraint(equalTo: switchContentView.trailingAnchor))
        }
        NSLayoutConstraint.activate(constraints)
    }

    @objc
    func openAccountPress() {
        print("open account press")
        showAlert(title: "施工中", msg: "測試中未完成，但你剛剛的帳號可以登入了，請試試看")
        tfUsername.text = tfRegisterUsername.text
        tfPassword.text = tfRegisterPassword.text
        toggleState(UILoginState.login)
        textFieldDidChange(textField: tfUsername)
    }

    func toggleFillInformationView(isHidden: Bool) {
        lbFillTitle.isHidden = isHidden
        tfFillRealName.isHidden = isHidden
        tfFillBirthday.isHidden = isHidden
        tfFillAddress.isHidden = isHidden
        lbNeedReason.isHidden = isHidden
        btnOpenAccount.isHidden = isHidden
    }

    func getlbFillTitle() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.paragraphSpacing = 2
        paragraphStyle.lineSpacing = 0
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline),
            NSAttributedString.Key.foregroundColor: self.text_color,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        let title = "帳號設定成功！\n請完成以下資訊以開通帳號："
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        return label
    }

    func gettfFillRealName() -> LoginTextField {
        let tf = LoginTextField(type: TextFieldType.username)
        tf.title = L10n.realName
        tf.delegate = self
        tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        return tf
    }

    func gettfFillBirthday() -> LoginTextField {
        let tf = LoginTextField(type: TextFieldType.username)
        tf.title = L10n.birthday
        tf.keyboardType = .numberPad
        tf.delegate = self
        tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        return tf
    }

    func gettfFillAddress() -> LoginTextField {
        let tf = LoginTextField(type: TextFieldType.username)
        tf.title = L10n.address
        tf.delegate = self
        tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        return tf
    }

    func getlbNeedReason() -> UIButton {
        let button = UIButton()
        let title = L10n.whyNeedPersonalInfo

        button.contentHorizontalAlignment = .left
        let attr = [
            NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] as [NSAttributedString.Key: Any]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attr), for: UIControl.State.normal)

        button.addTarget(self, action: #selector(onNotReceive), for: .touchUpInside)

        return button
    }

    func getbtnOpenAccount() -> LoginButton {
        let button = LoginButton(type: .primary)
        let title = L10n.openAccount

        let attr = [
            NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] as [NSAttributedString.Key: Any]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attr), for: UIControl.State.normal)

        button.addTarget(self, action: #selector(openAccountPress), for: .touchUpInside)

        return button
    }

}
