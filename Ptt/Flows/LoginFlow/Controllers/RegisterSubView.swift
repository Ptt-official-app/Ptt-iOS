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
}
