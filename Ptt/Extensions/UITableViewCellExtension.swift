//
//  UITableViewCellExtension.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/10.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var cellID: String {
        String(describing: self)
    }
}
