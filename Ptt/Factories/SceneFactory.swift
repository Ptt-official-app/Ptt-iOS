//
//  SceneFactory.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/12.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
import UIKit

final class SceneFactory: LoginSceneFactoryProtocol,
                          FBPageSceneFactoryProtocol,
                          PopularArticlesSceneFactoryProtocol,
                          BoardListSceneFactoryProtocol {
    
    func makeLoginView() -> LoginView {
        let loginViewController = LoginViewController()
        return loginViewController
    }
    
    func makeFBPageView() -> FBPageView {
        let fbPageViewController = FBPageViewController()
        return fbPageViewController
    }

    func makePopularArticlesView() -> PopularArticlesView {
        let vc = PopularArticlesViewController()
        let viewModel = PopularArticlesViewModel(apiClient: APIClient.shared,
                                                 uiDelegate: vc)
        vc.setup(viewModel: viewModel)
        return vc
    }

    func makeBoardView(withBoardName boardName: String) -> BoardView {
        return BoardViewController(boardName: boardName)
    }

    func makeArticleView(withBoardArticle boardArticle: BoardArticle) -> ArticleView {
        return SingleArticleViewController(article: boardArticle)
    }

    func makeComposeArticleView(withBoardName boardName: String) -> UIViewController {
        return ComposeArticleViewController(boardName: boardName)
    }

    func makeBoardListView(listType: BoardListViewModel.ListType) -> BoardListView {
        let viewModel = BoardListViewModel(listType: listType)
        let tvc = BoardListTVC(viewModel: viewModel)
        viewModel.uiDelegate = tvc
        return tvc
    }
}
