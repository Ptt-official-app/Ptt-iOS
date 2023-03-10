//
//  CoordinatorFactory.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

final class CoordinatorFactory: CoordinatorFactoryProtocol {

    func makeTabbarCoordinator() -> (coordinator: Coordinatorable, toPresent: Presentable?) {
        let controller = TabBarController()
        let coordinator = TabBarCoordinator(tabBarView: controller, coordinatorFactory: CoordinatorFactory())
        return (coordinator, controller)
    }

    func makeFavoriteCoordinator(navigationController: UINavigationController?) -> Coordinatorable {
        let coordinator = FavoriteCoordinator(router: router(navigationController),
                                              factory: SceneFactory(),
                                              coordinatoryFactory: CoordinatorFactory())
        return coordinator
    }

    func makeFBPageCoordinator(navigationController: UINavigationController?) -> Coordinatorable {
        let coordinator = FBPageCoordinator(router: router(navigationController),
                                            factory: SceneFactory(),
                                            coordinatoryFactory: CoordinatorFactory())
        return coordinator
    }

    func makePopularBoardsCoordinator(navigationController: UINavigationController?) -> Coordinatorable {
        let coordinator = PopularBoardsCoordinator(router: router(navigationController),
                                              factory: SceneFactory(),
                                              coordinatoryFactory: CoordinatorFactory())
        return coordinator
    }

    func makePopularArticleCoordinator(navigationController: UINavigationController?) -> Coordinatorable {
        let coordinator = PopularArticlesCoordinator(router: router(navigationController),
                                                     factory: SceneFactory(),
                                                     coordinatorFactory: CoordinatorFactory())
        return coordinator
    }

    func makeLoginCoordinator(router: Router) -> Coordinatorable {
        let coordinator = LoginCoordinator(router: router,
                                              factory: SceneFactory(),
                                              coordinatoryFactory: CoordinatorFactory())
        return coordinator
    }
}

private extension CoordinatorFactory {

    func router(_ navigationController: UINavigationController?) -> Routerable {
        return Router(rootController: self.navigationController(navigationController))
    }

    func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        if let navController = navController {
            return navController
        } else {
            return UINavigationController()
        }
    }
}
