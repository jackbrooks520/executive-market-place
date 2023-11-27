 

import UIKit

class PaymentSettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var myContainerViewSubmit: UIView!
    @IBOutlet weak var myBtnSubmit: UIButton!
    @IBOutlet weak var myTblView: UITableView!
    
    let cellIdentifier: String = "PaymentSettingsTableViewCell"
    
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
    let TAG_ORDER_STATUS : Int = 100
    
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
        
        NAVIGAION.setNavigationTitle(aStrTitle: "Stripe Settings", aViewController: self)
        myBtnSubmit.setTitle("Update", for: .normal)
    }
    
    func setUpUI(){
        
        setUpLeftBarBackButton()
//        myDictDetails = SESSION.getUserStripeInfo()
        
        myTblView.delegate = self
        myTblView.dataSource = self
        
        myTblView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        self.myBtnSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        HELPER.setRoundCornerView(aView: myContainerViewSubmit, borderRadius: 15.0)
    }
    
    func setUpModel(){
        
        myAryPaymentCancelInfo = [[KTITLE: StripeScrenTitle.CONTENT_TITLE_ACC_HOLDER_NAME.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_ACC_NO.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_IBAN.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_BANK_NAME.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_BANK_ADDRESS.titlecontent(), KPLACEHOLDER: ""],[KTITLE: StripeScrenTitle.CONTENT_TITLE_SORT_CODE.titlecontent(), KPLACEHOLDER: "UK Bank code (6 digits usually displayed as 3 pairs of numbers)"],[KTITLE: StripeScrenTitle.CONTENT_TITLE_ROUTING_NUMBER.titlecontent(), KPLACEHOLDER: "The American Bankers Association Number (consists of 9 digits) and is also called a ABA Routing Number"],[KTITLE: StripeScrenTitle.CONTENT_TITLE_IFSC_CODE.titlecontent(), KPLACEHOLDER: "Financial System Code, which is a unique 11-digit code that identifies the bank branch i.e. ICIC0001245"]]
    }
    
    func loadModel(){
        
       callGetStripeDetailsApi()
    }
    
    // MARK: - TableView delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryPaymentCancelInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell:PaymentSettingsTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PaymentSettingsTableViewCell)!
        
        if indexPath.row == 0 {
            
            aCell.gLabelTitle.text = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KTITLE] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_ACC_HOLDER_NAME
            aCell.gTextFieldContent.placeholder = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
            aCell.gTextFieldContent.text = myStrAccHolderName
            
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 1 {
            
            aCell.gLabelTitle.text = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KTITLE] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_ACC_NO
            aCell.gTextFieldContent.placeholder = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
            aCell.gTextFieldContent.text = myStrAccNo
            
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 2 {
            
            aCell.gLabelTitle.text = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KTITLE] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_IBAN
            aCell.gTextFieldContent.placeholder = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
            aCell.gTextFieldContent.text = myStrIBAN
            
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 3 {
            
            aCell.gLabelTitle.text = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KTITLE] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_BANK_NAME
            aCell.gTextFieldContent.placeholder = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
            aCell.gTextFieldContent.text = myStrBankName
            
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 4 {
            
            aCell.gLabelTitle.text = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KTITLE] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_BANK_ADDRESS
            aCell.gTextFieldContent.placeholder = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KPLACEHOLDER] as? String
            aCell.gTextFieldContent.text = myStrBankAddress
            
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 5 {
            
            aCell.gLabelTitle.text = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KTITLE] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_SORT_CODE
            aCell.gTextFieldContent.placeholder = "UK Bank code (6 digits usually displayed as 3 pairs of numbers"
            aCell.gTextFieldContent.text = myStrSortCode
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else if indexPath.row == 6 {
            
            aCell.gLabelTitle.text = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KTITLE] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_ROUTING_NUMBER
            aCell.gTextFieldContent.placeholder = "The American Bankers Association Number (consists of 9 digits) and is also called a ABA Routing Number"
            aCell.gTextFieldContent.text = myStrRoutingNo
            aCell.gTextFieldContent.delegate = self
            aCell.gTextFieldContent.returnKeyType = UIReturnKeyType.next
        }
            
        else {
            
            aCell.gLabelTitle.text = HELPER.returnStringFromNull(myAryPaymentCancelInfo[indexPath.row][KTITLE] as AnyObject) as? String  //myAryPaymentCancelInfo[indexPath.row][KTITLE] as? String
            aCell.gTextFieldContent.tag = TAG_IFSC_CODE
            aCell.gTextFieldContent.text = myStrIFSC
            aCell.gTextFieldContent.placeholder = "Financial System Code, which is a unique 11-digit code that identifies the bank branch i.e. ICIC0001245"
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
        
        if (self.myStrAccHolderName.isEmpty) &&  (self.myStrAccNo.isEmpty) && (self.myStrIBAN.isEmpty) && (self.myStrBankName.isEmpty) && (self.myStrBankAddress.isEmpty) && (self.myStrSortCode.isEmpty) && (self.myStrRoutingNo.isEmpty) &&  (self.myStrIFSC.isEmpty) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_REQUIRED_FIELDS)
        }
        if (self.myStrAccHolderName.isEmpty)  {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_ACCOUNT_HOLDER_NAME_FIELD)
        }
        else if (self.myStrAccNo.isEmpty)  {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_ACCOUNT_NO_FIELD + ALERT_EMPTY_FIELD)
        }
        else if (self.myStrBankName.isEmpty)  {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_BANK_NAME_FIELD + ALERT_EMPTY_FIELD)
        }
        else if (self.myStrBankAddress.isEmpty)  {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_BANK_ADDRESS_FIELD + ALERT_EMPTY_FIELD)
        }
        else if (self.myStrSortCode.isEmpty) && (self.myStrRoutingNo.isEmpty) && (self.myStrIFSC.isEmpty) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_ANYONE_FIELDS)
        }
        else {
            
            callStripeSettingsApi()
        }
    }
    
    // MARK: - Api call
    
    func callGetStripeDetailsApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["type"] = SESSION.getUserLogInType()
        
        HTTPMANAGER.callGetApiParams(strUrl: WEB_SERVICE_URL + CASE_STRIPE_DETAILS, dictParameters: aDictParams, sucessBlock: { response in
        
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.hideLoadingAnimation()
                    self.myDictDetails = response["data"] as! [String : String]
                    
                    if self.myDictDetails.count > 0 {
                        
                        self.myStrAccHolderName = self.myDictDetails["account_holder_name"]!
                        self.myStrAccNo = self.myDictDetails["account_number"]!
                        self.myStrIBAN = self.myDictDetails["account_iban"]!
                        self.myStrBankName = self.myDictDetails["bank_name"]!
                        self.myStrBankAddress = self.myDictDetails["bank_address"]!
                        self.myStrSortCode = self.myDictDetails["sort_code"]!
                        self.myStrRoutingNo = self.myDictDetails["routing_number"]!
                        self.myStrIFSC = self.myDictDetails["account_ifsc"]!
                        
                        self.myTblView.reloadData()
                    }
                }
                else {
                    
                    HELPER.hideLoadingAnimation()
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    func callStripeSettingsApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        let aDicParams = ["account_holder_name":myStrAccHolderName, "account_number":myStrAccNo, "account_iban":myStrIBAN, "bank_name":myStrBankName, "bank_address":myStrBankAddress, "sort_code":myStrSortCode, "routing_number": myStrRoutingNo ,"account_ifsc": myStrIFSC,"type":SESSION.getUserLogInType()]
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SEND_STRIPE_DETAILS, dictParameters: aDicParams, sucessBlock: { (response) in
            
            //        HTTPMANAGER.stripePaymentEditSericeRequest(parameter: aDicParams, SucessBlock: {response in
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                    //            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    //
                    //                HELPER.hideLoadingAnimation()
                    //                HELPER.showAlertControllerWithOkActionBlock(aViewController: (APPDELEGATE.window?.rootViewController)!, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                    //
                    //                    SESSION.setIsUserLogIN(isLogin: false)
                    //                    SESSION.setUserImage(aStrUserImage: "")
                    //                    SESSION.setUserPriceOption(option: "", price: "", extraprice: "")
                    //                    SESSION.setUserId(aStrUserId: "")
                    //                    APPDELEGATE.loadLogInSceen()
                    //
                    //                })
                    //            }
                else {
                    
                    HELPER.hideLoadingAnimation()
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
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
        leftBtn.setImage(UIImage(named: ICON_BACK)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)               }
                      else {
                         leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
                      }
//        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(questionBackBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func questionBackBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }

}
