//
//  UserInfoCoordinator.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/22.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

class UserInfoCoordinator: BaseCoordinator {

    private let factory: UserInfoSceneFactoryProtocol
    private let coordinatoryFactory: CoordinatorFactoryProtocol
    private let router: Routerable

    init(
        router: Routerable,
        factory: UserInfoSceneFactoryProtocol,
        coordinatoryFactory: CoordinatorFactoryProtocol
    ) {
        self.router = router
        self.factory = factory
        self.coordinatoryFactory = coordinatoryFactory
    }

    override func start() {
        showUserInfoView()
    }
}

// MARK: - Private

private extension UserInfoCoordinator {

    func showUserInfoView() {
        let view = factory.makeUserInfoView()

//        boardListView.onBoardSelect = { [unowned self] boardName in
//            self.runBoardFlow(withBoardName: boardName)
//        }
//
//        boardListView.onLogout = { [unowned self] () in
//            self.removeDependency(self)
//            self.finshFlow?()
//        }

        router.setRootModule(view)
    }
}
