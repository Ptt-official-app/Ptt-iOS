//
//  TabBarCoordinator.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

class TabBarCoordinator: BaseCoordinator {
    
    private let tabBarView: TabBarView
    private let coordinatorFactory: CoordinatorFactoryProtocol
    
    init(tabBarView: TabBarView, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.tabBarView = tabBarView
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        
    }
}

private extension TabBarCoordinator {
    
    func runFavoriteFlow() -> ((UINavigationController) -> Void) {
        return { navController in
            if navController.viewControllers.isEmpty {
                
            }
        }
    }
}
