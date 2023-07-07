//  swiftlint:disable:this file_name
//  LoginSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/9.
//  Copyright © 2022 Ptt. All rights reserved.
//

import UIKit

extension LoginViewController {

    func initLoginViews() {
        let viewsDict = ["tfUsername": tfUsername, "tfPassword": tfPassword, "btnLogin": btnLogin, "btnUserAgreement": btnUserAgreement, "vLine": vLine, "btnForget": btnForget]
        let loginViews = [tfUsername, tfPassword, btnLogin, btnUserAgreement, vLine, btnForget]
        switchContentView.ptt_add(subviews: loginViews)
        let metrics = ["h": 30]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tfUsername(h)]-(30)-[tfPassword(h)]-(35)-[btnLogin(h)]-(25)-[btnUserAgreement(h)]-(50)-[vLine(0.5)]-(25)-[btnForget(h)]", metrics: metrics, views: viewsDict)
        for view in loginViews {
            constraints += [
                view.leadingAnchor.constraint(equalTo: switchContentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: switchContentView.trailingAnchor)
            ]
        }
        NSLayoutConstraint.activate(constraints)

#if DEVELOP // Disable btnUserAgreement and btnForget, for now
#else
        btnUserAgreement.isHidden = true
        vLine.isHidden = true
        btnForget.isHidden = true
#endif
    }

    func toggleLoginView(isHidden: Bool) {
        tfUsername.isHidden = isHidden
        tfPassword.isHidden = isHidden

        btnLogin.isHidden = isHidden
        btnForget.isHidden = isHidden
        tfUsername.isHidden = isHidden
        tfPassword.isHidden = isHidden
        btnUserAgreement.isHidden = isHidden
        btnForget.isHidden = isHidden
        vLine.isHidden = isHidden
    }

    @objc
    func forgetPress() {
        print("forget press")
        showAlert(title: "XD", msg: "NOT IMPLEMENT YET -_-")
        // toggleState(UILoginState.FillInformation)
    }

    func gettfUsername() -> LoginTextField {
        let textField: LoginTextField = LoginTextField(type: .username)
        textField.title = L10n.username
        textField.delegate = self
        textField.returnKeyType = .next
        textField.keyboardType = .asciiCapable
        textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        return textField
    }

    func gettfPassword() -> LoginTextField {
        let textField: LoginTextField = LoginTextField(type: .password)
        textField.title = L10n.password
        textField.isSecureTextEntry = true
        textField.returnKeyType = .send
        textField.delegate = self
        textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        return textField
    }

    func getbtnUserAgreement() -> UIButton {
        let button = UIButton()
        let title = L10n.agreeWhenYouUseApp

        let attr = [
            NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] as [NSAttributedString.Key: Any]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attr), for: UIControl.State.normal)

        button.addTarget(
            self,
            action: #selector(userAgreementPress),
            for: .touchUpInside
        )

        return button
    }

    func getbtnLogin() -> LoginButton {
        let button = LoginButton(type: .primary)
        let title = L10n.login

        let attr_tint: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: PttColors.shark.color,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1
                                                             )
        ]

        button.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        button.setTitle(title, for: .normal)
        button.setTitleColor(PttColors.tangerine.color, for: .normal)
        button.setBackgroundImage(UIImage.backgroundImg(from: .clear), for: UIControl.State.normal)

        button.setBackgroundImage(UIImage.backgroundImg(from: PttColors.tangerine.color), for: UIControl.State.selected)
        button.setAttributedTitle(
            NSAttributedString(string: title, attributes: attr_tint),
            for: UIControl.State.selected
        )

        // override the disable state
        button.setBackgroundImage(UIImage.backgroundImg(from: PttColors.tangerine.color), for: UIControl.State.disabled)
        button.setAttributedTitle(
            NSAttributedString(string: title, attributes: attr_tint),
            for: UIControl.State.disabled
        )

        button.addTarget(self, action: #selector(loginPress), for: .touchUpInside)

        return button
    }

    func getbtnForget() -> LoginButton {
        let button = LoginButton(type: .secondary)
        button.title = L10n.forget
        button.addTarget(self, action: #selector(forgetPress), for: .touchUpInside)

        return button
    }

    @objc
    func loginPress() {
        print("login press")
        view.endEditing(true)
        var account = ""
        var passwd = ""

        if let tfText = self.tfUsername.text {
            account = tfText
        }
        if let tfText = self.tfPassword.text {
            passwd = tfText
        }

        // block by btnLogin.isEnabled
        // todo: fix
        if account.isEmpty {
            self.tfUsername.warning(msg: L10n.notFinish)
            return
        }

        if passwd.isEmpty {
            self.tfPassword.warning(msg: L10n.notFinish)
            return
        }

        self.btnLogin.isEnabled = false
        APIClient.shared.login(account: account, password: passwd) { result in
            DispatchQueue.main.async(execute: {
                self.btnLogin.isEnabled = true
                print("login using", account, " result", result)
                switch result {
                case .failure(let error):
                    print(error)
                    self.showAlert(title: L10n.error, msg: L10n.login + L10n.error + error.message)
                case .success(let token):
                    print(token.access_token)
                    KeyChainItem.shared.save(object: token, for: .loginToken)
                    self.onLoginSuccess(token: token.access_token)
                }
            })
        }
    }
}
