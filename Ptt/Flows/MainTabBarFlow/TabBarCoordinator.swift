//
//  TabBarCoordinator.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

protocol TabBarCoordinatorProtocol {
    var tabBarView: TabBarView { get set }

    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorProtocol {

    private let coordinatorFactory: CoordinatorFactoryProtocol

    init(tabBarView: TabBarView, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.tabBarView = tabBarView
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage]
#if DEVELOP // Disable .popularArticles, for now
        pages = [.popular, .favorite, .popularArticles, .profile, .settings]
#else
        pages = [.popular, .favorite, .profile, .settings]
#endif
        Task {
            try? await FavoriteBoardManager.shared.fetchAllFavoriteBoards()
        }
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages
            .sorted(by: { $0.pageOrderNumber < $1.pageOrderNumber })
            .map({ getTabController($0) })

        prepareTabBarController(withTabControllers: controllers)
    }

    // MARK: - TabBarCoordinatorProtocol
    var tabBarView: TabBarView

    func currentPage() -> TabBarPage? {TabBarPage(index: tabBarView.selectedIndex)
    }

    func selectPage(_ page: TabBarPage) {
        tabBarView.selectedIndex = page.pageOrderNumber
    }

    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        tabBarView.selectedIndex = page.pageOrderNumber
    }
}

private extension TabBarCoordinator {

    func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Assign page's controllers
        tabBarView.setViewControllers(tabControllers, animated: true)
        /// Let set index
        tabBarView.selectedIndex = TabBarPage.favorite.pageOrderNumber
    }

    func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        navController.tabBarItem = UITabBarItem(title: page.pageTitleValue,
                                                image: page.pageIconImage,
                                                tag: page.pageOrderNumber)
        switch page {
        case .favorite:
            let coordinator = coordinatorFactory.makeBoardListCoordinator(
                navigationController: navController,
                listType: .favorite
            )
            addDependency(coordinator)
            (coordinator as? BoardListCoordinator)?.finshFlow = { [unowned self] () in
                print("temp logout flow in FavoriteCoordinator")
                removeDependency(self)
                self.finshFlow?() // tab bar's finish flow
            }
            coordinator.start()
        case .profile:
            let coordinator = coordinatorFactory.makeUserInfoCoordinator(navigationController: navController)
            addDependency(coordinator)
            coordinator.start()
        case .settings:
            let settingsViewController: SettingsViewController
            if #available(iOS 13.0, *) {
                settingsViewController = SettingsViewController(style: .insetGrouped)
            } else {
                settingsViewController = SettingsViewController(style: .grouped)
            }
            navController.setViewControllers([settingsViewController], animated: false)
        case .popular:
            let coordinator = coordinatorFactory.makeBoardListCoordinator(
                navigationController: navController,
                listType: .popular
            )
            addDependency(coordinator)
            coordinator.start()
        case .popularArticles:
            let coordinator = self.coordinatorFactory.makePopularArticleCoordinator(navigationController: navController)
            self.addDependency(coordinator)
            coordinator.start()
        }
        return navController
    }
}
