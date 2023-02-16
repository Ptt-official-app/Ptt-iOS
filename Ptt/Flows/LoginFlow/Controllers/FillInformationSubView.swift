//
//  FillInformationSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/23.
//  Copyright © 2022 Ptt. All rights reserved.
//
import AsyncDisplayKit
import Foundation
import UIKit

extension LoginViewController {

    func initFillInformationViews() {
        lbFillTitle.style.preferredSize = CGSize(width: global_width, height: 55)

        tfFillRealName.style.preferredSize = CGSize(width: global_width / 2, height: 30)
        tfFillBirthday.style.preferredSize = CGSize(width: global_width / 2, height: 30)
        tfFillAddress.style.preferredSize = CGSize(width: global_width, height: 30)

        lbNeedReason.style.preferredSize = CGSize(width: global_width / 2, height: 30)
        btnOpenAccount.style.preferredSize = CGSize(width: global_width / 2, height: 30)

        let horiLine1 = ASStackLayoutSpec(direction: .horizontal,
                                                                  spacing: 0,
                                                                  justifyContent: .center,
                                                                  alignItems: .center,
                                                                  children: [tfFillRealName, tfFillBirthday])
        let addressInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0), child: tfFillAddress)

        let horiLine2 = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [lbNeedReason, btnOpenAccount])

        let vertLine = ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [lbFillTitle, horiLine1,
                                                              addressInset, horiLine2])

        fillInformationStackSpec = ASCenterLayoutSpec(centeringOptions: ASCenterLayoutSpecCenteringOptions.X, sizingOptions: ASCenterLayoutSpecSizingOptions.minimumY, child: vertLine)

        self.node.addSubnode(lbFillTitle)
        self.node.addSubnode(tfFillRealName)
        self.node.addSubnode(tfFillBirthday)
        self.node.addSubnode(tfFillAddress)
        self.node.addSubnode(lbNeedReason)
        self.node.addSubnode(btnOpenAccount)
    }

    @objc func openAccountPress() {
        print("open account press")
        showAlert(title: "施工中", msg: "測試中未完成，但你剛剛的帳號可以登入了，請試試看")
        (tfUsername.view as! LoginTextField).text = (tfRegisterUsername.view as! LoginTextField).text
        (tfPassword.view as! LoginTextField).text = (tfRegisterPassword.view as! LoginTextField).text
        toggleState(UILoginState.Login)
        textFieldDidChange(textField: tfUsername.view as! UITextField)
    }

    func toggleFillInformationView(isHidden: Bool) {
        lbFillTitle.isHidden = isHidden
        tfFillRealName.isHidden = isHidden
        tfFillBirthday.isHidden = isHidden
        tfFillAddress.isHidden = isHidden
        lbNeedReason.isHidden = isHidden
        btnOpenAccount.isHidden = isHidden
    }

    func getlbFillTitle() -> ASTextNode {
        let label = ASTextNode()
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

    func gettfFillRealName() -> ASDisplayNode {
        return ASDisplayNode { () -> UIView in
            let tf = LoginTextField(type: TextFieldType.Username)
            tf.title = L10n.realName

            tf.delegate = self
            tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
            return tf
        }
    }

    func gettfFillBirthday() -> ASDisplayNode {
        return ASDisplayNode { () -> UIView in
            let tf = LoginTextField(type: TextFieldType.Username)
            tf.title = L10n.birthday
            tf.delegate = self
            tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
            return tf
        }
    }

    func gettfFillAddress() -> ASDisplayNode {
        return ASDisplayNode { () -> UIView in
            let tf = LoginTextField(type: TextFieldType.Username)
            tf.title = L10n.address

            tf.delegate = self
            tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
            return tf
        }
    }

    func getlbNeedReason() -> ASButtonNode {
        let button = ASButtonNode()
        let title = L10n.whyNeedPersonalInfo

        button.contentHorizontalAlignment = .left
        let attr = [
            NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] as [NSAttributedString.Key: Any]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attr), for: UIControl.State.normal)

        button.addTarget(self, action: #selector(onNotReceive), forControlEvents: ASControlNodeEvent.touchUpInside)

        return button
    }

    func getbtnOpenAccount() -> ASButtonNode {
        let button = ButtonNode(type: .primary)
        let title = L10n.openAccount

        let attr = [
            NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] as [NSAttributedString.Key: Any]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attr), for: UIControl.State.normal)

        button.addTarget(self, action: #selector(openAccountPress), forControlEvents: ASControlNodeEvent.touchUpInside)

        return button
    }

}
