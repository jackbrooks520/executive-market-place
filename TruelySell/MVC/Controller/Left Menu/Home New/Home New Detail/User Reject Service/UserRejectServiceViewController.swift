 
import UIKit

class UserRejectServiceViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var myBtnSubmit: UIButton!
    @IBOutlet weak var myTxtView: UITextView!
    @IBOutlet weak var myContainerViewSubmit: UIView!
    @IBOutlet weak var myContanierView: UIView!
    @IBOutlet weak var myLblRejectService: UILabel!
    
    var myStrReason = String()
    var gStrServiceId = String()
    var gStrProviderUSerId = String()
    var gBoolIsFromBlock:Bool = false
    
    let TAG_REASON:Int = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        myTxtView.tag = TAG_REASON
        myTxtView.delegate = self
        HELPER.setRoundCornerView(aView: myContanierView, borderRadius: 10.0)
        HELPER.setRoundCornerView(aView: myContainerViewSubmit, borderRadius: 15.0)
        myContainerViewSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        if gBoolIsFromBlock {
            myLblRejectService.text = Booking_service.BLOCK.titlecontent()
        }
        else {
        myLblRejectService.text = Booking_service.REJECT_SERVICE.titlecontent()
            }
        myBtnSubmit.setTitle(ProviderAndUserScreenTitle.BTN_SUBMIT.titlecontent(), for: .normal)
        
        myTxtView.text = Booking_service.LEAVE_COMMENTS.titlecontent()
        myTxtView.textColor = .lightGray
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    //MARK: - TextView Delegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.tag == TAG_REASON {
            
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.tag == TAG_REASON {
            
            if textView.text == "" {
                
                textView.text = Booking_service.LEAVE_COMMENTS.titlecontent()
                textView.textColor = UIColor.lightGray
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let textViewText: NSString = (textView.text ?? "") as NSString
        let txtAfterUpdate = textViewText.replacingCharacters(in: range, with: text)
        
        if textView.tag == TAG_REASON {
            
            myStrReason = txtAfterUpdate
        }
        
        return true
    }

  // MARK: - Button Action
    @IBAction func btnSubmitTApped(_ sender: Any) {
        if gBoolIsFromBlock {
            blockApi()
        }
        else {
        if myStrReason.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: Booking_service.ENTER_REJECTED_REASON.titlecontent())
            return
        }
        else {
            
            setServiceStatusApi(statusType: "2")
        }
        }
    }
    
    // MARK: - Api Call
    
    //Change Status
    func blockApi() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        
            aDictParams["provider_id"] = gStrProviderUSerId
        aDictParams["reason"] = myStrReason
        var CASE_API = String()
        if SESSION.getUserLogInType() == "1" {
            CASE_API = CASE_BLOCK_USERS
        }
        else {
            CASE_API = CASE_BLOCK_PROVIDER
        }
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_API, dictParameters: aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            if response.count != 0 {
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        
                        self.dismiss(animated: true, completion: nil)
                    })
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
    func setServiceStatusApi(statusType:String) {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
            aDictParams["id"] = gStrServiceId
            aDictParams["type"] = SESSION.getUserLogInType()
            aDictParams["status"] = statusType
            aDictParams["reason"] = myStrReason
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_BOOKING_STATUS_UPDATE, dictParameters: aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        
                        self.dismiss(animated: true, completion: nil)
                    })
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
