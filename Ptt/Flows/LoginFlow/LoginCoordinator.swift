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
    
    private let loginView: LoginView
    private let coordinatorFactory: CoordinatorFactoryProtocol

    init(loginView: LoginView, coordinatorFactory: CoordinatorFactoryProtocol) {
        self.loginView = loginView
        self.coordinatorFactory = coordinatorFactory
    }
    
}

// MARK: - Private

private extension LoginCoordinator {
    
    func finishFlow() {
        
    }
}

