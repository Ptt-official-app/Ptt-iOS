//
//  TabBarPage.swift
//  Ptt
//
//  Created by 賴彥宇 on 2021/1/9.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

enum TabBarPage {
    case popular
    case favorite
    case popularArticles
    case profile
    case settings

    init?(index: Int) {
        switch index {
        case 0:
            self = .popular
        case 1:
            self = .favorite
        case 2:
            self = .popularArticles
        case 3:
            self = .profile
        case 4:
            self = .settings
        default:
            return nil
        }
    }
    
    var pageOrderNumber: Int {
        switch self {
        case .popular:
            return 0
        case .favorite:
            return 1
        case .popularArticles:
            return 2
        case .profile:
            return 3
        case .settings:
            return 4
        }
    }
    
    var pageTitleValue: String {
        switch self {
        case .popular:
            return L10n.popularBoards
        case .favorite:
            return L10n.favoriteBoards
        case .popularArticles:
            return L10n.popularArticles
        case .profile:
            return L10n.profilePage
        case .settings:
            return L10n.settings

        }
    }
    
    var pageIconImage: UIImage {
        switch self {
        case .popular:
            return StyleKit.imageOfPopularBoard()
        case .favorite:
            return StyleKit.imageOfFavoriteTabBar()
        case .popularArticles:
            return StyleKit.imageOfHotTopic()
        case .profile:
            return StyleKit.imageOfProfile()
        case .settings:
            // TODO: update design from Zeplin
            if #available(iOS 13.0, *) {
                if let gearImage = UIImage(systemName: "gear") {
                    return gearImage
                }
            }
            return UIImage()
        }
    }
    // Add tab icon selected / deselected color
    // etc
}
