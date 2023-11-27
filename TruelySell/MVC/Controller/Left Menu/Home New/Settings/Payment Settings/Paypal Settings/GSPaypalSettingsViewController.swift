//
//  GSPaypalSettingsViewController.swift
//  Gigs
//
//  Created by Dreamguys on 13/03/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSPaypalSettingsViewController: UIViewController {

    @IBOutlet var myContainerView: UIView!
    @IBOutlet var myTxtFldEmail: UITextField!
    @IBOutlet var myBtnSubmit: UIButton!
   
    var myStrPaypalId = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: StripeScrenTitle.SCREEN_TITLE_PAYPAL_SETTINGS.titlecontent(), aViewController: self)
        setUpLeftBarBackButton()
         HELPER.translateTextField(textField: myTxtFldEmail, key: "txt_fld_email", inPage: "register_screen", isPlaceHolderEnabled: true)
        
        myStrPaypalId = SESSION.getPaypalId()
        myTxtFldEmail.text = myStrPaypalId
        myTxtFldEmail.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        self.myBtnSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        self.myBtnSubmit.setTitle(ProviderAndUserScreenTitle.BTN_SUBMIT.titlecontent(), for: .normal)
        HELPER.setRoundCornerView(aView: self.myBtnSubmit, borderRadius: 7.0)
        HELPER.setBorderView(aView: myContainerView, borderWidth: 1, borderColor: UIColor.gray, cornerRadius: 5)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    // MARK: - Textfield delegate
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        
        if textfield.returnKeyType == UIReturnKeyType.done {
            textfield.resignFirstResponder()
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

     // MARK: - Api Call
    
    func httpRequestForPaypal() {
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        var dictForgetPassword = [String:String]()
        dictForgetPassword["paypal_email"] = myTxtFldEmail.text
        //dictForgetPassword["user_id"] = SESSION.getUserId()
        dictForgetPassword[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_PAYPAL, dictParameters: dictForgetPassword, sucessBlock: { (response) in

//        HTTPMANAGER.PaypalRequest(parameter: dictForgetPassword, confirmPasswordSucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            let aIntResponseCode = response["code"] as! Int
            let aMessageResponse = response["message"] as! String
            
            if aIntResponseCode == RESPONSE_CODE_200 {
                
                SESSION.setPaypalId(aStrPaypalId: self.myTxtFldEmail.text!)
           
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (okAction) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
            }
            else if aIntResponseCode == RESPONSE_CODE_498 {
                HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                    
                    SESSION.setIsUserLogIN(isLogin: false)
                    SESSION.setUserImage(aStrUserImage: "")
                    SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                    SESSION.setUserId(aStrUserId: "")
                    
                })
            }
            else {
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    //MARK: - Button Action
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME,aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        if (self.myTxtFldEmail.text?.isEmpty)! {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: ALERT_PAYPAL_EMPTY_FIELD, aStrMessage: ALERT_REQUIRED_FIELDS)
        }
        else if !HELPER.isValidEmailAddress(emailAddressString: self.myTxtFldEmail.text!) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: "Email id", aStrMessage: ALERT_EMAIL_ID_NOTVALID)
        }
        else {
            
            httpRequestForPaypal()
        }
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
