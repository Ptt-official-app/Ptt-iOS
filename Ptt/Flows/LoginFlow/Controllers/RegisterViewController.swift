import Foundation
import UIKit
import WebKit

protocol RegisterView: BaseView {}

final class RegisterViewController: UIViewController, RegisterView {

    private let webView = WKWebView()
    private let webProgressView = UIProgressView(progressViewStyle: .bar)
    private var webViewProgressObservation : NSKeyValueObservation!

    override func loadView() {
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("Register", comment: "");
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

        refresh()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webProgressView.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webProgressView.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
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
            if let url = URL(string: UserDefaultsManager.address() + "/register") {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        } else {
            webView.reload()
        }
    }
}

extension RegisterViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        let confirm = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .default, handler: nil)
        alert.addAction(confirm)
        self.present(alert, animated: true, completion: nil)
    }
}

