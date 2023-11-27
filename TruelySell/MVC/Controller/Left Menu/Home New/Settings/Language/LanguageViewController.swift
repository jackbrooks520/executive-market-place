//
//  LanguageViewController.swift
//  DreamsChat
//
//  Created by user on 21/05/20.
//  Copyright © 2020 Dreams. All rights reserved.
//

import UIKit
import CZPicker

class LanguageViewController: UIViewController, CZPickerViewDelegate, CZPickerViewDataSource{
    
    
    var myAryLangInfo = [[String:String]]()
    var countryImages = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        callLanguageList()
    }
    
    func setUpModel() {
    }
    
    func loadModel() {
    }
    
    // MARK: - CZPicker delegate and datasource
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return myAryLangInfo.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return myAryLangInfo[row]["language"]
        
    }
    
    //    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
    //        if row == 0 {
    //            return countryImages[0]
    //        }
    //        else if row == 1 {
    //            return countryImages[1]
    //        }
    //        else {
    //            return countryImages[2]
    //        }
    //    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        let aStrLangValue = myAryLangInfo[row]["language_value"]!
        let aLangTag = myAryLangInfo[row]["tag"]!
         let myStrLangName = myAryLangInfo[row]["language"]!
        
        SESSION.setAppLangType(aStrAppLangType: aStrLangValue)
        SESSION.setAppLanguage(aStrAppLang: myStrLangName)
        callLanguage(langType: aStrLangValue, aLangTag: aLangTag)
        
        
        //        SESSION.setIsAppLaunchFirstTime(isLogin: true)
        //        APPDELEGATE.loadTabbar()
    }
    
    //Language Detail
    func callLanguage(langType:String, aLangTag: String) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var dictParameters = [String:Any]()
        dictParameters["language"] = langType
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_LANGUAGE_TYPE, dictParameters: dictParameters as! [String : String], sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            let aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                
                HELPER.hideLoadingAnimation(viewController: self)
                SESSION.setIsAppLaunchFirstTime(isLogin: true)
                if aLangTag.uppercased() == "RTL" {
                    SESSION.setIsRtl(isRightToLeft: true)
                } else {
                     SESSION.setIsRtl(isRightToLeft: false)
                }
                
                var aDictData = [String:Any]()
                var aDictLanguage = [String:Any]()
                
                
                
                aDictData = response["data"] as! [String : Any]
                aDictLanguage = aDictData["language"] as! [String : Any]
                
                SESSION.setLangInfo(dictInfo: aDictLanguage)
                
                                SESSION.setIsAppLaunchFirstTime(isLogin: true)
                
                //                 NotificationCenter.default.post(name: Notification.Name("callleftmenu"), object: nil)
                
                //                self.myTblView.reloadData()
                
                APPDELEGATE.loadTabbar()
            }
                
            else {
                
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                
                
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    
    
    //Language List
    func callLanguageList() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET)
            
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_LANGUAGE_LIST, sucessBlock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            var aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                
                self.myAryLangInfo = response["data"] as! [[String : String]]
                
                let picker = CZPickerView(headerTitle: "Choose a language", cancelButtonTitle: "", confirmButtonTitle: "")
                
                picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                picker?.delegate = self
                picker?.dataSource = self
                picker?.needFooterView = false
                picker?.show()
            }
            //            else if aIntResponseCode == RESPONSE_CODE_498 {
            //                let ALERT_OK_ = HELPER.getTranslateForKey(key: "lbl_ok", inPage: "general_alert_contents", existingString: "Ok")
            //                HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!,okButtonTitle : ALERT_OK_, aStrMessage: aMessageResponse, okActionBlock: { (action) in
            //
            //                    SESSION.setIsUserLogIN(isLogin: false)
            //                    SESSION.setUserImage(aStrUserImage: "")
            //                    SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
            //                    SESSION.setUserId(aStrUserId: "")
            //                    APPDELEGATE.loadLogInSceen()
            //
            //                })
            //            }
            //            else {
            //
            //                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME,okButtonTitle: self.OK_ALERT, aStrMessage: aMessageResponse)
            //            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
}
