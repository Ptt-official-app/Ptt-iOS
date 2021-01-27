//
//  SceneFactory.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/12.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

final class SceneFactory: FavoriteSceneFactoryProtocol,
                          FBPageSceneFactoryProtocol,
                          LoginSceneFactoryProtocol
                           {
    
    func makeLoginView() -> LoginView {
        let loginViewController = LoginViewController()
        return loginViewController
    }

    func makeFavoriteView() -> FavoriteView {
        let favoriteViewController = FavoriteViewController()
        return favoriteViewController
    }
    
    func makeFBPageView() -> FBPageView {
        let fbPageViewController = FBPageViewController()
        return fbPageViewController
    }
        
    func makeBoardView(withBoardName boardName: String) -> BoardView {
        return BoardViewController(boardName: boardName)
    }
    
    func makePostView(withBoardPost boardPost: BoardPost) -> PostView {
        return PostViewController(post: boardPost.post, boardName: boardPost.boardName)
    }
}
