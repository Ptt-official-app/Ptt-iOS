//
//  BoardSceneFactoryProtocol.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/13.
//  Copyright © 2020 Ptt. All rights reserved.
//

protocol BoardSceneFactoryProtocol {
    func makeBoardView(withBoardName boardName: String) -> BoardView
    func makePostView(withBoardPost boardPost: BoardPost) -> PostView
}
