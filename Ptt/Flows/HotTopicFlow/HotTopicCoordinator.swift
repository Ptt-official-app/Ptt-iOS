//
//  HotTopicCoordinator.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/12.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

class HotTopicCoordinator: BaseCoordinator {
    
    private let factory: HotTopicSceneFactoryProtocol
    private let coordinatoryFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(router: Routerable, factory: HotTopicSceneFactoryProtocol, coordinatoryFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.factory = factory
        self.coordinatoryFactory = coordinatoryFactory
    }
    
    override func start() {
        showHotTopicView()
    }
}

// MARK: - Private

private extension HotTopicCoordinator {
    
    func showHotTopicView() {
        let hotTopicView = factory.makeHotTopicView()
        router.setRootModule(hotTopicView)
    }
}
