//
//  CoordinatorFactoryProtocol.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    func makeTabbarCoordinator() -> (coordinator: Coordinatorable, toPresent: Presentable?)
}
