//
//  VerifyCodeSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/21.
//  Copyright © 2022 Ptt. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

extension LoginViewController {
    
    
    func initVerifyCodeViews() {
//        lbVerifyCodeTitle
//        tfVerifyCode
//        lbVerifyCodeResponse
//        lbVerifyCodeTimer
//        btnVerifyCodeBack
//        btnVerifyCodeNotReceive
//
//
        lbVerifyCodeTitle.style.preferredSize = CGSize(width: global_width, height: 66)
        tfVerifyCode.style.preferredSize = CGSize(width: global_width, height: 30)
        
        lbVerifyCodeResponse.style.preferredSize = CGSize(width: global_width, height: 44)
        lbVerifyCodeTimer.style.preferredSize = CGSize(width: global_width, height: 44)
        
        btnVerifyCodeBack.style.preferredSize = CGSize(width: global_width/2, height: 30)
        btnVerifyCodeNotReceive.style.preferredSize = CGSize(width: global_width/2, height: 30)
        
        let tfVerifyCodeInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0), child: tfVerifyCode)
        
        let horiLine1 = ASAbsoluteLayoutSpec(children: [lbVerifyCodeResponse, lbVerifyCodeTimer])
        horiLine1.style.preferredSize = CGSize(width: global_width, height: 44)
//        let horiLine1 = ASAbs(direction: .horizontal,
//                                                   spacing: 0,
//                                                    justifyContent: .center,
//                                          alignItems: .end,
//                                                   children: [lbVerifyCodeResponse, lbVerifyCodeTimer])
        
        let horiLine2 = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [btnVerifyCodeBack, btnVerifyCodeNotReceive])
        
        
        let horiLine2Inset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0), child: horiLine2)
        
        let vertLine = ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [lbVerifyCodeTitle, tfVerifyCodeInset, horiLine1, horiLine2Inset])
        
        verifyStackSpec = ASCenterLayoutSpec(centeringOptions: ASCenterLayoutSpecCenteringOptions.X, sizingOptions: ASCenterLayoutSpecSizingOptions.minimumY, child: vertLine)
        
        self.node.addSubnode(lbVerifyCodeTitle)
        self.node.addSubnode(tfVerifyCode)
        self.node.addSubnode(lbVerifyCodeResponse)
        self.node.addSubnode(lbVerifyCodeTimer)
        self.node.addSubnode(btnVerifyCodeBack)
        self.node.addSubnode(btnVerifyCodeNotReceive)
    }
    
    func toggleVerifyCodeView(isHidden:Bool){
        lbVerifyCodeTitle.isHidden = isHidden
        tfVerifyCode.isHidden = isHidden
        lbVerifyCodeResponse.isHidden = isHidden
        lbVerifyCodeTimer.isHidden = isHidden
        btnVerifyCodeBack.isHidden = isHidden
        btnVerifyCodeNotReceive.isHidden = isHidden
    }
    
    
    func onVerifyCodeFill()
    {
        let tf = tfVerifyCode.view as! LoginTextField
        tf.isEnabled = false ;
        if let user = (self.tfRegisterUsername.view as! LoginTextField).text,
           let email = (self.tfRegisterUsername.view as! LoginTextField).text,
           let password = (self.tfRegisterUsername.view as! LoginTextField).text,
           let token = (self.tfVerifyCode.view as! LoginTextField).text {
            APIClient.shared.register(account: user, email: email, password: password, token: token) { result in
                DispatchQueue.main.async {
                    tf.isEnabled = true
                    (self.tfVerifyCode.view as! LoginTextField).text = "";
                    
                    switch (result) {
                    case .failure(let error):
                        print(error)
                        self.lbVerifyCodeResponse.attributedText = NSAttributedString.init(string: error.message, attributes: nil)
                    case .success(let result):
                        print(result)
                        self.onRegisterSuccess(result: result)
                        self.toggleState(.FillInformation)
                    }
                }
            }
        }
        else {
            showAlert(title: "ERROR", msg: "ERROR data missing-_- ")
        }
    }
    
    func onRegisterSuccess(result:APIModel.Register){
        
    }
    
    @objc func onVerifyCodeBack(){
        print("onVerifyCodeBack")
        toggleState(.AttemptRegister)
    }
    
    @objc func onNotReceive(){
        print("not Receive")
        showAlert(title: "TEMP", msg: "NOT IMPLEMENT YET QQ")
    }
}

