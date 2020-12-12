//
//  TabBarView.swift
//  Ptt
//
//  Created by 賴彥宇 on 2020/11/22.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

protocol TabBarView: class {
    var onViewDidLoad: ((UINavigationController) -> Void)? { get set }
    var onFavoriteFlowSelect: ((UINavigationController) -> Void)? { get set }
    var onHotTopicFlowSelect: ((UINavigationController) -> Void)? { get set }
}
