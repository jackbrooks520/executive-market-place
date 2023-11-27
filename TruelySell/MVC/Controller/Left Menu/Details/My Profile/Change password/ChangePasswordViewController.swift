
import UIKit
import IQKeyboardManagerSwift

class ChangePasswordViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var myBtnSubmit: UIButton!
    
    @IBOutlet var myViewCrtPwd: UIView!
    @IBOutlet var myViewNewPwd: UIView!
    @IBOutlet var myViewCnfCrtPwd: UIView!
   
    @IBOutlet var myTxtFldCrtPwd: UITextField!
    @IBOutlet var myTxtFldNewPwd: UITextField!
    @IBOutlet var myTxtFldCnfCrtPwd: UITextField!
    
    @IBOutlet var myLblCrtPwd: UILabel!
    @IBOutlet var myLblNewPwd: UILabel!
    @IBOutlet var myLblCnfCrtPwd: UILabel!
    
    var aDictLangSignUp = [String:Any]()
    var aDictCommonText = [String:Any]()
    
    var myStrScreenTitle = String()
    var myStrLoading = String()
    
    var myStrPassword = String()
    var myStrNewPassword = String()
    var myStrCnfrmPassword = String()
    var myStrUserType = String()
    
    
    let TAG_PASSWORD : Int = 10
    let TAG_NEW_PASSWORD : Int = 30
    let TAG_CNFRM_PASSWORD : Int = 50

    
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
//        changeLanguageContent()
        setUpLeftBarBackButton()
        IQKeyboardManager.shared.enable = true
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: ChangePasswordScreenTitle.CHANGE_PASSWORD.titlecontent(), aViewController: self)
        
        HELPER.setBorderView(aView: myViewCrtPwd, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3)
        HELPER.setBorderView(aView: myViewNewPwd, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3)
        HELPER.setBorderView(aView: myViewCnfCrtPwd, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3)

        myBtnSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        myTxtFldCrtPwd.delegate = self
        myTxtFldNewPwd.delegate = self
        myTxtFldCnfCrtPwd.delegate = self
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
               myLblCrtPwd.textAlignment = .right
             myLblNewPwd.textAlignment = .right
             myLblCnfCrtPwd.textAlignment = .right
           }
           else {
               myLblCrtPwd.textAlignment = .left
            myLblNewPwd.textAlignment = .left
                        myLblCnfCrtPwd.textAlignment = .left
           }
        
        
        myLblCrtPwd.text = ChangePasswordScreenTitle.CURRENT_PASSWORD.titlecontent()
        myLblNewPwd.text = ChangePasswordScreenTitle.NEW_PASSWORD.titlecontent()
        myLblCnfCrtPwd.text = ChangePasswordScreenTitle.CONFIRM_PASSWORD.titlecontent()
    
        myTxtFldCrtPwd.tag = TAG_PASSWORD
        myTxtFldNewPwd.tag = TAG_NEW_PASSWORD
        myTxtFldCnfCrtPwd.tag = TAG_CNFRM_PASSWORD
myBtnSubmit.setTitle(ProviderAndUserScreenTitle.BTN_SUBMIT.titlecontent(), for: .normal)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    // MARK: - Textfield delegate and datasource
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
 
        if textField.tag == TAG_PASSWORD {
            
            if txtAfterUpdate.count <= 15 {
                
                myStrPassword = txtAfterUpdate
                
                return true
            }
                
            else {
                
                return false
            }
        }
            
        else if textField.tag == TAG_NEW_PASSWORD {
            
            if txtAfterUpdate.count <= 15 {
                
                myStrNewPassword = txtAfterUpdate
                
                return true
            }
                
            else {
                
                return false
            }
        }
        
        else if textField.tag == TAG_CNFRM_PASSWORD {
            
            if txtAfterUpdate.count <= 15 {
                
                myStrCnfrmPassword = txtAfterUpdate
                
                return true
            }
                
            else {
                
                return false
            }
        }
        
        return true;
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField == myTxtFldCrtPwd) {
            
            myTxtFldCrtPwd.resignFirstResponder()
            myTxtFldNewPwd.becomeFirstResponder()
        }
            
        else if (textField == myTxtFldNewPwd) {
            
            myTxtFldNewPwd.resignFirstResponder()
            myTxtFldCnfCrtPwd.becomeFirstResponder()
            
        } else {
            
            myTxtFldCnfCrtPwd.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // MARK: -Api call
    
    func callChangePasswordApi() {
    
        var dictInfo = [String:String]()
        dictInfo["current_password"] = myStrPassword
        dictInfo["confirm_password"] = myStrCnfrmPassword
        dictInfo["user_id"] = SESSION.getUserProviderID()
         dictInfo["user_type"] = myStrUserType
       
        
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")

        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_CHANGE_PASSWORD,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            var aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
    
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aDictResponse[kRESPONSE_MESSAGE]!, okActionBlock: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
                
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
            
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
        })
    }
    
    
    // MARK: - Button action
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        let isNewPassword = isPasswordValid(password: myTxtFldNewPwd.text!)
        let isConfirmPassword = isPasswordValid(password: myTxtFldCnfCrtPwd.text!)
        
        if (myTxtFldCrtPwd.text?.isEmpty)! && (myTxtFldNewPwd.text?.isEmpty)! && (myTxtFldCnfCrtPwd.text?.isEmpty)! {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ChangePasswordScreenTitle.EMPTY_PASSWORD.titlecontent())
        }
            
        else if (myTxtFldCrtPwd.text?.isEmpty)! {
             HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ChangePasswordScreenTitle.ENTER_CURRENT_PASSWORD.titlecontent())
            
        }
            
        else if (myTxtFldNewPwd.text?.isEmpty)! {
               HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ChangePasswordScreenTitle.ENTER_NEW_PASSWORD.titlecontent())
//            let alert = UIAlertController(title: APP_NAME, message: (aDictLangSignUp["lg1_enter_new_passw"] as? String)!, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: (aDictCommonText["lg7_ok"] as? String)!, style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
            
//        else if (myTxtFldNewPwd.text?.count)! < 8 {
//
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: (aDictCommonText["lg7_password_must_b"] as? String)!)
//
//            return
//        }
        
//        else if !isNewPassword {
//
//            let alert = UIAlertController(title: APP_NAME, message: (aDictCommonText["lg7_password_must_b"] as? String)!, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: (aDictCommonText["lg7_ok"] as? String)!, style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
            
        else if (myTxtFldCnfCrtPwd.text?.isEmpty)! {
               HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ChangePasswordScreenTitle.ENTER_CONFIRM_PASSWORD.titlecontent())
//            let alert = UIAlertController(title: APP_NAME, message: (aDictLangSignUp["lg1_enter_confirm_p"] as? String)!, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: (aDictCommonText["lg7_ok"] as? String)!, style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
            
//        else if (myTxtFldCnfCrtPwd.text?.count)! < 8 {
//
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: (aDictCommonText["lg7_password_must_b"] as? String)!)
//
//            return
//        }
            
//        else if !isConfirmPassword {
//
//            let alert = UIAlertController(title: APP_NAME, message: (aDictCommonText["lg7_password_must_b"] as? String)!, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: (aDictCommonText["lg7_ok"] as? String)!, style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
            
        else if (myTxtFldNewPwd.text) != (myTxtFldCnfCrtPwd.text) {
               HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ChangePasswordScreenTitle.NEW_AND_CONFIRM_PASSWORD_NOT_MATCH.titlecontent())
//            let alert = UIAlertController(title: APP_NAME, message: (aDictLangSignUp["lg1_password_and_co"] as? String)!, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: (aDictCommonText["lg7_ok"] as? String)!, style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        }
            
        else {
            
            callChangePasswordApi()
        }
        
    }
    
    // MARK: - Private Action
    
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

    func isPasswordValid(password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*\\d)(?=.*[a-z]|[A-Z])[^\\s]{8,15}$")
        return passwordTest.evaluate(with: password)
    }
    
//    func changeLanguageContent() {
//
//        var aDictLangInfo = SESSION.getLangInfo()
//        var aDictScreenTitle = [String:Any]()
//        aDictLangSignUp = aDictLangInfo["sign_up"] as! [String : Any]
//        aDictScreenTitle = aDictLangInfo["navigation"] as! [String : Any]
//        myStrScreenTitle = aDictScreenTitle["lg3_change_password"] as! String
//        aDictCommonText = aDictLangInfo["common_used_texts"] as! [String : Any]
//
////        var aDictLangCommonContent = [String:Any]()
////        aDictLangCommonContent = aDictLangInfo["common_used_texts"] as! [String : Any]
////        myStrLoading = aDictLangCommonContent["lg7_loading"] as! String
//
//        myBtnSubmit.setTitle(ProviderAndUserScreenTitle.BTN_SUBMIT.titlecontent(), for: .normal)
//    }
}
