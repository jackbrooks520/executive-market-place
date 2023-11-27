
import UIKit
import Stripe


class SubscriptionPlanNewCardPaymentViewController: UIViewController {
    
    @IBOutlet weak var gTxtFldCardNumber: FormTextField!
    @IBOutlet weak var gTxtFldCvv: FormTextField!
    @IBOutlet weak var gTxtFldExpirationDate: FormTextField!
    @IBOutlet weak var gBtnSubscribeNow: UIButton!
    
    var aStrSubcriptionFee = String()
    var aStrCurrencyCode = String()
    var aStrSubcriptionId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpModel()
        loadModel()
    }
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: CommonTitle.POPULAR_SERVICES.titlecontent(), aViewController: self)
        setUpLeftBarBackButton()
               if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                gTxtFldCardNumber.textAlignment = .right
                 gTxtFldExpirationDate.textAlignment = .right
                 gTxtFldCvv.textAlignment = .right
               }
               else {
                gTxtFldCardNumber.textAlignment = .left
                gTxtFldExpirationDate.textAlignment = .left
                gTxtFldCvv.textAlignment = .left
        }
        gBtnSubscribeNow.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        gBtnSubscribeNow.layer.cornerRadius = gBtnSubscribeNow.frame.height / 2
        gBtnSubscribeNow.setTitle(SubscriptionScreen.SUBSCRIBE_NOW.titlecontent(), for: .normal)
        gTxtFldCardNumber.placeholder = WalletContent.ADD_CARD.titlecontent()
        gTxtFldCardNumber.inputType = .integer
        gTxtFldCardNumber.formatter = CardNumberFormatter()
        var validation = Validation()
        validation.maximumLength = "1234 5678 1234 5678".count
        validation.minimumLength = "1234 5678 1234 5678".count
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        gTxtFldCardNumber.inputValidator = inputValidator
        
        gTxtFldExpirationDate.inputType = .integer
        gTxtFldExpirationDate.formatter = CardExpirationDateFormatter()
        gTxtFldExpirationDate.placeholder = WalletContent.EXPIRATION_MNTH.titlecontent()
        var validation1 = Validation()
        validation1.minimumLength = 1
        let inputValidator1 = CardExpirationDateInputValidator(validation: validation1)
        gTxtFldExpirationDate.inputValidator = inputValidator1
        
        gTxtFldCvv.inputType = .integer
        gTxtFldCvv.placeholder = WalletContent.CARD_CVV.titlecontent()
        var validation2 = Validation()
        validation2.maximumLength = "CVVV".count
        validation2.minimumLength = "CVV".count
        validation2.characterSet = NSCharacterSet.decimalDigits
        let inputValidator2 = InputValidator(validation: validation2)
        gTxtFldCvv.inputValidator = inputValidator2
        
    }
    
    func    setUpModel() {
        
    }
    func    loadModel() {
        
    }
    
    @IBAction func subscribeBtnTapped(_ sender: Any) {
        sendBookingToApi()
        //        apiCaseSubscription()
    }
    
    // MARK:-  Api Call
    func sendBookingToApi() {
        
        let aTxtFieldCardNo = gTxtFldCardNumber.text
        let aTxtFieldCardExpiry = gTxtFldExpirationDate.text
        let aTxtFieldCardCVV = gTxtFldCvv.text
        
        if aTxtFieldCardNo == "" && aTxtFieldCardExpiry == "" && aTxtFieldCardCVV == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ENTER_CARD_DETAILS.titlecontent())
        }
        else if aTxtFieldCardNo == ""  {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CARD_NUMBER.titlecontent())
        }
        else if aTxtFieldCardExpiry == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CARD_EXPIRY.titlecontent())
        }
        else if aTxtFieldCardCVV == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CVV.titlecontent())
        }
        else {
            let validCardNumber = gTxtFldCardNumber.validate()
            let validCardExpirationDate = gTxtFldExpirationDate.validate()
            let validCVC = gTxtFldCvv.validate()
            
//            print(validCardNumber)
//            print(validCardExpirationDate)
//            print(validCVC)
            
            var aStrMonth = Int()
            var aStrYear = Int()
            
            let aExpirationDate = aTxtFieldCardExpiry?.components(separatedBy: "/")
            
            aStrMonth = Int(aExpirationDate![0])!
            aStrYear = Int(aExpirationDate![1])!
            
            if  validCardNumber && validCardExpirationDate && validCVC {
                
                let card: STPCardParams = STPCardParams()
                card.number = aTxtFieldCardNo
                card.expMonth = UInt(aStrMonth)
                card.expYear = UInt(aStrYear)
                card.cvc = aTxtFieldCardCVV
                card.currency = aStrCurrencyCode
                HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
                
                STPAPIClient.shared.createToken(withCard: card) { token, error in
                    if let token = token {
                        
                        let aTransactionId = token.tokenId as String
                        print(aTransactionId)
                        self.apiCaseSubscription(tokenID : aTransactionId)
                        
                    } else {
                        HELPER.hideLoadingAnimation()
                        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: (error?.localizedDescription)!)
                    }
                }
            }
            else {
                HELPER.hideLoadingAnimation()
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.NOT_VALID_CARD.titlecontent())
            }
        }
    }
    
    // MARK:- Api Call
    func apiCaseSubscription(tokenID : String)  {
        let params: [String: String] = [
            "tokenid": tokenID,
            "amount": aStrSubcriptionFee,
            "subscription_id": aStrSubcriptionId,
            "description": "Purchased from \(APP_NAME)"
        ]
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        print(params)
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SUBSCRIPTION, dictParameters: params, sucessBlock: { (response) in
            print(response)
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                print(response)
                HELPER.hideLoadingAnimation()
                //    completion(nil)
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    let trans_id = aDictResponseData["transaction_id"] as! String
                    let jsonStr = aDictResponseData["payment_details"] as! String
                    
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
        let paramDict = ["subscription_id": aStrSubcriptionId,"transaction_id":transId,"payment_details":""]
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

}
