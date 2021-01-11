//
//  PopularBoardsSceneFactoryProtocol.swift
//  Ptt
//
//  Created by marcus fu on 2021/1/7.
//  Copyright © 2021 Ptt. All rights reserved.
//

protocol PopularBoardsSceneFactoryProtocol: BoardSceneFactoryProtocol {
    func makePopularBoardsView() -> PopularBoardsView
}
