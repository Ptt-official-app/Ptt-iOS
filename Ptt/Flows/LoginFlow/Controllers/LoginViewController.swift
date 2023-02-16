//
//  LoginViewController.swift
//  Ptt
//
//  Created by You Gang Kuo on 2020/12/8.
//  Copyright © 2020 Ptt. All rights reserved.
//

import AsyncDisplayKit
import Foundation
import UIKit

protocol LoginView: BaseView {
    var onCompleteAuth: (() -> Void)? { get set }
}

final class LoginViewController: ASDKViewController<ASDisplayNode>, LoginView {
    var onCompleteAuth: (() -> Void)?

    enum UILoginState {
        case Login  // the default state
        case AttemptRegister // try to register
        case VerifyCode // wait for email code
        case Error // display error
        case FillInformation // register success, fill name, birthday, address, etc.
    }

    // private let rootNode =

    var scrollNode = ASScrollNode()

    var contentStackSpec: ASStackLayoutSpec?
    var contentCenterLayoutSpec: ASCenterLayoutSpec?

    var funcStackSpec: ASLayoutSpec?
    var switchNode: ASDisplayNode?

    var loginStackSpec: ASCenterLayoutSpec?
    var registerStackSpec: ASCenterLayoutSpec?
    var errorStackSpec: ASCenterLayoutSpec?
    var verifyStackSpec: ASCenterLayoutSpec?
    var fillInformationStackSpec: ASCenterLayoutSpec?

    let global_width = 265

    func init_layout() -> ASLayoutSpec {
        let LeftfuncStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 5,
                                                   justifyContent: .start,
                                                   alignItems: .start,
                                                   children: [btnTypeLogin, lbLine, btnTypeRegister])
        LeftfuncStackSpec.style.preferredSize = CGSize(width: global_width, height: 44)

        let registerProcessInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 8), child: lbRegisterProgress)

        let RightfuncStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 5,
                                                   justifyContent: .end,
                                                   alignItems: .start,
                                                   children: [registerProcessInset])
        RightfuncStackSpec.style.preferredSize = CGSize(width: global_width, height: 44)

        funcStackSpec = ASAbsoluteLayoutSpec(children: [RightfuncStackSpec, LeftfuncStackSpec])
        funcStackSpec?.style.preferredSize = CGSize(width: global_width, height: 44 + 43)

        initErrorViews()
        initVerifyCodeViews()
        initLoginViews() // init loginStackSpec and login views
        initRegisterViews() // init registerStackSpec and register views
        initFillInformationViews()

        let switchLayoutSpec = ASAbsoluteLayoutSpec(children: [registerStackSpec!, loginStackSpec!, errorStackSpec!, verifyStackSpec!, fillInformationStackSpec!])
        // ASLayoutSpec(children: [loginStackSpec, registerStackSpec])
        contentStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [lbTitle, funcStackSpec!, switchLayoutSpec])

        self.scrollNode.addSubnode(self.lbTitle)

        self.scrollNode.addSubnode(self.btnTypeLogin)
        self.scrollNode.addSubnode(self.btnTypeRegister)
        self.scrollNode.addSubnode(self.lbRegisterProgress)

        node.addSubnode(self.scrollNode)

        return contentStackSpec!
    }

    func getTextFieldList() -> [ASDisplayNode] {
        return [tfUsername, tfPassword,
                tfRegisterUsername, tfRegisterEmail, tfRegisterPassword,
                tfVerifyCode,
                tfFillRealName, tfFillBirthday, tfFillAddress ]
    }

    @objc func hideKeyboard() {

        let tfList = getTextFieldList()
        for node in tfList {
            if let tf = node.view as? UITextField {
                tf.endEditing(true)
            }
        }
    }

    func bind_event() {
        btnTypeLogin.addTarget(self, action: #selector(switchTypeRegister), forControlEvents: ASControlNodeEvent.touchUpInside)
        btnTypeRegister.addTarget(self, action: #selector(switchTypeRegister), forControlEvents: ASControlNodeEvent.touchUpInside)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.node.view.addGestureRecognizer(tap)

    }

    @objc func testErrorMsg() {
        displayError(message: "TEST AAA BBC LDJ:LAKJ DD")
        toggleState(UILoginState.Error)
    }

    func toggleState(_ state: UILoginState) {
        switch state {
        case .Login:
            print("Toggle State Login")
            toggleLoginView(isHidden: false)
            toggleRegisterView(isHidden: true)
            toggleErrorView(isHidden: true)
            toggleVerifyCodeView(isHidden: true)
            toggleFillInformationView(isHidden: true)
            lbRegisterProgress.isHidden = true

        case .AttemptRegister:
            print("Toggle State AttemptRegister")
            toggleLoginView(isHidden: true)
            toggleRegisterView(isHidden: false)

            toggleErrorView(isHidden: true)
            toggleVerifyCodeView(isHidden: true)

            toggleFillInformationView(isHidden: true)

            lbRegisterProgress.isHidden = false
            lbRegisterProgress.attributedText = getRegisterProgressText(0)

        case .VerifyCode:
            print("Toggle State VerifyCode")
            toggleLoginView(isHidden: true)
            toggleRegisterView(isHidden: true)
            toggleErrorView(isHidden: true)
            toggleVerifyCodeView(isHidden: false)
            toggleFillInformationView(isHidden: true)

            lbRegisterProgress.isHidden = false
            lbRegisterProgress.attributedText = getRegisterProgressText(1)

        case .Error: // note: register error msg
            print("Toggle State Error")
            toggleLoginView(isHidden: true)
            toggleRegisterView(isHidden: true)
            toggleErrorView(isHidden: false)
            toggleVerifyCodeView(isHidden: true)
            toggleFillInformationView(isHidden: true)

        case .FillInformation:
            print("Toggle State FillInformation")
            toggleLoginView(isHidden: true)
            toggleRegisterView(isHidden: true)
            toggleErrorView(isHidden: true)
            toggleVerifyCodeView(isHidden: true)
            toggleFillInformationView(isHidden: false)
            lbRegisterProgress.isHidden = false
            lbRegisterProgress.attributedText = getRegisterProgressText(2)
        }
    }

    override func viewDidLoad() {
        print("login view did load")
        self.bind_event()
        toggleState(.Login)
    }

    override init() {
        super.init(node: ASDisplayNode())
        self.node.backgroundColor = GlobalAppearance.backgroundColor

        let stack = self.init_layout()

        self.scrollNode.automaticallyManagesSubnodes = true
        self.scrollNode.automaticallyManagesContentSize = false // false: can't scroll by user but keyboard
        self.scrollNode.view.showsHorizontalScrollIndicator = false
        self.scrollNode.view.showsVerticalScrollIndicator = false

        scrollNode.layoutSpecBlock = { _, _ in
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

    @objc func switchTypeRegister(_ button: ASButtonNode) {

        if button == btnTypeRegister {
            btnTypeRegister.isSelected = true
            btnTypeLogin.isSelected = false
            toggleState(.AttemptRegister)
        } else if button == btnTypeLogin {
            btnTypeRegister.isSelected = false
            btnTypeLogin.isSelected = true
            toggleState(.Login)
        }
        self.hideKeyboard()
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    lazy var lbRegisterProgress: ASTextNode = {
        let label = ASTextNode()
        label.attributedText = getRegisterProgressText(0)
        return label
    }()

    /**
     Colors:
     White, Gray, Tangerine
     0: WGG
     1: TWG
     2: TTW
     3: TTT
     */
    func getRegisterProgressText(_ progress: Int) -> NSMutableAttributedString {

        // The attributed text length can't be changed -_-
        let title = "帳密  驗證  資料"

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        paragraphStyle.paragraphSpacing = 2
        paragraphStyle.lineSpacing = 0
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline),
            NSAttributedString.Key.foregroundColor: PttColors.slateGrey.color,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        let mString = NSMutableAttributedString(string: title, attributes: attributes)

        switch progress {
        case 0:
            mString.addAttribute(NSAttributedString.Key.foregroundColor, value: PttColors.paleGrey.color, range: NSRange(location: 0, length: 2))
        case 1:
            mString.addAttribute(NSAttributedString.Key.foregroundColor, value: PttColors.tangerine.color, range: NSRange(location: 0, length: 2))
            mString.addAttribute(NSAttributedString.Key.foregroundColor, value: PttColors.paleGrey.color, range: NSRange(location: 4, length: 2))
        case 2:
            mString.addAttribute(NSAttributedString.Key.foregroundColor, value: PttColors.tangerine.color, range: NSRange(location: 0, length: 2))
            mString.addAttribute(NSAttributedString.Key.foregroundColor, value: PttColors.tangerine.color, range: NSRange(location: 4, length: 2))
            mString.addAttribute(NSAttributedString.Key.foregroundColor, value: PttColors.paleGrey.color, range: NSRange(location: 8, length: 2))
        case 3:
            mString.addAttribute(NSAttributedString.Key.foregroundColor, value: PttColors.tangerine.color, range: NSRange(location: 0, length: 2))
            mString.addAttribute(NSAttributedString.Key.foregroundColor, value: PttColors.tangerine.color, range: NSRange(location: 4, length: 2))
            mString.addAttribute(NSAttributedString.Key.foregroundColor, value: PttColors.tangerine.color, range: NSRange(location: 8, length: 2))

        default:
            break
        }

        return mString
    }

    lazy var btnTypeRegister: ASButtonNode = {
        let button = ASButtonNode()
        let title = L10n.register

        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline) // UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]

        button.setTitle(title, with: nil, with: PttColors.paleGrey.color, for: UIControl.State.selected)
        button.setTitle(title, with: nil, with: PttColors.slateGrey.color, for: UIControl.State.normal)

        button.isSelected = false
        return button
    }()

    lazy var btnTypeLogin: ASButtonNode = {
        let button = ASButtonNode()
        let title = L10n.login

        let attr: [NSAttributedString.Key: Any] = [
           .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline) // UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        button.setTitle(title, with: nil, with: PttColors.paleGrey.color, for: UIControl.State.selected)
        button.setTitle(title, with: nil, with: PttColors.slateGrey.color, for: UIControl.State.normal)

        button.isSelected = true

        return button
    }()

    lazy var lbLine: ASTextNode = {
        let label = ASTextNode()
        let attr: [NSAttributedString.Key: Any] = [
            .foregroundColor: PttColors.paleGrey.color,
            .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        ]

        var title = NSAttributedString(string: "|", attributes: attr)
        label.attributedText = title
        return label
    }()

    lazy var vLine: ASDisplayNode = {
        let line = ASDisplayNode()
        line.backgroundColor = PttColors.slateGrey.color
        return line
    }()

    lazy var lbTitle: ASTextNode = {
        let label = ASTextNode()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.paragraphSpacing = 2
        paragraphStyle.lineSpacing = 0
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1), // UIFont.boldSystemFont(ofSize: 24),
            NSAttributedString.Key.foregroundColor: self.text_color,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        label.attributedText = NSAttributedString(string: "批踢踢實業坊\nPtt.cc", attributes: attributes)

        return label
    }()

    // Register views
    lazy var tfRegisterEmail = gettfRegisterEmail()
    lazy var tfRegisterUsername = gettfRegisterUsername()
    lazy var tfRegisterPassword = gettfRegisterPassword()
    lazy var btnAttemptRegister: ASButtonNode = getbtnAttemptRegister()
    lazy var btnRegisterUserAgreement: ASButtonNode = getbtnRegisterUserAgreement()

    // Login Views
    lazy var tfUsername = gettfUsername()
    lazy var tfPassword = gettfPassword()
    lazy var btnLogin: ASButtonNode = getbtnLogin()
    lazy var btnUserAgreement: ASButtonNode = getbtnUserAgreement()
    lazy var btnForget: ASButtonNode = getbtnForget()

    // error views
    lazy var lbError: ASTextNode = getErrorView()

    func onLoginSuccess(token: String) {
        _ = LoginKeyChainItem.shared.saveToken(token)
        // todo: push view
        DispatchQueue.main.async {
            print("ready to call finish flow in main thread")
            self.onCompleteAuth?()
        }
    }

    @objc func userAgreementPress() {
        print("user agreement press")
        showAlert(title: "XD", msg: "NOT IMPLEMENT YET -_-")
    }

    // verify code views:
    lazy var lbVerifyCodeTitle: ASTextNode = getlbVerifyCodeTitle()
    lazy var tfVerifyCode = gettfVerifyCode()
    lazy var lbVerifyCodeResponse: ASTextNode = getlbVerifyCodeResponse()
    lazy var lbVerifyCodeTimer: ASTextNode = getlbVerifyCodeTimer()
    lazy var btnVerifyCodeBack: ASButtonNode = getbtnVerifyCodeBack()
    lazy var btnVerifyCodeNotReceive: ASButtonNode = getbtnVerifyCodeNotReceive()

    // Fill Information Views:
    lazy var lbFillTitle: ASTextNode = getlbFillTitle()
    lazy var tfFillRealName = gettfFillRealName()
    lazy var tfFillBirthday = gettfFillBirthday()
    lazy var tfFillAddress = gettfFillAddress()
    lazy var lbNeedReason: ASButtonNode = getlbNeedReason()
    lazy var btnOpenAccount: ASButtonNode = getbtnOpenAccount()
}

extension LoginViewController: UITextFieldDelegate {

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            scrollViewToFitKeyboard(Int(keyboardHeight))
        }
    }

    func scrollViewToFitKeyboard(_ lastKeyboardHeight: Int) {
        let screenHeight = Int(self.view.bounds.height)

        let keyboardHeight: Int = lastKeyboardHeight + Int(self.btnForget.frame.height + self.btnLogin.frame.height + 31) // 31 = login~forget height

        let margin_to_keyboard = 10
        let diff = Int(btnLogin.view.frame.origin.y) - (screenHeight - keyboardHeight) + margin_to_keyboard

        if diff > 0 {
            let point = CGPoint(x: 0, y: Int(diff) )
            self.scrollNode.view.setContentOffset(point, animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case tfUsername.view:
            tfPassword.becomeFirstResponder()
        case tfPassword.view:
            loginPress()

        case tfRegisterEmail.view:
            tfRegisterUsername.becomeFirstResponder()
        case tfRegisterUsername.view:
            tfRegisterPassword.becomeFirstResponder()
        case tfRegisterPassword.view:
            btnAttemptRegisterPress()

        case tfFillRealName.view:
            tfFillBirthday.becomeFirstResponder()
        case tfFillBirthday.view:
            tfFillAddress.becomeFirstResponder()
        case tfFillAddress.view:
            openAccountPress()
        default:
            break
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let point = CGPoint(x: 0, y: 0)
        self.scrollNode.view.setContentOffset(point, animated: true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        let tfList = getTextFieldList()
        for node in tfList {
            if let tf = node.view as? LoginTextField {
                if tf == textField {
                    tf.warning(msg: nil)
                }
            }
        }
    }

    @objc func textFieldDidChange(textField: UITextField) {

        if let usernameTextField = tfUsername.view as? UITextField,
           let passwordTextField = tfPassword.view as? UITextField,
           let username = usernameTextField.text,
           let password = passwordTextField.text,
           !username.isEmpty && !password.isEmpty {
            btnLogin.isSelected = true
        } else {
            btnLogin.isSelected = false
        }

        if let tfEmail = tfRegisterEmail.view as? UITextField,
           let tfUser = tfRegisterUsername.view as? UITextField,
           let tfPass = tfRegisterPassword.view as? UITextField,
           let email = tfEmail.text,
           let username = tfUser.text,
           let password = tfPass.text,
           !email.isEmpty && !username.isEmpty && !password.isEmpty {
            btnAttemptRegister.isSelected = true
        } else {
            btnAttemptRegister.isSelected = false
        }

        if textField == tfVerifyCode.view {
            // todo: modify the text length
            if textField.text?.count == 6 {
                // start the register progress!!
                print("start the register process with text.count = 6")
                self.onVerifyCodeFill()
            }
        }
    }
}

// Others
extension LoginViewController {

    var text_color: UIColor {
        if #available(iOS 11.0, *) {
            return PttColors.paleGrey.color
        } else {
            return UIColor(red: 240 / 255, green: 240 / 255, blue: 247 / 255, alpha: 1.0)
        }
    }

    var textfield_backgroundcolor: UIColor {
        if #available(iOS 11.0, *) {
            return PttColors.shark.color
        } else {
            return UIColor(red: 28 / 255, green: 28 / 255, blue: 31 / 255, alpha: 1.0)
        }
    }

    var tint_color: UIColor {
        if #available(iOS 11.0, *) {
            return PttColors.tangerine.color // UIColor(named: "tintColor-255-159-10")!
        } else {
            return UIColor(red: 255 / 255, green: 159 / 255, blue: 10 / 255, alpha: 1.0)
        }
    }

    func showAlert(title: String, msg: String) {
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }

}
