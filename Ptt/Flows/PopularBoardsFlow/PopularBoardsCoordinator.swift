//
//  PopularBoardsCoordinator.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/7.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

class PopularBoardsCoordinator: BaseCoordinator {

    private let factory: PopularBoardsSceneFactoryProtocol & BoardSceneFactoryProtocol
    private let coordinatoryFactory: CoordinatorFactoryProtocol
    private let router: Routerable

    init(router: Routerable, factory: PopularBoardsSceneFactoryProtocol, coordinatoryFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.factory = factory
        self.coordinatoryFactory = coordinatoryFactory
    }

    override func start() {
        showPopularBoardsView()
    }
}

// MARK: - Private

private extension PopularBoardsCoordinator {

    func showPopularBoardsView() {
        let popularBoardsView = factory.makePopularBoardsView()

        popularBoardsView.onBoardSelect = { [unowned self] (boardName) in
            self.runBoardFlow(withBoardName: boardName)
        }

        router.setRootModule(popularBoardsView)
    }

    func runBoardFlow(withBoardName boardName: String) {
        let coordinator = BoardCoordinator(router: router, factory: factory, coordinatoryFactory: coordinatoryFactory)

        coordinator.finshFlow = { [unowned self] in
            self.removeDependency(coordinator)
        }

        addDependency(coordinator)
        coordinator.start(withBoardName: boardName)
    }
}
