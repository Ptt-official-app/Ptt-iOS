//
//  PorfileCoordinator.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/22.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

class ProfileCoordinator: BaseCoordinator {

    private let factory: ProfileSceneFactoryProtocol
    private let coordinatoryFactory: CoordinatorFactoryProtocol
    private let router: Routerable

    init(
        router: Routerable,
        factory: ProfileSceneFactoryProtocol,
        coordinatoryFactory: CoordinatorFactoryProtocol
    ) {
        self.router = router
        self.factory = factory
        self.coordinatoryFactory = coordinatoryFactory
    }

    override func start() {
        showProfileView()
    }
}

// MARK: - Private

private extension ProfileCoordinator {

    func showProfileView() {
        let boardListView = factory.makeProfileView()

//        boardListView.onBoardSelect = { [unowned self] boardName in
//            self.runBoardFlow(withBoardName: boardName)
//        }
//
//        boardListView.onLogout = { [unowned self] () in
//            self.removeDependency(self)
//            self.finshFlow?()
//        }

        router.setRootModule(boardListView)
    }
}
