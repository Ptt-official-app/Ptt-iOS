//
//  FBPageCoordinator.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/12.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

final class FBPageCoordinator: BaseCoordinator {

    private let factory: FBPageSceneFactoryProtocol
    private let coordinatoryFactory: CoordinatorFactoryProtocol
    private let router: Routerable

    init(router: Routerable, factory: FBPageSceneFactoryProtocol, coordinatoryFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.factory = factory
        self.coordinatoryFactory = coordinatoryFactory
    }

    override func start() {
        showFBPageView()
    }
}

// MARK: - Private

private extension FBPageCoordinator {

    func showFBPageView() {
        let fbPageView = factory.makeFBPageView()
        router.setRootModule(fbPageView)
    }
}
