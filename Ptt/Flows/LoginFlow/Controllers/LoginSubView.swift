//
//  LoginSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/9.
//  Copyright © 2022 Ptt. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

extension LoginViewController {

    func initLoginViews(){
        // login:
        
        let usernameInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0), child: tfUsername)
        let passwordInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0), child: tfPassword)
        let agreeInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0), child: btnUserAgreement)
        let loginInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0), child: btnLogin)
        
        let forgetInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0), child: btnForget)
        let forgetCenterLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: forgetInset)

        

        // login
        lbTitle.style.preferredSize = CGSize(width: global_width, height: 58+63)
        tfUsername.style.preferredSize = CGSize(width: global_width, height: 30)
        tfPassword.style.preferredSize = CGSize(width: global_width, height: 30)
        btnLogin.style.preferredSize = CGSize(width: global_width, height: 30)
        btnForget.style.preferredSize = CGSize(width: global_width, height: 30)
        btnUserAgreement.style.preferredSize = CGSize(width: global_width, height: 30)
        vLine.style.preferredSize = CGSize(width: CGFloat(global_width), height: 0.5)
        
        self.node.addSubnode(self.tfUsername)
        self.node.addSubnode(self.tfPassword)
        self.node.addSubnode(self.btnForget)
        self.node.addSubnode(self.btnUserAgreement)
        self.node.addSubnode(self.vLine)
        self.node.bounds = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        
        loginStackSpec = ASCenterLayoutSpec(centeringOptions: ASCenterLayoutSpecCenteringOptions.X, sizingOptions: ASCenterLayoutSpecSizingOptions.minimumY, child: ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [usernameInset,
                                                              passwordInset, loginInset, agreeInset,
                                                              vLine, forgetCenterLayout]))
        
    }
    
    
    func toggleLoginView(isHidden:Bool){
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
    
    
    @objc func forgetPress() {
        print("forget press")
        showAlert(title: "XD", msg: "NOT IMPLEMENT YET -_-")
        //toggleState(UILoginState.FillInformation)
    }
    
    func gettfUsername() -> ASDisplayNode {
        return ASDisplayNode.init { () -> UIView in
            let textField:LoginTextField = LoginTextField(type: .Username)
            textField.title = L10n.username
            textField.delegate = self
            textField.returnKeyType = .next
            
            textField.keyboardType = .asciiCapable
            
            textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
            return textField
        }
    }
    
    func gettfPassword() -> ASDisplayNode {
        return ASDisplayNode.init { () -> UIView in
            let textField:LoginTextField = LoginTextField(type: .Password)

            textField.title = L10n.password
            
            textField.isSecureTextEntry = true
            textField.returnKeyType = .send
            
            textField.delegate = self
            textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
            return textField
        }
    }
    
    func getbtnUserAgreement() -> ASButtonNode {
        let button = ASButtonNode()
        let title = NSLocalizedString("AgreeWhenYouUseApp", comment:"")
        
        let attr = [
            NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] as [NSAttributedString.Key : Any]
        button.setAttributedTitle(NSAttributedString.init(string: title, attributes: attr), for: UIControl.State.normal)
        
        button.addTarget(self, action: #selector(userAgreementPress), forControlEvents: ASControlNodeEvent.touchUpInside)
        
        return button
    }
    
    
    func getbtnLogin() -> ASButtonNode {
        let button = ButtonNode(type: .primary)
        let title = L10n.login
        
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
        
        button.addTarget(self, action: #selector(loginPress), forControlEvents: ASControlNodeEvent.touchUpInside)

        
        return button
    }
    
    func getbtnForget() -> ASButtonNode {
        let button = ButtonNode(type: .secondary)
        button.title = L10n.forget
        button.addTarget(self, action: #selector(forgetPress), forControlEvents: ASControlNodeEvent.touchUpInside)
        
        return button
    }
    
    
    @objc func loginPress() {
        print("login press")
        self.hideKeyboard()
        var account = ""
        var passwd = ""
        
        if let tf = self.tfUsername.view as? UITextField, let tfText = tf.text {
            account = tfText
        }
        if let tf = self.tfPassword.view as? UITextField, let tfText = tf.text {
            passwd = tfText
        }
  
        // block by btnLogin.isEnabled
        // todo: fix
        if ( account.isEmpty ) {
            if let tf = self.tfUsername.view as? LoginTextField {
                tf.warning(msg: L10n.notFinish)
            }
            return
        }

        if (passwd.isEmpty ){
            if let tf = self.tfPassword.view as? LoginTextField {
                tf.warning(msg: L10n.notFinish)
            }
            return
        }
        
        self.btnLogin.isEnabled = false
        APIClient.shared.login(account: account, password: passwd) { (result) in
            self.btnLogin.isEnabled = true ;
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
}
