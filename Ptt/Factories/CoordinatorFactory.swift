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

    func makeBoardListCoordinator(
        navigationController: UINavigationController?,
        listType: BoardListViewModel.ListType
    ) -> Coordinatorable {
        let coordinator = BoardListCoordinator(
            router: router(navigationController),
            factory: SceneFactory(),
            coordinatoryFactory: CoordinatorFactory(),
            listType: listType
        )
        return coordinator
    }

    func makeFBPageCoordinator(navigationController: UINavigationController?) -> Coordinatorable {
        let coordinator = FBPageCoordinator(router: router(navigationController),
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

    func makeProfileCoordinator(navigationController: UINavigationController?) -> Coordinatorable {
        ProfileCoordinator(
            router: router(navigationController),
            factory: SceneFactory(),
            coordinatoryFactory: CoordinatorFactory()
        )
    }

    func makeLoginCoordinator(router: Router) -> Coordinatorable {
        let coordinator = LoginCoordinator(
            router: router,
            factory: SceneFactory(),
            coordinatoryFactory: CoordinatorFactory()
        )
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
