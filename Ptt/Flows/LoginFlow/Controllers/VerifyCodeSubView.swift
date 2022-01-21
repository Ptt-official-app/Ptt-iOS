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
        lbVerifyCodeTitle
        tfVerifyCode
        lbVerifyCodeResponse
        lbVerifyCodeTimer
        btnVerifyCodeBack
        btnVerifyCodeNotReceive
        
        
        lbVerifyCodeTitle.style.preferredSize = CGSize(width: global_width, height: 66)
        tfVerifyCode.style.preferredSize = CGSize(width: global_width, height: 30)
        lbVerifyCodeResponse.style.preferredSize = CGSize(width: global_width/4*3, height: 44)
        lbVerifyCodeTimer.style.preferredSize = CGSize(width: global_width/4, height: 44)
        btnVerifyCodeBack.style.preferredSize = CGSize(width: global_width/2, height: 30)
        btnVerifyCodeNotReceive.style.preferredSize = CGSize(width: global_width/2, height: 30)
        
        let horiLine1 = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 0,
                                                    justifyContent: .center,
                                          alignItems: .end,
                                                   children: [lbVerifyCodeResponse, lbVerifyCodeTimer])
        
        let horiLine2 = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [btnVerifyCodeBack, btnVerifyCodeNotReceive])
        
        
        
        let vertLine = ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [lbVerifyCodeTitle, tfVerifyCode, horiLine1, horiLine2])
        
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
}

