//
//  GSStripeViewController.swift
//  Gigs
//
//  Created by user on 09/06/2018.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSStripeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var myBtnSubmit: UIButton!
    @IBOutlet weak var myTblView: UITableView!
    
    let cellIdentifier: String = "GSPaymentCancelTableViewCell"
 
    var myAryPaymentCancelInfo = [[String:Any]]()
    
    
    let KTITLE: String = "title"
    let KPLACEHOLDER : String = "placeholder"
    
    let TAG_REASON : Int = 10
    let TAG_EMAIL_ID: Int = 20
    let TAG_ACC_HOLDER_NAME: Int = 20
    let TAG_ACC_NO: Int = 30
    let TAG_IBAN: Int = 40
    let TAG_BANK_NAME : Int = 50
    let TAG_BANK_ADDRESS : Int = 60
    let TAG_SORT_CODE : Int = 70
    let TAG_ROUTING_NUMBER : Int = 80
    let TAG_IFSC_CODE : Int = 90
    let TAG_EMAIL_ADDRESS : Int = 100
    let TAG_CONTACT_NUMBER : Int = 100
    
    var myStrReason = String()
    var myStrEmailId = String()
    var myStrAccHolderName = String()
    var myStrAccNo = String()
    var myStrIBAN = String()
    var myStrBankName = String()
    var myStrBankAddress = String()
    var myStrSortCode = String()
    var myStrRoutingNo = String()
    var myStrIFSC = String()
    var myStrContactNo = String()
    var myStrOrderStatusTitle = String()
    var myStrOrderStatusId = String()
    
    var myDictDetails = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUITranslation()
       
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUITranslation() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: StripeScrenTitle.SCREEN_TITLE_STRIPE_SETTINGS.titlecontent(), aViewController: self)
        myBtnSubmit.setTitle(CommonTitle.BTN_UPDATE.titlecontent(), for: .normal)
    }
    
    func setUpUI(){
        
        setUpLeftBarBackButton()
        myDictDetails = SESSION.getUserStripeInfo()
    
        myTblView.delegate = self
        myTblView.dataSource = self
        
        myTblView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

        self.myBtnSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())

    }
    
    func setUpModel(){
        
        myAryPaymentCancelInfo = [[KTITLE: StripeScrenTitle.CONTENT_TITLE_ACC_HOLDER_NAME.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_ACC_NO.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_IBAN.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_BANK_NAME.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_BANK_ADDRESS.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_SORT_CODE.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_ROUTING_NUMBER.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_IFSC_CODE.titlecontent(), KPLACEHOLDER: ""],[KTITLE: "Email", KPLACEHOLDER: ""],[KTITLE: "Contact Number" , KPLACEHOLDER: ""]]
        
        if myDictDetails.count > 0 {
            
            myStrAccHolderName = myDictDetails["account_holder_name"]!
            myStrAccNo = myDictDetails["account_number"]!
            myStrIBAN = myDictDetails["account_iban"]!
            myStrBankName = myDictDetails["bank_name"]!
            myStrBankAddress = myDictDetails["bank_address"]!
            myStrSortCode = myDictDetails["sort_code"]!
            myStrRoutingNo = myDictDetails["routing_number"]!
            myStrIFSC = myDictDetails["account_ifsc"]!
            myStrEmailId = myDictDetails["email"]!
            myStrContactNo = myDictDetails["contact_number"]!
        }
    }
    
    func loadModel(){
        
    }

    // MARK: - TableView delegate and datasource
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return myAryPaymentCancelInfo.count
     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let aCell:GSPaymentCancelTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? GSPaymentCancelTableViewCell)!
       if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
        aCell.gTextFieldContent.textAlignment = .right
       }
       else {
            aCell.gTextFieldContent.textAlignment = .left
       }
        if indexPath.row == 0 {
            
            aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_ACC_HOLDER_NAME
            aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
            aCell.gTextFieldContent.text = myStrAccHolderName
            aCell.gTextFieldContent.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 1 {
            
            aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_ACC_NO
            aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
            aCell.gTextFieldContent.text = myStrAccNo
            aCell.gTextFieldContent.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 2 {
            
            aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_IBAN
            aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
            aCell.gTextFieldContent.text = myStrIBAN
            aCell.gTextFieldContent.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 3 {
            
            aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_BANK_NAME
            aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
            aCell.gTextFieldContent.text = myStrBankName
            aCell.gTextFieldContent.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 4 {
            
            aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_BANK_ADDRESS
            aCell.gTextFieldContent.placeholder = myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
            aCell.gTextFieldContent.text = myStrBankAddress
            aCell.gTextFieldContent.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 5 {
            
            aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_SORT_CODE
            
            HELPER.translateTextField(textField:  aCell.gTextFieldContent, key: "txt_fld_ifsc_code", inPage: "stripe_payment_screen", isPlaceHolderEnabled: true)
            
            aCell.gTextFieldContent.text = myStrSortCode
            aCell.gTextFieldContent.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 6 {
            
            aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_ROUTING_NUMBER
            
            HELPER.translateTextField(textField:  aCell.gTextFieldContent, key: "txt_fld_swift_num", inPage: "stripe_payment_screen", isPlaceHolderEnabled: true)
            
            aCell.gTextFieldContent.text = myStrRoutingNo
            aCell.gTextFieldContent.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
         else if indexPath.row == 7 {
            
            aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_IFSC_CODE
            HELPER.translateTextField(textField:  aCell.gTextFieldContent, key: "txt_fld_ifsc_code", inPage: "stripe_payment_screen", isPlaceHolderEnabled: true)
            aCell.gTextFieldContent.text = myStrIFSC
            aCell.gTextFieldContent.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
         else if indexPath.row == 8 {
            
            aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_EMAIL_ID
           // HELPER.translateTextField(textField:  aCell.gTextFieldContent, key: "txt_fld_ifsc_code", inPage: "stripe_payment_screen", isPlaceHolderEnabled: true)
            aCell.gTextFieldContent.text = myStrEmailId
            aCell.gTextFieldContent.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
         else  {
            
            aCell.gLabelTitle.text = myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_CONTACT_NUMBER
         //   HELPER.translateTextField(textField:  aCell.gTextFieldContent, key: "txt_fld_ifsc_code", inPage: "stripe_payment_screen", isPlaceHolderEnabled: true)
            aCell.gTextFieldContent.text = myStrContactNo
            aCell.gTextFieldContent.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
        return aCell
     }
    
    
    //MARK: - Textfield Delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.tag == TAG_ACC_HOLDER_NAME {
            
            myStrAccHolderName = txtAfterUpdate
        }
            
        else if textField.tag == TAG_ACC_NO {
            
            myStrAccNo = txtAfterUpdate
        }
            
        else if textField.tag == TAG_IBAN {
            
            myStrIBAN = txtAfterUpdate
        }
            
        else if textField.tag == TAG_BANK_NAME {
            
            myStrBankName = txtAfterUpdate
        }
            
        else if textField.tag == TAG_BANK_ADDRESS {
            
            myStrBankAddress = txtAfterUpdate
        }
            
        else if textField.tag == TAG_SORT_CODE {
            
            myStrSortCode = txtAfterUpdate
        }
            
        else if textField.tag == TAG_ROUTING_NUMBER {
            
            myStrRoutingNo = txtAfterUpdate
        }
            
        else if textField.tag == TAG_IFSC_CODE {
            
            myStrIFSC = txtAfterUpdate
        }
        else if textField.tag == TAG_EMAIL_ID {
            
            myStrEmailId = txtAfterUpdate
        }
        else if textField.tag == TAG_CONTACT_NUMBER {
            
            myStrContactNo = txtAfterUpdate
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == UIReturnKeyType.next {
            
            self.myTblView.viewWithTag(textField.tag + 10)?.becomeFirstResponder()
        }
            
        else {
            
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // MARK: - Button Action
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        if (self.myStrAccHolderName.isEmpty) &&  (self.myStrAccNo.isEmpty) && (self.myStrIBAN.isEmpty) && (self.myStrBankName.isEmpty) && (self.myStrBankAddress.isEmpty) && (self.myStrSortCode.isEmpty) && (self.myStrRoutingNo.isEmpty) &&  (self.myStrEmailId.isEmpty) &&  (self.myStrIFSC.isEmpty) &&  (self.myStrContactNo.isEmpty) {
           
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_REQUIRED_FIELDS)

           
            
        }
        
        if (self.myStrAccHolderName.isEmpty)  {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_REQUIRED_FIELDS)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_ACCOUNT_HOLDER_NAME_FIELD)

           
        }
        else if (self.myStrAccNo.isEmpty)  {
             HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_ACCOUNT_NO_FIELD + ALERT_EMPTY_FIELD)
            
        }
//        else if (self.myStrIBAN.isEmpty)  {
//
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_IBAN_FIELD)
//        }
        else if (self.myStrBankName.isEmpty)  {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage:ALERT_BANK_NAME_FIELD + ALERT_EMPTY_FIELD)
                       
           
        }
        else if (self.myStrBankAddress.isEmpty)  {
              HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage:ALERT_BANK_ADDRESS_FIELD + ALERT_EMPTY_FIELD)
           
        }
            
        else if (self.myStrSortCode.isEmpty) && (self.myStrRoutingNo.isEmpty) && (self.myStrIFSC.isEmpty) {
             HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_ANYONE_FIELDS)
        }
        else if (self.myStrEmailId.isEmpty)  {
              HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage:ProviderAndUserScreenTitle.EMAIL_TITLE.titlecontent() + ALERT_EMPTY_FIELD)
           
        }
        else if (self.myStrContactNo.isEmpty)  {
              HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage:HELPER.getTranslateForKey(key: "lbl_contact_number", inPage: "account_settings_screen", existingString: "Contact Number") + ALERT_EMPTY_FIELD)
           
        }
            
//        else if (self.myStrSortCode.isEmpty)  {
//            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_SORT_CODE_FIELD)
//        }
//        else if (self.myStrRoutingNo.isEmpty)  {
//            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_ROUTING_NUMBER_FIELD)
//        }
        else if self.myStrIFSC.count != 0 &&  self.myStrIFSC.count <= 10 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: HELPER.getTranslateForValidation1Key(key: "lbl_ifsc_code", inPage: "account_settings_screen", existingString: "Enter Valid IFSC code"))
        }
        else {
            
            callStripeSettingsApi()
        }
    }
    
    // MARK: - Api call
    
    func callStripeSettingsApi() {
        
        if !HELPER.isConnectedToNetwork() {
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        let aDicParams = ["account_holder_name":myStrAccHolderName, "account_number":myStrAccNo, "account_iban":myStrIBAN, "bank_name":myStrBankName, "bank_address":myStrBankAddress, "sort_code":myStrSortCode, "routing_number": myStrRoutingNo ,"account_ifsc": myStrIFSC, "email" : myStrEmailId , "contact_number" : myStrContactNo]
//        aDicParams[kDEVICE_TYPE] = kDEVICE_TYPE_IOS
    
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL+CASE_STRIPE_PAYMENT_SETTINGS, dictParameters: aDicParams, sucessBlock: { (response) in

  //        HTTPMANAGER.stripePaymentEditSericeRequest(parameter: aDicParams, SucessBlock: {response in
            HELPER.hideLoadingAnimation()
            
            let aDictResponse = response[kRESPONSE] as! [String : String]
                          
                          let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            
               if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                HELPER.hideLoadingAnimation()
                SESSION.setUserStripeInfo(dictInfo:aDicParams)
                HELPER.showNotificationInAlertSucess(aStrMessage: aMessageResponse!, inView: self.view)
                     self.navigationController?.popViewController(animated: true)

                
//                self.dismiss(animated: true, completion: {
//
//                })
            }
            else if (Int(aDictResponse[kRESPONSE_CODE]!) == RESPONSE_CODE_498) {
                
                HELPER.hideLoadingAnimation()
              
                HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                    
                    SESSION.setIsUserLogIN(isLogin: false)
                    SESSION.setUserImage(aStrUserImage: "")
                    SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                    SESSION.setUserId(aStrUserId: "")
                    
                })
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

    
    // MARK: - Left Bar Button Methods
    
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


