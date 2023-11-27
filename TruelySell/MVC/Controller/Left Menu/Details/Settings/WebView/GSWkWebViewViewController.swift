//
//  GSWkWebViewViewController.swift
//  Gigs
//
//  Created by DreamGuys Tech on 07/09/20.
//  Copyright © 2020 dreams. All rights reserved.
//

import UIKit
import WebKit

class GSWkWebViewViewController: UIViewController,WKUIDelegate,WKNavigationDelegate {
    
    @IBOutlet var myWebView: WKWebView!
    var gStrTitle = String()
    var gStrContent = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpModel()
        loadModel()
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
        
        
        //        NAVIGAION.setNavigationTitle(aStrTitle: gStrTitle, aViewController: self)
        //        setUpLeftBarBackButton()
        ////        myWebView.delegate = self
        //
        //        let url = URL (string: gStrContent)
        //        let requestObj = URLRequest(url: url!)
        //        myWebView.loadRequest(requestObj)
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
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        let strUrl = url?.absoluteString
        if strUrl == WEB_BASE_URL {
            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: "Success") { (action) in
                
                APPDELEGATE.loadTabbar()
            }
        } 

        
        decisionHandler(.allow)
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HELPER.hideLoadingAnimation()
    }
    
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


