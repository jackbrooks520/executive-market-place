//
//  Navigation.swift
//  DriverUtilites
//
//  Created by admin on 13/05/2017.
//  Copyright © 2017 project. All rights reserved.
//

import UIKit
import MarqueeLabel

class Navigation: NSObject {

    var myMenuViewController =  UIViewController ()
    var myLeftViewController =  UIViewController ()
    
    var myStrNavigationTitle = String()
    
    static let sharedInstance: Navigation = {
        
        let instance = Navigation()
        
        // setup code
        
        return instance
    }()
    
    // MARK : Public Methods
    
    func hideNavigationBar(aViewController: UIViewController) {
        
        aViewController.navigationController?.navigationBar.isTranslucent = false
        aViewController.navigationController?.navigationBar.isHidden = true
    }
    
    func setNavigationTitle(aStrTitle: String, aViewController: UIViewController) {
        
        myStrNavigationTitle = aStrTitle
        setTitle(aStrNavigationTitle: aStrTitle, viewController: aViewController)
        setNavigationBarProperties(viewController: aViewController)
    }
    
    func setNavigationTitleWithBarbuttonImage(navigationTitle: String, leftButtonImageName: String, rightButtonImageName: String,  aViewController: UIViewController) {
        
        myStrNavigationTitle = navigationTitle
        myMenuViewController = aViewController
        
        setTitle(aStrNavigationTitle: navigationTitle, viewController: aViewController)
        setNavigationBarProperties(viewController: aViewController)
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: leftButtonImageName), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leftBtn.addTarget(self, action: #selector(leftBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        aViewController.navigationItem.leftBarButtonItem = leftBarBtnItem
        
        if rightButtonImageName.count != 0 {
            
            let rightBtn = UIButton(type: .custom)
            rightBtn.setImage(UIImage(named: rightButtonImageName), for: .normal)
            rightBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            
//            rightBtn.addTarget(aViewController, action: Selector(("leftHeaderBtnAction")), for: .touchUpInside)
            
            let rightBarBtnItem = UIBarButtonItem(customView: rightBtn)
            aViewController.navigationItem.rightBarButtonItem = rightBarBtnItem
            
           
        }
    }
    
    func setNavigationTitleWithBackButton(navigationTitle: String, aViewController: UIViewController) {
        
        myStrNavigationTitle = navigationTitle
        myLeftViewController = aViewController
        
        setTitle(aStrNavigationTitle: navigationTitle, viewController: aViewController)
        setNavigationBarProperties(viewController: aViewController)
        
        //        let leftBtn = UIButton(type: .custom)
        //        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        //        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //
        //        leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        //
        //        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        //        aViewController.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    func hideNavigationBottomLine(aViewController: UIViewController) {
        
        aViewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        aViewController.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setNavigationBarProperties(viewController : UIViewController) {
       
        viewController.navigationController?.navigationBar.isTranslucent = false
        viewController.navigationController?.navigationBar.isHidden = false
        
        let img = UIImage(named: "img_home_bg")
        viewController.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        
//        viewController.navigationController?.navigationBar.barTintColor = HELPER.hexStringToUIColor(hex: APP_PRIMARY_COLOR)
    }
    
    // MARK :  Private Methods
    
    private func setTitle(aStrNavigationTitle: String, viewController : UIViewController)  {
        
       // let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 180, height: 30))
        
        let titleLabel = MarqueeLabel.init(frame: CGRect(x: 0, y: 0, width: 180, height: 30), duration: 15, fadeLength: 10.0)

        titleLabel.text = aStrNavigationTitle
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        viewController.navigationItem.titleView = titleLabel
    }
    
    // MARK : Button Action
    
    @objc func leftBtnTapped () {
        
        myMenuViewController.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)

        //myMenuViewController.dismiss(animated: true, completion: nil)
        
        //myMenuViewController.navigationController?.popViewController(animated: true)
//        myMenuViewController.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }
    
    func rightBtnTapped () {
        
        // myViewController.evo_drawerController?.toggleDrawerSide(.right, animated: true, completion: nil)
    }
    
    //    func backBtnTapped()  {
    //
    //        myLeftViewController.navigationController?.popViewController(animated: true)
    //    }
    
}
