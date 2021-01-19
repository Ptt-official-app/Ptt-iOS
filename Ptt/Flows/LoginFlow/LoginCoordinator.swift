//
//  LoginCoordinator.swift
//  Ptt
//
//  Created by You Gang Kuo on 2021/1/2.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation


import UIKit

class LoginCoordinator: BaseCoordinator {
    
    private let factory: LoginSceneFactoryProtocol
    private let coordinatoryFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(router: Routerable, factory: LoginSceneFactoryProtocol, coordinatoryFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.factory = factory
        self.coordinatoryFactory = coordinatoryFactory
    }
    
    override func start() {
        showLoginView()
    }
}

// MARK: - Private

extension LoginCoordinator {

    func showLoginView() {
        let loginView = factory.makeLoginView()
        
        // self.finshFlow =
        loginView.finishFlow = { [unowned self] in
            print("run finish flow")
            self.removeDependency(self)
            let (coordinator, module) = coordinatoryFactory.makeTabbarCoordinator()
            addDependency(coordinator)
            router.setRootModule(module, hideBar: true)
            coordinator.start()
        }
        
        router.setRootModule(loginView, hideBar: true)
    }
}

