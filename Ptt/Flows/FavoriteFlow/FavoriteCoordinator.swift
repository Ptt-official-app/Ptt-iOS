//
//  FavoriteCoordinator.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/12.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

class FavoriteCoordinator: BaseCoordinator {

    private let factory: FavoriteSceneFactoryProtocol & BoardSceneFactoryProtocol
    private let coordinatoryFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(router: Routerable, factory: FavoriteSceneFactoryProtocol, coordinatoryFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.factory = factory
        self.coordinatoryFactory = coordinatoryFactory
    }
    
    override func start() {
        showFavoriteView()
    }
}

// MARK: - Private

private extension FavoriteCoordinator {
    
    func showFavoriteView() {
        let favoriteView = factory.makeFavoriteView()
        
        favoriteView.onBoardSelect = { [unowned self] (boardName) in
            self.runBoardFlow(withBoardName: boardName)
        }
        
        router.setRootModule(favoriteView)
    }
    
    func runBoardFlow(withBoardName boardName: String) {
        let coordinator = BoardCoordinator(router: router, factory: factory, coordinatoryFactory: coordinatoryFactory)
        addDependency(coordinator)
        coordinator.start(withBoardName: boardName)
    }
}
