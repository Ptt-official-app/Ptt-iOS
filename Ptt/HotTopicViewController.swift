//
//  HotTopicViewController.swift
//  Ptt
//
//  Created by denkeni on 2020/4/9.
//  Copyright © 2020 Ptt. All rights reserved.
//

import UIKit
import WebKit

final class HotTopicViewController: UIViewController {

    private let webView = WKWebView()
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

        if #available(iOS 11.0, *) {
            // will change contentInset later
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = true
            webView.scrollView.decelerationRate = .normal
        }
        let webProgressView = UIProgressView(progressViewStyle: .bar)
        navigationController?.navigationBar.ptt_add(subviews: [webProgressView])
        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[webProgressView]-0-|", options: [], metrics: nil, views: ["webProgressView": webProgressView])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[webProgressView(2)]-0-|", options: [], metrics: nil, views: ["webProgressView": webProgressView])
        NSLayoutConstraint.activate(constraints)
        webViewProgressObservation = webView.observe(\.estimatedProgress, options: [.new], changeHandler: { (webView, change) in
            guard let progress = change.newValue else { return }
            switch progress {
            case 1.0:
                webProgressView.setProgress(Float(progress), animated: false)
                UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseIn, animations: {
                    webProgressView.alpha = 0
                }) { (isFinished) in
                    webProgressView.setProgress(0, animated: false)
                }
            default:
                webProgressView.setProgress(Float(progress), animated: true)
                webProgressView.alpha = 1.0
            }
        })

        backItem.isEnabled = false
        forwardItem.isEnabled = false
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        navigationItem.leftBarButtonItems = [backItem, forwardItem]
        navigationItem.rightBarButtonItem = refreshItem

        refresh()
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
            if let url = URL(string: "https://www.facebook.com/pg/PttTW/posts/") {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        } else {
            webView.reload()
        }
    }
}

extension HotTopicViewController : WKNavigationDelegate {

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
        if let resultUrl = resultUrl, Utility.isPttArticle(url: resultUrl) {
            let postViewController = PostViewController(url: resultUrl)
            show(postViewController, sender: self)
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
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
}
