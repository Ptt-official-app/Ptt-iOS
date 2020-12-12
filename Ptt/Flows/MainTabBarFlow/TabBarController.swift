//
//  TabBarController.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

private enum Tab: Int {
    case favorite = 0
    case hotTopic
}

final class TabBarController: UITabBarController, UITabBarControllerDelegate, TabBarView {
    
    // MARK: - Properties

    var onViewDidLoad: ((UINavigationController) -> Void)?
    var onFavoriteFlowSelect: ((UINavigationController) -> Void)?
    var onHotTopicFlowSelect: ((UINavigationController) -> Void)?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        if let controller = customizableViewControllers?.first as? UINavigationController {
            onViewDidLoad?(controller)
        }
    }
    
    // MARK: - UITabBarControllerDelegate
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController,
              let tab = Tab(rawValue: selectedIndex) else { return }
        
        switch tab {
        case .favorite:
            onFavoriteFlowSelect?(controller)
        case .hotTopic:
            onHotTopicFlowSelect?(controller)
        }
    }
}
