//
//  PaymentViewController.swift
//
//  Created by DreamGuys Tech on 08/07/20.
//  Copyright © 2020 dreams. All rights reserved.
//

import UIKit
import Stripe
import Braintree
import Razorpay
import Paystack
import BraintreeDropIn

class PaymentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,BTViewControllerPresentingDelegate, BTAppSwitchDelegate, RazorpayPaymentCompletionProtocol,PSTCKPaymentCardTextFieldDelegate {
    
    let walletAddNewCardCellIdentifier: String = "AddNewCardTableViewCell"
    let CardImageTableViewCellIdentifier = "CardImageTableViewCell"
    let PaymentGateWaysTableViewCellIdentifier = "PaymentGateWaysTableViewCell"
    let walletWithdrawCashIdentifier: String = "GSWithdrawCashTableViewCell"
    @IBOutlet weak var myTblView: UITableView!
    let TAG_CARD_NUMBER = 1000
    let TAG_CARD_EXPIRY_DATE = 2000
    let TAG_CARD_CVV = 3000
    var amountInfo = String()
    var aStrCurrencyCode = String()
    var aStrRazorPayKey = String()
    var aStrBrainteeKey = String()
    var strPayStackKey = String()
    var SUBSCRIPTIONID = "0"
    var gPaymentStatus: String = "0"
    var braintreeClient: BTAPIClient?
    var razorpay: RazorpayCheckout!
    var gBoolPayPallSelected = Bool()
    var myStrPayPallEnabled = String()
    var myStrStripeEnabled = String()
    var myStrRazorPayEnabled = String()
    var myStrPayStackEnabled = String()
    var myStrPaySolutionsEnabled = String()
    var myArrPayment = [String]()
    var strEmail = String()
    var aStrSubcriptionFee = String()
    var strReference = String()
    let cardParams = PSTCKCardParams.init()
    var myStrMerchantId = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI(){
        self.braintreeClient = BTAPIClient(authorization: aStrBrainteeKey)!
        self.razorpay = RazorpayCheckout.initWithKey(aStrRazorPayKey, andDelegate: self)
        myTblView.register(UINib.init(nibName: walletAddNewCardCellIdentifier, bundle: nil), forCellReuseIdentifier: walletAddNewCardCellIdentifier)
        myTblView.register(UINib.init(nibName: CardImageTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: CardImageTableViewCellIdentifier)
        myTblView.register(UINib.init(nibName: PaymentGateWaysTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: PaymentGateWaysTableViewCellIdentifier)
        myTblView.register(UINib.init(nibName: walletWithdrawCashIdentifier, bundle: nil), forCellReuseIdentifier: walletWithdrawCashIdentifier)
        if self.myStrPayStackEnabled == "1" {
            self.myArrPayment.append("paystack")
        }
        if  self.myStrRazorPayEnabled == "1" {
            self.myArrPayment.append("Razor")
        }
        if  self.myStrStripeEnabled == "1" {
            self.myArrPayment.append("stripe")
        }
        if  self.myStrPayPallEnabled == "1" {
            self.myArrPayment.append("paypall")
        }
        if  self.myStrPaySolutionsEnabled == "1" {
            self.myArrPayment.append("paysolutions")
        }
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        else if section == 1 {
           if myArrPayment.count != 0 {
                return 20
            }
            return 0
        }
        else {
            if gPaymentStatus == "1" ||  gPaymentStatus == "3" {
                return 20
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
      
        let headerView = view as! UITableViewHeaderFooterView
        
        if section == 1 {
            headerView.textLabel?.text = WalletContent.SELECT_PAYMENT_METHOD.titlecontent()
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
        if section == 2 {
            headerView.textLabel?.text = WalletContent.ADD_CARD.titlecontent()
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        headerView.tintColor = UIColor.white
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        }
        else if indexPath.section == 1 {
            return CGFloat(myArrPayment.count * 40)
          //  return 180
        }
        else {
            if gPaymentStatus == "1" {
                return 260
            }
            else if gPaymentStatus == "3" {
                return 260
            }
            return 60
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let aCell = tableView.dequeueReusableCell(withIdentifier: CardImageTableViewCellIdentifier, for: indexPath) as! CardImageTableViewCell
            return aCell
        }
        else if indexPath.section == 1 {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: PaymentGateWaysTableViewCellIdentifier, for: indexPath) as! PaymentGateWaysTableViewCell
            
            aCell.gLblPayPall.text = "PayPal"//WalletContent.PAYPAL.titlecontent()
            aCell.gLblStripe.text = "Stripe"//WalletContent.STRIPE.titlecontent()
            aCell.gLblRazorPay.text = "RazorPay"
            aCell.gLblPayStack.text = "PayStack"
            aCell.gLblPaySolutions.text = "PaySolutions"
            
            if gPaymentStatus == "0" {
                aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_tick_gray")
                aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
            }
            else if gPaymentStatus == "1" {
                aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_tick_gray")
                aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
            }
            else if gPaymentStatus == "2" {
                aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_tick_gray")
                aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
            }
            else if gPaymentStatus == "3" {
                aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_tick_gray")
                aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
            }
            else{
                aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_tick_gray")
            }
            
            
            
            if myStrPayPallEnabled == "1" {
                aCell.gViewPayPallContainer.isHidden = false
                aCell.gPaypallHeightConstraint.constant = 40
            }
            else if myStrPayPallEnabled == "0" {
                aCell.gViewPayPallContainer.isHidden = true
                 aCell.gPaypallHeightConstraint.constant = 0
            }
            if myStrStripeEnabled == "1" {
                aCell.gViewStripeContainer.isHidden = false
                aCell.gStripeHeightConstraint.constant = 40
            }
            else  if myStrStripeEnabled == "0" {
                aCell.gViewStripeContainer.isHidden = true
                 aCell.gStripeHeightConstraint.constant = 0
            }
            if myStrRazorPayEnabled == "1" {
                aCell.gViewRazorPayContainer.isHidden = false
                aCell.gRazorPayHeightConstraint.constant = 40
            }
            else if myStrRazorPayEnabled == "0" {
                aCell.gViewRazorPayContainer.isHidden = true
                aCell.gRazorPayHeightConstraint.constant = 0
            }
            if myStrPayStackEnabled == "1" {
                aCell.gViewPayStack.isHidden = false
                aCell.gPayStackHeightConstraint.constant = 40
            }
            else if myStrPayStackEnabled == "0" {
                aCell.gViewPayStack.isHidden = true
                aCell.gPayStackHeightConstraint.constant = 0
            }
            if myStrPaySolutionsEnabled == "1" {
                aCell.gViewPaysolutions.isHidden = false
                aCell.gPaySolutionsHeightConstraint.constant = 40
            }
            else if myStrPayStackEnabled == "0" {
                aCell.gViewPaysolutions.isHidden = true
                aCell.gPaySolutionsHeightConstraint.constant = 0
            }
            
            aCell.gBtnPayPal.addTarget(self, action: #selector(PayPallBtnTapped), for: .touchUpInside)
            aCell.gBtnStripe.addTarget(self, action: #selector(StripeBtnTapped), for: .touchUpInside)
            aCell.gBtnRazorPay.addTarget(self, action: #selector(RazorPayBtnTapped), for: .touchUpInside)
            aCell.gBtnPayStack.addTarget(self, action: #selector(PayStackBtnTapped), for: .touchUpInside)
            aCell.gBtnPaySolutions.addTarget(self, action: #selector(PaySolutionsBtnTapped), for: .touchUpInside)
            return aCell
            
        }
        else {
            if gPaymentStatus == "1" || gPaymentStatus == "3" {
                let aCell = tableView.dequeueReusableCell(withIdentifier: walletAddNewCardCellIdentifier, for: indexPath) as! AddNewCardTableViewCell
                
                aCell.gViewAddCash.layer.cornerRadius = aCell.gViewAddCash.frame.height / 2
                aCell.gViewContainer.layer.borderWidth = 1
                aCell.gViewContainer.layer.borderColor = UIColor.lightGray.cgColor
                aCell.gViewContainer.layer.cornerRadius = 10
                
                aCell.gViewCardNumberContainer.layer.cornerRadius = 5
                aCell.gViewCardNumberContainer.layer.borderWidth = 0.3
                aCell.gViewCardNumberContainer.layer.borderColor = UIColor.lightGray.cgColor
                
                aCell.gViewCardExpiryContainer.layer.cornerRadius = 5
                aCell.gViewCardExpiryContainer.layer.borderWidth = 0.3
                aCell.gViewCardExpiryContainer.layer.borderColor = UIColor.lightGray.cgColor
                
                aCell.gViewCvvContainer.layer.cornerRadius = 5
                aCell.gViewCvvContainer.layer.borderWidth = 0.3
                aCell.gViewCvvContainer.layer.borderColor = UIColor.lightGray.cgColor
                
                aCell.gLblPrivacyMsg.text = WalletContent.PRIVACY_MSG.titlecontent()
                aCell.gLblDebitCreditCard.text = WalletContent.DEBIT_CREDIT_CARD.titlecontent()
                aCell.gBtnAddCash.setTitle(CommonTitle.PAY_NOW.titlecontent(), for: .normal)
                aCell.gBtnAddCash.addTarget(self, action: #selector(AddCashBtnTapped), for: .touchUpInside)
                aCell.gBtnAddCash.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                aCell.gViewAddCash.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                aCell.gTxtFldCardNumber.tag = TAG_CARD_NUMBER
                aCell.gTxtFldCardNumber.placeholder = WalletContent.CARD_NUMBER.titlecontent()
                aCell.gTxtFldCardNumber.inputType = .integer
                aCell.gTxtFldCardNumber.formatter = CardNumberFormatter()
                
                var validation = Validation()
                validation.maximumLength = "1234 5678 1234 5678".count
                validation.minimumLength = "1234 5678 1234 5678".count
                let characterSet = NSMutableCharacterSet.decimalDigit()
                characterSet.addCharacters(in: " ")
                validation.characterSet = characterSet as CharacterSet
                let inputValidator = InputValidator(validation: validation)
                aCell.gTxtFldCardNumber.inputValidator = inputValidator
                //             aCell.myTxtFldCardNumber.delegate = self
                
                aCell.gTxtFldExpiry.tag = TAG_CARD_EXPIRY_DATE
                aCell.gTxtFldExpiry.inputType = .integer
                aCell.gTxtFldExpiry.formatter = CardExpirationDateFormatter()
                aCell.gTxtFldExpiry.placeholder = "MM/YY "
                //              aCell.myTxtFldExpiry.delegate = self
                
                var validation1 = Validation()
                validation1.minimumLength = 1
                let inputValidator1 = CardExpirationDateInputValidator(validation: validation1)
                aCell.gTxtFldExpiry.inputValidator = inputValidator1
                
                aCell.gTxtFldCvv.tag = TAG_CARD_CVV
                aCell.gTxtFldCvv.inputType = .integer
                aCell.gTxtFldCvv.placeholder = "CVV "
                //            aCell.myTxtFldCVV.delegate = self
                
                var validation2 = Validation()
                validation2.maximumLength = "CVV".count
                validation2.minimumLength = "CVV".count
                validation2.characterSet = NSCharacterSet.decimalDigits
                let inputValidator2 = InputValidator(validation: validation2)
                aCell.gTxtFldCvv.inputValidator = inputValidator2
                
                return aCell
            }
            else {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: walletWithdrawCashIdentifier, for: indexPath) as! GSWithdrawCashTableViewCell
                
                aCell.gViewWithdrawContainer.layer.cornerRadius = aCell.gViewWithdrawContainer.layer.frame.height / 2
                aCell.gViewWithdrawContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                aCell.gBtnWithdrawCash.setTitle(WalletContent.ADD_CASH_SECURE.titlecontent(), for: .normal)
                aCell.gBtnWithdrawCash.setTitleColor(UIColor.white, for: .normal)
                aCell.gBtnWithdrawCash.addTarget(self, action: #selector(AddCashThroughPayPallRazorPayTapped), for: .touchUpInside)
                return aCell
                
            }
        }
        
    }
    // MARK:- Button Action
    @objc func AddCashBtnTapped(){
        sendBookingToApi()
    }
    @objc func PayPallBtnTapped(){
        gBoolPayPallSelected = true
        gPaymentStatus = "0"
        
        myTblView.reloadData()
    }
    @objc func StripeBtnTapped(){
        gBoolPayPallSelected = false
        gPaymentStatus = "1"
        
        myTblView.reloadData()
    }
    
    @objc func RazorPayBtnTapped(){
        gPaymentStatus = "2"
        myTblView.reloadData()
    }
    @objc func PayStackBtnTapped(){
        gPaymentStatus = "3"
        myTblView.reloadData()
    }
    @objc func PaySolutionsBtnTapped(){
        gPaymentStatus = "4"
        myTblView.reloadData()
    }
    @objc func AddCashThroughPayPallRazorPayTapped(){
        if gPaymentStatus == "0" {
            //           AddCashPayPall()
            presentDropInController()
        }
        else if gPaymentStatus == "4" {
            let aViewController = GSWkWebViewViewController()
            aViewController.gStrTitle = "Payment Withdraw"
            aViewController.gStrContent = "\(WEB_BASE_URL)home/paysolutionapi?refno=\(strReference)&merchantid=\(myStrMerchantId)&customeremail=\( SESSION.getUserInfoNew().1)&total=\(amountInfo)&productdetail=subscription_\(SUBSCRIPTIONID)"
          
           
            self.navigationController?.pushViewController(aViewController, animated: true)
            }
        else {
            AddCashRazorPayBtnTapped()
        }
        
    }
 
    func AddCashRazorPayBtnTapped(){
        let myIntTotalAmount = (amountInfo as NSString).integerValue
        
        let aIntAmtConver = myIntTotalAmount * 100
        let options: [String:Any] = [
            "amount": "\(aIntAmtConver)", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency":  aStrCurrencyCode,//We support more that 92 international currencies.
            "prefill": [
                "contact": "",
                "email": ""
            ],
            "theme": [
                "color": "#" + SESSION.getAppColor()
            ]
            
        ]
    
        razorpay.open(options)
    }
    // MARK: - BTViewControllerPresentingDelegate
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - BTAppSwitchDelegate
    
    
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
    // MARK:-  RazorPay Delegates
    public func onPaymentError(_ code: Int32, description str: String){
        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    public func onPaymentSuccess(_ payment_id: String){
        self.sendToken(tokenId: payment_id, paymentType: "razorpay")
        
    }
    

    func sendToken(tokenId : String, paymentType : String){
        var aDictParams = [String:String]()
        
        aDictParams["transaction_id"] = tokenId
        aDictParams["paytype"] = paymentType
        aDictParams["subscription_id"] = SUBSCRIPTIONID
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SUBSCRIPTION_SUCCESS, dictParameters: aDictParams , sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if aDictResponse[kRESPONSE_CODE] == "200" {
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
//                    let trans_id = aDictResponseData["transaction_id"] as! String
//                    self .callSubScriptionApi(transId: trans_id)
                    let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SUBSCRIPTION_SUCCESS_VC) as! SubscriptionSuccessViewController
                    
                    SESSION.setUserSubscriptionStatus(status:true )
                    self.navigationController?.pushViewController(aViewController, animated: true)
//                                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
//
//                                        self.navigationController?.popViewController(animated: true)
//                                    })
                }
                else {
                    
                    HELPER.hideLoadingAnimation()
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    func sendBookingToApi() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        if gPaymentStatus == "3"  {
            if (strPayStackKey == "" || !strPayStackKey.hasPrefix("pk_")) {
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "You need to set your Paystack public key.")
//                showOkayableMessage("You need to set your Paystack public key.", message:"You can find your public key at https://dashboard.paystack.co/#/settings/developer .")
                // You need to set your Paystack public key.
                return
            }
            
            Paystack.setDefaultPublicKey(strPayStackKey)
        }
        let aTxtFieldCardNo = self.view.viewWithTag(TAG_CARD_NUMBER) as! FormTextField
        let aTxtFieldCardExpiry = self.view.viewWithTag(TAG_CARD_EXPIRY_DATE) as! FormTextField
        let aTxtFieldCardCVV = self.view.viewWithTag(TAG_CARD_CVV) as! FormTextField
        
        
        if aTxtFieldCardNo.text == "" && aTxtFieldCardExpiry.text == "" && aTxtFieldCardCVV.text == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "Enter card details")
        }
        else if aTxtFieldCardNo.text == ""  {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CARD_NUMBER.titlecontent())
        }
        else if aTxtFieldCardExpiry.text == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CARD_EXPIRY.titlecontent())
        }
        else if aTxtFieldCardCVV.text == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CVV.titlecontent())
        }
        else {
            let validCardNumber = aTxtFieldCardNo.validate()
            let validCardExpirationDate = aTxtFieldCardExpiry.validate()
            let validCVC = aTxtFieldCardCVV.validate()
            
            print(validCardNumber)
            print(validCardExpirationDate)
            print(validCVC)
            
            var aStrMonth = Int()
            var aStrYear = Int()
            
            let aExpirationDate = aTxtFieldCardExpiry.text?.components(separatedBy: "/")
            
            aStrMonth = Int(aExpirationDate![0])!
            aStrYear = Int(aExpirationDate![1])!
            
            if  validCardNumber && validCardExpirationDate && validCVC {
                if gPaymentStatus == "3" {
                    
                    cardParams.number = aTxtFieldCardNo.text
                    cardParams.cvc = aTxtFieldCardCVV.text
                    
                    cardParams.expMonth = UInt(aStrMonth)
                    cardParams.expYear = UInt(aStrYear)
                    
                  
                    changeCurrency(paymentType: "paystack", currency: "NGN")
                }
                else {
                let card: STPCardParams = STPCardParams()
                card.number = aTxtFieldCardNo.text
                card.expMonth = UInt(aStrMonth)
                card.expYear = UInt(aStrYear)
                card.cvc = aTxtFieldCardCVV.text
                card.currency = aStrCurrencyCode
                
                HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
                
                STPAPIClient.shared.createToken(withCard: card) { token, error in
                    if let token = token {
                        
                        let aTransactionId = token.tokenId as String
                        self.sendToken(tokenId: aTransactionId, paymentType: "stripe")
                        //                        self.getSubscriptionAPI(aTransactionId)
                        
                    }else {
                        HELPER.hideLoadingAnimation()
                        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: (error?.localizedDescription)!)
                    }
                    
                }
                } }else {
                HELPER.hideLoadingAnimation()
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "Invaild Response")
            }
        }
        
    }
    func changeCurrency(paymentType : String , currency : String) {
    var aDictParams = [String:String]()
    
    aDictParams["user_currency_code"] = self.aStrCurrencyCode
    aDictParams["amount"] = self.aStrSubcriptionFee
    aDictParams["paytype"] = paymentType
    aDictParams["conversion_currency"] = currency
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
    if !HELPER.isConnectedToNetwork() {
        
        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
        return
    }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
    HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_CURRENCY_CONVERT, dictParameters: aDictParams , sucessBlock: { (response) in
        
        HELPER.hideLoadingAnimation()
        if response.count != 0 {
            
            let aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                let transactionParams = PSTCKTransactionParams.init();
                var aDictResponseData = [String:Any]()
                aDictResponseData = response["data"] as! [String : Any]
                let myIntTotalAmount = Double(truncating: aDictResponseData["currency_amount"] as? NSNumber ?? 0)
                let aIntAmtConver = myIntTotalAmount * 100
                transactionParams.email = self.strEmail;
                transactionParams.amount = UInt(aIntAmtConver);
                transactionParams.currency = currency;
                transactionParams.reference = self.strReference;
                
                let dictParams: NSMutableDictionary = [
                    "recurring": true
                ];
                let arrParams: NSMutableArray = [
                    "0","go"
                ];
                do {
                    try transactionParams.setMetadataValueDict(dictParams, forKey: "custom_filters");
                    try transactionParams.setMetadataValueArray(arrParams, forKey: "custom_array");
                } catch {
                    print(error)
                }
                // use library to create charge and get its reference
                PSTCKAPIClient.shared().chargeCard(self.cardParams, forTransaction: transactionParams, on: self, didEndWithError: { (error, reference) in
                    print(error)
                    if error._code == PSTCKErrorCode.PSTCKExpiredAccessCodeError.rawValue{
                    }
                    if error._code == PSTCKErrorCode.PSTCKConflictError.rawValue{
                    }
                    if let errorDict = (error._userInfo as! NSDictionary?){
                        if let errorString = errorDict.value(forKeyPath: "com.paystack.lib:ErrorMessageKey") as! String? {
                            if let reference=reference {
                                HELPER.hideLoadingAnimation()
                                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "An error occured")
//                                self.showOkayableMessage("An error occured while completing "+reference, message: errorString)
                          
                            } else {
                                HELPER.hideLoadingAnimation()
                                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "An error occured")
//                                self.showOkayableMessage("An error occured", message: errorString)
                                //                        self.outputOnLabel(str: errorString)
                            }
                        }
                    }
                    
                }, didRequestValidation: { (reference) in
                }, willPresentDialog: {
        
                }, dismissedDialog: {
                }) { (reference) in
                    HELPER.hideLoadingAnimation()
                    self.sendToken(tokenId: reference, paymentType: "paystack")
                }
                return
            }
            else {
                
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
        }
        
        
    }, failureBlock: { error in
        
        HELPER.hideLoadingAnimation()
        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
    })
    }
    func callSubScriptionApi(transId:String) {
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        let paramDict = ["subscription_id":SUBSCRIPTIONID,"transaction_id":transId,"payment_details":""]
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SUBSCRIPTION_SUCCESS, dictParameters: paramDict , sucessBlock: { (response) in
            print(response)
            if  response[kRESPONSE] as? [String : String] != nil{
                
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
    @objc func presentDropInController() {
        
        BTUIKAppearance.sharedInstance()?.colorScheme = .light
        
        
        
        let dropInRequest = BTDropInRequest()
        
        dropInRequest.vaultManager = !ProcessInfo.processInfo.arguments.contains("-DisableEditMode")
        
        BTUIKLocalizedString.setCustomTranslations(["cs"])
        
        
        
        dropInRequest.paypalDisabled = false
        
        dropInRequest.cardDisabled = true
        
        dropInRequest.applePayDisabled = true
        
        
        if ProcessInfo.processInfo.arguments.contains("-PayPalOneTime") {
            
            dropInRequest.payPalRequest = BTPayPalRequest(amount: self.amountInfo)
            
        }
        
        
        
        let dropInController = BTDropInController(authorization: aStrBrainteeKey, request: dropInRequest) { (dropInController, result, error) in
            
            guard let result = result, error == nil else {
                
                //                self.progressBlock?("Error: \(error!.localizedDescription)")
                
                print("Error: \(error!)")
                
                return
                
            }
           if result.isCancelled {
                                
            } else {
                
                 
                let timestamp = NSDate().timeIntervalSince1970
                
                
                
                //                var aDictParams = [String:String]()
                
                //
                
                //                aDictParams["amount"] = self.strTotalAmont
                //
                //                aDictParams["tokenid"] = ""
                //
                //                aDictParams["paytype"] = "paypal"
                //
                //                aDictParams["currency"] = self.aStrCurrencyCode
                //
                //                aDictParams["payload_nonce"] = result.paymentMethod?.nonce
                //
                //                aDictParams["orderID"] = "\(timestamp)"
                self.sendToken(tokenId: result.paymentMethod!.nonce, paymentType: "paypall")
//                self.withdrawCashToPaypalApi(noncetoken: result.paymentMethod!.nonce, orderId: "\(timestamp)")
                
            }
            
            
            
            dropInController.dismiss(animated: true, completion: nil)
            
        }
        
        
        
        guard let dropIn = dropInController else {
            
            //            progressBlock?("Unable to initialize BTDropInController")
            
            return
            
        }
        
        
        
        present(dropIn, animated: true, completion: nil)
        
    }

}
