//
//  FavoriteSceneFactoryProtocol.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/12.
//  Copyright © 2020 Ptt. All rights reserved.
//

protocol FavoriteSceneFactoryProtocol {
    func makeFavoriteView() -> FavoriteView
    func makeBoardView(withBoardName boardName: String) -> BoardView
}
