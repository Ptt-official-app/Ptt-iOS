//
//  TabBarController.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

private enum Tab: Int {
    case popularBoards = 0
    case favorite
    case hotTopic
}

final class TabBarController: UITabBarController, UITabBarControllerDelegate, TabBarView {
    
    // MARK: - Properties

    var onViewDidLoad: ((UINavigationController) -> Void)?
    var onFavoriteFlowSelect: ((UINavigationController) -> Void)?
    var onHotTopicFlowSelect: ((UINavigationController) -> Void)?
    var onPopularBoardsFlowSelect: ((UINavigationController) -> Void)?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarItems()
        
        delegate = self
        if let controller = customizableViewControllers?.first as? UINavigationController {
            if #available(iOS 11.0, *) {
                controller.navigationBar.prefersLargeTitles = true
            }
            onViewDidLoad?(controller)
        }
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController,
              let tab = Tab(rawValue: selectedIndex) else { return }
        
        switch tab {
        case .favorite:
            onFavoriteFlowSelect?(controller)
        case .hotTopic:
            onHotTopicFlowSelect?(controller)
        case .popularBoards:
            onPopularBoardsFlowSelect?(controller)
        }
    }
}

private extension TabBarController {
    
    func configureTabBarItems() {
        guard let controllers = customizableViewControllers as? [UINavigationController] else { return }
        
        for (index, controller) in controllers.enumerated() {
            guard let tab = Tab(rawValue: index) else { return }
            
            var localizedString = ""
            var image: UIImage = UIImage()
            
            switch tab {
            case .favorite:
                localizedString = "Favorite Boards123"
                image = StyleKit.imageOfFavoriteTabBar()
            case .hotTopic:
                localizedString = "Hot Topics"
                image = StyleKit.imageOfHotTopic()
            case .popularBoards:
                localizedString = "Popular Boards"
                image = StyleKit.imageOfPopularBoard()
            }
            
            controller.tabBarItem = UITabBarItem(title: NSLocalizedString(localizedString, comment: ""), image: image, tag: index)
        }
    }
}
