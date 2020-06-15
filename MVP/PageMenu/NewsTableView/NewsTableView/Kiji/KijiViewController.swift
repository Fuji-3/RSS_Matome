//
//  KijiViewController.swift
//  RSS_Matome
//
//  Created by Kimisira on 2020/06/14.
//  Copyright © 2020年 Kimisira. All rights reserved.
//

import UIKit
import WebKit

class KijiViewController: UIViewController {
    let webView = WKWebView()

    var backButton: UIButton!
    var forwadButton: UIButton!
    var exitButton: UIButton!

    var newsURL: String!

    init(newsURL: String) {
        super.init(nibName: nil, bundle: nil)
        self.newsURL = newsURL
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.frame = view.frame
        webView.navigationDelegate = self
        webView.uiDelegate = self

        webView.allowsBackForwardNavigationGestures = true

        let urlRequest = URLRequest(url: URL(string: self.newsURL)!)
        webView.load(urlRequest)
        view.addSubview(webView)

        self.creatWebViewButton()
    }
}
//ボタン
extension KijiViewController {
    func creatWebViewButton() {
        let buttonSize = CGSize(width: 40, height: 40)
        let offseetUnderButton: CGFloat = 60

        let yPos = (UIScreen.main.bounds.height - offseetUnderButton)
        let buuttonPadding: CGFloat = 10

        let backButtonPos = CGPoint(x: buuttonPadding, y: yPos)
        let forwardButtonPos = CGPoint(x: (buuttonPadding + buttonSize.width + buuttonPadding), y: yPos)

        exitButton = UIButton(frame: CGRect(x: 15, y: 15, width: 40, height: 40))

        backButton = UIButton(frame: CGRect(origin: backButtonPos, size: buttonSize))
        forwadButton = UIButton(frame: CGRect(origin: forwardButtonPos, size: buttonSize))

        backButton.setTitle("<", for: .normal)
        backButton.setTitle(">", for: .highlighted)
        backButton.setTitleColor(.white, for: .normal)
        backButton.layer.backgroundColor = UIColor.black.cgColor
        backButton.layer.opacity = 0.6
        backButton.layer.cornerRadius = 5.0
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.isHidden = true
        view.addSubview(backButton)

        forwadButton.setTitle(">", for: .normal)
        forwadButton.setTitle("<", for: .highlighted)
        forwadButton.setTitleColor(.white, for: .normal)
        forwadButton.layer.backgroundColor = UIColor.black.cgColor
        forwadButton.layer.opacity = 0.6
        forwadButton.layer.cornerRadius = 5.0
        forwadButton.addTarget(self, action: #selector(goForward), for: .touchUpInside)
        forwadButton.isHidden = true
        view.addSubview(forwadButton)

        exitButton.setTitle("x", for: .normal)
        exitButton.setTitleColor(.white, for: .normal)
        exitButton.layer.backgroundColor = UIColor.black.cgColor
        exitButton.layer.opacity = 0.6
        exitButton.layer.cornerRadius = 5.0
        exitButton.addTarget(self, action: #selector(batuButton), for: .touchUpInside)
        exitButton.isHidden = true
        view.addSubview(exitButton)

        webView.scrollView.delegate = self
    }
    @objc private func goBack() {

        webView.goBack()

    }
    @objc private func goForward() {
        webView.goForward()
    }
    @objc private func batuButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
extension KijiViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isHidden = (webView.canGoBack) ? false : true
        forwadButton.isHidden = (webView.canGoBack) ? false : true
    }

}
extension KijiViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension KijiViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        exitButton.isHidden = false
    }
}
