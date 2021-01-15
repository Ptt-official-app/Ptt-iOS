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
    case hotTopic
    
    init?(index: Int) {
        switch index {
        case 0:
            self = .favorite
        case 1:
            self = .hotTopic
        default:
            return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .favorite:
            return 0
        case .hotTopic:
            return 1
        }
    }
    
    
    func pageTitleValue() -> String {
        switch self {
        case .favorite:
            return "Favorite Boards"
        case .hotTopic:
            return "Hot Topics"
        }
    }
    
    func pageIconImage() -> UIImage {
        switch self {
        case .favorite:
            return StyleKit.imageOfFavoriteTabBar()
        case .hotTopic:
            return StyleKit.imageOfHotTopic()
        }
    }
    // Add tab icon selected / deselected color
    // etc
}
