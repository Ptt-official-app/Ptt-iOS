//
//  LoginSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/9.
//  Copyright © 2022 Ptt. All rights reserved.
//

import Foundation


extension LoginViewController {

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
