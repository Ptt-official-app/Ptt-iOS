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

protocol LoginView: BaseView {
    var onCompleteAuth: (() -> Void)? { get set }
}

final class LoginViewController: ASDKViewController<ASDisplayNode>, LoginView{
    var onCompleteAuth: (() -> Void)?
    
    //private let apiClient: APIClientProtocol = nil

    private let rootNode = ASDisplayNode()
    var scrollNode = ASScrollNode()

    var contentStackSpec:ASStackLayoutSpec?
    var contentCenterLayoutSpec:ASCenterLayoutSpec?
    
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
        super.init(node: rootNode)
        self.rootNode.backgroundColor = GlobalAppearance.backgroundColor // self.blackColor
        
        let stack = self.init_layout()
        
        self.scrollNode.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesContentSize = false // false: can't scroll by user but keyboard
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
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    func gotoRegisterWebview() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func switchTypeRegister(_ button:ASButtonNode) {
        
        if button == btnTypeRegister {
            //btnTypeRegister.isSelected = true
            //btnTypeLogin.isSelected = false
            gotoRegisterWebview()
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
        let title = NSLocalizedString("Register", comment:"")
        
        let attr: [NSAttributedString.Key : Any] = [
            .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline) //UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        
        button.setTitle(title, with: nil, with: text_color, for: UIControl.State.selected)
        button.setTitle(title, with: nil, with: .systemGray, for: UIControl.State.normal)
        
        button.isSelected = false
        return button
    }()
    
    
    lazy var btnTypeLogin:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("Login", comment:"")

        let attr: [NSAttributedString.Key : Any] = [
           .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline) // UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        button.setTitle(title, with: nil, with: text_color, for: UIControl.State.selected)
        button.setTitle(title, with: nil, with: .systemGray, for: UIControl.State.normal)

        button.isSelected = true
        
        return button
    }()
    
    lazy var lbLine:ASTextNode =  {
        let label = ASTextNode()
        let attr:[NSAttributedString.Key : Any] = [
            .foregroundColor: self.text_color,
            .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)// UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        
        var title = NSAttributedString.init(string: "|", attributes: attr)
        label.attributedText = title
        return label
    }()
    
    lazy var lbTitle:ASTextNode =  {
        let label = ASTextNode()
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.alignment = .left
        paragraphStyle.paragraphSpacing = 2
        paragraphStyle.lineSpacing = 0
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1), //UIFont.boldSystemFont(ofSize: 24),
            NSAttributedString.Key.foregroundColor: self.text_color,
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
            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)//UIFont.systemFont(ofSize: 12)
        ]
        textField.attributedPlaceholder = NSAttributedString.init(string: title, attributes:attr)
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        
        textField.delegate = self
        textField.textColor = UIColor.black
        
        textField.text = "SYSOP"
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
            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1
            )//UIFont.systemFont(ofSize: 12)
        ]
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString.init(string: title, attributes:attr )
        
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.textColor = UIColor.black
        
        textField.text = "123123"
        
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
        let okAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
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
        self.btnLogin.isEnabled = false
        self.hideKeyboard()
        
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
                    DispatchQueue.main.async {
                        self.showAlert(title: NSLocalizedString("Error", comment: ""), msg: NSLocalizedString("Login", comment: "") + NSLocalizedString("Error", comment: "") + error.message)
                    }
                case .success(let token):
                    print(token.access_token)
                    self.onLoginSuccess(token: token.access_token)
                }
                self.btnLogin.isEnabled = true
            }
        }
        else {
            self.btnLogin.isEnabled = true
        }
    }
    
    func onLoginSuccess(token:String) {
        _ = LoginKeyChainItem.shared.saveToken(token)
        // todo: push view
        DispatchQueue.main.async {
            print("ready to call finish flow in main thread")
            self.onCompleteAuth?()
        }
    }
    
    @objc func forgetPress() {
        print("forget press")
    }
    
    lazy var btnLogin:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("Login", comment:"")
        let attr : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: self.textfield_backgroundcolor,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1
            )// UIFont.systemFont(ofSize: 12)
        ]
        button.backgroundColor = UIColor.systemGray
        button.setAttributedTitle(NSAttributedString.init(string: title, attributes: attr), for: UIControl.State.normal)
        
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        
        return button
    }()

    lazy var btnForget:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("Forget", comment:"")
        let attr = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1
            )// UIFont.systemFont(ofSize: 12)
        ]
        button.setAttributedTitle(NSAttributedString.init(string: title, attributes: attr), for: UIControl.State.normal)
        return button
    }()
    
    
    
    var text_color : UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "textColor-240-240-247")!
        } else {
            return UIColor(red: 42/255, green: 42/255, blue: 48/255, alpha: 1.0)
        }
    }
    
    var textfield_backgroundcolor : UIColor {
        if #available(iOS 11.0, *) {
            return UIColor(named: "blackColor-28-28-31")!
        } else {
            return UIColor(red: 28/255, green: 28/255, blue: 31/255, alpha: 1.0)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            scrollViewToFitKeyboard(Int(keyboardHeight))
        }
    }
    
    func scrollViewToFitKeyboard(_ lastKeyboardHeight:Int){
        let screenHeight = Int(self.view.bounds.height)
        
        let keyboardHeight:Int = lastKeyboardHeight + Int(self.btnForget.frame.height + self.btnLogin.frame.height + 31) // 31 = login~forget height
        
        let margin_to_keyboard = 10
        let diff = Int(btnLogin.view.frame.origin.y) - (screenHeight-keyboardHeight) + margin_to_keyboard
        
//        print("screen height=", UIScreen.main.bounds.height)
//        print("btn login pos=", btnLogin.view.frame.origin, btnLogin.view.bounds)
//        print("screen diff=", diff)
        
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

