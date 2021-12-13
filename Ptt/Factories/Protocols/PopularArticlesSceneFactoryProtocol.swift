//
//  PopularArticlesSceneFactoryProtocol.swift
//  Ptt
//
//  Created by Anson on 2021/12/5.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

protocol PopularArticlesSceneFactoryProtocol: BoardSceneFactoryProtocol {
    func makePopularArticlesView() -> PopularArticlesView
}
