//
//  FBPageViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/4/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit
import WebKit

protocol FBPageView: BaseView {}

final class FBPageViewController: UIViewController, FBPageView {

    private let webView = WKWebView()
    private let webProgressView = UIProgressView(progressViewStyle: .bar)
    private var webViewProgressObservation : NSKeyValueObservation!

    private lazy var backItem : UIBarButtonItem = {
        if #available(iOS 13.0, *) {
            return UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back))
        } else {
            if let systemItem = UIBarButtonItem.SystemItem(rawValue: 101) {
                return UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(back))
            }
            return UIBarButtonItem(title: "←", style: .plain, target: self, action: #selector(back))
        }
    }()
    private lazy var forwardItem : UIBarButtonItem = {
        if #available(iOS 13.0, *) {
            return UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(forward))
        } else {
            if let systemItem = UIBarButtonItem.SystemItem(rawValue: 102) {
                return UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: #selector(forward))
            }
            return UIBarButtonItem(title: "→", style: .plain, target: self, action: #selector(forward))
        }
    }()

    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = L10n.pttfbPage
        self.navigationController?.fixBarColor()
        if #available(iOS 15, *) {
            // Fix tab bar color when scrolling to bottom
            // Do not override with UITabBarAppearance, so we can still enjoy the default design benefits of iOS 15 SDK in other tabs.
            // Ex. For similar reason: https://github.com/Ptt-official-app/Ptt-iOS/pull/39#pullrequestreview-830323041
            webView.backgroundColor = PttColors.codGray.color
            webView.isOpaque = false
        }

        if #available(iOS 11.0, *) {
            // will change contentInset later
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = true
            webView.scrollView.decelerationRate = .normal
        }
        navigationController?.navigationBar.ptt_add(subviews: [webProgressView])
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[webProgressView]-0-|", options: [], metrics: nil, views: ["webProgressView": webProgressView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[webProgressView(2)]-0-|", options: [], metrics: nil, views: ["webProgressView": webProgressView])
        NSLayoutConstraint.activate(constraints)
        webViewProgressObservation = webView.observe(\.estimatedProgress, options: [.new], changeHandler: { (webView, change) in
            guard let progress = change.newValue else { return }
            switch progress {
            case 1.0:
                self.webProgressView.setProgress(Float(progress), animated: false)
                UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseIn, animations: {
                    self.webProgressView.alpha = 0
                }) { (isFinished) in
                    self.webProgressView.setProgress(0, animated: false)
                }
            default:
                self.webProgressView.setProgress(Float(progress), animated: true)
                self.webProgressView.alpha = 1.0
            }
        })

        backItem.isEnabled = false
        forwardItem.isEnabled = false
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        navigationItem.leftBarButtonItems = [backItem, forwardItem]
        navigationItem.rightBarButtonItem = refreshItem

        refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webProgressView.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webProgressView.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if #available(iOS 11.0, *) {
            let insects = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
            webView.scrollView.contentInset = insects
            if #available(iOS 12.0, *) {
            } else {
                webView.scrollView.scrollIndicatorInsets = insects
            }
        }
    }

    @objc private func back() {
        webView.goBack()
    }

    @objc private func forward() {
        webView.goForward()
    }

    @objc private func refresh() {
        if webView.url == nil {
            if let url = URL(string: "https://www.facebook.com/PttTW/") {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        } else {
            webView.reload()
        }
    }
}

extension FBPageViewController : WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else { return }
        var resultUrl : URL? = nil
        switch url {
        // lm for mobile, l for desktop (iPadOS)
        case let url where url.host == "lm.facebook.com" || url.host == "l.facebook.com":
            if let urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let queryItems = urlComponent.queryItems {
                for queryItem in queryItems {
                    if queryItem.name == "u",
                        let queryUrlString = queryItem.value, let queryUrl = URL(string: queryUrlString) {
                        resultUrl = queryUrl
                        break
                    }
                }
            }
        default:
            resultUrl = url
        }
        if let resultUrl = resultUrl, APIModel.FullArticle.isPttArticle(url: resultUrl) {
            let articleViewController = ArticleViewController(url: resultUrl)
            show(articleViewController, sender: self)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backItem.isEnabled = webView.canGoBack
        forwardItem.isEnabled = webView.canGoForward
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: L10n.error, message: error.localizedDescription, preferredStyle: .alert)
        let confirm = UIAlertAction(title: L10n.confirm, style: .default, handler: nil)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
}
