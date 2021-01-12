//
//  LoginViewController.swift
//  Ptt
//
//  Created by You Gang Kuo on 2020/12/8.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

protocol LoginView: BaseView {}


final class LoginViewController: ASDKViewController<ASDisplayNode>, LoginView{
    
    //private let apiClient: APIClientProtocol = nil

    private let rootNode = ASDisplayNode()
    var scrollNode = ASScrollNode()

    var loginKeyChain:LoginKeyChainItem
    var contentStackSpec:ASStackLayoutSpec?
    var contentCenterLayoutSpec:ASCenterLayoutSpec?

    // var finishFlow
    
    func init_layout() -> ASLayoutSpec {
        
        let global_width = 265
        let forgetCenterLayout = ASCenterLayoutSpec(centeringOptions: .X, sizingOptions: ASCenterLayoutSpecSizingOptions.minimumY, child: btnForget)
        
        let funcStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 5,
                                                   justifyContent: .start,
                                                   alignItems: .start,
                                                   children: [btnTypeLogin, lbLine, btnTypeRegister])
        
        funcStackSpec.style.preferredSize = CGSize(width: global_width, height: 44+43)
        
        let usernameInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0), child: tfUsername)
        let passwordInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0), child: tfPassword)
        
        let loginInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 31, right: 0), child: btnLogin)
        contentStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [lbTitle, funcStackSpec, usernameInset,
                                                              passwordInset, loginInset, forgetCenterLayout])
        
        lbTitle.style.preferredSize = CGSize(width: global_width, height: 58+63)
        tfUsername.style.preferredSize = CGSize(width: global_width, height: 30)
        tfPassword.style.preferredSize = CGSize(width: global_width, height: 30)
        btnLogin.style.preferredSize = CGSize(width: global_width, height: 30)
        btnForget.style.preferredSize = CGSize(width: 100, height: 30)
        
        
        self.scrollNode.addSubnode(self.lbTitle)
        self.scrollNode.addSubnode(self.tfUsername)
        self.scrollNode.addSubnode(self.tfPassword)
        self.scrollNode.addSubnode(self.btnTypeLogin)
        self.scrollNode.addSubnode(self.btnTypeRegister)
        
        node.addSubnode(self.scrollNode) ;
        
        
        return contentStackSpec!
    }
    
    @objc func hideKeyboard() {
        print("did hide keyboard")
        if let tf = tfPassword.view as? UITextField {
            tf.endEditing(true)
        }
        if let tf = tfUsername.view as? UITextField {
            tf.endEditing(true)
        }
    }
    
    func bind_event(){
        btnTypeLogin.addTarget(self, action: #selector(switchTypeRegister), forControlEvents: ASControlNodeEvent.touchDown)
        btnTypeRegister.addTarget(self, action: #selector(switchTypeRegister), forControlEvents: ASControlNodeEvent.touchDown)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.node.view.addGestureRecognizer(tap)
        
        self.btnLogin.addTarget(self, action: #selector(loginPress), forControlEvents: ASControlNodeEvent.touchDown)
        self.btnForget.addTarget(self, action: #selector(forgetPress), forControlEvents: ASControlNodeEvent.touchDown)
    }
    
    override func viewDidLoad() {
        print("login view did load") ;
        self.bind_event()
    }

    override init() {
        self.loginKeyChain = LoginKeyChainItem(service: "service", group: "group")
        super.init(node: rootNode)
        self.rootNode.backgroundColor = self.blackColor
        
        let stack = self.init_layout()
        
        self.scrollNode.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesContentSize = true
        self.scrollNode.view.showsHorizontalScrollIndicator = false
        self.scrollNode.view.showsVerticalScrollIndicator = false
        
        scrollNode.layoutSpecBlock = { node, constrainedSize in
            return stack
        }
        
        node.layoutSpecBlock = { _, _ in
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: self.scrollNode)
        }
        
        node.automaticallyManagesSubnodes = true
    }

    
    @objc func switchTypeRegister(_ button:ASButtonNode) {
        
        if button == btnTypeRegister {
            btnTypeRegister.isSelected = true
            btnTypeLogin.isSelected = false
        }
        else if button == btnTypeLogin {
            btnTypeRegister.isSelected = false
            btnTypeLogin.isSelected = true
        }
        
        btnLogin.isHidden = btnTypeRegister.isSelected
        btnForget.isHidden = btnTypeRegister.isSelected
        tfUsername.isHidden = btnTypeRegister.isSelected
        tfPassword.isHidden = btnTypeRegister.isSelected
        
        if btnTypeRegister.isSelected {
        }
        else if btnLogin.isSelected {
        }
        
        self.hideKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var btnTypeRegister:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("註冊", comment:"")
        
        let attr: [NSAttributedString.Key : Any] = [
           .foregroundColor: UIColor.white,
           .font: UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        
        button.setTitle(title, with: nil, with: self.paleGrey, for: UIControl.State.selected)
        button.setTitle(title, with: nil, with: self.slateGrey, for: UIControl.State.normal)
        
        button.isSelected = false
        return button
    }()
    
    
    lazy var btnTypeLogin:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("登入", comment:"")

        let attr: [NSAttributedString.Key : Any] = [
            .foregroundColor: self.paleGrey,
           .font: UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        button.setTitle(title, with: nil, with: self.paleGrey, for: UIControl.State.selected)
        button.setTitle(title, with: nil, with: self.slateGrey, for: UIControl.State.normal)

        button.isSelected = true
        
        return button
    }()
    
    var lbLine:ASTextNode =  {
        let label = ASTextNode()
        let attr:[NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        
        var title = NSAttributedString.init(string: "|", attributes: attr)
        label.attributedText = title
        return label
    }()
    
    var lbTitle:ASTextNode =  {
        let label = ASTextNode()
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.alignment = .left
        paragraphStyle.paragraphSpacing = 2
        paragraphStyle.lineSpacing = 0
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        label.attributedText = NSAttributedString.init(string: "批踢踢實業坊\nPtt.cc", attributes: attributes)
        //label.backgroundColor = GlobalAppearance.backgroundColor
        return label
    }()
    
    lazy var tfUsername = ASDisplayNode.init { () -> UIView in
        var textField:TextFieldWithPadding = TextFieldWithPadding()
        textField.background = self.backgroundImg(color: self.textfield_backgroundcolor)
        let title = NSLocalizedString("User Id", comment: "")
        let attr:[NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: self.slateGrey,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
        ]
        textField.attributedPlaceholder = NSAttributedString.init(string: title, attributes:attr)
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        
        textField.delegate = self
        return textField
    }
    
    
    lazy var btnTooglePassword:UIButton = {
        var btn = UIButton()
        btn.frame = CGRect(x:0, y:0, width:44, height:44)
        btn.setImage(StyleKit.imageOfPasswdVisibilitySelected(), for: UIControl.State.selected)
        btn.setImage(StyleKit.imageOfPasswdVisibility(), for: UIControl.State.normal)

        btn.addTarget(self, action: #selector(self.togglePassword), for: UIControl.Event.touchDown)
        return btn
    }()
    
    lazy var tfPassword = ASDisplayNode.init { () -> UIView in
        var textField:TextFieldWithPadding = TextFieldWithPadding()
        
        textField.background = self.backgroundImg(color: self.textfield_backgroundcolor)
        
        let title = NSLocalizedString("Password", comment: "")
        let attr = [
            NSAttributedString.Key.foregroundColor: self.slateGrey,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
        ]
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString.init(string: title, attributes:attr )
        
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true


        
        textField.rightViewMode = .always
        textField.rightView = self.btnTooglePassword
        
        textField.delegate = self
        return textField
    }
    
    class TextFieldWithPadding: UITextField {
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
        
        override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
            var rightRect:CGRect = super.rightViewRect(forBounds: bounds)
            rightRect.origin.x -= 16
            rightRect.origin.y -= 10
            rightRect.size.width += 10
            rightRect.size.height += 20
            return rightRect
        }
    }
    
    func backgroundImg(color:UIColor) -> UIImage {
        let size: CGSize = CGSize(width: 1, height: 1)
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }

    
    
    @objc func togglePassword() {
        self.btnTooglePassword.isSelected = !self.btnTooglePassword.isSelected
        if let tf = tfPassword.view as? UITextField {
            tf.isSecureTextEntry = !tf.isSecureTextEntry
        }
    }
    
    func showAlert(title:String, msg:String) {
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    func isLoginInputOK() -> Bool{
        if let tf = self.tfUsername.view as? UITextField {
            if let t = tf.text {
                if t.count == 0 {
                    showAlert(title: "Warning", msg: "請輸入帳號")
                    return false ;
                }
            }
        }
        if let tf = self.tfPassword.view as? UITextField {
            if let t = tf.text {
                if t.count == 0 {
                    showAlert(title: "Warning", msg: "請輸入密碼")
                    return false ;
                }
            }
        }
        
        return true
    }
    
    @objc func loginPress() {
        print("login press")
        
        if self.isLoginInputOK() {
            
            var account:String = ""
            var passwd:String = ""
            if let tf = self.tfUsername.view as? UITextField {
                account = tf.text!
            }
            if let tf = self.tfPassword.view as? UITextField {
                passwd = tf.text!
            }

            APIClient.shared.login(account: account, password: passwd) { (result) in
                print("login using", account, " result", result)
                switch (result) {
                case .failure(let error):
                    print(error)
                    self.showAlert(title: "Error", msg: "登入失敗")
                case .success(let token):
                    print(token.access_token)
                    self.onLoginSuccess(token: token.access_token)
                }
            }
        }
    }
    
    func onLoginSuccess(token:String) {
        _ = loginKeyChain.saveToken(token)
        // todo: push view
    }
    
    @objc func forgetPress() {
        print("forget press")
    }
    
    lazy var btnLogin:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("Login", comment:"")
        let attr : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: self.textfield_backgroundcolor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
        ]
        button.backgroundColor = self.slateGrey
        button.setAttributedTitle(NSAttributedString.init(string: title, attributes: attr), for: UIControl.State.normal)
        
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        
        return button
    }()

    lazy var btnForget:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("Forget", comment:"")
        let attr = [
            NSAttributedString.Key.foregroundColor: self.slateGrey,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)
        ]
        button.setAttributedTitle(NSAttributedString.init(string: title, attributes: attr), for: UIControl.State.normal)
        return button
    }()
    
    var blackColor : UIColor? {
        if #available(iOS 11.0, *) {
            return UIColor(named: "blackColor-23-23-23")
        } else {
            return UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1.0)
        }
    }
    
    var textfield_backgroundcolor : UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(red: 42/255, green: 42/255, blue: 48/255, alpha: 1.0)
            //return UIColor(named: "tintColor-42-42-48")
        } else {
            return UIColor(red: 42/255, green: 42/255, blue: 48/255, alpha: 1.0)
        }
    }
    
    // todo: add to assets
    var slateGrey:UIColor {
        return UIColor(red: 94/255, green: 94/255, blue: 102/255, alpha: 1.0)
    }
    
    var paleGrey:UIColor {
        return UIColor(red: 240/255, green: 240/255, blue: 247/255, alpha: 1.0)
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        let screenHeight = Int(self.view.bounds.height)
        let keyboardHeight = 253+50 // todo: get keyboard height from addObserver
        let margin_to_keyboard = 10
        let diff = Int(btnLogin.view.frame.origin.y) - (screenHeight-keyboardHeight) + margin_to_keyboard
        
        print("screen height=", UIScreen.main.bounds.height)
        print("btn login pos=", btnLogin.view.frame.origin, btnLogin.view.bounds)
        print("screen diff=", diff)
        
        if ( diff > 0){
            let point = CGPoint(x: 0, y: Int(diff) )
            self.scrollNode.view.setContentOffset(point, animated: true)
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        let point = CGPoint(x: 0, y: 0)
        self.scrollNode.view.setContentOffset(point, animated: true)
    }
    
}

