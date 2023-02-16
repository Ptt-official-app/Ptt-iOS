//
//  ErrorSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/21.
//  Copyright © 2022 Ptt. All rights reserved.
//

import AsyncDisplayKit
import Foundation
import UIKit

extension LoginViewController {

    func initErrorViews() {
        let errorInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0), child: lbError)

        self.errorStackSpec = ASCenterLayoutSpec(centeringOptions: ASCenterLayoutSpecCenteringOptions.X, sizingOptions: ASCenterLayoutSpecSizingOptions.minimumY, child: ASStackLayoutSpec(direction: .vertical,
                                                   spacing: 0,
                                                   justifyContent: .center,
                                                   alignItems: .center,
                                                   children: [errorInset]))

        lbError.style.preferredSize = CGSize(width: global_width, height: 100)
    }

    func getErrorAttr() -> [NSAttributedString.Key: Any] {
        return [.foregroundColor: PttColors.paleGrey.color,
            .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        ]
    }

    func getErrorView() -> ASTextNode {
        let label = ASTextNode()
        let title = NSAttributedString(string: "Error Message 123 123 123 123 456 456 456 ASDF", attributes: getErrorAttr())
        label.attributedText = title
        return label
    }

    func toggleErrorView(isHidden: Bool) {
        lbError.isHidden = isHidden
    }

    func displayError(message: String) {
        lbError.attributedText = NSAttributedString(string: message, attributes: getErrorAttr())
    }
}
