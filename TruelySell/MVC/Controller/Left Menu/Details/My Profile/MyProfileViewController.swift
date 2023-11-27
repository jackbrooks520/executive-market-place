 

import UIKit
import Photos
import Alamofire
import MobileCoreServices
import SDWebImage
//import CoreLocation
import CZPicker

class MyProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CZPickerViewDelegate,CZPickerViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var myViewBtnAvailability: UIView!
    @IBOutlet weak var myBtnAvailability: UIButton!
    @IBOutlet weak var myViewUserHeader: UIView!
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myBtnEdit: UIButton!
    @IBOutlet weak var myContainerView: UIView!
    @IBOutlet weak var myBtnProfileImage: UIButton!
    @IBOutlet weak var gImageViewProfileImage: UIImageView!
    @IBOutlet var myBtnUpdate: UIButton!
 
    var myStrSubscription = String()
    var myStrUserName = String()
    var myStrEmail = String()
    var myStrPhoneNumber = String()
    var myStrCatName = String()
    var myStrCatID = String()
    var myStrSubCatName = String()
    var myStrSubCatID = String()
    var myStrICNumber = String()
    var myStrProfileImage = String()
    var myStrICCardImage = String()
    var myStrSubscriptionName = String()
    var myStrExpiryDate = String()
    var myStrCurrencyCode = String()
    var myStrCurrencyID = String()
    
    
    var myStrProviderName = String()
    
    let TAG_SUBSCRIPTION : Int = 10
    let TAG_USER_NAME : Int = 20
    let TAG_EMAIL : Int = 30
    let TAG_PHONE_NUMBER : Int = 40
    let TAG_IC_NUMBER : Int = 50
    let TAG_CAT : Int = 60
    let TAG_SUB_CAT : Int = 70
    let TAG_PROVIDER_NAME : Int = 80
    let TAG_CURRENCY = 90
    
    var profilePicSelected = true
    var myImageUrl:URL?
    var myCardImgUrl:URL?
    var isClickImage = false
    var isClickSubBtn = true
    var isFromProvider = true
    
    var isClickEditBtn = Bool()
    var isUserInteractionEnable = Bool ()
    
    var myDictUserInfo = [String:Any]()
    var aDictLangMyProfile = [String:Any]()
    var aDictCommonText = [String:Any]()
    var myAryCatInfo = [[String:Any]]()
    var myArySubCatInfo = [[String:Any]]()
    var myAryCurrencyList = [[String:String]]()
    
    var myImgDta = Data()
    var myCardDta = Data()
    var imagePicker = UIImagePickerController()
    let cellProfile = "MyProfileTableViewCell"
    let cellProfileIC = "MyProfileICTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpUI()
        setUpModel()
        loadModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI()  {
        
        
        NAVIGAION.setNavigationTitle(aStrTitle: ProviderAndUserScreenTitle.MYPROFILE_TITLE.titlecontent(), aViewController: self)
        
        setUpLeftBarBackButton()
        
        myTblView.delegate = self
        myTblView.dataSource = self
        imagePicker.delegate = self
        HELPER.setRoundCornerView(aView: myContainerView)
        HELPER.setRoundCornerView(aView: gImageViewProfileImage)
        
        myTblView.register(UINib.init(nibName: cellProfile, bundle: nil), forCellReuseIdentifier: cellProfile)
        myTblView.register(UINib.init(nibName: cellProfileIC, bundle: nil), forCellReuseIdentifier: cellProfileIC)
        
        myBtnProfileImage.tag = 100
        myBtnUpdate.isHidden = false
        
        myViewBtnAvailability.isHidden = true
        
        myViewUserHeader.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        myBtnUpdate.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        myBtnEdit.backgroundColor = UIColor.clear
        let btnname = CommonTitle.BTN_UPDATE.titlecontent()
        myBtnUpdate.setTitle(btnname, for: .normal)
        
//        if CLLocationManager.locationServicesEnabled() {
//            switch CLLocationManager.authorizationStatus() {
//            case .notDetermined, .restricted, .denied:
//                print("No access")
//                
//                let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_LOCATION_POPUP_VC) as! LocationPopViewController
//                self.present(aViewController, animated: true, completion: nil)
//                
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("Access")
//            }
//        } else {
//        }
    }
    
    func setUpModel() {
        
        if SESSION.getUserLogInType() == "1" {
            
            isFromProvider = true
            getProfileDetailsProviderFromApi()
            myViewBtnAvailability.isHidden = false
      
            HELPER.setRoundCornerView(aView: myViewBtnAvailability, borderRadius: 20.0)
            myViewBtnAvailability.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            myBtnAvailability.setTitle(ProviderAndUserScreenTitle.AVAILABILTY_TITLE.titlecontent(), for: .normal)
        }
        else {
            
            isFromProvider = false
           
            
            getProfileDetailsUserFromApi()
            myViewBtnAvailability.isHidden = true
        }
       
        callCurrencyList()
//        getCategoryFromApi()
    }
    
    func loadModel() {
        
        myBtnProfileImage.isUserInteractionEnabled = true
        isUserInteractionEnable = true
        isClickEditBtn = true
        isClickSubBtn = false
      
    }
    
    //MARK:- Tableview delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if SESSION.getIsFromEmailLoginType() == true {
        if isFromProvider == true {
            return 8
        }
        else {
            
            return 5
        }
        }
         else {
            if isFromProvider == true {
                
                return 5
            }
            else {
                
                return 4
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isFromProvider == true {
            
            if indexPath.row == 0 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                
                aCell.gLabel.text = ProviderAndUserScreenTitle.SUBSCRIPTION_TITLE.titlecontent()//aDictLangMyProfile["lg4_subscription"] as? String
                aCell.gTextfield.tag = TAG_SUBSCRIPTION
                //            aCell.gTextfield.textColor = UIColor.red
                if SESSION.getUserSubscriptionStatus() {
                    aCell.gTextfield.text = "(\(ProviderAndUserScreenTitle.VALID_TILL_TITLE.titlecontent()) \(self.myStrExpiryDate)) \(self.myStrSubscriptionName)"
                }
                else {
                    aCell.gTextfield.text = ""
                }
                aCell.gTextfield.delegate = self
                aCell.gTextfield.isUserInteractionEnabled = false
                aCell.gTextfield.returnKeyType = UIReturnKeyType.next
                aCell.gSubscriptionBtn.isHidden = isClickSubBtn
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
                aCell.gSubscriptionBtn.addTarget(self, action: #selector(didTapOnSubscription), for: .touchUpInside)
                aCell.subscription_btn_width.constant = 30
                
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTextfield.textAlignment = .right
                }
                else {
                    aCell.gTextfield.textAlignment = .left
                }
                return aCell
            }
            else if indexPath.row == 1 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                
                aCell.gLabel.text = ProviderAndUserScreenTitle.NAME_TITLE.titlecontent()//aDictLangMyProfile["lg4_username"] as? String
                aCell.gTextfield.tag = TAG_PROVIDER_NAME
                aCell.gTextfield.text = myStrProviderName
                aCell.gTextfield.delegate = self
                aCell.gTextfield.isUserInteractionEnabled = true
                aCell.gTextfield.returnKeyType = UIReturnKeyType.next
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
                aCell.subscription_btn_width.constant = 0
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTextfield.textAlignment = .right
                }
                else {
                    aCell.gTextfield.textAlignment = .left
                }
                return aCell
            }
            else if indexPath.row == 2 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                
                aCell.gLabel.text = ProviderAndUserScreenTitle.EMAIL_TITLE.titlecontent() //aDictLangMyProfile["lg4_email"] as? String
                aCell.gTextfield.tag = TAG_EMAIL
                aCell.gTextfield.text = myStrEmail
                aCell.gTextfield.delegate = self
                aCell.gTextfield.isUserInteractionEnabled = false
                aCell.gTextfield.returnKeyType = UIReturnKeyType.next
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
                aCell.subscription_btn_width.constant = 0
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTextfield.textAlignment = .right
                }
                else {
                    aCell.gTextfield.textAlignment = .left
                }
                return aCell
            }
            else if indexPath.row == 3 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                aCell.gLabel.text = ProviderAndUserScreenTitle.MOBILENUMBER_TITLE.titlecontent() //aDictLangMyProfile["lg4_phone"] as? String
                aCell.gTextfield.tag = TAG_PHONE_NUMBER
                aCell.gTextfield.text = myStrPhoneNumber
                aCell.gTextfield.delegate = self
                aCell.gTextfield.keyboardType = UIKeyboardType.numberPad
                aCell.gTextfield.isUserInteractionEnabled = false
                aCell.gTextfield.returnKeyType = UIReturnKeyType.next
                aCell.subscription_btn_width.constant = 0
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
                aCell.gSubscriptionBtn.addTarget(self, action: #selector(didTapOnMobNumber), for: .touchUpInside)
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTextfield.textAlignment = .right
                }
                else {
                    aCell.gTextfield.textAlignment = .left
                }
                return aCell
            }
//            else if indexPath.row == 4 {
//
//                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
//                aCell.gLabel.text = ProviderAndUserScreenTitle.CATEGORY_TITLE.titlecontent()
//                aCell.gTextfield.tag = TAG_CAT
//                aCell.gTextfield.text = myStrCatName
//                aCell.gTextfield.delegate = self
//                aCell.gTextfield.isUserInteractionEnabled = false
//                aCell.subscription_btn_width.constant = 0
//                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
//                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
//                    aCell.gTextfield.textAlignment = .right
//                }
//                else {
//                    aCell.gTextfield.textAlignment = .left
//                }
//                return aCell
//            }
//            else if indexPath.row == 5  {
//
//                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
//                aCell.gLabel.text = ProviderAndUserScreenTitle.SUBCATEGORY_TITLE.titlecontent()
//                aCell.gTextfield.tag = TAG_SUB_CAT
//                aCell.gTextfield.text = myStrSubCatName
//                aCell.gTextfield.delegate = self
//                aCell.gTextfield.isUserInteractionEnabled = false
//                aCell.subscription_btn_width.constant = 0
//                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
//                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
//                    aCell.gTextfield.textAlignment = .right
//                }
//                else {
//                    aCell.gTextfield.textAlignment = .left
//                }
//                return aCell
//            }
            else  if indexPath.row == 4 {
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                aCell.gLabel.text = ProviderAndUserScreenTitle.CURRENCY_TITLE.titlecontent()
                aCell.gTextfield.tag = TAG_CURRENCY
                aCell.gTextfield.text = myStrCurrencyCode
                aCell.gTextfield.delegate = self
                aCell.subscription_btn_width.constant = 0
                aCell.gTextfield.isUserInteractionEnabled = false
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTextfield.textAlignment = .right
                }
                else {
                    aCell.gTextfield.textAlignment = .left
                }
                
                 return aCell
            }
            else {
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                               aCell.gLabel.text = ChangePasswordScreenTitle.CHANGE_PASSWORD.titlecontent()
                aCell.gTextfield.isUserInteractionEnabled = false
                                return aCell
            }
            
        }
        else {
            
            if indexPath.row == 0 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                aCell.gLabel.text = ProviderAndUserScreenTitle.NAME_TITLE.titlecontent() //aDictLangMyProfile["lg4_username"] as? String
                aCell.gTextfield.tag = TAG_USER_NAME
                aCell.gTextfield.text = myStrUserName
                aCell.gTextfield.delegate = self
                aCell.gTextfield.isUserInteractionEnabled = true
                aCell.gTextfield.returnKeyType = UIReturnKeyType.next
                aCell.subscription_btn_width.constant = 0
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTextfield.textAlignment = .right
                }
                else {
                    aCell.gTextfield.textAlignment = .left
                }
                return aCell
            }
            else if indexPath.row == 1 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                aCell.gLabel.text = ProviderAndUserScreenTitle.EMAIL_TITLE.titlecontent() //aDictLangMyProfile["lg4_email"] as? String
                aCell.gTextfield.tag = TAG_EMAIL
                aCell.gTextfield.text = myStrEmail
                aCell.gTextfield.delegate = self
                aCell.gTextfield.isUserInteractionEnabled = false
                aCell.gTextfield.returnKeyType = UIReturnKeyType.next
                aCell.subscription_btn_width.constant = 0
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTextfield.textAlignment = .right
                }
                else {
                    aCell.gTextfield.textAlignment = .left
                }
                return aCell
            }
            else if indexPath.row == 2  {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                aCell.gLabel.text = ProviderAndUserScreenTitle.MOBILENUMBER_TITLE.titlecontent() //aDictLangMyProfile["lg4_phone"] as? String
                aCell.gTextfield.tag = TAG_PHONE_NUMBER
                aCell.gTextfield.text = myStrPhoneNumber
                aCell.gTextfield.delegate = self
                aCell.gTextfield.keyboardType = UIKeyboardType.numberPad
                aCell.gTextfield.isUserInteractionEnabled = false
                aCell.gTextfield.returnKeyType = UIReturnKeyType.next
                aCell.subscription_btn_width.constant = 0
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
                //                aCell.gSubscriptionBtn.addTarget(self, action: #selector(didTapOnMobNumber), for: .touchUpInside)
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTextfield.textAlignment = .right
                }
                else {
                    aCell.gTextfield.textAlignment = .left
                }
                return aCell
            }
            else if indexPath.row == 3{
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                
                aCell.gLabel.text = ProviderAndUserScreenTitle.CURRENCY_TITLE.titlecontent()
                aCell.gTextfield.tag = TAG_CURRENCY
                aCell.gTextfield.text = myStrCurrencyCode
                aCell.gTextfield.isUserInteractionEnabled = false
                
                aCell.gTextfield.delegate = self
                aCell.subscription_btn_width.constant = 0
                aCell.gTextfield.isUserInteractionEnabled = false
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gSubscriptionBtn, imageName: "icon_new_add_sub")
                
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTextfield.textAlignment = .right
                }
                else {
                    aCell.gTextfield.textAlignment = .left
                }
                return aCell
            }

            else {
                 let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
                aCell.gLabel.text = ChangePasswordScreenTitle.CHANGE_PASSWORD.titlecontent()
                aCell.gTextfield.isUserInteractionEnabled = false
                 return aCell
            }
           
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFromProvider == true {
            
//            if indexPath.row == 4 {
//                myStrSubCatName = ""
//                myStrSubCatID = ""
//                let picker = CZPickerView(headerTitle: ProviderAndUserScreenTitle.CHOOSE_CATEGORY.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
//
//                picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
//                picker?.delegate = self
//                picker?.dataSource = self
//                picker?.needFooterView = false
//                picker?.tag = TAG_CAT
//                picker?.show()
//            }
//            else if indexPath.row == 5 {
//
//                let picker = CZPickerView(headerTitle: ProviderAndUserScreenTitle.CHOOSE_SUB_CATEGORY.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
//
//                picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
//                picker?.delegate = self
//                picker?.dataSource = self
//                picker?.needFooterView = false
//                picker?.tag = TAG_SUB_CAT
//                picker?.show()
//            }
             if indexPath.row == 4 {
                let picker = CZPickerView(headerTitle: ProviderAndUserScreenTitle.CHOOSE_CURRENCY.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
                
                picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                picker?.delegate = self
                picker?.dataSource = self
                picker?.needFooterView = false
                picker?.tag = TAG_CURRENCY
            
                picker?.show()
                
            }
            else if indexPath.row == 7 {
                let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHANGE_PASSWORD) as! ChangePasswordViewController
                aViewController.myStrUserType = "provider"
                          self.navigationController?.pushViewController(aViewController, animated: true)
            }
        }
        else {
            if indexPath.row == 3 {
                let picker = CZPickerView(headerTitle: ProviderAndUserScreenTitle.CHOOSE_CURRENCY.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
                
                picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                picker?.delegate = self
                picker?.dataSource = self
                picker?.needFooterView = false
                picker?.tag = TAG_CURRENCY
                picker?.show()
            }
            else if indexPath.row == 4 {
                let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHANGE_PASSWORD) as! ChangePasswordViewController
                            aViewController.myStrUserType = "user"
                          self.navigationController?.pushViewController(aViewController, animated: true)
                     
            }
        }
    }
    //MARK: - Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.tag == TAG_SUBSCRIPTION {
            
            myStrSubscription = txtAfterUpdate
        }
        else if textField.tag == TAG_USER_NAME {
            
            myStrUserName = txtAfterUpdate
        }
        else if textField.tag == TAG_PROVIDER_NAME {
            
            myStrProviderName = txtAfterUpdate
        }
        else if textField.tag == TAG_EMAIL {
            
            myStrEmail = txtAfterUpdate
        }
            
        else if textField.tag == TAG_PHONE_NUMBER {
            
            if txtAfterUpdate.count <= 16 {
                
                myStrPhoneNumber = txtAfterUpdate
                
                return true
            }
                
            else {
                
                return false
            }
        }
        else if textField.tag == TAG_IC_NUMBER {
            
            myStrICNumber = txtAfterUpdate
        }
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == TAG_SUBSCRIPTION {
            
            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHECKOUT_VC) as! CheckoutViewController
            aViewController.myStrSubscriptionName = myStrSubscriptionName
            self.navigationController?.pushViewController(aViewController, animated: true)
            return false
        }
        else if textField.tag == TAG_CAT {
            
            
        }
        else if textField.tag == TAG_SUB_CAT {
            
            
        }
        else if textField.tag == TAG_CURRENCY {
            
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: - CZPicker delegate and datasource
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        if pickerView.tag == TAG_CAT {
            
            return myAryCatInfo.count
        }
        else if pickerView.tag == TAG_CURRENCY {
            return myAryCurrencyList.count
        }
        else {
            
            return myArySubCatInfo.count
        }
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        if pickerView.tag == TAG_CAT {
            
            return myAryCatInfo[row]["category_name"] as? String
        }
        else if pickerView.tag == TAG_CURRENCY {
            return myAryCurrencyList[row]["currency_code"]
        }
        else {
            
            return myArySubCatInfo[row]["subcategory_name"] as? String
        }
    }
    
    //    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
    //
    //        if pickerView.tag == TAG_CAT {
    //
    //            var aStrImg = String()
    //            var aStrImgUrl = String()
    //            aStrImgUrl = myAryCatInfo[row]["category_image"] as! String
    //            aStrImg = WEB_BASE_URL + aStrImgUrl
    //            let temp = UIImage(named: "icon_flag_english")
    //
    //            return temp
    //        }
    //        else {
    //
    //            var aStrImg = String()
    //            var aStrImgUrl = String()
    //            aStrImgUrl = myArySubCatInfo[row]["subcategory_image"] as! String
    //            aStrImg = WEB_BASE_URL + aStrImgUrl
    //            let temp = UIImage(named: "icon_flag_english")
    //
    //            return temp
    //        }
    //    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        
//        if pickerView.tag == TAG_CAT {
//
//            myStrCatID = myAryCatInfo[row]["id"] as! String
//            myStrCatName = myAryCatInfo[row]["category_name"] as! String
//            let mySubCatIndexPath = IndexPath(row: 5, section: 0)
//            self.myTblView.reloadRows(at: [mySubCatIndexPath], with: .automatic)
//            let myIndexPath = IndexPath(row: 4, section: 0)
//            self.myTblView.reloadRows(at: [myIndexPath], with: .automatic)
//            getSubCategoryFromApi(catId: myStrCatID)
//        }
         if pickerView.tag == TAG_CURRENCY {
            
            myStrCurrencyID = myAryCurrencyList[row]["id"]!
            myStrCurrencyCode = myAryCurrencyList[row]["currency_code"]!
            if isFromProvider == true {
                let myIndexPath = IndexPath(row: 6, section: 0)
                self.myTblView.reloadRows(at: [myIndexPath], with: .automatic)
            }
            else {
                let myIndexPath = IndexPath(row: 3, section: 0)
                self.myTblView.reloadRows(at: [myIndexPath], with: .automatic)
            }
        }
        else {
            
            myStrSubCatName = myArySubCatInfo[row]["subcategory_name"] as! String
            myStrSubCatID = myArySubCatInfo[row]["id"] as! String
            let myIndexPath = IndexPath(row: 5, section: 0)
            self.myTblView.reloadRows(at: [myIndexPath], with: .automatic)
        }
    }
    
    //MARK:- Imagae picker Delegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
        image = fixImageOrientation(image)
        if profilePicSelected {
            gImageViewProfileImage.image = image
            if let data = image.jpegData(compressionQuality: 0.1) {
                
                myImgDta = data
            }
        }
        else {
            let cardView = self.myTblView.viewWithTag(1000) as! UIImageView
            cardView.image = image
            if let data = image.jpegData(compressionQuality: 0.1) {
                myCardDta = data
            }
        }
        
        dismiss(animated:true, completion: nil)
    }
    func fixImageOrientation(_ image: UIImage)->UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        isClickImage = false
        dismiss(animated:true, completion: nil)
    }
    
    func showPhotoAction () {
        
        //         if isClickEditBtn == true {
        
        let aActionSheetController: UIAlertController = UIAlertController(title: CommonTitle.CHOOSE_TITLE.titlecontent(), message: nil, preferredStyle: .actionSheet) // aDictLangMyProfile["lg4_choose_a_photo_"] as? String
        
        let aActionCancel: UIAlertAction = UIAlertAction(title: CommonTitle.CANCEL_BUTTON.titlecontent(), style: .cancel) { void in
            //aDictLangMyProfile["lg4_cancel"] as? String
            print("Cancel")
        }
        aActionSheetController.addAction(aActionCancel)
        
        let aActionCamera: UIAlertAction = UIAlertAction(title: CommonTitle.CAMERA_BTN.titlecontent(), style: .default) //title: aDictCommonText["lg7_camera"] as? String
        { void in
            
            self.openCamera()
        }
        aActionSheetController.addAction(aActionCamera)
        
        let aActionGallery: UIAlertAction = UIAlertAction(title: CommonTitle.GALLERY_BTN.titlecontent(), style: .default) //title: aDictCommonText["lg7_gallery"] as? String
        { void in
            
            self.loadGallery()
        }
        aActionSheetController.addAction(aActionGallery)
        
        self.present(aActionSheetController, animated: true, completion: nil)
        //        }
    }
    
    func loadGallery() {
        
        isClickImage = true
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ([(kUTTypeImage as? String)] as? [String])!
        picker.navigationBar.barTintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        picker.navigationBar.tintColor = .white
        //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(picker, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: CommonTitle.WARNING_MSG.titlecontent(), message: CommonTitle.NOACCESS_CAMERA.titlecontent(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: CommonTitle.BTN_OK.titlecontent(), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

//    func openCamera() {
//
//        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
//
//            let picker = UIImagePickerController()
//
//            picker.allowsEditing = true
//            picker.delegate = self
//            picker.sourceType = .camera
//            picker.mediaTypes = ([(kUTTypeImage as? String)] as? [String])!
//            //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
//            self.present(picker, animated: true, completion: nil)
//
//            //already authorized
//        } else {
//            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
//                if granted {
//
//                    //access allowed
//                    DispatchQueue.main.async {
//                        self.camPicker.allowsEditing = true
//                        self.camPicker.delegate = self
//                        self.camPicker.sourceType = .camera
//                    }
//                    self.camPicker.mediaTypes = ([(kUTTypeImage as? String)] as? [String])!
//                    //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
//                    self.present(self.camPicker, animated: true, completion: nil)
//
//                } else {
//
//
//                    HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CommonTitle.ENABLE_CAMERA_IN_SETTING.titlecontent())
//
//                    //access denied
//                }
//            })
//        }
//    }
    
    //MARK:- Button action
    @objc func didTapOnSubscription() {
        
        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHECKOUT_VC) as! CheckoutViewController
        aViewController.myStrSubscriptionName = myStrSubscriptionName
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    @objc func didTapOnMobNumber() {
        
        
    }
    //    @objc func currencyBtnTapped(sender: UIButton) {
    //
    ////        showCurrencyPicker()
    //    }
    
    @IBAction func btnUpdateTapped(_ sender: Any) {
        
        if isFromProvider == true {
            
            if !HELPER.isConnectedToNetwork() {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                return
            }
            if (myStrProviderName.isEmpty) {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.EMPTY_PROVIDER_NAME.titlecontent()) //(aDictLangMyProfile["lg4_enter_phone_num"] as? String)!
            }
//            else if (myStrCatName.isEmpty) {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.EMPTY_CATEGORY.titlecontent()) //(aDictLangMyProfile["lg4_enter_phone_num"] as? String)!
//            }
//            else if (myStrSubCatName.isEmpty) {
//
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.EMPTY_SUB_CATEGORY.titlecontent()) //(aDictLangMyProfile["lg4_enter_phone_num"] as? String)!
//            }
            else {
                callUpdateApiProvider()
            }
        }
        else {
            
            if !HELPER.isConnectedToNetwork() {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                return
            }
            if (myStrUserName.isEmpty) {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAndUserScreenTitle.EMPTY_USER_NAME.titlecontent()) //(aDictLangMyProfile["lg4_enter_phone_num"] as? String)!
            }
            else {
                callUpdateApiUser()
            }
        }
        
    }
    
    @IBAction func btnEditTapped(_ sender: Any) {
        
        
    }
    
    
    @IBAction func btnProfileImageTapped(_ sender: Any) {
        
        profilePicSelected = true
        showPhotoAction()
    }
    
    @IBAction func changePasswordBtnTapped(_ sender: Any) {
    }
    @IBAction func btnAvailabilityTapped(_ sender: Any) {
        
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_PROVIDER_AVAILABILITY_VC) as! NewProviderAvailabilityViewController
        aViewController.gClickEditProvide = false
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    //MARK:- Private button action
    
    @objc func imageBtnTapped(_ sender: UIButton) {
        
        if isUserInteractionEnable == true {
            
            profilePicSelected = false
            showPhotoAction()
        }
    }
    
    func checkPathNameIsOrNot() {
        
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        
        do {
            
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                for fileName in fileNames {
                    if (fileName.hasSuffix("capture.png"))
                    {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    @objc func profileEditBtnAction() {
        
        isClickEditBtn = true
        myBtnUpdate.isHidden = false
        isUserInteractionEnable = true
        isClickSubBtn = false
        myBtnProfileImage.isUserInteractionEnabled = true
        self.myTblView.reloadData()
    }
    
    
    //    func showCurrencyPicker() {
    //
    //        let regularFont = UIFont.systemFont(ofSize: 16)
    //        let boldFont = UIFont.boldSystemFont(ofSize: 16)
    //
    //        let blueAppearance = YBTextPickerAppearanceManager.init(
    //            pickerTitle         : "Select Currency",
    //            titleFont           : boldFont,
    //            titleTextColor      : .black,
    //            titleBackground     : .clear,
    //            searchBarFont       : regularFont,
    //            searchBarPlaceholder: "Select Currency",
    //            closeButtonTitle    : "Cancel",
    //            closeButtonColor    : .darkGray,
    //            closeButtonFont     : regularFont,
    //            doneButtonTitle     : "Done",
    //            doneButtonColor     : UIColor.blue,
    //            doneButtonFont      : boldFont,
    //            checkMarkPosition   : .Right,
    //            itemCheckedImage    : UIImage(named:"blue_ic_checked"),
    //            itemUncheckedImage  : UIImage(),
    //            itemColor           : .black,
    //            itemFont            : regularFont
    //        )
    //
    //        //        let aStrArr = myCountryList.map { "\($0.name)"}
    //
    //        let picker = YBTextPicker.init(with: [myAryCurrencyList[0]["currency_code"]!], appearance: blueAppearance,
    //                                       onCompletion: { (selectedIndexes, selectedValues) in
    //                                        print(selectedIndexes)
    //                                        if selectedValues.count != 0 {
    //                                            //                                            if let aShowFieldIndex = self.myCountryList.firstIndex(where: { $0.name == selectedValues[0]}) {
    //                                            //                                                print(self.myCountryList[aShowFieldIndex].dialCode)
    //                                            //                                                print(self.myCountryList[aShowFieldIndex].name)
    //                                            //
    //                                            //
    //                                            //                                            }
    //                                        }
    //        },onCancel: {
    //            print("Cancelled")
    //        })
    //
    //        picker.allowMultipleSelection = false
    //        picker.show(withAnimation: .Fade)
    //
    //    }
    //
    //  MARK: - Currency Code picker delegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return myAryCurrencyList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myAryCurrencyList[row]["currency_code"]
    }
    
    //     func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //
    //    }
    //
    //     func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    //
    //    }
    //
    
    
    //MARK:- Api call
    //User Details
    func getProfileDetailsUserFromApi() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_VIEW_USER_PROFILE, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    
                    print(aDictResponseData)
                    
                    self.myDictUserInfo = aDictResponseData
                    
                    //        myStrSubscription = myDictUserInfo[""] as! String
                    self.myStrUserName = self.myDictUserInfo["name"] as! String
                    self.myStrEmail = self.myDictUserInfo["email"] as! String
                    self.myStrPhoneNumber = self.myDictUserInfo["mobileno"] as! String
                    self.myStrProfileImage = self.myDictUserInfo["profile_img"] as! String
                    self.myStrCurrencyCode = self.myDictUserInfo["currency_code"] as! String
                    self.myStrCurrencyID = self.myDictUserInfo["currency_id"] as! String
                    
                   
                    //                if let subinfo = self.myDictUserInfo["subscription_details"] as? [String:Any] {
                    //
                    //                    if let name = subinfo["subscription_name"] as? String {
                    //                        self.myStrSubscriptionName = name
                    //                    }
                    //                    if let date = subinfo["expiry_date_time"] as? String {
                    //
                    ////                        var info = date.components(separatedBy: " ")
                    //                        self.myStrExpiryDate = date
                    //                    }
                    //                }
                    
                    //        myStrICNumber = myDictUserInfo[""] as! String
                    
                    self.gImageViewProfileImage.setShowActivityIndicator(true)
                    self.gImageViewProfileImage.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
                    self.gImageViewProfileImage.sd_setImage(with: URL(string: (WEB_BASE_URL + self.myStrProfileImage)), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
                    SESSION.setUserImage(aStrUserImage: self.myStrProfileImage)
                    
                    self.myTblView.reloadData()
                    //                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                    
                }
                else {
                     HELPER.hideLoadingAnimation()
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }
    
    func getProfileDetailsProviderFromApi() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_VIEW_PROVIDER_PROFILE, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    
                    print(aDictResponseData)
                    
                    self.myDictUserInfo = aDictResponseData
                    
                    //        myStrSubscription = myDictUserInfo[""] as! String
                    self.myStrProviderName = HELPER.returnStringFromNull(self.myDictUserInfo["name"] as AnyObject) as! String
                    self.myStrEmail = HELPER.returnStringFromNull(self.myDictUserInfo["email"] as AnyObject) as! String
                    self.myStrPhoneNumber = HELPER.returnStringFromNull(self.myDictUserInfo["mobileno"] as AnyObject) as! String
                    self.myStrProfileImage = HELPER.returnStringFromNull(self.myDictUserInfo["profile_img"] as AnyObject) as! String
//                    self.myStrCatName = HELPER.returnStringFromNull(self.myDictUserInfo["category_name"] as AnyObject) as! String
//                    self.myStrCatID = HELPER.returnStringFromNull(self.myDictUserInfo["category"] as AnyObject) as! String
//                    self.myStrSubCatName = HELPER.returnStringFromNull(self.myDictUserInfo["subcategory_name"] as AnyObject) as! String
                    self.myStrCurrencyCode = self.myDictUserInfo["currency_code"] as! String
                    self.myStrCurrencyID = self.myDictUserInfo["currency_id"] as! String
                    
                    
                    if let subinfo = self.myDictUserInfo["subscription_details"] as? [String:Any] {
                        
                        if let name = subinfo["subscription_name"] as? String {
                            self.myStrSubscriptionName = name
                        }
                        if let date = subinfo["expiry_date_time"] as? String {
                            self.myStrExpiryDate = date
                        }
                    }
                    
                    
                    //        myStrICNumber = myDictUserInfo[""] as! String
                    
                    self.gImageViewProfileImage.setShowActivityIndicator(true)
                    self.gImageViewProfileImage.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
                    self.gImageViewProfileImage.sd_setImage(with: URL(string: (WEB_BASE_URL + self.myStrProfileImage)), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
                    SESSION.setUserImage(aStrUserImage: self.myStrProfileImage)
                    
                    self.myTblView.reloadData()
                    
//                    self.getSubCategoryFromApi(catId: self.myStrCatID)
                    //                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
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
//    func getCategoryFromApi() {
//        if !HELPER.isConnectedToNetwork() {
//
//                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
//                   return
//               }
//        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
//
//        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_PROFESSIONAL_CATEGOY, sucessBlock: { response in
//
//            HELPER.hideLoadingAnimation()
//
//            if response.count != 0 {
//
//                let aDictResponse = response[kRESPONSE] as! [String : String]
//
//                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
//
//                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
//
//                    var aDictResponseData = [String:Any]()
//                    aDictResponseData = response["data"] as! [String:Any]
//
//                    self.myAryCatInfo = aDictResponseData["category_list"] as! [[String : Any]]
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
    
//    func getSubCategoryFromApi(catId:String) {
//        if !HELPER.isConnectedToNetwork() {
//
//                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
//                   return
//               }
//        //        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
//
//        var aDictParams = [String:String]()
//        aDictParams["category"] = catId
//
//        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_PROFESSIONAL_SUB_CATEGOY,dictParameters:aDictParams, sucessBlock: { response in
//
//            HELPER.hideLoadingAnimation()
//
//            if response.count != 0 {
//
//                let aDictResponse = response[kRESPONSE] as! [String : String]
//
//                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
//
//                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
//
//                    var aDictResponseData = [String:Any]()
//                    aDictResponseData = response["data"] as! [String:Any]
//
//                    if aDictResponseData.count != 0 {
//
//                        self.myArySubCatInfo = aDictResponseData["subcategory_list"] as! [[String : Any]]
//                        HELPER.hideLoadingAnimation()
//                    }
//
//                    HELPER.hideLoadingAnimation()
//                }
//                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
//
//                }
//                else {
//
//                                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
//                }
//            }
//
//        }, failureBlock: { error in
//
//            HELPER.hideLoadingAnimation()
//            //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
//        })
//    }
    
    //Provider to Update
    
    func callUpdateApiProvider()  {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: CommonTitle.UPDATING.titlecontent())
        
        var headers:HTTPHeaders? = nil
        if SESSION.getUserToken().count > 0 {
            headers = ["Content-Type" : "application/json; charset=utf-8","token": SESSION.getUserToken(),"language":SESSION.getAppLangType()]
        }
        
        let dictRegisteration = ["name":myStrProviderName,"type":SESSION.getUserLogInType(),"user_currency":myStrCurrencyCode] as [String : Any]
        
        print(dictRegisteration)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if self.myImgDta.count != 0 {
                
                print(self.myImgDta.count/1024);
                
                multipartFormData.append(self.myImgDta, withName: "profile_img", fileName: "iosimg.jpg", mimeType: "image/jpg")
            }
            
            for (key, value) in dictRegisteration {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                         usingThreshold: UInt64.init(), to: WEB_SERVICE_URL + CASE_UPDATE_PROFILE_PROVIDER, method: .post, headers: headers) { (result) in
                            
                            switch result {
                            case .success(let upload, _,_ ):
                                
                                upload.uploadProgress(closure: { (progress) in
                                    //Print progress
                                    print(progress)
                                    
                                })
                                
                                upload.responseJSON { response in
                                    
                                    HELPER.hideLoadingAnimation()
                                    
                                    if response.result.isSuccess {
                                        
                                        self.myImgDta = Data()
                                        self.myCardDta = Data()
                                        
                                        print(response)
                                        let jsonDict = response.result.value as? [String:Any]
                                        
                                        let jsonDictSuccess = jsonDict!["response"] as? [String:Any]
                                        
                                        let aIntResponseCode = jsonDictSuccess!["response_code"] as! String
                                        let aMessageResponse = jsonDictSuccess!["response_message"] as! String
                                        
                                        if (Int(aIntResponseCode) == kRESPONSE_CODE_DATA) {
                                            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                                            
                                            var aDictResponseData = [String:Any]()
                                            var aDictProfileData = [String:Any]()
                                            
                                            aDictResponseData = jsonDict!["data"] as! [String:Any]
                                            aDictProfileData = aDictResponseData
                                            
                                            SESSION.setUserImage(aStrUserImage: aDictProfileData["profile_img"] as! String)
                                            SESSION.setUserInfoNew(name: aDictProfileData["name"] as! String, email: self.myStrEmail, mobilenumber: self.myStrPhoneNumber)
                                            
                                            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                                                
                                                self.navigationController?.popViewController(animated: true)
                                            })
                                            
                                            //                                            NotificationCenter.default.post(name: Notification.Name("callUpdateProfile"), object: nil)
                                            //
                                            //                                            NotificationCenter.default.post(name: GETLANGUAGECHANGE, object: nil, userInfo: ["phoneNo":""])
                                        }
                                        else if (Int(aIntResponseCode) == kRESPONSE_CODE_NO_DATA) {
                                            
                                            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                                        }
                                    }
                                    else {
                                        
                                        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
                                    }
                                }
                            case .failure(let encodingError):
                                print (encodingError.localizedDescription)
                                HELPER.hideLoadingAnimation()
                            }
        }
    }
    
    //User to Update
    func callUpdateApiUser()  {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: CommonTitle.UPDATING.titlecontent())
        
        var headers:HTTPHeaders? = nil
        if SESSION.getUserToken().count > 0 {
            headers = ["Content-Type" : "application/json; charset=utf-8","token": SESSION.getUserToken(),"language":SESSION.getAppLangType()]
        }
        
        let dictRegisteration = ["name":myStrUserName,"type":SESSION.getUserLogInType(),"user_currency":myStrCurrencyCode] as [String : Any]
        
        print(dictRegisteration)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if self.myImgDta.count != 0 {
                
                print(self.myImgDta.count/1024);
                
                multipartFormData.append(self.myImgDta, withName: "profile_img", fileName: "iosimg.jpg", mimeType: "image/jpg")
            }
            //            if self.myCardDta.count != 0 {
            //
            //                print(self.myCardDta.count/1024);
            //
            //                multipartFormData.append(self.myCardDta, withName: "ic_card_image", fileName: "iosimg.jpg", mimeType: "image/jpg")
            //            }
            
            for (key, value) in dictRegisteration {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                         usingThreshold: UInt64.init(), to: WEB_SERVICE_URL + CASE_UPDATE_PROFILE_USER, method: .post, headers: headers) { (result) in
                            
                            switch result {
                            case .success(let upload, _,_ ):
                                
                                upload.uploadProgress(closure: { (progress) in
                                    //Print progress
                                    print(progress)
                                    
                                })
                                
                                upload.responseJSON { response in
                                    
                                    HELPER.hideLoadingAnimation()
                                    
                                    if response.result.isSuccess {
                                        
                                        self.myImgDta = Data()
                                        self.myCardDta = Data()
                                        
                                        print(response)
                                        let jsonDict = response.result.value as? [String:Any]
                                        
                                        let jsonDictSuccess = jsonDict!["response"] as? [String:Any]
                                        
                                        let aIntResponseCode = jsonDictSuccess!["response_code"] as! String
                                        let aMessageResponse = jsonDictSuccess!["response_message"] as! String
                                        
                                        if (Int(aIntResponseCode) == kRESPONSE_CODE_DATA) {
                                            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                                            
                                            var aDictResponseData = [String:Any]()
                                            var aDictProfileData = [String:Any]()
                                            
                                            aDictResponseData = jsonDict!["data"] as! [String:Any]
                                            aDictProfileData = aDictResponseData
                                            
                                            SESSION.setUserImage(aStrUserImage: aDictProfileData["profile_img"] as! String)
                                            
                                            //                                            NotificationCenter.default.post(name: Notification.Name("callUpdateProfile"), object: nil)
                                            //
                                            //                                            NotificationCenter.default.post(name: GETLANGUAGECHANGE, object: nil, userInfo: ["phoneNo":""])
                                        }
                                        else if (Int(aIntResponseCode) == kRESPONSE_CODE_NO_DATA) {
                                            
                                            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                                        }
                                    }
                                    else {
                                        
                                        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
                                    }
                                }
                            case .failure(let encodingError):
                                print (encodingError.localizedDescription)
                                HELPER.hideLoadingAnimation()
                            }
        }
    }
    //Currency
    func callCurrencyList() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_CURRENCY_LIST, sucessBlock: {response in
            HELPER.hideLoadingAnimation()
            let aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                var aDictData = [[String : Any]]()
                
                aDictData = response["data"] as! [[String : Any]]
                
                self.myAryCurrencyList = aDictData as! [[String : String]]
                
                
            }
                //            else if aIntResponseCode == RESPONSE_CODE_498 {
                //
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
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
            
        })
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

