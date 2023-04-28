//  swiftlint:disable:this file_name
//  RegisterSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2021/12/15.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

extension LoginViewController {

    func initRegisterViews() {
        let viewsDict = ["tfRegisterEmail": tfRegisterEmail, "tfRegisterUsername": tfRegisterUsername, "tfRegisterPassword": tfRegisterPassword, "btnAttemptRegister": btnAttemptRegister, "btnRegisterUserAgreement": btnRegisterUserAgreement]
        let registerViews = [tfRegisterEmail, tfRegisterUsername, tfRegisterPassword, btnAttemptRegister, btnRegisterUserAgreement]
        switchContentView.ptt_add(subviews: registerViews)
        let metrics = ["h": 30]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[tfRegisterEmail(h)]-(h)-[tfRegisterUsername(h)]-(h)-[tfRegisterPassword(h)]-(h)-[btnAttemptRegister(h)]-(h)-[btnRegisterUserAgreement(h)]|", metrics: metrics, views: viewsDict)
        for view in registerViews {
            constraints += [
                view.leadingAnchor.constraint(equalTo: switchContentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: switchContentView.trailingAnchor)
            ]
        }
        NSLayoutConstraint.activate(constraints)
    }

    func toggleRegisterView(isHidden: Bool) {
        tfRegisterEmail.isHidden = isHidden
        tfRegisterUsername.isHidden = isHidden
        tfRegisterPassword.isHidden = isHidden
        btnAttemptRegister.isHidden = isHidden
        btnRegisterUserAgreement.isHidden = isHidden
    }

    @objc
    func btnAttemptRegisterPress() {
        print("btnAttemptRegisterPress")

        if let email = tfRegisterEmail.text,
           let username = tfRegisterUsername.text,
           let password = tfRegisterPassword.text {

            print("text is filled")
            if email.isEmpty || username.isEmpty || password.isEmpty {
                print("anyone is empty:", email, username, password)
                // any one is empty
                if email.isEmpty {
                    tfRegisterEmail.warning(msg: L10n.pleaseFillEmail)
                }
                if username.isEmpty {
                    tfRegisterUsername.warning(msg: L10n.pleaseFillUsername)
                }
                if password.isEmpty {
                    tfRegisterPassword.warning(msg: L10n.pleaseFillPassword)
                }
            } else {
                // todo: add email format check
                btnAttemptRegister.isEnabled = false
                APIClient.shared.attemptRegister(account: username, email: email) {result in
                    DispatchQueue.main.async(execute: {
                        self.btnAttemptRegister.isEnabled = true
                        switch result {
                        case .failure(let error):
                            print(result, error)
                            self.showAlert(title: L10n.error, msg: L10n.login + L10n.error + error.message)

                        case .success(let result):

                            print(result.user_id)
                            // get user id: Attempt Register Success
                            // wait for email notification
                            // this account can be register
                            self.toggleState(UILoginState.verifyCode)
                        }
                    })
                }

            }
        } else {
            btnAttemptRegister.isSelected = false
            print("set att reg = is false", btnAttemptRegister.isSelected)
        }
    }

    @objc
    func __loginPress() {
        self.hideKeyboard()
        var account = ""
        var passwd = ""

        if let tfText = self.tfUsername.text {
            account = tfText
        }
        if let tfText = self.tfPassword.text {
            passwd = tfText
        }

        self.btnLogin.isEnabled = false
        APIClient.shared.login(account: account, password: passwd) { result in
            DispatchQueue.main.async(execute: {
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

    func onAttmeptRegisterSuccess(token: String) {
    }

    func gettfRegisterEmail() -> LoginTextField {
        let tf = LoginTextField(type: TextFieldType.email)
        tf.title = L10n.email
        tf.returnKeyType = .next
        tf.delegate = self
        tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        return tf
    }

    func gettfRegisterUsername() -> LoginTextField {
        let tf = LoginTextField(type: TextFieldType.username)
        tf.title = L10n.username
        tf.returnKeyType = .next
        tf.delegate = self
        tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        return tf
    }

    func gettfRegisterPassword() -> LoginTextField {
        let tf = LoginTextField(type: TextFieldType.password)
        tf.title = L10n.password
        tf.returnKeyType = .send
        tf.delegate = self
        tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        return tf
    }

    func getbtnAttemptRegister() -> LoginButton {
        let button = LoginButton(type: .primary)
        let title = L10n.next

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

        button.addTarget(
            self,
            action: #selector(self.btnAttemptRegisterPress),
            for: .touchUpInside
        )

        return button
    }

    func getbtnRegisterUserAgreement() -> UIButton {
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

}
