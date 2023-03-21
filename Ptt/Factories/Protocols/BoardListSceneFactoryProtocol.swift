//
//  BoardListSceneFactoryProtocol.swift
//  Ptt
//
//  Created by AnsonChen on 2023/3/12.
//  Copyright © 2023 Ptt. All rights reserved.
//

import Foundation

protocol BoardListSceneFactoryProtocol: BoardSceneFactoryProtocol {
    func makeBoardListView(listType: BoardListViewModel.ListType) -> BoardListView
}
