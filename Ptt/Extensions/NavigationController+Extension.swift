//
//  NavigationController+Extension.swift
//  Ptt
//
//  Created by Anson on 2021/12/13.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func fixBarColor() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.compactAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
