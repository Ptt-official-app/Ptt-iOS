//
//  FillInformationSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/23.
//  Copyright © 2022 Ptt. All rights reserved.
//
import Foundation
import AsyncDisplayKit
import UIKit

extension LoginViewController {
    
    func initFillInformationViews() {
        lbFillTitle.style.preferredSize = CGSize(width: global_width, height: 55)
        
        tfFillRealName.style.preferredSize = CGSize(width: global_width/2, height: 30)
        tfFillBirthday.style.preferredSize = CGSize(width: global_width/2, height: 30)
        tfFillAddress.style.preferredSize = CGSize(width: global_width, height: 30)
        
        lbNeedReason.style.preferredSize = CGSize(width: global_width/2, height: 30)
        btnOpenAccount.style.preferredSize = CGSize(width: global_width/2, height: 30)
        
        
        let horiLine1 = ASStackLayoutSpec(direction: .horizontal,
                                                                  spacing: 0,
                                                                  justifyContent: .center,
                                                                  alignItems: .center,
                                                                  children: [tfFillRealName, tfFillBirthday])
        let addressInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0), child: tfFillAddress)
        
        let horiLine2 = ASStackLayoutSpec(direction: .horizontal,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [lbNeedReason, btnOpenAccount])
        
        

        
        let vertLine = ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [lbFillTitle, horiLine1,
                                                              addressInset, horiLine2])
        
        fillInformationStackSpec = ASCenterLayoutSpec(centeringOptions: ASCenterLayoutSpecCenteringOptions.X, sizingOptions: ASCenterLayoutSpecSizingOptions.minimumY, child: vertLine)
        
        
        self.node.addSubnode(lbFillTitle)
        self.node.addSubnode(tfFillRealName)
        self.node.addSubnode(tfFillBirthday)
        self.node.addSubnode(tfFillAddress)
        self.node.addSubnode(lbNeedReason)
        self.node.addSubnode(btnOpenAccount)
    }
    
    
    func toggleFillInformationView(isHidden:Bool){
        lbFillTitle.isHidden = isHidden
        tfFillRealName.isHidden = isHidden
        tfFillBirthday.isHidden = isHidden
        tfFillAddress.isHidden = isHidden
        lbNeedReason.isHidden = isHidden
        btnOpenAccount.isHidden = isHidden
    }

}
