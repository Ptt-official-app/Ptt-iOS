//
//  UIViewController+Extension.swift
//  Ptt
//
//  Created by 陳建佑 on 2023/12/9.
//  Copyright © 2023 Ptt. All rights reserved.
//

import UIKit

extension UIViewController {
    func addLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        [
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ].active()
    }

    func removeLoadingView() {
        let loadingView = view.subviews.first(where: { $0 is LoadingView })
        loadingView?.removeFromSuperview()
    }

    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: L10n.error, message: message, preferredStyle: .alert)

        let confirm = UIAlertAction(title: L10n.confirm, style: .default)
        [confirm].forEach(alert.addAction)
        present(alert, animated: true)
    }
}
