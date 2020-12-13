//
//  SceneFactory.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/12.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation

final class SceneFactory: FavoriteSceneFactoryProtocol,
                          HotTopicSceneFactoryProtocol {
    
    func makeFavoriteView() -> FavoriteView {
        let favoriteViewController = FavoriteViewController()
        return favoriteViewController
    }
    
    func makeHotTopicView() -> HotTopicView {
        let hotTopicViewController = HotTopicViewController()
        return hotTopicViewController
    }
        
    func makeBoardView(withBoardName boardName: String) -> BoardView {
        return BoardViewController(boardName: boardName)
    }
    
    func makePostView(withBoardPost boardPost: BoardPost) -> PostView {
        return PostViewController(post: boardPost.post, boardName: boardPost.boardName)
    }
}
