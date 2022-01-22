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
        self.registerNode.addSubnode(tfRegisterEmail)
        self.registerNode.addSubnode(tfRegisterUsername)
        self.registerNode.addSubnode(tfRegisterPassword)
        self.registerNode.addSubnode(btnAttemptRegister)
        self.registerNode.addSubnode(btnRegisterUserAgreement)
        
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
        
        btnAttemptRegister.isEnabled = false
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
                    tfEmail.warning(msg: "請輸mail")
                }
                if username.isEmpty {
                    tfEmail.warning(msg: "請輸user")
                }
                if password.isEmpty {
                    tfEmail.warning(msg: "請輸PW")
                }
            }
            else {
                print("start request")
                // todo: add email format check
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
                            self.toggleState(UILoginState.VerifyCode)
                        }
                        
                        print("@@ account can be use=", type(of: result), result)
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
    
}
