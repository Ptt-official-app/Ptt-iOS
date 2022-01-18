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
    
    func toggleRegisterView(isHidden:Bool){
        tfRegisterEmail.isHidden = isHidden
        tfRegisterUsername.isHidden = isHidden
        tfRegisterPassword.isHidden = isHidden
    }
}
