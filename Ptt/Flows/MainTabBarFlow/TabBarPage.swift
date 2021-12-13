//
//  TabBarPage.swift
//  Ptt
//
//  Created by 賴彥宇 on 2021/1/9.
//  Copyright © 2021 Ptt. All rights reserved.
//

import UIKit

enum TabBarPage {
    case favorite
    case fbPage
    case settings
    case popular
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .favorite
        case 1:
            self = .fbPage
        case 2:
            self = .popular
        case 3:
            self = .settings
        default:
            return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .favorite:
            return 0
        case .fbPage:
            return 1
        case .popular:
            return 2
        case .settings:
            return 3
        }
    }
    
    
    func pageTitleValue() -> String {
        switch self {
        case .favorite:
            return "Favorite Boards"
        case .fbPage:
            return "FB Page"
        case .settings:
            return "Settings"
        case .popular:
            return "Popular Boards"
        }
    }
    
    func pageIconImage() -> UIImage {
        switch self {
        case .favorite:
            return StyleKit.imageOfFavoriteTabBar()
        case .fbPage:
            return StyleKit.imageOfFBPage()
        case .settings:
            // TODO: update design from Zeplin
            if let gearImage = UIImage(systemName: "gear") {
                return gearImage
            }
            return UIImage()
        case .popular:
            return StyleKit.imageOfPopularBoard()
        }
    }
    // Add tab icon selected / deselected color
    // etc
}
