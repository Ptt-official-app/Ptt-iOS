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

private extension LoginCoordinator {
    
    func showLoginView() {
        let loginView = factory.makeLoginView()
        
        self.finshFlow = { [unowned self] in
            self.removeDependency(self)
        }
        router.setRootModule(loginView)
    }
}

