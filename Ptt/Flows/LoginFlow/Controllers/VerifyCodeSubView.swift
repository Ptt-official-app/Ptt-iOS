//  swiftlint:disable:this file_name
//  VerifyCodeSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/21.
//  Copyright © 2022 Ptt. All rights reserved.
//

import UIKit

extension LoginViewController {

    func initVerifyCodeViews() {
        var constraints = [NSLayoutConstraint]()

        let horiLine1 = UIView()
        horiLine1.ptt_add(subviews: [lbVerifyCodeResponse, lbVerifyCodeTimer])
        let viewsDict1 = ["lbVerifyCodeResponse": lbVerifyCodeResponse, "lbVerifyCodeTimer": lbVerifyCodeTimer]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[lbVerifyCodeResponse]-[lbVerifyCodeTimer]|", metrics: nil, views: viewsDict1)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[lbVerifyCodeResponse(44)]", metrics: nil, views: viewsDict1)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[lbVerifyCodeTimer(44)]", metrics: nil, views: viewsDict1)

        let horiLine2 = UIView()
        horiLine2.ptt_add(subviews: [btnVerifyCodeBack, btnVerifyCodeNotReceive])
        let viewsDict2 = ["btnVerifyCodeBack": btnVerifyCodeBack, "btnVerifyCodeNotReceive": btnVerifyCodeNotReceive]
        let metrics = ["halfW": global_width / 2]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[btnVerifyCodeBack(halfW)][btnVerifyCodeNotReceive(halfW)]|", metrics: metrics, views: viewsDict2)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[btnVerifyCodeBack(30)]", metrics: nil, views: viewsDict2)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[btnVerifyCodeNotReceive(30)]", metrics: nil, views: viewsDict2)

        let viewsDict = ["lbVerifyCodeTitle": lbVerifyCodeTitle, "tfVerifyCode": tfVerifyCode, "horiLine1": horiLine1, "horiLine2": horiLine2]
        let views = [lbVerifyCodeTitle, tfVerifyCode, horiLine1, horiLine2]
        switchContentView.ptt_add(subviews: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbVerifyCodeTitle(66)]-(20)-[tfVerifyCode(30)]-[horiLine1(44)]-(32)-[horiLine2(30)]", metrics: nil, views: viewsDict)
        for view in views {
            constraints.append(view.leadingAnchor.constraint(equalTo: switchContentView.leadingAnchor))
            constraints.append(view.trailingAnchor.constraint(equalTo: switchContentView.trailingAnchor))
        }

        NSLayoutConstraint.activate(constraints)
    }

    func toggleVerifyCodeView(isHidden: Bool) {
        lbVerifyCodeTitle.isHidden = isHidden
        tfVerifyCode.isHidden = isHidden
        lbVerifyCodeResponse.isHidden = isHidden
        lbVerifyCodeTimer.isHidden = isHidden
        btnVerifyCodeBack.isHidden = isHidden
        btnVerifyCodeNotReceive.isHidden = isHidden
    }

    func onVerifyCodeFill() {
        let tf = tfVerifyCode
        tf.isEnabled = false
        if let user = self.tfRegisterUsername.text,
           let email = self.tfRegisterUsername.text,
           let password = self.tfRegisterUsername.text,
           let token = self.tfVerifyCode.text {
            APIClient.shared.register(account: user, email: email, password: password, token: token) { result in
                DispatchQueue.main.async(execute: {
                    tf.isEnabled = true
                    self.tfVerifyCode.text = ""

                    switch result {
                    case .failure(let error):
                        self.lbVerifyCodeResponse.text = error.message
                    case .success(let result):
                        print(result)
                        self.onRegisterSuccess(result: result)
                        self.toggleState(.fillInformation)
                    }
                })
            }
        } else {
            showAlert(title: L10n.error, msg: "ERROR data missing-_- ")
        }
    }

    func onRegisterSuccess(result: APIModel.Register) {

    }

    @objc
    func onVerifyCodeBack() {
        print("onVerifyCodeBack")
        toggleState(.attemptRegister)
    }

    @objc
    func onNotReceive() {
        print("not Receive")
        showAlert(title: L10n.error, msg: "NOT IMPLEMENT YET QQ")
    }

    func getlbVerifyCodeTitle() -> UILabel {
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

        let title = "驗證碼已經發送到你的信箱，請在五分鐘內輸入驗證碼 (註: 打到6個字時 會自動觸發)"
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        return label
    }

    func gettfVerifyCode() -> LoginTextField {
        let tf = LoginTextField(type: TextFieldType.username)
        tf.title = L10n.verifyCode
        tf.keyboardType = .numberPad
        tf.textContentType = .oneTimeCode
        tf.delegate = self
        tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        return tf
    }

    func getlbVerifyCodeResponse() -> UILabel {
        let label = UILabel()
        label.textColor = PttColors.tangerine.color
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }

    func getlbVerifyCodeTimer() -> UILabel {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.paragraphSpacing = 2
        paragraphStyle.lineSpacing = 0
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1),
            NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        let title = "00:00"
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        return label
    }

    func getbtnVerifyCodeBack() -> LoginButton {
        let button = LoginButton(type: .secondary)
        button.title = L10n.backToRegister

        button.addTarget(self, action: #selector(onVerifyCodeBack), for: .touchUpInside)

        return button
    }

    func getbtnVerifyCodeNotReceive() -> UIButton {
        let button = UIButton()
        let title = L10n.notReceiveYet

        let attr = [
            NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] as [NSAttributedString.Key: Any]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attr), for: UIControl.State.normal)

        button.addTarget(self, action: #selector(onNotReceive), for: .touchUpInside)

        return button
    }
}
