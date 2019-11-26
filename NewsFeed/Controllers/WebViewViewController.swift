//
//  WebViewViewController.swift
//  NewsFeed
//
//  Created by Artjoms Vorona on 25/11/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import WebKit
import UIKit

class WebViewViewController: UIViewController, WKNavigationDelegate {
    
    var newsUrl = ""

    //TODO: activity indicator is not working
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: newsUrl) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        activityIndicator = UIActivityIndicatorView()
        view = activityIndicator
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started navigation")
        self.activityIndicator.startAnimating()
        self.activityIndicator.color = .systemGray
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Navigation stopped")
        activityIndicator.stopAnimating()
        view = webView
    }
    
}
