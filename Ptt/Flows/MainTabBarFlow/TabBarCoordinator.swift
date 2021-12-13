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
        let pages: [TabBarPage] = [.favorite, .fbPage, .settings, .popular]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    // MARK: - TabBarCoordinatorProtocol
    var tabBarView: TabBarView
    
    func currentPage() -> TabBarPage? {
        TabBarPage.init(index: tabBarView.selectedIndex)
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarView.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarView.selectedIndex = page.pageOrderNumber()
    }
}

private extension TabBarCoordinator {
    
    func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Assign page's controllers
        tabBarView.setViewControllers(tabControllers, animated: true)
        /// Let set index
        tabBarView.selectedIndex = TabBarPage.favorite.pageOrderNumber()
    }
    
    func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)
        navController.tabBarItem = UITabBarItem(title: NSLocalizedString(page.pageTitleValue(), comment: ""),
                                                image: page.pageIconImage(),
                                                tag: page.pageOrderNumber())
        
        switch page {
        case .favorite:
            let favoriteCoordinator = self.coordinatorFactory.makeFavoriteCoordinator(navigationController: navController)
            self.addDependency(favoriteCoordinator)
            
            (favoriteCoordinator as? FavoriteCoordinator)?.finshFlow = { [unowned self] () in
                print("temp logout flow in FavoriteCoordinator")
                removeDependency(self)
                self.finshFlow?() // tab bar's finish flow
            }
            
            favoriteCoordinator.start()
        case .fbPage:
            let fbPageCoordinator = self.coordinatorFactory.makeFBPageCoordinator(navigationController: navController)
            self.addDependency(fbPageCoordinator)
            fbPageCoordinator.start()
        case .settings:
            let settingsViewController : SettingsViewController
            settingsViewController = SettingsViewController(style: .insetGrouped)
            navController.setViewControllers([settingsViewController], animated: false)
        case .popular:
            let popularCoordinator = self.coordinatorFactory.makePopularBoardsCoordinator(navigationController: navController)
            self.addDependency(popularCoordinator)
            popularCoordinator.start()
        }
        
        return navController
    }
}
