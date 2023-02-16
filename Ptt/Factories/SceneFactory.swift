//
//  SceneFactory.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/12/12.
//  Copyright © 2020 Ptt. All rights reserved.
//

import Foundation
import UIKit

final class SceneFactory: FavoriteSceneFactoryProtocol,
                          LoginSceneFactoryProtocol,
                          PopularBoardsSceneFactoryProtocol,
                          FBPageSceneFactoryProtocol,
                          PopularArticlesSceneFactoryProtocol {

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

    func makePopularBoardsView() -> PopularBoardsView {
        let popularBoardsViewController = PopularBoardsViewController()
        return popularBoardsViewController
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
        return ArticleViewController(article: boardArticle.article, boardName: boardArticle.boardName)
    }

    func makeComposeArticleView(withBoardName boardName: String) -> UIViewController {
        return ComposeArticleViewController(boardName: boardName)
    }
}
