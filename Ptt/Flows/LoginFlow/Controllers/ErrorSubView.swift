//  swiftlint:disable:this file_name
//  ErrorSubView.swift
//  Ptt
//
//  Created by You Gang Kuo on 2022/1/21.
//  Copyright © 2022 Ptt. All rights reserved.
//

import UIKit

extension LoginViewController {

    func initErrorViews() {
        let viewsDict = ["lbError": lbError]
        switchContentView.ptt_add(subviews: [lbError])
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(50)-[lbError(100)]", metrics: nil, views: viewsDict)
        constraints += [
            lbError.leadingAnchor.constraint(equalTo: switchContentView.leadingAnchor),
            lbError.trailingAnchor.constraint(equalTo: switchContentView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func getErrorAttr() -> [NSAttributedString.Key: Any] {
        return [.foregroundColor: PttColors.paleGrey.color,
            .font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        ]
    }

    func getErrorView() -> UILabel {
        let label = UILabel()
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
