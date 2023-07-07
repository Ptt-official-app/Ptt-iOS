//
//  LoginViewController.swift
//  Ptt
//
//  Created by You Gang Kuo on 2020/12/8.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

protocol LoginView: BaseView {
    var onCompleteAuth: (() -> Void)? { get set }
}

final class LoginViewController: UIViewController, LoginView {
    var onCompleteAuth: (() -> Void)?

    enum UILoginState {
        case login  // the default state
        case attemptRegister // try to register
        case verifyCode // wait for email code
        case error // display error
        case fillInformation // register success, fill name, birthday, address, etc.
    }

    private let scrollView = UIScrollView()
    private let mainContentView = UIView()
    let switchContentView = UIView()
    let global_width: CGFloat = 265
    var state: UILoginState = .login

    private func init_layout() {
        view.ptt_add(subviews: [scrollView])
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", metrics: nil, views: ["scrollView": scrollView]) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", metrics: nil, views: ["scrollView": scrollView])
        )

        scrollView.ptt_add(subviews: [mainContentView])
        NSLayoutConstraint.activate([
            mainContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 50),
            mainContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            mainContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 50),
            mainContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -50),
            mainContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -100)
        ])
        mainContentView.ptt_add(subviews: [lbTitle, leftFuncStack, lbRegisterProgress, switchContentView])
        let viewsDictionary = ["lbTitle": lbTitle,
                               "leftFuncStack": leftFuncStack, "lbRegisterProgress": lbRegisterProgress,
                               "switchContentView": switchContentView]
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|[lbTitle(100)]-[leftFuncStack(44)]-(50)-[switchContentView]|", metrics: nil, views: viewsDictionary)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[lbTitle]|", metrics: nil, views: viewsDictionary)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[leftFuncStack]-[lbRegisterProgress]|", metrics: nil, views: viewsDictionary)
        constraints += [lbRegisterProgress.centerYAnchor.constraint(equalTo: leftFuncStack.centerYAnchor)]
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[switchContentView]|", metrics: nil, views: viewsDictionary)
        NSLayoutConstraint.activate(constraints)

#if DEVELOP // Disable registering, for now
#else
        leftFuncStack.isHidden = true
#endif

        initErrorViews()
        initVerifyCodeViews()
        initLoginViews() // init loginStackSpec and login views
        initRegisterViews() // init registerStackSpec and register views
        initFillInformationViews()
    }

    func getTextFieldList() -> [LoginTextField] {
        return [tfUsername, tfPassword,
                tfRegisterUsername, tfRegisterEmail, tfRegisterPassword,
                tfVerifyCode,
                tfFillRealName, tfFillBirthday, tfFillAddress]
    }

    func bind_event() {
        btnTypeLogin.addTarget(
            self,
            action: #selector(switchTypeRegister),
            for: .touchUpInside
        )
        btnTypeRegister.addTarget(
            self,
            action: #selector(switchTypeRegister),
            for: .touchUpInside
        )
    }

    @objc
    func testErrorMsg() {
        displayError(message: "TEST AAA BBC LDJ:LAKJ DD")
        toggleState(UILoginState.error)
    }

    func toggleState(_ state: UILoginState) {
        self.state = state
        switch state {
        case .login:
            print("Toggle State Login")
            toggleLoginView(isHidden: false)
            toggleRegisterView(isHidden: true)
            toggleErrorView(isHidden: true)
            toggleVerifyCodeView(isHidden: true)
            toggleFillInformationView(isHidden: true)
            lbRegisterProgress.isHidden = true

        case .attemptRegister:
            print("Toggle State AttemptRegister")
            toggleLoginView(isHidden: true)
            toggleRegisterView(isHidden: false)

            toggleErrorView(isHidden: true)
            toggleVerifyCodeView(isHidden: true)

            toggleFillInformationView(isHidden: true)

            lbRegisterProgress.isHidden = false
            lbRegisterProgress.attributedText = getRegisterProgressText(0)

        case .verifyCode:
            print("Toggle State VerifyCode")
            toggleLoginView(isHidden: true)
            toggleRegisterView(isHidden: true)
            toggleErrorView(isHidden: true)
            toggleVerifyCodeView(isHidden: false)
            toggleFillInformationView(isHidden: true)

            lbRegisterProgress.isHidden = false
            lbRegisterProgress.attributedText = getRegisterProgressText(1)

        case .error: // note: register error msg
            print("Toggle State Error")
            toggleLoginView(isHidden: true)
            toggleRegisterView(isHidden: true)
            toggleErrorView(isHidden: false)
            toggleVerifyCodeView(isHidden: true)
            toggleFillInformationView(isHidden: true)

        case .fillInformation:
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
        super.viewDidLoad()
        print("login view did load")
        self.bind_event()
        toggleState(.login)

        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = GlobalAppearance.backgroundColor

        self.init_layout()
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func gotoRegisterWebview() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func switchTypeRegister(_ button: UIButton) {
        if button == btnTypeRegister {
            btnTypeRegister.isSelected = true
            btnTypeLogin.isSelected = false
            toggleState(.attemptRegister)
        } else if button == btnTypeLogin {
            btnTypeRegister.isSelected = false
            btnTypeLogin.isSelected = true
            toggleState(.login)
        }

        view.endEditing(true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var lbRegisterProgress: UILabel = {
        let label = UILabel()
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
            mString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: PttColors.paleGrey.color,
                range: NSRange(location: 0, length: 2)
            )
        case 1:
            mString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: PttColors.tangerine.color,
                range: NSRange(location: 0, length: 2)
            )
            mString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: PttColors.paleGrey.color,
                range: NSRange(location: 4, length: 2)
            )
        case 2:
            mString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: PttColors.tangerine.color,
                range: NSRange(location: 0, length: 2)
            )
            mString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: PttColors.tangerine.color,
                range: NSRange(location: 4, length: 2)
            )
            mString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: PttColors.paleGrey.color,
                range: NSRange(location: 8, length: 2)
            )
        case 3:
            mString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: PttColors.tangerine.color,
                range: NSRange(location: 0, length: 2)
            )
            mString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: PttColors.tangerine.color,
                range: NSRange(location: 4, length: 2)
            )
            mString.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: PttColors.tangerine.color,
                range: NSRange(location: 8, length: 2)
            )

        default:
            break
        }

        return mString
    }

    lazy var btnTypeRegister: UIButton = {
        let button = UIButton()
        let title = L10n.register

        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        ]

        button.setTitle(title, for: .selected)
        button.setTitleColor(PttColors.paleGrey.color, for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitleColor(PttColors.slateGrey.color, for: .normal)

        button.isSelected = false
        return button
    }()

    lazy var btnTypeLogin: UIButton = {
        let button = UIButton()
        let title = L10n.login

        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        ]
        button.setTitle(title, for: .selected)
        button.setTitleColor(PttColors.paleGrey.color, for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitleColor(PttColors.slateGrey.color, for: .normal)

        button.isSelected = true

        return button
    }()

    lazy var lbLine: UILabel = {
        let label = UILabel()
        let attr: [NSAttributedString.Key: Any] = [
            .foregroundColor: PttColors.slateGrey.color,
            .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        ]

        var title = NSAttributedString(string: "|", attributes: attr)
        label.attributedText = title
        return label
    }()

    lazy var leftFuncStack: UIView = {
        let stack = UIView()
        let viewsDictionary = ["btnTypeLogin": btnTypeLogin, "lbLine": lbLine, "btnTypeRegister": btnTypeRegister]
        stack.ptt_add(subviews: [btnTypeLogin, lbLine, btnTypeRegister])
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[btnTypeLogin]-(5)-[lbLine]-(5)-[btnTypeRegister]", metrics: nil, views: viewsDictionary) +
            [
                btnTypeLogin.centerYAnchor.constraint(equalTo: stack.centerYAnchor),
                lbLine.centerYAnchor.constraint(equalTo: btnTypeLogin.centerYAnchor),
                btnTypeRegister.centerYAnchor.constraint(equalTo: btnTypeLogin.centerYAnchor)
            ]
        )
        return stack
    }()

    lazy var vLine: UIView = {
        let line = UIView()
        line.backgroundColor = PttColors.slateGrey.color
        return line
    }()

    lazy var lbTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.paragraphSpacing = 2
        paragraphStyle.lineSpacing = 0
        let attributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1),
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
    lazy var btnAttemptRegister = getbtnAttemptRegister()
    lazy var btnRegisterUserAgreement = getbtnRegisterUserAgreement()

    // Login Views
    lazy var tfUsername = gettfUsername()
    lazy var tfPassword = gettfPassword()
    lazy var btnLogin = getbtnLogin()
    lazy var btnUserAgreement = getbtnUserAgreement()
    lazy var btnForget = getbtnForget()

    // error views
    lazy var lbError = getErrorView()

    func onLoginSuccess(token: String) {
        self.onCompleteAuth?()
    }

    @objc
    func userAgreementPress() {
        showAlert(title: "XD", msg: "NOT IMPLEMENT YET -_-")
    }

    // verify code views:
    lazy var lbVerifyCodeTitle = getlbVerifyCodeTitle()
    lazy var tfVerifyCode = gettfVerifyCode()
    lazy var lbVerifyCodeResponse = getlbVerifyCodeResponse()
    lazy var lbVerifyCodeTimer = getlbVerifyCodeTimer()
    lazy var btnVerifyCodeBack = getbtnVerifyCodeBack()
    lazy var btnVerifyCodeNotReceive = getbtnVerifyCodeNotReceive()

    // Fill Information Views:
    lazy var lbFillTitle = getlbFillTitle()
    lazy var tfFillRealName = gettfFillRealName()
    lazy var tfFillBirthday = gettfFillBirthday()
    lazy var tfFillAddress = gettfFillAddress()
    lazy var lbNeedReason = getlbNeedReason()
    lazy var btnOpenAccount = getbtnOpenAccount()
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case tfUsername:
            tfPassword.becomeFirstResponder()
        case tfPassword:
            loginPress()
        case tfRegisterEmail:
            tfRegisterUsername.becomeFirstResponder()
        case tfRegisterUsername:
            tfRegisterPassword.becomeFirstResponder()
        case tfRegisterPassword:
            btnAttemptRegisterPress()
        case tfFillRealName:
            tfFillBirthday.becomeFirstResponder()
        case tfFillBirthday:
            tfFillAddress.becomeFirstResponder()
        case tfFillAddress:
            openAccountPress()
        default:
            break
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        let tfList = getTextFieldList()
        for tf in tfList where tf == textField {
            tf.warning(msg: nil)
        }
    }

    @objc
    func textFieldDidChange(textField: UITextField) {

        if let username = tfUsername.text,
           let password = tfPassword.text,
           !username.isEmpty && !password.isEmpty {
            btnLogin.isSelected = true
        } else {
            btnLogin.isSelected = false
        }

        if let email = tfRegisterEmail.text,
           let username = tfRegisterUsername.text,
           let password = tfRegisterPassword.text,
           !email.isEmpty && !username.isEmpty && !password.isEmpty {
            btnAttemptRegister.isSelected = true
        } else {
            btnAttemptRegister.isSelected = false
        }

        // todo: modify the text length
        if tfVerifyCode.text?.count == 6 {
            // start the register progress!!
            print("start the register process with text.count = 6")
            self.onVerifyCodeFill()
        }
    }
}

// Notifications
extension LoginViewController {
    @objc
    func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)

            var visibleFrame: CGRect?

            // TODO: Checking the visibility of user agreement button for adjusting scrollview visible area temporarily, should be removed later when the agreement feature is ready
            switch state {
            case .login:
                visibleFrame = btnUserAgreement.isHidden ? btnLogin.frame : btnUserAgreement.frame
            case .attemptRegister:
                visibleFrame = btnRegisterUserAgreement.isHidden ? btnAttemptRegister.frame : btnRegisterUserAgreement.frame
            default:
                visibleFrame = nil
            }

            if let rect = visibleFrame {
                let convertedFrame = switchContentView.convert(rect, to: scrollView)
                scrollView.scrollRectToVisible(convertedFrame, animated: true)
            }
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}

// Others
extension LoginViewController {

    var text_color: UIColor {
        PttColors.paleGrey.color
    }

    var textfield_backgroundcolor: UIColor {
        PttColors.shark.color
    }

    var tint_color: UIColor {
        PttColors.tangerine.color
    }

    func showAlert(title: String, msg: String) {
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }

}
