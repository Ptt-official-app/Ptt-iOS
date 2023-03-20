//
//  CoordinatorFactoryProtocol.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

protocol CoordinatorFactoryProtocol {
    func makeTabbarCoordinator() -> (coordinator: Coordinatorable, toPresent: Presentable?)
    func makePopularArticleCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeFBPageCoordinator(navigationController: UINavigationController?) -> Coordinatorable
    func makeBoardListCoordinator(
        navigationController: UINavigationController?,
        listType: BoardListViewModel.ListType
    ) -> Coordinatorable
}
