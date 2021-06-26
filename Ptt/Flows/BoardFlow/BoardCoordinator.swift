//
//  BoardCoordinator.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/13.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

class BoardCoordinator: BaseCoordinator {
    
    private let factory: BoardSceneFactoryProtocol
    private let coordinatoryFactory: CoordinatorFactoryProtocol
    private let router: Routerable
    
    init(router: Routerable, factory: BoardSceneFactoryProtocol, coordinatoryFactory: CoordinatorFactoryProtocol) {
        self.router = router
        self.factory = factory
        self.coordinatoryFactory = coordinatoryFactory
    }
    
    func start(withBoardName boardName: String) {
        showBoardView(withBoardName: boardName)
    }
}

// MARK: - Private

private extension BoardCoordinator {
    
    func showBoardView(withBoardName boardName: String) {
        let boardView = factory.makeBoardView(withBoardName: boardName)
        
        boardView.onArticleSelect = { [weak self] (boardArticle) in
            self?.showArticleView(withBoardArticle: boardArticle)
        }
        
        router.push(boardView, animated: true, hideBottomBar: true) { [weak self] in
            self?.finshFlow?()
        }
    }
    
    func showArticleView(withBoardArticle boardArticle: BoardArticle) {
        let articleView = factory.makeArticleView(withBoardArticle: boardArticle)
        router.push(articleView)
    }
}
