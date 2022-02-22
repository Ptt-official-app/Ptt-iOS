//
//  RegisterSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2021/12/15.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

extension LoginViewController {
    
    
    func initRegisterViews() {
        
        let registerEmailInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0), child: tfRegisterEmail)
        let registerUsernameInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0), child: tfRegisterUsername)
        let registerPasswordInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0), child: tfRegisterPassword)
        
        
        let btnAttemptRegisterInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0), child: btnAttemptRegister)
        
        let btnRegisterUserAgreementInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0), child: btnRegisterUserAgreement)
        
        self.registerStackSpec = ASCenterLayoutSpec(centeringOptions: ASCenterLayoutSpecCenteringOptions.X, sizingOptions: ASCenterLayoutSpecSizingOptions.minimumY, child: ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [registerEmailInset, registerUsernameInset, registerPasswordInset,btnAttemptRegisterInset,btnRegisterUserAgreementInset]))
        
        // type register
        tfRegisterEmail.style.preferredSize = CGSize(width: global_width, height: 30)
        tfRegisterUsername.style.preferredSize = CGSize(width: global_width, height: 30)
        tfRegisterPassword.style.preferredSize = CGSize(width: global_width, height: 30)
        btnAttemptRegister.style.preferredSize = CGSize(width: global_width, height: 30)
        btnRegisterUserAgreement.style.preferredSize = CGSize(width: global_width, height: 30)
        self.node.addSubnode(tfRegisterEmail)
        self.node.addSubnode(tfRegisterUsername)
        self.node.addSubnode(tfRegisterPassword)
        self.node.addSubnode(btnAttemptRegister)
        self.node.addSubnode(btnRegisterUserAgreement)
        
    }
    func toggleRegisterView(isHidden:Bool){
        tfRegisterEmail.isHidden = isHidden
        tfRegisterUsername.isHidden = isHidden
        tfRegisterPassword.isHidden = isHidden
        btnAttemptRegister.isHidden = isHidden
        btnRegisterUserAgreement.isHidden = isHidden
    }
    
    @objc func btnAttemptRegisterPress(){
        print("btnAttemptRegisterPress")
        
        if let tfEmail = tfRegisterEmail.view as? LoginTextField,
           let tfUser = tfRegisterUsername.view as? LoginTextField,
           let tfPass = tfRegisterPassword.view as? LoginTextField,
           let email = tfEmail.text,
           let username = tfUser.text,
           let password = tfPass.text {
            
            print("text is filled")
            if email.isEmpty || username.isEmpty || password.isEmpty {
                print("anyone is empty:", email, username, password)
                // any one is empty
                if email.isEmpty {
                    tfEmail.warning(msg: L10n.pleaseFillEmail)
                }
                if username.isEmpty {
                    tfUser.warning(msg: L10n.pleaseFillUsername)
                }
                if password.isEmpty {
                    tfPass.warning(msg: L10n.pleaseFillPassword)
                }
            }
            else {
                // todo: add email format check
                btnAttemptRegister.isEnabled = false
                APIClient.shared.attemptRegister(account: username, email: email) {result in
                    DispatchQueue.main.async {
                        self.btnAttemptRegister.isEnabled = true
                        switch (result) {
                        case .failure(let error):
                            print(result, error)
                            self.showAlert(title: L10n.error, msg: L10n.login + L10n.error + error.message)
                            
                        case .success(let result):
                        
                            print(result.user_id)
                            // get user id: Attempt Register Success
                            // wait for email notification
                            // this account can be register
                            self.toggleState(UILoginState.VerifyCode)
                        }
                    }
                }
                    
            }
        }
        else {
            btnAttemptRegister.isSelected = false
            print("set att reg = is false", btnAttemptRegister.isSelected)
        }
    }
    
    
    @objc func __loginPress() {
        self.hideKeyboard()
        var account = ""
        var passwd = ""
        
        if let tf = self.tfUsername.view as? UITextField, let tfText = tf.text {
            account = tfText
        }
        if let tf = self.tfPassword.view as? UITextField, let tfText = tf.text {
            passwd = tfText
        }
  
        self.btnLogin.isEnabled = false
        APIClient.shared.login(account: account, password: passwd) { (result) in
            DispatchQueue.main.async {
                print("login using", account, " result", result)
                switch (result) {
                case .failure(let error):
                    print(error)
                    self.showAlert(title: L10n.error, msg: L10n.login + L10n.error + error.message)
                case .success(let token):
                    print(token.access_token)
                    self.onLoginSuccess(token: token.access_token)
                }
            }
        }
    }
    
    func onAttmeptRegisterSuccess(token:String) {
    }
    
    func gettfRegisterEmail() -> ASDisplayNode {
        return ASDisplayNode.init { () -> UIView in
            let tf = LoginTextField(type: TextFieldType.Email)
            tf.title = L10n.email
            
            tf.returnKeyType = .next
            tf.delegate = self
            tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
            return tf
        }
    }
    
    func gettfRegisterUsername() -> ASDisplayNode {
        return ASDisplayNode.init { () -> UIView in
            let tf = LoginTextField(type: TextFieldType.Username)
            tf.title = L10n.username
            
            tf.returnKeyType = .next
            tf.delegate = self
            tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
            return tf
        }
    }
    
    func gettfRegisterPassword() -> ASDisplayNode {
        return ASDisplayNode.init { () -> UIView in
            let tf = LoginTextField(type: TextFieldType.Password)
            tf.title = L10n.password
            
            tf.returnKeyType = .send
            
            tf.delegate = self
            tf.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
            return tf
        }
    }
    
    func getbtnAttemptRegister() -> ASButtonNode {
        let button = ButtonNode(type: .primary)
        let title = L10n.next
        
        let attr_tint : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: PttColors.shark.color,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1
            )
        ]
        
        button.setTitle(title, with: .preferredFont(forTextStyle: .caption1),
                 with: PttColors.tangerine.color, for: .normal)
        button.setBackgroundImage(UIImage.backgroundImg(from: .clear), for: UIControl.State.normal)
        
        button.setBackgroundImage(UIImage.backgroundImg(from: PttColors.tangerine.color), for: UIControl.State.selected)
        button.setAttributedTitle(NSAttributedString.init(string: title, attributes: attr_tint), for: UIControl.State.selected)

        // override the disable state
        button.setBackgroundImage(UIImage.backgroundImg(from: PttColors.tangerine.color), for: UIControl.State.disabled)
        button.setAttributedTitle(NSAttributedString.init(string: title, attributes: attr_tint), for: UIControl.State.disabled)
        
        
        button.addTarget(self, action: #selector(self.btnAttemptRegisterPress), forControlEvents: ASControlNodeEvent.touchUpInside)

        return button
    }
    
    func getbtnRegisterUserAgreement() -> ASButtonNode {
        let button = ASButtonNode()
        let title = L10n.agreeWhenYouUseApp
        
        let attr = [
            NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] as [NSAttributedString.Key : Any]
        button.setAttributedTitle(NSAttributedString.init(string: title, attributes: attr), for: UIControl.State.normal)
        
        button.addTarget(self, action: #selector(userAgreementPress), forControlEvents: ASControlNodeEvent.touchUpInside)
        
        return button
    }
    

}
