 

import UIKit
import Stripe
import Alamofire


class CheckoutViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myTblView: UITableView!
    
    var amountInfo = String()
    var myStrSubscriptionName = String()
    var aStrStripeKey = String()
    var SUBSCRIPTIONID = "0"
    let cellIdentifierList = "SubscriptionTableViewCell"
    var sub_id = ""
    var sub_name = ""
    var sub_fee = ""
    var sub_fee_info = ""
    var curr_info = ""
    var infoArr = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self .setUpUI()
        self .getSubscriptionDetailsFromApi()
        
        // Do any additional setup after loading the view.
    }
    
    func setUpUI()  {
        
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: ProviderAndUserScreenTitle.SUBSCRIPTION_TITLE.titlecontent(), aViewController: self)
        setUpLeftBarBackButton()
        
        myTblView.tableFooterView = UIView()
        
        myTblView.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)
    }
    
    // MARK: - Table view delegate and data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return infoArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierList, for: indexPath) as! SubscriptionTableViewCell
         if SESSION.getUserSubscriptionStatus() {
             if let name = infoArr[indexPath.row]["subscription_name"] as? String {
                 if myStrSubscriptionName == name {
                     aCell.gBtnBuyNow.setTitle("Subscribed", for: .normal)
                     aCell.gBtnBuyNow.isUserInteractionEnabled = false
             }
                 else {
                     aCell.gBtnBuyNow.setTitle(CommonTitle.BUY_NOW.titlecontent(), for: .normal)
                     aCell.gBtnBuyNow.tag = indexPath.row
                         aCell.gBtnBuyNow.isUserInteractionEnabled = true
                     aCell.gBtnBuyNow.addTarget(self, action: #selector(didTapOnSubscription(_:)), for: .touchUpInside)
                 }
         }
         }
        else {
            aCell.gBtnBuyNow.setTitle(CommonTitle.BUY_NOW.titlecontent(), for: .normal)
            aCell.gBtnBuyNow.tag = indexPath.row
                aCell.gBtnBuyNow.isUserInteractionEnabled = true
            aCell.gBtnBuyNow.addTarget(self, action: #selector(didTapOnSubscription(_:)), for: .touchUpInside)
        }
        if let name = infoArr[indexPath.row]["subscription_name"] as? String {
            self.sub_name = name
        }
        if let id = infoArr[indexPath.row]["id"] as? String {
            self.sub_id = id
        }
        if let fee = infoArr[indexPath.row]["fee"] as? String {
            self.sub_fee = fee
        }
        if let fee = infoArr[indexPath.row]["fee_description"] as? String {
            self.sub_fee_info = fee
        }
        if let fee = infoArr[indexPath.row]["currency_code"] as? String {
            self.curr_info = fee
            
        }
        
        aCell.gLblTitle.text = self.sub_name
        aCell.gLblCostInfo.text = self.sub_fee
        aCell.currencyInfo.text = self.curr_info
        aCell.subScriptionInfo.text = self.sub_fee_info
//        aCell.gBtnBuyNow.setTitle(CommonTitle.BUY_NOW.titlecontent(), for: .normal)
        aCell.gBtnBuyNow.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        aCell.gBtnBuyNow.layer.cornerRadius = aCell.gBtnBuyNow.frame.height / 2
//        aCell.gBtnBuyNow.tag = indexPath.row
//        aCell.gBtnBuyNow.addTarget(self, action: #selector(didTapOnSubscription(_:)), for: .touchUpInside)
        
        aCell.selectionStyle = .none
        return aCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Button Action
    
    // MARK:- Left Bar Button Methods
    
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
        leftBtn.setImage(UIImage(named: ICON_BACK)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)               }
                      else {
                         leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
                      }
//        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func backBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapOnSubscription(_ sender: UIButton) {
        
        let buyNowBtn = sender
        
        if let id = infoArr[buyNowBtn.tag]["id"] as? String {
            self.sub_id = id
        }
        
        var aStrSubcriptionFee = String()
        aStrSubcriptionFee = infoArr[buyNowBtn.tag]["fee"] as! String
        
        print(aStrSubcriptionFee)
        
        amountInfo = infoArr[buyNowBtn.tag]["fee"] as! String
        SUBSCRIPTIONID = self.sub_id
        
        var aDoubleAmount = Float()
        aDoubleAmount = Float(amountInfo)!
        
        if aDoubleAmount <= 0 {
            
            callSubScriptionApifree(transId: self.sub_id)
        }
        else {
            
            getStripekeyFromApi(tag: buyNowBtn.tag)
        }
        
        //Check stripe key here
    }
    
    func getStripekeyFromApi(tag: Int) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "Loading")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_STRIPE_KEY, sucessBlock: {response in
            
            HELPER.hideLoadingAnimation()
            
            var aDictResponse = [String:Any]()
            aDictResponse = response["response"] as! [String : Any]
            
            let aIntResponseCode = aDictResponse["response_code"] as! String
            let aMessageResponse = aDictResponse["response_message"] as! String
            var myDictStripeKey = [String:Any]()
            
            if aIntResponseCode == "200" {
                
                myDictStripeKey = (response["data"] as? [String:Any])!
                  
                        StripeAPI.defaultPublishableKey = myDictStripeKey["publishable_key"] as? String ?? ""
                       let aStrBrainteeKey = myDictStripeKey["braintree_key"] as! String
                        let aStrRazorPayKey = myDictStripeKey["razorpay_apikey"] as! String
                        let strPayStackKey =  myDictStripeKey["paystack_apikey"] as? String ?? ""
                        let strReference =  myDictStripeKey["paystack_ref_key"] as? String ?? ""
                        let myStrPayStackEnabled = myDictStripeKey["paystack_option"] as? String ?? ""
                        let myStrRazorPayEnabled = myDictStripeKey["razor_option"] as? String ?? ""
                        let myStrStripeEnabled = myDictStripeKey["stripe_option"] as? String ?? ""
                        let myStrPayPallEnabled = myDictStripeKey["paypal_option"] as? String ?? ""
                let myStrPaySolutionsEnabled = myDictStripeKey["paysolution_option"] as? String ?? ""
                let myStrMerchantId = myDictStripeKey["merchant_id"] as? String ?? ""
                        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_PAYMENT) as! PaymentViewController
                        aViewController.amountInfo = self.amountInfo
              
                        aViewController.SUBSCRIPTIONID = self.SUBSCRIPTIONID
                        aViewController.aStrCurrencyCode = self.curr_info
                        aViewController.aStrBrainteeKey = aStrBrainteeKey
                        aViewController.aStrRazorPayKey = aStrRazorPayKey
                        aViewController.strPayStackKey = strPayStackKey
                        aViewController.myStrPayStackEnabled = myStrPayStackEnabled
                        aViewController.myStrRazorPayEnabled = myStrRazorPayEnabled
                        aViewController.myStrStripeEnabled = myStrStripeEnabled
                        aViewController.myStrPayPallEnabled = myStrPayPallEnabled
                 aViewController.myStrPaySolutionsEnabled = myStrPaySolutionsEnabled
                        aViewController.aStrSubcriptionFee =  self.infoArr[tag]["fee"] as? String ?? ""
                         aViewController.strReference =  strReference
                aViewController.myStrMerchantId =  myStrMerchantId
//                        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_CARD_PAYMENT_VC) as! SubscriptionPlanNewCardPaymentViewController
//
//                    aViewController.aStrSubcriptionFee = self.infoArr[tag]["fee"] as! String
//                    aViewController.aStrSubcriptionId = self.infoArr[tag]["id"] as! String
//                    aViewController.aStrCurrencyCode = self.infoArr[tag]["currency_code"] as! String
                    self.navigationController?.pushViewController(aViewController, animated: true)
                       
               
            }
            else if aIntResponseCode == "404" {
                HELPER.hideLoadingAnimation()
            }
            else {
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
//    func getStripekeyFromApi() {
    
        //        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        //
        //        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_STRIPE_KEY, sucessBlock: { response in
        //
        //            HELPER.hideLoadingAnimation()
        //
        //            if response.count != 0 {
        //
        //                var aDictResponse = response[kRESPONSE] as! [String : String]
        //
        //                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
        //
        //                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
        //
        //                    var aDictResponseData = [String:Any]()
        //                    aDictResponseData = response["data"] as! [String:Any]
        //
        //                    self.aStrStripeKey = aDictResponseData["publishable_key"] as! String
        //
        //                    print(self.aStrStripeKey)
        //
        //                    if self.aStrStripeKey.count != 0 {
        
        //                        Stripe.setDefaultPublishableKey(self.aStrStripeKey)
        //                        STPPaymentConfiguration.shared().publishableKey = self.aStrStripeKey
        
//        STPPaymentConfiguration.shared().publishableKey = "pk_test_5J1tjkjdwBGS9TdcYm2a5dk2"
//        let addCardViewController = STPAddCardViewController()
//        addCardViewController.delegate = self
//        self.navigationController?.pushViewController(addCardViewController, animated: true)
        //                    }
        //
        //                }
        //                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
        //
        //                }
        //                else {
        //
        //                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
        //                }
        //            }
        //
        //        }, failureBlock: { error in
        //
        //            HELPER.hideLoadingAnimation()
        //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        //        })
//    }
    
    func callSubScriptionApifree(transId:String) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        let paramDict = ["subscription_id":transId,"transaction_id":"free","payment_details":""]
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SUBSCRIPTION_SUCCESS, dictParameters: paramDict , sucessBlock: { (response) in
            print(response)
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                print(response)
                HELPER.hideLoadingAnimation()
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SUBSCRIPTION_SUCCESS_VC) as! SubscriptionSuccessViewController
                    
                    SESSION.setUserSubscriptionStatus(status:true)
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_VALIDATION) {
                    
                    
                    HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictResponse[kRESPONSE_MESSAGE]!)
                    
                }
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    func getSubscriptionDetailsFromApi() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_SUBSCRIPTION_DETAILS, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    
                    self.infoArr = aDictResponseData["subscription_list"] as! [[String:Any]]
                    self.myTblView .reloadData()
                    
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                    
                }
                else {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }
}

extension CheckoutViewController: STPAddCardViewControllerDelegate {
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        
    }
    
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    private func addCardViewController(_ addCardViewController: STPAddCardViewController,
                                       didCreateToken token: STPToken,
                                       completion: @escaping STPErrorBlock) {
        
        let params: [String: String] = [
            "tokenid": token.tokenId,
            "amount": amountInfo,
            "currency": Constants.defaultCurrency,
            "description": Constants.defaultDescription
        ]
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SUBSCRIPTION, dictParameters: params, sucessBlock: { (response) in
            print(response)
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                print(response)
                HELPER.hideLoadingAnimation()
                completion(nil)
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    let trans_id = aDictResponseData["transaction_id"] as! String
//                    let jsonStr = aDictResponseData["payment_details"] as! String
                    
                    self .callSubScriptionApi(transId: trans_id)
                    //                let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SUBSCRIPTION_SUCCESS_VC) as! SubscriptionSuccessViewController
                    //
                    //                SESSION.setUserSubscriptionStatus(status:true )
                    //
                    //                self.navigationController?.pushViewController(aViewController, animated: true)
                    
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_VALIDATION) {
                    
                    
                    HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                    
                }
            }
            
        }) { (error) in
            HELPER.hideLoadingAnimation()
            print(error)
        }
    }
    
    
    func callSubScriptionApi(transId:String) {
        /*
         "subscription_id,
         transaction_id,
         payment_details"
         */
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        let paramDict = ["subscription_id":SUBSCRIPTIONID,"transaction_id":transId,"payment_details":""]
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SUBSCRIPTION_SUCCESS, dictParameters: paramDict , sucessBlock: { (response) in
            print(response)
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                print(response)
                HELPER.hideLoadingAnimation()
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SUBSCRIPTION_SUCCESS_VC) as! SubscriptionSuccessViewController
                    
                    
                    SESSION.setUserSubscriptionStatus(status:true )
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_VALIDATION) {
                    
                    
                    HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictResponse[kRESPONSE_MESSAGE]!)
                    
                }
            }
            
        }) { (error) in
            print(error)
        }
    }
}
