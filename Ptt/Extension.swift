//
//  Extension.swift
//  Ptt
//
//  Created by denkeni on 2020/3/27.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

extension UIView {

    func ptt_add(subviews: [UIView]) {
        for subview in subviews {
            subview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
        }
    }
}
