//
//  WebViewViewController.swift
//
//  Created by user on 04/06/19.
//  Copyright © 2019 dreams. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var myWebView: WKWebView!
    
    var gStrTitle = String()
    var gStrContent = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        NAVIGAION.setNavigationTitle(aStrTitle: gStrTitle, aViewController: self)
        setUpLeftBarBackButton()
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        let url = URL (string: gStrContent)
        let myRequest = URLRequest(url: url!)
        myWebView.uiDelegate = self
        myWebView.isOpaque = false
        myWebView.navigationDelegate = self
        myWebView.backgroundColor = UIColor.clear
        myWebView.scrollView.backgroundColor = UIColor.clear
        myWebView.scrollView.isScrollEnabled = true
        myWebView.load(myRequest)
       
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    // MARK: - WebView delegate
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        HELPER.hideLoadingAnimation()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HELPER.hideLoadingAnimation()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HELPER.hideLoadingAnimation()
    }

    
    //    // MARK: - WebView delegate
    //
    //    func webViewDidStartLoad(_ webView: UIWebView) {
    //
    //        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading")
    //    }
    //
    //    func webViewDidFinishLoad(_ webView: UIWebView) {
    //
    //        HELPER.hideLoadingAnimation()
    //    }
    //    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    //
    //        HELPER.hideLoadingAnimation()
    //    }
    //
    // MARK : - Left Bar Button Methods
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            leftBtn.setImage(UIImage(named: ICON_BACK)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
        else {
            leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        }
        
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(questionBackBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func questionBackBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension WKWebView {
    
    func loadHTMLStringWithMagic(content:String,baseURL:URL?){
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        loadHTMLString(headerString + content, baseURL: baseURL)
    }
}
