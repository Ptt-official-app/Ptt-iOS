//
//  FullscreenSwipeBack.swift
//  Ptt
//
//  Created by denkeni on 2020/11/17.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit

@available(iOS, deprecated: 26.0, message: "Fullscreen swipe-back is built-in since iOS 26. Use UINavigationController.interactiveContentPopGestureRecognizer instead.")
protocol FullscreenSwipeable: UIViewController {

    func enableFullscreenSwipeBack()
}

extension FullscreenSwipeable {

    func enableFullscreenSwipeBack() {
        if #available(iOS 26.0, *) {
            return
        }
        guard let target = self.navigationController?.interactivePopGestureRecognizer?.delegate else { return }
        let selector = NSSelectorFromString("handleNavigationTransition:")
        if target.responds(to: selector) {
            let panGestureRecognizer = UIPanGestureRecognizer(
                target: self.navigationController?.interactivePopGestureRecognizer?.delegate,
                action: selector
            )
            panGestureRecognizer.delegate = self
            self.view.addGestureRecognizer(panGestureRecognizer)
        }
    }
}

extension UIViewController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let translation = panGestureRecognizer.translation(in: panGestureRecognizer.view)
        if translation.x <= 0 {
            return false
        }
        return true
    }
}
