//
//  TabBarController.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate, TabBarView {

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        if let controller = customizableViewControllers?.first as? UINavigationController {
            if #available(iOS 11.0, *) {
                controller.navigationBar.prefersLargeTitles = true
            }
        }
    }
}
