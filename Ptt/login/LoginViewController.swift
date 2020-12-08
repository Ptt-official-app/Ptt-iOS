//
//  LoginViewController.swift
//  Ptt
//
//  Created by You Gang Kuo on 2020/12/8.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
import UIKit

final class LoginViewController: UIViewController {
    
    //private let apiClient: APIClientProtocol = nil

    private var svScrollView:UIScrollView = UIScrollView()
    private var isRequesting = false
    private var receivedPage : Int = 0
    
    private let activityIndicator = UIActivityIndicatorView()
    
    lazy var lbTitle:UILabel =  {
        let label = UILabel()
            let paragraphStyle = NSMutableParagraphStyle.init()
            paragraphStyle.alignment = .left
            paragraphStyle.paragraphSpacing = 20
            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30),
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            
            label.attributedText = NSAttributedString.init(string: "批踢踢實業坊\nPtt.cc", attributes: attributes)
            label.numberOfLines = 0
            label.backgroundColor = GlobalAppearance.backgroundColor
            return label
        }()
    
    lazy var tfUsername:LoginTextField = {
        let textField = LoginTextField()
            textField.placeholder = NSLocalizedString("User Id", comment:"")
            return textField
        }()
    
    lazy var tfPassword: LoginTextField = {
        let textField = LoginTextField()
            textField.isSecureTextEntry = true
            textField.placeholder = NSLocalizedString("Password", comment:"")
            return textField
        }()
    
    lazy var btnLogin:UIButton = {
        let button = UIButton()
            button.titleLabel?.text = NSLocalizedString("Login", comment:"")
            return button
        }()

    lazy var sgFuncSwitch: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [NSLocalizedString("Login", comment: ""), NSLocalizedString("Register",comment: "")])
            return segmentedControl
        }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GlobalAppearance.backgroundColor
        activityIndicator.color = .lightGray
        self.init_layouts()
    }
    
    func init_layouts() {
    
        
        for v in [lbTitle, sgFuncSwitch, tfUsername, tfPassword, btnLogin] {
            v.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(v)
        }
        
        NSLayoutConstraint.activate([
            self.tfUsername.widthAnchor.constraint(equalToConstant: 250),
            self.tfUsername.heightAnchor.constraint(equalToConstant: 45),
            self.tfUsername.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tfUsername.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.tfPassword.widthAnchor.constraint(equalTo: tfUsername.widthAnchor),
            self.tfPassword.heightAnchor.constraint(equalTo: tfUsername.heightAnchor),
            self.tfPassword.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.tfPassword.topAnchor.constraint(equalTo: tfUsername.bottomAnchor, constant: 20),
        ])
        
        
        NSLayoutConstraint.activate([
            self.lbTitle.widthAnchor.constraint(equalTo: tfUsername.widthAnchor),
            self.lbTitle.heightAnchor.constraint(equalToConstant: 120),
            self.lbTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.lbTitle.bottomAnchor.constraint(equalTo: tfUsername.topAnchor, constant: -150),
        ])
        
        NSLayoutConstraint.activate([
            self.sgFuncSwitch.leftAnchor.constraint(equalTo: tfUsername.leftAnchor),
            self.sgFuncSwitch.bottomAnchor.constraint(equalTo: tfUsername.topAnchor, constant: -50),
        ])
        
        NSLayoutConstraint.activate([
            self.btnLogin.widthAnchor.constraint(equalTo: tfUsername.widthAnchor),
            self.btnLogin.leftAnchor.constraint(equalTo: tfUsername.leftAnchor),
            self.btnLogin.topAnchor.constraint(equalTo: tfPassword.topAnchor, constant: 70),
        ])
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    class LoginTextField: UITextField {
        @IBInspectable var insetX: CGFloat = 16
        @IBInspectable var insetY: CGFloat = 16

        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)!
            self.setup_view()
        }
        required override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup_view()
        }
        func setup_view(){
            self.clipsToBounds = true
            self.layer.masksToBounds = false
            self.layer.cornerRadius = 20
            backgroundColor = textfield_backgroundcolor
        }
    
        // placeholder position
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: insetX, dy: insetY)
        }

        // text position
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: insetX, dy: insetY)
        }
        
        var textfield_backgroundcolor : UIColor? {
            if #available(iOS 11.0, *) {
                return UIColor(red: 42/255, green: 42/255, blue: 48/255, alpha: 1.0)
                //return UIColor(named: "tintColor-42-42-48")
            } else {
                return UIColor(red: 42/255, green: 42/255, blue: 48/255, alpha: 1.0)
            }
        }
        
    }
}
