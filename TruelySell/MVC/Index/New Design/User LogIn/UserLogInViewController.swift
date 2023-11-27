
import UIKit
import SwiftyCodeView
import ADCountryPicker
import Presentr

class UserLogInViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,SwiftyCodeViewDelegate, ADCountryPickerDelegate {
    
    @IBOutlet weak var myBtnClose: UIButton!
    @IBOutlet weak var myViewClose: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myLblProfessionalContent: UILabel!
    @IBOutlet weak var myContanierView: UIView!
    @IBOutlet weak var myHeightConstraintContainerView: NSLayoutConstraint!
    @IBOutlet var mySegmentControl: UISegmentedControl!
   
    @IBOutlet var myCollectionViewTopConstraint: NSLayoutConstraint!
    let cellCategoryCollectionFieldsIdentifier = "ProfessionalLogInFieldsCollectionViewCell"
    let cellCategoryCollectionOTPIdentifier = "ProfessionalLogInOTPCollectionViewCell"
    let cellCategoryCollectionAlreadyIdentifier = "ProfessionalLogInMobNoCollectionViewCell"
    let cellCategoryProfessionalEmailLogin = "ProfessionalEmailLoginCollectionViewCell"
    let cellCategoryProfessionalLoginForgotPasswordIdentifier = "ProfessionalLoginForgotPasswordCollectionViewCell"
    
    var countryImages = [UIImage]()
    var myDictProviderLogInResponseData = [String:Any]()
    var myBoolTerms = Bool()
    var myStrCatName: String = ""
    var myStrSubCatName: String = ""
    var myStrName = String()
    var myStrReferenceCode = String()
    var myStrEmail = String()
    var myStrMobileCode = String()
    var myStrMobileNumber = String()
    var myStrOTPCode = String()
    var myStrRegPassword = String()
    var myStrRegConfirmPassword = String()
    var myStrEmailLoginEmail = String()
    var myStrEmailLoginPassword = String()
    var myStrEmailLoginForgotPassword = String()
    var myStrLoginType:String = "1"
    var myCountryList = Countries()
    
    let TAG_CAT = 100
    let TAG_SUB_CAT = 200
    let TAG_SUB_NAME = 300
    let TAG_SUB_EMAIL = 400
    let TAG_SUB_MOB_CODE = 500
    let TAG_SUB_MOB_CODE_ALREADY = 550
    let TAG_SUB_MOB_NO = 600
    let TAG_REF_NO = 700
    let TAG_NEW_REG_PASSWORD = 800
    let TAG_NEW_REG_CONFIRM_PASSWORD = 900
    let TAG_EMAIL_LOGIN_EMAIL = 805
    let TAG_EMAIL_LOGIN_PASSWORD = 905
    let TAG_EMAIL_LOGIN_FORGOT_PASSWORD = 950
    var isAlreadyProvider:Bool = true
    var isFromTabbar:Bool = false
    
    
    var myAryCountryCode = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
    }
    
    
    func setUpUI() {
        
        myViewClose.layer.cornerRadius = myViewClose.layer.frame.width / 2
        myViewClose.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        self.myLblProfessionalContent.text = APP_NAME
        myBtnClose.setImage(UIImage(named: "icon_new_login_close_white"), for: .normal)
         if SESSION.getIsFromEmailLoginType() == false {
            myHeightConstraintContainerView.constant =  300
        }
        else {
            myHeightConstraintContainerView.constant = 380
        }
        HELPER.setRoundCornerView(aView: myContanierView, borderRadius: 10.0)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.register(UINib(nibName: cellCategoryCollectionFieldsIdentifier, bundle: nil), forCellWithReuseIdentifier: cellCategoryCollectionFieldsIdentifier)
        myCollectionView.register(UINib(nibName: cellCategoryCollectionOTPIdentifier, bundle: nil), forCellWithReuseIdentifier: cellCategoryCollectionOTPIdentifier)
        myCollectionView.register(UINib(nibName: cellCategoryCollectionAlreadyIdentifier, bundle: nil), forCellWithReuseIdentifier: cellCategoryCollectionAlreadyIdentifier)
        myCollectionView.register(UINib(nibName: cellCategoryProfessionalEmailLogin, bundle: nil), forCellWithReuseIdentifier: cellCategoryProfessionalEmailLogin)
        myCollectionView.register(UINib(nibName: cellCategoryProfessionalLoginForgotPasswordIdentifier, bundle: nil), forCellWithReuseIdentifier: cellCategoryProfessionalLoginForgotPasswordIdentifier)
        
        if isFromTabbar == true {
            myViewClose.isHidden = false
        }else {
            
            myViewClose.isHidden = true
        }
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    @IBAction func indexChanged(_ sender: Any) {
        switch mySegmentControl.selectedSegmentIndex
            {
            case 0:
               myStrLoginType = "1"
            myCollectionView.reloadData()
            case 1:
            myStrLoginType = "2"
            myCollectionView.reloadData()
            default:
                break
            }
    }
    // MARK: - Collection View Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            
            if isAlreadyProvider == true {
                if SESSION.getIsFromEmailLoginType() == false {
                    
                    let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCategoryCollectionAlreadyIdentifier, for: indexPath) as! ProfessionalLogInMobNoCollectionViewCell
                    myCollectionViewTopConstraint.constant = 45
                    mySegmentControl.isHidden = false
                    HELPER.setRoundCornerView(aView: aCell.gViewNext, borderRadius: 15.0)
                    HELPER.setRoundCornerView(aView: aCell.gViewPrevious, borderRadius: 15.0)
                    aCell.gViewNext.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                    aCell.gViewPrevious.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                    aCell.gTxtFldMobCode.placeholder = ProviderAndUserScreenTitle.CODE_TITLE.titlecontent()
                    aCell.gTxtFldMobCode.isUserInteractionEnabled = false
                  
                    HELPER.translateTextField(textField: aCell.gTxtFldMobNo, key: "txt_fld_mobile_num", inPage: "register_screen", isPlaceHolderEnabled: true)
                    
                    aCell.gBtnNext.setTitle(ProviderAndUserScreenTitle.LOGIN_TITLE.titlecontent(), for: .normal)
                    aCell.gBtnPrevious.setTitle(ProviderAndUserScreenTitle.PREVIOUS_TITLE.titlecontent(), for: .normal)
                    if  myStrLoginType == "1" {
                        self.myLblProfessionalContent.text =  ProviderAndUserScreenTitle.LOGIN_AS_USER.titlecontent()
                        aCell.gLblAlreadyContent.text = ProviderAndUserScreenTitle.ALREADY_USER.titlecontent()
                    } else {
                        self.myLblProfessionalContent.text =  ProviderAndUserScreenTitle.LOGIN_AS_PROFESSIONAL.titlecontent()
                        aCell.gLblAlreadyContent.text = ProviderAndUserScreenTitle.ALREADY_PROFESSIONAL.titlecontent()
                    }
                 
                    if  UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gTxtFldMobCode.textAlignment = .right
                        aCell.gTxtFldMobNo.textAlignment = .right
                    }
                    else {
                        aCell.gTxtFldMobCode.textAlignment = .left
                        aCell.gTxtFldMobNo.textAlignment = .left
                        
                    }
                    
                    aCell.gTxtFldMobCode.tag = TAG_SUB_MOB_CODE_ALREADY
                    aCell.gTxtFldMobNo.tag = TAG_SUB_MOB_NO
                    aCell.gViewPrevious.isHidden = true
                    aCell.gTxtFldMobNo.delegate = self
                    
                    aCell.gBtnMobCode.addTarget(self, action: #selector(self.mobCodeBtnTapped(sender:)), for: .touchUpInside)
                    aCell.gBtnNext.addTarget(self, action: #selector(self.nextBtnSecondTappedAlreadyProvider(sender:)), for: .touchUpInside)
                    aCell.gBtnPrevious.addTarget(self, action: #selector(self.previousBtnSecondTapped(sender:)), for: .touchUpInside)
                    aCell.gBtnAlreadyProviderLogInTick.addTarget(self, action: #selector(self.alreadyProviderBtnTapped(sender:)), for: .touchUpInside)
                    HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnAlreadyProviderLogInTick, imageName: "icon_new_check")
                    return aCell
                }
                else {
                    let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCategoryProfessionalEmailLogin, for: indexPath) as! ProfessionalEmailLoginCollectionViewCell
                    myCollectionViewTopConstraint.constant = 45
                    mySegmentControl.isHidden = false
                    HELPER.translateTextField(textField: aCell.gTxtFldEmail, key: "txt_fld_email", inPage: "register_screen", isPlaceHolderEnabled: true)
                    aCell.gTxtFldPassword.placeholder = EmailLoginScreenTitle.PASSWORD.titlecontent()
                    aCell.gBtnForgotPassword.setTitle(EmailLoginScreenTitle.FORGOT_PASSWORD.titlecontent(), for: .normal)
                    aCell.gBtnForgotPassword.setTitleColor(HELPER.hexStringToUIColor(hex: SESSION.getAppColor()), for: .normal)
                    aCell.gBtnLogin.setTitle(ProviderAndUserScreenTitle.LOGIN_TITLE.titlecontent(), for: .normal)
                    aCell.gViewPrevious.isHidden = true
                    aCell.gBtnLogin.addTarget(self, action: #selector(self.ThroughEmailLoginBtnTapped(sender:)), for: .touchUpInside)
                    aCell.gBtnForgotPassword.addTarget(self, action: #selector(self.ForgotPasswordBtnTapped(sender:)), for: .touchUpInside)
                    HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gRadioBtn, imageName: "icon_new_check")
                    aCell.gRadioBtn.addTarget(self, action: #selector(self.alreadyProviderBtnTapped(sender:)), for: .touchUpInside)

//                    aCell.gViewRadioBtnContainer.isHidden = false
//                    aCell.gViewRadioBtnHeightConstraint.constant = 50
                    aCell.gViewPrevious.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                    aCell.gViewLogin.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                    
                    HELPER.setRoundCornerView(aView: aCell.gViewPrevious, borderRadius: 15.0)
                    HELPER.setRoundCornerView(aView: aCell.gViewLogin, borderRadius: 15.0)
                    if  myStrLoginType == "1" {
                        aCell.gLblAlreadyProvider.text = ProviderAndUserScreenTitle.ALREADY_USER.titlecontent()
                    } else {
                        aCell.gLblAlreadyProvider.text = ProviderAndUserScreenTitle.ALREADY_PROFESSIONAL.titlecontent()
                    }
                    if  UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gTxtFldEmail.textAlignment = .right
                        
                        aCell.gTxtFldPassword.textAlignment = .right
                    }
                    else {
                        aCell.gTxtFldEmail.textAlignment = .left
                        
                        aCell.gTxtFldPassword.textAlignment = .left
                    }
                    aCell.gTxtFldPassword.tag = TAG_EMAIL_LOGIN_PASSWORD
                    aCell.gTxtFldEmail.tag = TAG_EMAIL_LOGIN_EMAIL
                    aCell.gTxtFldPassword.delegate = self
                    aCell.gTxtFldEmail.delegate = self
                    
                    return aCell
                    
                }
            }
            else {
                
                let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCategoryCollectionFieldsIdentifier, for: indexPath) as! ProfessionalLogInFieldsCollectionViewCell
                
                myCollectionViewTopConstraint.constant = 45
                mySegmentControl.isHidden = false
                HELPER.translateTextField(textField: aCell.gTxtFldName, key: "txt_fld_name", inPage: "register_screen", isPlaceHolderEnabled: true)
                HELPER.translateTextField(textField: aCell.gTxtFldEmail, key: "txt_fld_email", inPage: "register_screen", isPlaceHolderEnabled: true)
                HELPER.translateTextField(textField: aCell.gTxtFldMobNo, key: "txt_fld_mobile_num", inPage: "register_screen", isPlaceHolderEnabled: true)
                HELPER.translateTextField(textField: aCell.gTxtFldReferenceCode, key: "txt_fld_reference_code", inPage: "register_screen", isPlaceHolderEnabled: true)
                
                aCell.gTxtFldMobCode.placeholder = ProviderAndUserScreenTitle.CODE_TITLE.titlecontent()
                self.myLblProfessionalContent.text = APP_NAME
                HELPER.setRoundCornerView(aView: aCell.gViewNext, borderRadius: 15.0)
                HELPER.setRoundCornerView(aView: aCell.gViewPrevious, borderRadius: 15.0)
                aCell.gBtnReadTerms.setTitleColor(HELPER.hexStringToUIColor(hex: SESSION.getAppColor()), for: .normal)
                aCell.gBtnReadPrivacy.setTitleColor(HELPER.hexStringToUIColor(hex: SESSION.getAppColor()), for: .normal)
                aCell.gViewPrevious.isHidden = true
                aCell.gViewNext.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                aCell.gViewPrevious.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                aCell.gTxtFldMobCode.isUserInteractionEnabled = false
                aCell.gBtnNext.setTitle(ProviderAndUserScreenTitle.REGISTER_TITLE.titlecontent(), for: .normal)
                aCell.gBtnPrevious.setTitle(ProviderAndUserScreenTitle.LOGIN_TITLE.titlecontent(), for: .normal)
           
                aCell.gViewPrevious.isHidden = false
                aCell.gTxtFldName.tag = TAG_SUB_NAME
                aCell.gTxtFldEmail.tag = TAG_SUB_EMAIL
                aCell.gTxtFldMobCode.tag = TAG_SUB_MOB_CODE
                aCell.gTxtFldMobNo.tag = TAG_SUB_MOB_NO
                aCell.gTxtFldReferenceCode.tag = TAG_REF_NO
                aCell.gTxtFldPassword.tag = TAG_NEW_REG_PASSWORD
                
                aCell.gTxtFldName.delegate = self
                aCell.gTxtFldEmail.delegate = self
                aCell.gTxtFldMobNo.delegate = self
                aCell.gTxtFldReferenceCode.delegate = self
                aCell.gTxtFldPassword.delegate = self
               
                aCell.gLblTermsContent.text = "I agree with"
                aCell.gLblAnd.text = "and"
                 aCell.gBtnReadTerms.setTitle("Terms", for: .normal)
                aCell.gBtnReadPrivacy.setTitle("Privacy", for: .normal)
             
                if  UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTxtFldMobCode.textAlignment = .right
                    aCell.gTxtFldMobNo.textAlignment = .right
                    aCell.gTxtFldName.textAlignment = .right
                    aCell.gTxtFldEmail.textAlignment = .right
                    aCell.gTxtFldReferenceCode.textAlignment = .right
                    aCell.gTxtFldPassword.textAlignment = .right
                }
                else {
                    aCell.gTxtFldMobCode.textAlignment = .left
                    aCell.gTxtFldMobNo.textAlignment = .left
                    aCell.gTxtFldName.textAlignment = .left
                    aCell.gTxtFldEmail.textAlignment = .left
                    aCell.gTxtFldReferenceCode.textAlignment = .left
                    aCell.gTxtFldPassword.textAlignment = .left
                }
                
                aCell.gTxtFldMobNo.text = myStrMobileNumber
                aCell.gTxtFldName.text = myStrName
                aCell.gTxtFldEmail.text = myStrEmail
                aCell.gTxtFldReferenceCode.text = myStrReferenceCode
                aCell.gTxtFldPassword.text = myStrRegPassword
                
                if isAlreadyProvider == true {
                    
                    aCell.gViewName.isHidden = true
                    aCell.gViewEmail.isHidden = true
                    aCell.gConstraintHeightName.constant = 0
                    aCell.gConstraintHeightEmail.constant = 0
                }
                else {
                    
                    aCell.gViewName.isHidden = false
                    aCell.gViewEmail.isHidden = false
                    aCell.gConstraintHeightName.constant = 40
                    aCell.gConstraintHeightEmail.constant = 40
                }
                
                if SESSION.getIsFromEmailLoginType() == false {
                    
                    aCell.gViewPasswordContainer.isHidden = true
                    aCell.gViewPasswordHeightConstraint.constant = 0
                }
                else if SESSION.getIsFromEmailLoginType() == true {
                    aCell.gViewPasswordHeightConstraint.constant = 45
                    
                    
                }
                
                aCell.gTxtFldMobCode.placeholder = ProviderAndUserScreenTitle.CODE_TITLE.titlecontent()
                aCell.gBtnNext.addTarget(self, action: #selector(self.nextBtnSecondTapped(sender:)), for: .touchUpInside)
                aCell.gBtnPrevious.addTarget(self, action: #selector(self.alreadyProviderBtnTapped(sender: )), for: .touchUpInside)
                aCell.gBtnAcceptTerms.addTarget(self, action: #selector(self.acceptTermsBtnTapped(sender:)), for: .touchUpInside)
                aCell.gBtnMobCode.addTarget(self, action: #selector(self.mobCodeBtnTapped(sender:)), for: .touchUpInside)
                aCell.gBtnReadTerms.addTarget(self, action: #selector(self.tandcBtnTapped(sender:)), for: .touchUpInside)
                aCell.gBtnReadPrivacy.addTarget(self, action: #selector(self.PrivacyBtnTapped(sender:)), for: .touchUpInside)
                
                aCell.gBtnAlreadyUser.addTarget(self, action: #selector(self.alreadyProviderBtnTapped(sender:)), for: .touchUpInside)
                if myBoolTerms {
                    HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnAcceptTerms, imageName: "icon_new_check")
                    aCell.gImgTermsTick.isHidden = false
                } else {
                    HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnAcceptTerms, imageName: "icon_new_uncheck")
                    aCell.gImgTermsTick.isHidden = true
                }
                aCell.gTxtFldMobCode.text = myStrMobileCode
                if  myStrLoginType == "1" {
                    self.myLblProfessionalContent.text = ProviderAndUserScreenTitle.JOIN_AS_USER.titlecontent()
                    aCell.gLblAlreadyContent.text = ProviderAndUserScreenTitle.ALREADY_USER.titlecontent()
                } else {
                    self.myLblProfessionalContent.text = ProviderAndUserScreenTitle.JOIN_AS_PROFESSIONAL.titlecontent()
                    aCell.gLblAlreadyContent.text = ProviderAndUserScreenTitle.ALREADY_PROFESSIONAL.titlecontent()
                }
                return aCell
            }
        }
        else if indexPath.row == 1 {
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCategoryCollectionOTPIdentifier, for: indexPath) as! ProfessionalLogInOTPCollectionViewCell
            
            aCell.myLblAccessCodeContent.text = ProviderAndUserScreenTitle.ACCESS_CODE.titlecontent()
            myCollectionViewTopConstraint.constant = 5
            mySegmentControl.isHidden = true
            HELPER.setRoundCornerView(aView: aCell.gViewNext, borderRadius: 15.0)
            aCell.gViewNext.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.myLblMobileNumber.text = ProviderAndUserScreenTitle.OTP_SENT_CONTENT.titlecontent() + myStrMobileCode +  " " + myStrMobileNumber
            aCell.gBtnSubmit.addTarget(self, action: #selector(self.submitBtnTapped(sender:)), for: .touchUpInside)
            aCell.myViewOtp.code = ""
            aCell.myViewOtp.delegate = (self as SwiftyCodeViewDelegate)
            
            aCell.gBtnSubmit.setTitle(ProviderAndUserScreenTitle.BTN_SUBMIT.titlecontent(), for: .normal)
            aCell.myBtnResendOtp.addTarget(self, action: #selector(self.resendBtnTapped(sender:)), for: .touchUpInside)
            aCell.myBtnResendOtp.setTitle(ProviderAndUserScreenTitle.RESEND_OTP.titlecontent(), for: .normal)
            aCell.myBtnResendOtp.setTitleColor(HELPER.hexStringToUIColor(hex: SESSION.getAppColor()), for: .normal)
            return aCell
        }
        else {
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCategoryProfessionalLoginForgotPasswordIdentifier, for: indexPath) as! ProfessionalLoginForgotPasswordCollectionViewCell
            myLblProfessionalContent.text = EmailLoginScreenTitle.FORGOT_PASSWORD.titlecontent()
            HELPER.translateTextField(textField: aCell.gTxtFldEmail, key: "txt_fld_email", inPage: "register_screen", isPlaceHolderEnabled: true)
            if  UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                aCell.gTxtFldEmail.textAlignment = .right
            }
            else {
                aCell.gTxtFldEmail.textAlignment = .left
            }
            myCollectionViewTopConstraint.constant = 5
            mySegmentControl.isHidden = true
            aCell.gTxtFldEmail.delegate = self
            aCell.gTxtFldEmail.tag = TAG_EMAIL_LOGIN_FORGOT_PASSWORD
            aCell.gTxtFldEmail.text = myStrEmailLoginForgotPassword
            aCell.gViewSubmitBtn.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            HELPER.setRoundCornerView(aView: aCell.gViewSubmitBtn, borderRadius: 15.0)
            aCell.gBtnSubmit.setTitle(ProviderAndUserScreenTitle.BTN_SUBMIT.titlecontent(), for: .normal)
            aCell.gBtnSubmit.addTarget(self, action: #selector(self.ForgotPasswordSubmitBtnTapped(sender:)), for: .touchUpInside)
            return aCell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width + 10, height: collectionView.frame.height + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    @objc func maleBtnTapped(sender: UIButton) {
        self.myStrLoginType = "1"
        let myIndexPath = IndexPath(row: 0, section: 0)
        self.myCollectionView.reloadItems(at: [myIndexPath])
    }
    @objc func femaleBtnTapped(sender: UIButton) {
        self.myStrLoginType = "2"
        let myIndexPath = IndexPath(row: 0, section: 0)
        self.myCollectionView.reloadItems(at: [myIndexPath])
    }
    @objc func acceptTermsBtnTapped(sender: UIButton) {
        if myBoolTerms {
            myBoolTerms = false
        } else {
            myBoolTerms = true
        }
        let myIndexPath = IndexPath(row: 0, section: 0)
        self.myCollectionView.reloadItems(at: [myIndexPath])
    }
    
    // MARK: - Textfield Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.tag == TAG_SUB_NAME {
            
            myStrName = txtAfterUpdate
        }
        else if textField.tag == TAG_SUB_EMAIL {
            
            myStrEmail = txtAfterUpdate
        }
        else if textField.tag == TAG_SUB_MOB_NO {
            
            if txtAfterUpdate.count <= 15 {
                
                myStrMobileNumber = txtAfterUpdate
                
                return true
            }
            else {
                
                return false
            }
        }
        else if textField.tag == TAG_REF_NO {
            myStrReferenceCode = txtAfterUpdate
        }
        else if textField.tag == TAG_EMAIL_LOGIN_EMAIL {
            myStrEmailLoginEmail = txtAfterUpdate
        }
        else if textField.tag == TAG_EMAIL_LOGIN_PASSWORD {
            myStrEmailLoginPassword = txtAfterUpdate
        }
        else if textField.tag == TAG_NEW_REG_CONFIRM_PASSWORD {
            myStrRegConfirmPassword = txtAfterUpdate
        }
        else if textField.tag == TAG_NEW_REG_PASSWORD {
            myStrRegPassword = txtAfterUpdate
        }
        else if textField.tag == TAG_EMAIL_LOGIN_FORGOT_PASSWORD {
            myStrEmailLoginForgotPassword =  txtAfterUpdate
        }
        return true;
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        
        textfield.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        print(code, dialCode)
        let mobileCode =  dialCode.components(separatedBy: "+")
        myStrMobileCode = mobileCode[1]
        if isAlreadyProvider == true {
            
            let aTxtFldMobilecodeAlready = self.myCollectionView.viewWithTag(TAG_SUB_MOB_CODE_ALREADY) as! UITextField
            
            aTxtFldMobilecodeAlready.text = myStrMobileCode
            
        }
        else {
            
            let aTxtFldMobilecode = self.myCollectionView.viewWithTag(TAG_SUB_MOB_CODE) as! UITextField
            aTxtFldMobilecode.text = myStrMobileCode
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) -> Bool {
        
        myStrOTPCode = code
        
        if myStrOTPCode.count < 4 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_VALID_OTP.titlecontent())
            return true
        }
        else {
            
            var aDict = [String:Any]()
            aDict["mobileno"] = myStrMobileNumber
            aDict["otp"] = myStrOTPCode
            aDict["country_code"] = myStrMobileCode
            if myStrLoginType == "1" {
                getUserLoginOTPToApi(aDictParam: aDict as! [String : String])
            } else {
                getProviderLoginOTPToApi(aDictParam: aDict as! [String : String])
            }
           
           
        }
        return true
    }
    
    
    // MARK: - Button Action
    @objc func PrivacyBtnTapped(sender: UIButton) {
        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_WEBVIEW_VC) as! WebViewViewController
        aViewController.gStrTitle = "Privacy Policy"
        aViewController.gStrContent = PRIVACY_POLICY_URL
        let width = ModalSize.custom(size: Float(self.myCollectionView.frame.width))
        let height =  ModalSize.custom(size: Float(self.myCollectionView.frame.height) + 200)
        
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .coverVertical
        customPresenter.roundCorners = true
        customPresenter.dismissOnSwipe = false
        customPresenter.dismissOnSwipeDirection = .default
        customPresenter.blurBackground = false
        customPresenter.blurStyle = .extraLight
        
        
        self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
      
    }
    @objc func tandcBtnTapped(sender: UIButton) {
        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_WEBVIEW_VC) as! WebViewViewController
        aViewController.gStrTitle = SettingsLangContents.TEARMS_AND_CONDITION_TITLE.titlecontent()
        aViewController.gStrContent = TERMS_CONDITION_URL
        let width = ModalSize.custom(size: Float(self.myCollectionView.frame.width))
        let height =  ModalSize.custom(size: Float(self.myCollectionView.frame.height) + 200)
        
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .coverVertical
        customPresenter.roundCorners = true
        customPresenter.dismissOnSwipe = false
        customPresenter.dismissOnSwipeDirection = .default
        customPresenter.blurBackground = false
        customPresenter.blurStyle = .extraLight
        
        
        self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
      
    }
    @objc func ThroughEmailLoginBtnTapped(sender: UIButton) {
        var aDict = [String:Any]()
        if isAlreadyProvider == true {
            if myStrEmailLoginEmail.count == 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_EMAIL.titlecontent())
                return
            }
            else if !HELPER.isValidEmailAddress(emailAddressString: myStrEmailLoginEmail) {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_VALID_EMAIL.titlecontent())
                return
            }
            else if myStrEmailLoginPassword.count == 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ChangePasswordScreenTitle.EMPTY_PASSWORD.titlecontent())
                return
            }
            else {
                
                aDict["email"] = myStrEmailLoginEmail
                aDict["password"] = myStrEmailLoginPassword
              
                if myStrLoginType == "1" {
                    getUserLoginOTPToApi(aDictParam: aDict as! [String : String])
                } else {
                    getProviderLoginOTPToApi(aDictParam: aDict as! [String : String])
                }
            }
            
            
        }
        
        
    }
    
    @objc func ForgotPasswordBtnTapped(sender: UIButton) {
        updateConstraintsForContainerView(constraintValue: 230)
        let rect = self.myCollectionView.layoutAttributesForItem(at: IndexPath(row: 2, section: 0))?.frame
        self.myCollectionView.scrollRectToVisible(rect!, animated: false)
        
        
        //        self.myCollectionView.scrollToItem(at:IndexPath(item: 2, section: 0), at: .right, animated: true)
    }
    @objc func ForgotPasswordSubmitBtnTapped(sender: UIButton) {
        if myStrEmailLoginForgotPassword.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_EMAIL.titlecontent())
            return
        }
        else if !HELPER.isValidEmailAddress(emailAddressString: myStrEmailLoginForgotPassword) {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_VALID_EMAIL.titlecontent())
            return
        }
        else {
            var aDict = [String:Any]()
            
            aDict["email"] = myStrEmailLoginForgotPassword
            aDict["mode"] = "2"
            
            callForgotPasswordApi(aDictParam: aDict as! [String : String])
        }
    }
    
    
    @objc func nextBtnSecondTapped(sender: UIButton) {
        
        var aDict = [String:Any]()
        
        if myStrName.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_NAME.titlecontent())
            return
        }
        else if myStrEmail.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_EMAIL.titlecontent())
            return
        }
        
        else if myStrMobileCode.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.SELECT_MOBILE_CODE.titlecontent())
            return
        }
        else if myStrMobileNumber.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_MOBILE_NUM.titlecontent())
            return
        }
        else if myStrMobileNumber.count < 9 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_VALID_MOBILE_NO.titlecontent())
            return
        }
        else if myStrLoginType == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "Select Join type")
            return
        }
        else if myBoolTerms == false {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "Accept Terms and condition")
            return
        }
        else if SESSION.getIsFromEmailLoginType() == true {
            if myStrRegPassword.count == 0 {
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ChangePasswordScreenTitle.EMPTY_PASSWORD.titlecontent())
                return
            }
            else {
                aDict["name"] = myStrName
                aDict["email"] = myStrEmail
                aDict["country_code"] = myStrMobileCode
                aDict["mobileno"] = myStrMobileNumber
                aDict["device_id"] = SESSION.getDeviceToken()
                aDict["device_type"] = kDEVICE_TYPE_IOS
                aDict["password"] = myStrRegPassword
                print(aDict)
                if myStrLoginType == "1" {
                    getUserLoginFromApi(aDictParam: aDict as! [String : String], isFromResend: false)
                } else {
                    getProviderLoginFromApi(aDictParam:aDict as! [String : String], isFromResend: false)
                }
               
            }
        }
        else {
            
            aDict["name"] = myStrName
            aDict["email"] = myStrEmail
            aDict["country_code"] = myStrMobileCode
            aDict["mobileno"] = myStrMobileNumber
            aDict["device_id"] = SESSION.getDeviceToken()
            aDict["device_type"] = kDEVICE_TYPE_IOS
            
            print(aDict)
            if myStrLoginType == "1" {
                getUserLoginFromApi(aDictParam: aDict as! [String : String], isFromResend: false)
            } else {
                getProviderLoginFromApi(aDictParam:aDict as! [String : String], isFromResend: false)
            }
        }
    }
    
    @objc func previousBtnSecondTapped(sender: UIButton) {
        
        updateConstraintsForContainerView(constraintValue: 330)
        self.myCollectionView.scrollToItem(at:IndexPath(item: 1, section: 0), at: .right, animated: true)
    }
    
    @objc func submitBtnTapped(sender: UIButton) {
        
        if myStrOTPCode.count < 4 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_VALID_OTP.titlecontent())
            return
        }
    }
    
    @objc func nextBtnSecondTappedAlreadyProvider(sender: UIButton) {
        
        var aDict = [String:Any]()
        
        if isAlreadyProvider == true {
            
            if myStrMobileCode.count == 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.SELECT_MOBILE_CODE.titlecontent())
                return
            }
            else if myStrMobileNumber.count == 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_MOBILE_NUM.titlecontent())
                return
            }
            else if myStrMobileNumber.count < 9 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.ENTER_VALID_MOBILE_NO.titlecontent())
                return
            }
            else if myStrLoginType == "" {
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "Select Join type")
                return
            }
            else {
                aDict["country_code"] = myStrMobileCode
                aDict["mobileno"] = myStrMobileNumber
                aDict["device_id"] = SESSION.getDeviceToken()
                aDict["device_type"] = kDEVICE_TYPE_IOS
                
                print(aDict)
                if myStrLoginType == "1" {
                    getUserLoginFromApi(aDictParam: aDict as! [String : String], isFromResend: false)
                } else {
                    getProviderLoginFromApi(aDictParam: aDict as! [String : String], isFromResend: false)
                }
                
            }
        }
    }
    
    @objc func alreadyProviderBtnTapped(sender: UIButton) {
        
        if self.isAlreadyProvider == true {
            
            self.isAlreadyProvider = false
            // new cust height
            if SESSION.getIsFromEmailLoginType() == false {
                updateConstraintsForContainerView(constraintValue: 440)
            }
            else {
                updateConstraintsForContainerView(constraintValue: 490)
            }
            
            //            updateConstraintsForContainerView(constraintValue: 380)
            let myIndexPath = IndexPath(row: 0, section: 0)
            self.myCollectionView.reloadItems(at: [myIndexPath])
        }
        else{
            
            self.isAlreadyProvider = true
            if SESSION.getIsFromEmailLoginType() == false {
                updateConstraintsForContainerView(constraintValue: 300)
            }
            else {
                updateConstraintsForContainerView(constraintValue: 380)
            }
            let myIndexPath = IndexPath(row: 0, section: 0)
            self.myCollectionView.reloadItems(at: [myIndexPath])
        }
    }
    
    @objc func resendBtnTapped(sender: UIButton) {
        
        var aDict = [String:Any]()
        aDict["country_code"] = myStrMobileCode
        aDict["mobileno"] = myStrMobileNumber
        aDict["device_id"] = SESSION.getDeviceToken()
        aDict["device_type"] = kDEVICE_TYPE_IOS
        if myStrLoginType == "1" {
            getUserLoginFromApi(aDictParam: aDict as! [String : String], isFromResend: false)
        } else {
            getProviderLoginFromApi(aDictParam:aDict as! [String : String], isFromResend: false)
        }
       
    }
    
    @IBAction func btnCloseTapped(_ sender: Any) {
        
        APPDELEGATE.loadTabbar()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func mobCodeBtnTapped(sender: UIButton) {
        let aViewController = ADCountryPicker()
        aViewController.delegate = self
        aViewController.showCallingCodes = true
        aViewController.showFlags = true
        aViewController.pickerTitle = ProviderAndUserScreenTitle.SELECT_COUNTRY.titlecontent()
        aViewController.defaultCountryCode = APP_DEFAULT_COUNTRY_PICKER
        aViewController.forceDefaultCountryCode = false
        aViewController.alphabetScrollBarTintColor = UIColor.black
        aViewController.alphabetScrollBarBackgroundColor = UIColor.clear
        aViewController.closeButtonTintColor = UIColor.black
        aViewController.font = UIFont(name: "Helvetica Neue", size: 15)
        aViewController.flagHeight = 40
        aViewController.hidesNavigationBarWhenPresentingSearch = true
        aViewController.searchBarBackgroundColor = UIColor.lightGray
        
        let width = ModalSize.full
        let height = ModalSize.fluid(percentage: 0.60)
        
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVertical
        customPresenter.dismissTransitionType = .coverVertical
        customPresenter.roundCorners = true
        customPresenter.dismissOnSwipe = false
        customPresenter.dismissOnSwipeDirection = .default
        customPresenter.blurBackground = false
        customPresenter.blurStyle = .extraLight
        self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Api call
    //Send provider login
    func getProviderLoginFromApi(aDictParam:[String:String],isFromResend:Bool) {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams = aDictParam
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_GENERATE_OTP_PROVIDER,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    if SESSION.getIsFromEmailLoginType() == false {
                        if isFromResend == true {
                            
                            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                            self.myStrOTPCode = ""
                            let myIndexPath = IndexPath(row: 1, section: 0)
                            self.myCollectionView.reloadItems(at: [myIndexPath])
                            
                        }
                        else {
                            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                                
                                self.updateConstraintsForContainerView(constraintValue: 360)
                                
                                let rect = self.myCollectionView.layoutAttributesForItem(at: IndexPath(row: 1, section: 0))?.frame
                                self.myCollectionView.scrollRectToVisible(rect!, animated: false)
                                
                                
                                HELPER.hideLoadingAnimation()
                            })
                            
                        }
                    }
                    else {
                        var aDict = [String:Any]()
                        aDict["email"] = self.myStrEmail
                        aDict["password"] = self.myStrRegPassword

                        self.getProviderLoginOTPToApi(aDictParam: aDict as! [String : String])
                    }
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA_NOT_AVAILABLE) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
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
    //Send otp for provider login
    func getProviderLoginOTPToApi(aDictParam:[String:String]) {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams = aDictParam
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_PROVIDER_SIGNIN,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    self.myDictProviderLogInResponseData = aDictResponseData["provider_details"] as! [String : Any]
                    
                    SESSION.setUserLogInType(aStrUserLogInType: self.myDictProviderLogInResponseData["type"] as! String)
                    SESSION.setUserToken(aStrUserToken: self.myDictProviderLogInResponseData["token"] as! String)
                    SESSION.setUserInfoNew(name: self.myDictProviderLogInResponseData["name"] as! String, email: self.myDictProviderLogInResponseData["email"] as! String, mobilenumber: self.myDictProviderLogInResponseData["mobileno"] as! String)
                    SESSION.setUserImage(aStrUserImage: self.myDictProviderLogInResponseData["profile_img"] as! String)
                    if self.myDictProviderLogInResponseData["share_code"] as! String != "" {
                        SESSION.setReferenceCode(aStrReferenceCode : self.myDictProviderLogInResponseData["share_code"]as! String)
                    }
                    SESSION.setUserProviderID(aStrUserId : self.myDictProviderLogInResponseData["id"] as! String)
                    
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    let subscriptionStatus = self.myDictProviderLogInResponseData["is_subscribed"] as? String
                    
                    if subscriptionStatus == "0" {
                        
                        SESSION.setUserSubscriptionStatus(status: false)
                    }
                    else {
                        
                        SESSION.setUserSubscriptionStatus(status: true)
                    }
                    
                    APPDELEGATE.loadTabbar()
                    HELPER.hideLoadingAnimation()
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA_NOT_AVAILABLE) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
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
    func getUserLoginFromApi(aDictParam:[String:String],isFromResend:Bool) {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams = aDictParam
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_GENERATE_OTP_USER,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    if SESSION.getIsFromEmailLoginType() == false {
                        if isFromResend == true {
                            
                            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                            self.myStrOTPCode = ""
                            let myIndexPath = IndexPath(row: 1, section: 0)
                            self.myCollectionView.reloadItems(at: [myIndexPath])
                            
                        }
                        else {
                            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                                
                                self.updateConstraintsForContainerView(constraintValue: 360)
                                
                                let rect = self.myCollectionView.layoutAttributesForItem(at: IndexPath(row: 1, section: 0))?.frame
                                self.myCollectionView.scrollRectToVisible(rect!, animated: false)
                                
                                
                                HELPER.hideLoadingAnimation()
                            })
                            
                        }
                    }
                    else {
                        var aDict = [String:Any]()
                        aDict["email"] = self.myStrEmail
                        aDict["password"] = self.myStrRegPassword
                        
                        if self.myStrLoginType == "1" {
                            self.getUserLoginOTPToApi(aDictParam: aDict as! [String : String])
                        } else {
                            self.getProviderLoginOTPToApi(aDictParam: aDict as! [String : String])
                        }
                        
                    }
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA_NOT_AVAILABLE) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
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
    
    //Send otp for provider login
    func getUserLoginOTPToApi(aDictParam:[String:String]) {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams = aDictParam
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_USER_SIGNIN,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    self.myDictProviderLogInResponseData = aDictResponseData["user_details"] as! [String : Any]
                    
                    SESSION.setUserLogInType(aStrUserLogInType: self.myDictProviderLogInResponseData["type"] as! String)
                    SESSION.setUserToken(aStrUserToken: self.myDictProviderLogInResponseData["token"] as! String)
                    SESSION.setUserInfoNew(name: self.myDictProviderLogInResponseData["name"] as! String, email: self.myDictProviderLogInResponseData["email"] as! String, mobilenumber: self.myDictProviderLogInResponseData["mobileno"] as! String)
                    SESSION.setUserImage(aStrUserImage: self.myDictProviderLogInResponseData["profile_img"] as! String)
                    if self.myDictProviderLogInResponseData["share_code"] as! String != "" {
                        SESSION.setReferenceCode(aStrReferenceCode : self.myDictProviderLogInResponseData["share_code"]as! String)
                    }
                    SESSION.setUserProviderID(aStrUserId : self.myDictProviderLogInResponseData["id"] as! String)
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    APPDELEGATE.loadTabbar()
                    HELPER.hideLoadingAnimation()
                }                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA_NOT_AVAILABLE) {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                    
                }
                else {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        self.myStrOTPCode = ""
                        let myIndexPath = IndexPath(row: 1, section: 0)
                        self.myCollectionView.reloadItems(at: [myIndexPath])
                        
                        
                    })
                }
                
                
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }
    func callForgotPasswordApi(aDictParam:[String:String])  {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_FORGOT_PASSWORD, dictParameters: aDictParam , sucessBlock: { (response) in
            print(response)
            
            let aDictResponse = response[kRESPONSE] as! [String : String]
            
            print(response)
            HELPER.hideLoadingAnimation()
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aDictResponse[kRESPONSE_MESSAGE]!, okActionBlock: { (action) in
                    APPDELEGATE.loadTabbar()
                })
                
            }
            else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA_NOT_AVAILABLE) {
                
                
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictResponse[kRESPONSE_MESSAGE]!)
                
            }
            
            else  {
                
                
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictResponse[kRESPONSE_MESSAGE]!)
                
            }
            
            
        }) { (error) in
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        }
    }
    
    
    
    
    //MARK: - Design method
    func updateConstraintsForContainerView(constraintValue : Float) {
        
        myHeightConstraintContainerView.constant = CGFloat(constraintValue)
        
        myContanierView.layoutIfNeeded()
        myCollectionView.updateConstraints()
        self.myCollectionView.layoutIfNeeded()
        
        self.myCollectionView.reloadData()
        
    }
}

