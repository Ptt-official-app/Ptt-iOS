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
        
        self.loginNode.addSubnode(self.tfUsername)
        self.loginNode.addSubnode(self.tfPassword)
        self.loginNode.addSubnode(self.btnForget)
        self.loginNode.addSubnode(self.btnUserAgreement)
        self.loginNode.addSubnode(self.vLine)
        self.loginNode.bounds = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        
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
}
