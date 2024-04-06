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
                          BoardListSceneFactoryProtocol,
                          UserInfoSceneFactoryProtocol {

    func makeLoginView() -> LoginView {
        let loginViewController = LoginViewController()
        return loginViewController
    }

    func makeFBPageView() -> FBPageView {
        let fbPageViewController = FBPageViewController()
        return fbPageViewController
    }

    func makeUserInfoView() -> UserInfoView {
        let uiView = UserInfoUIView(viewModel: UserInfoViewModel())
        let vc = UserInfoVC(rootView: uiView)
        return vc
    }

    func makePopularArticlesView() -> PopularArticlesView {
        let vc = PopularArticlesViewController()
        let viewModel = PopularArticlesViewModel(apiClient: APIClient.shared,
                                                 uiDelegate: vc)
        vc.setup(viewModel: viewModel)
        return vc
    }

    func makeBoardView(withBoardName boardName: String) -> BoardView {
        let boardViewController = BoardViewController(boardName: boardName)
        boardViewController.navigationController?.isToolbarHidden = true
        return boardViewController
    }

    func makeArticleView(withBoardArticle boardArticle: BoardArticle) -> ArticleView {
        let singleArticleViewController = SingleArticleViewController(article: boardArticle)
        singleArticleViewController.navigationController?.isToolbarHidden = false
        return singleArticleViewController
    }

    func makeComposeArticleView(withBoardName boardName: String, postTypes: [String]) -> UIViewController {
        let vm = ComposeArticleViewModel(boardName: boardName, postTypes: postTypes)
        return ComposeArticleViewController(viewModel: vm)
    }

    func makeBoardListView(listType: BoardListViewModel.ListType) -> BoardListView {
        let viewModel = BoardListViewModel(listType: listType)
        let tvc = BoardListTVC(viewModel: viewModel)
        viewModel.uiDelegate = tvc
        return tvc
    }
}
