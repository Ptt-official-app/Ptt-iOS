//
//  FullscreenSwipeBack.swift
//  Ptt
//
//  Created by denkeni on 2020/11/17.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

protocol FullscreenSwipeable : UIViewController {

    func enableFullscreenSwipeBack()
}

extension FullscreenSwipeable where Self: UIViewController {

    func enableFullscreenSwipeBack() {
        guard let target = self.navigationController?.interactivePopGestureRecognizer?.delegate else { return }
        let selector = NSSelectorFromString("handleNavigationTransition:")
        if target.responds(to: selector) {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self.navigationController?.interactivePopGestureRecognizer?.delegate, action: selector)
            self.view.addGestureRecognizer(panGestureRecognizer)
        }
    }
}
