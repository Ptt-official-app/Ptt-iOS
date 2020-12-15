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

final class LoginViewController: ASDKViewController<ASDisplayNode>, ASEditableTextNodeDelegate {
    
    //private let apiClient: APIClientProtocol = nil
    private let rootNode = ASDisplayNode()
    
    func init_layout() -> ASLayoutSpec {
        
        let global_width = 265
        let forgetCenterLayout = ASCenterLayoutSpec(centeringOptions: .X, sizingOptions: ASCenterLayoutSpecSizingOptions.minimumY, child: btnForget)
        
        let funcStackSpec = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 5,
                                                   justifyContent: .start,
                                                   alignItems: .start,
                                                   children: [btnTypeLogin, lbLine, btnTypeRegister])
        
        funcStackSpec.style.preferredSize = CGSize(width: global_width, height: 44)
        
        let contentStackSpec = ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 10,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [lbTitle, funcStackSpec, tfUsername,
                                                              tfPassword, btnLogin, forgetCenterLayout])
        
        lbTitle.style.preferredSize = CGSize(width: global_width, height: 100)
        tfUsername.style.preferredSize = CGSize(width: global_width, height: 44)
        tfPassword.style.preferredSize = CGSize(width: global_width, height: 44)
        btnForget.style.preferredSize = CGSize(width: 100, height: 44)
        
        node.addSubnode(self.lbTitle)
        node.addSubnode(self.tfUsername)
        node.addSubnode(self.tfPassword)
        
        return contentStackSpec
    }
    
    func bind_event(){
        btnTypeLogin.addTarget(self, action: #selector(switchTypeRegister), forControlEvents: ASControlNodeEvent.touchDown)
        btnTypeRegister.addTarget(self, action: #selector(switchTypeRegister), forControlEvents: ASControlNodeEvent.touchDown)
    }
    
    override func viewDidLoad() {
        self.bind_event()
    }
    
    override init() {
        super.init(node: rootNode)
        
        let stack = self.init_layout()
        
        node.layoutSpecBlock = { _, _ in
            return ASCenterLayoutSpec(centeringOptions: .XY,
                                      sizingOptions: [],
                                      child: stack)
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
        
        if btnTypeRegister.isSelected {
            
        }
        else if btnLogin.isSelected {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    var btnTypeRegister:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("登入", comment:"")
        
        let attr: [NSAttributedString.Key : Any] = [
           .foregroundColor: UIColor.white,
           .font: UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        
        button.setTitle(title, with: nil, with: .white, for: UIControl.State.selected)
        button.setTitle(title, with: nil, with: .gray, for: UIControl.State.normal)
        
        button.isSelected = false
        return button
    }()
    
    
    var btnTypeLogin:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("註冊", comment:"")

        let attr: [NSAttributedString.Key : Any] = [
           .foregroundColor: UIColor.white,
           .font: UIFont(name: "HelveticaNeue-Bold", size: 16)!
        ]
        button.setTitle(title, with: nil, with: .white, for: UIControl.State.selected)
        button.setTitle(title, with: nil, with: .gray, for: UIControl.State.normal)
        

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
        paragraphStyle.paragraphSpacing = 20
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30),
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        label.attributedText = NSAttributedString.init(string: "批踢踢實業坊\nPtt.cc", attributes: attributes)
        label.backgroundColor = GlobalAppearance.backgroundColor
        return label
    }()
    
    lazy var tfUsername:ASEditableTextNode = {
        let textField = ASEditableTextNode()
        let title = NSLocalizedString("User Id", comment: "")
        let attr = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        textField.attributedPlaceholderText = NSAttributedString.init(string: title, attributes:attr)
        //textField.placeholder = NSLocalizedString("User Id", comment:"")
        textField.backgroundColor = self.textfield_backgroundcolor
        return textField
    }()

    
    lazy var tfPassword = ASDisplayNode.init { () -> UIView in
        var textField:UITextField = UITextField()
        let title = NSLocalizedString("Password", comment: "")
        let attr = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString.init(string: title, attributes:attr)
        textField.backgroundColor = self.textfield_backgroundcolor

        return textField
    }

    
    var btnLogin:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("Login", comment:"")
        let attr = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        button.titleNode.attributedText = NSAttributedString.init(string: title, attributes: attr)
        return button
    }()

    var btnForget:ASButtonNode = {
        let button = ASButtonNode()
        let title = NSLocalizedString("Forget", comment:"")
        let attr = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
        ]
        button.titleNode.attributedText = NSAttributedString.init(string: title, attributes: attr)
        return button
    }()
    
    var textfield_backgroundcolor : UIColor? {
        if #available(iOS 11.0, *) {
            return UIColor(red: 42/255, green: 42/255, blue: 48/255, alpha: 1.0)
            //return UIColor(named: "tintColor-42-42-48")
        } else {
            return UIColor(red: 42/255, green: 42/255, blue: 48/255, alpha: 1.0)
        }
    }
    
}
