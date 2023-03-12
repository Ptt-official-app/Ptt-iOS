//
//  BoardListCoordinator.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/12.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

class BoardListCoordinator: BaseCoordinator {

    private let factory: BoardListSceneFactoryProtocol & BoardSceneFactoryProtocol
    private let coordinatoryFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    private let listType: BoardListViewModel.ListType

    init(
        router: Routerable,
        factory: BoardListSceneFactoryProtocol,
        coordinatoryFactory: CoordinatorFactoryProtocol,
        listType: BoardListViewModel.ListType
    ) {
        self.router = router
        self.factory = factory
        self.coordinatoryFactory = coordinatoryFactory
        self.listType = listType
    }

    override func start() {
        showBoardListView()
    }
}

// MARK: - Private

private extension BoardListCoordinator {

    func showBoardListView() {
        let boardListView = factory.makeBoardListView(listType: listType)

        boardListView.onBoardSelect = { [unowned self] (boardName) in
            self.runBoardFlow(withBoardName: boardName)
        }

        boardListView.onLogout = { [unowned self] () in
            self.removeDependency(self)
            self.finshFlow?()
        }

        router.setRootModule(boardListView)
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
