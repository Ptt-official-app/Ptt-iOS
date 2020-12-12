//
//  CoordinatorFactory.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

final class CoordinatorFactory: CoordinatorFactoryProtocol {
    
    func makeTabbarCoordinator() -> (coordinator: Coordinatorable, toPresent: Presentable?) {
        let controller = TabBarController.controllerFromStoryboard(.main)
        let coordinator = TabBarCoordinator(tabBarView: controller, coordinatorFactory: CoordinatorFactory())
        return (coordinator, controller)
    }
}
