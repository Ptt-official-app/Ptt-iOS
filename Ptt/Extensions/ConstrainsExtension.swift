//
//  ConstrainsExtension.swift
//  Ptt
//
//  Created by Anson on 2021/12/9.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation
import UIKit

extension Array where Element: NSLayoutConstraint {
    func active() {
        self.forEach { constraint in
            guard let view = constraint.firstItem as? UIView else { return }
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate(self)
    }
}

extension NSLayoutConstraint {
    func set(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
