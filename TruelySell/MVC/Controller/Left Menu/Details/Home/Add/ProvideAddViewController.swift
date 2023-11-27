
import UIKit
import MXSegmentedControl
import CZPicker
import Photos
import MobileCoreServices
import Alamofire

class ProvideAddViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource,CZPickerViewDelegate,CZPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myViewGallery: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var myBtnChoosePhoto: UIButton!
    @IBOutlet weak var myViewSecondSegment: UIView!
    @IBOutlet weak var myLblDateContent: UILabel!
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var mySegmentControl: MXSegmentedControl!
    @IBOutlet weak var myViewHeadingAvailblity: UIView!
    @IBOutlet weak var myTblViewAvailblity: UITableView!
    @IBOutlet weak var myBtnSubmit: UIButton!
    @IBOutlet var myLblDays: UILabel!
    @IBOutlet var myLblFrom: UILabel!
    @IBOutlet var myLblTo: UILabel!
    
     @IBOutlet var myTFFrom: UITextField!
     @IBOutlet var myTFTo: UITextField!
    
    var myAryCatInfo = [[String:Any]]()
    var myArySubCatInfo = [[String:Any]]()
    var myAryImgInfo = [[String:Any]]()
    var myAryImgUpload = [[String:Any]]()
    
    var aDictLanguageAddReq = [String:Any]()
    var aDictLangSignUp = [String:Any]()
    
    let cellIdentifierTextField = "AddRequestTableViewCell"
    let cellIdentifierTextView = "AddRequestTextViewTableViewCell"
    let cellIdentifierAvailability = "AvailablityTableViewCell"
    let cellIdentifierCategory = "AddProviderCategoryTableViewCell"
    let cellIdentifierImage = "AddRequestImageTableViewCell"

    var myStrTitle = String()
    var myStrLocation = String()
    var myStrContactNumber = String()
    var myStrServiceID = String()
    
    var myStrFromTime = String()
    var myStrToTime = String()
    var myStrDate = String()
    
    var myStrIsCatId = String()
    var myStrCatId = String()
    var myStrSubCatID = String()
    var myStrCatName = String()
    var myStrSubCatName = String()
    var myStrAmount = String()
    var myStrAbout = String()
    var myStrLong = String()
    var myStrLat = String()
    
    var myStrAvailability = String()
    
    var myStrProvideId = String()
    var gClickEditProvide = false
    var gStrListID = String()
    var myDicInfo = [String:Any]()

    var myAryTxtViewInfo = [[String : String]] ()
    var myAryTimeInfo = [[String : String]] ()
    
//    var aDictLanguageAddReq = [String:Any]()
    var aDictLanguageCommon = [String:Any]()
    
    var myAryCatIndexCount = [Int]()
    var myArySubCatIndexCount = [Int]()

    var activeTF = UITextField()
    
    var myImgDta = Data()
    var isClickImage = false
    var myIntTotalPage = Int()
    var currentIndex = 1
    var isLoading = false
    
    
    let TAG_TIME = 400
    let TAG_TITLE = 100
    let TAG_LOCATION = 200
    let TAG_CONTACT_NUMBER = 600
    let TAG_CAT = 700
    let TAG_SUB_CAT = 800
    let TAG_AMOUNT = 820
    let TAG_ABOUT = 840
    let TAG_DATE_PICKER_FROM = 1000
    let TAG_DATE_PICKER_TO = 2000
    let TAG_PROFILE_IMAGE_VIEW : Int = 3000
    let TAG_PROFILE_IMAGE_VIEW_CENTER : Int = 3100
    let TAG_PROFILE_IMAGE_VIEW_LABEL : Int = 3200
    var curretSelectedTFTag = 0
    
    var allDaysSelected = false
    
    let K_TXT_VIEW_VALUE : String = "tztview_tzt"
    let K_TXT_VIEW_LABEL : String = "txtview_label"
    
    let K_TXT_FROM : String = "From"
    let K_TXT_TO : String = "To"
    let K_TXT_INDEX : String = ""
    
    let FROM_TIME = "from_time"
    let TO_TIME = "to_time"
    let DAY = "day"
    
    let myDatePicker = UIDatePicker()
    
    //Temp declare
    var pickerImg = [UIImage]()
    var pickerDataImg = [Data]()
    var imagePicker = UIImagePickerController()
    
   
    typealias CompletionBlock = (String?) -> Void
    var completion: CompletionBlock = { reason  in print(reason ?? false) }
    
    typealias CompletionBlockNewMap = (String?) -> Void
    var completionNewMap: CompletionBlockNewMap = { reasonNewMap  in print(reasonNewMap ?? false) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpUI()
        setUpModel()
        loadModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        callAccountStatusApi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI()  {
        
        changeLanguageContent()
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: (aDictLanguageAddReq[""] as? String)!, aViewController: self)

        myBtnSubmit.setTitle(aDictLanguageCommon["lg7_done"] as? String, for: .normal)
        
        setUpLeftBarBackButton()
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        imagePicker.delegate = self
        myCollectionView.register(UINib.init(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
        myTblView.register(UINib.init(nibName: cellIdentifierTextField, bundle: nil), forCellReuseIdentifier: cellIdentifierTextField)
        myTblView.register(UINib.init(nibName: cellIdentifierTextView, bundle: nil), forCellReuseIdentifier: cellIdentifierTextView)
        myTblView.register(UINib.init(nibName: cellIdentifierCategory, bundle: nil), forCellReuseIdentifier: cellIdentifierCategory)
        myTblView.register(UINib.init(nibName: cellIdentifierImage, bundle: nil), forCellReuseIdentifier: cellIdentifierImage)
        
        myBtnSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        mySegmentControl.selectedTextColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        mySegmentControl.indicatorColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        mySegmentControl.font =  UIFont.systemFont(ofSize: 14)
        mySegmentControl.append(title: CreateService.INFORMATION.titlecontent())
        mySegmentControl.append(title: CreateService.GALLERY.titlecontent())
        
        myTblView.tableFooterView = UIView()
        
        myDatePicker.datePickerMode = .date
        self .createToolbar()
        myDatePicker.minimumDate = Date()
        myDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        if mySegmentControl.selectedIndex == 0 {
            
            myViewSecondSegment.isHidden = true
            myTblView.isHidden = false
        }
        else {
            
            myViewSecondSegment.isHidden = false
            myTblView.isHidden = true
        }
    }
    
    func setUpModel() {
        
        if gClickEditProvide == true {
            
            getMyServiceDetailApi(listId:gStrListID)
            
        } else {
            
            myStrLat = SESSION.getUserLatLong().0
            myStrLong = SESSION.getUserLatLong().1
            myAryTxtViewInfo = [[K_TXT_VIEW_VALUE:"",K_TXT_VIEW_LABEL:"description" + " 1"]]
        }
    }
    
    func loadModel() {
        
        getCategoryListFromApi()
        
        if gClickEditProvide == true {
            
//            myStrCatId = myDicInfo["category"] as! String
//
//            getSubCategoryListFromApi(CatId: myStrCatId)
//
//            myStrTitle = myDicInfo["service_title"] as! String
//            myStrLocation = myDicInfo["service_location"] as! String
////            myStrContactNumber = myDicInfo["profile_contact_no"] as! String
//            myStrProvideId = myDicInfo["service_id"] as! String
//
//            myStrCatName = myDicInfo["category_name"] as! String
//            myStrSubCatName = myDicInfo["subcategory_name"] as! String
            
            //            myTFFrom.text = gAryEditInfo[0]["start_date"] as? String
            //            myTFTo.text = gAryEditInfo[0]["end_date"] as? String
            //            let aStrJsonForAvailability = gAryEditInfo[0]["availability"]
            //
            //            let dataForAvail = (aStrJsonForAvailability as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
            //
            //            do {
            //
            //                let arrayAvail = try JSONSerialization.jsonObject(with: dataForAvail, options: []) as! [Any]
            //                print(arrayAvail)
            //
            //                for var i in 0...7 {
            //                    myAryTimeInfo.append([K_TXT_FROM:"",K_TXT_TO:""])
            //
            //                }
            //
            //                for info in arrayAvail {
            //
            //                    var dict:[String:Any] = info as! [String : Any]
            //                    let fromTime:String = dict["from_time"] as! String
            //                    let toTime:String = dict["to_time"] as! String
            //                    let day:String = String(format: "%@", dict["day"] as! CVarArg)//dict["day"] as! String
            //
            //                    let indexValue = Int(day)
            //                    var dictInfo = myAryTimeInfo[indexValue!]
            //                    dictInfo[K_TXT_FROM] = fromTime
            //                    dictInfo[K_TXT_TO] = toTime
            //
            //                    myAryTimeInfo[indexValue!] = dictInfo
            //                }
            //            } catch let error as NSError {
            //                print("Failed to load: \(error.localizedDescription)")
            //            }
        }
        else {
            for var i in 0...7 {
                
                myAryTimeInfo.append([K_TXT_FROM:"",K_TXT_TO:""])
            }
        }
    }
    
    func loadData() {
        
        var aDictServiceOverview = [String:Any]()
        aDictServiceOverview = myDicInfo["service_overview"] as! [String : Any]
        myStrServiceID = aDictServiceOverview["service_id"] as! String
        let aStrJson = aDictServiceOverview["service_offered"]
        
        let data = (aStrJson as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String]
            
            for index in 0..<json.count {
                
                let dictInfo = [K_TXT_VIEW_VALUE:json[index],K_TXT_VIEW_LABEL:"\(String(describing: "description")) \(index + 1)"]
                
                myAryTxtViewInfo.append(dictInfo)
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        
        myStrCatId = aDictServiceOverview["category"] as! String
        
        getSubCategoryListFromApi(CatId: myStrCatId)
        
        myStrTitle = aDictServiceOverview["service_title"] as! String
        myStrLocation = aDictServiceOverview["service_location"] as! String
        //            myStrContactNumber = myDicInfo["profile_contact_no"] as! String
        myStrProvideId = aDictServiceOverview["service_id"] as! String
        
        myStrCatName = aDictServiceOverview["category_name"] as! String
        myStrSubCatName = aDictServiceOverview["subcategory_name"] as! String
        myStrAmount = aDictServiceOverview["service_amount"] as! String
        myStrAbout = aDictServiceOverview["about"] as! String
        myStrCatId = aDictServiceOverview["category"] as! String
        myStrSubCatID = aDictServiceOverview["subcategory"] as! String
        myStrLat = aDictServiceOverview["service_latitude"] as! String
        myStrLong = aDictServiceOverview["service_longitude"] as! String
    }
    
    // MARK: - Tableview Delegate and Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == myTblView {
            
            return 3
        }
            
        else {
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == myTblView {
            
            if section == 0 {
                
                return 1
            }
                
            else if section == 1 {
                
                return myAryTxtViewInfo.count
            }
                
            else if section == 2 {
                
                return 5
            }
            
        }
        else {
            
            return 8
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == myTblView {
            
            if indexPath.section == 0 {
                
                return 60
            }
                
            else if indexPath.section == 1 {
                
                return 100
            }
                
            else if indexPath.section == 2 {
                
                return 60
            }
            
        }
        else {
            
            return 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTextField, for: indexPath) as! AddRequestTableViewCell
           if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell.gTxtFld.textAlignment = .right
           }
           else {
            aCell.gTxtFld.textAlignment = .left
            }
            aCell.gTxtFld.delegate = self
            
            aCell.gTxtFld.placeholder = CreateService.TITLE.titlecontent()  //aDictLanguageAddReq["lg6_title"] as? String
            aCell.gImgView.image = UIImage(named: "icon_pencil")
            aCell.gTxtFld.text = myStrTitle
            aCell.gTxtFld.tag = TAG_TITLE
            aCell.gTxtFld.inputAccessoryView = nil
            
            return aCell
            
            //                }
        }
        else if indexPath.section == 1 {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTextView, for: indexPath) as! AddRequestTextViewTableViewCell
            
            aCell.gTxtView.delegate = self
            
            let aStrDescription:String = myAryTxtViewInfo[indexPath.row][K_TXT_VIEW_VALUE]!
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                      aCell.gTxtView.textAlignment = .right
                     }
                     else {
                      aCell.gTxtView.textAlignment = .left
                      }
            if aStrDescription.count != 0 {
                
                aCell.gTxtView.text = myAryTxtViewInfo[indexPath.row][K_TXT_VIEW_VALUE]
                aCell.gTxtView.textColor = .black
            }
            else {
                
                aCell.gTxtView.text = CreateService.TXT_SERVICE_OFFER.titlecontent()
                aCell.gTxtView.textColor = .lightGray
            }
            
            aCell.gTxtView.tag = indexPath.row
            aCell.gBtnClose.tag = indexPath.row
            aCell.gBtnFrontIcon.setImage(UIImage(named: "icon_cat"), for: .normal)
            
            aCell.gBtnClose.addTarget(self, action: #selector(ProvideAddViewController.btnDescscriptionAddAndDelete), for: .touchUpInside)
            
            if myAryTxtViewInfo.count == indexPath.row + 1 {
                
                aCell.gBtnClose.setImage(UIImage(named: "icon_add_plus"), for: .normal)
            }
                
            else {
                
                aCell.gBtnClose.setImage(UIImage(named: "icon_add_minus"), for: .normal)
            }
            
            return aCell
        }
            
        else {
            
            if indexPath.row == 0 {
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTextField, for: indexPath) as! AddRequestTableViewCell
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTxtFld.textAlignment = .right
                }
                else {
                    aCell.gTxtFld.textAlignment = .left
                }
                aCell.gTxtFld.delegate = self
                aCell.gTxtFld.text = myStrLocation
                aCell.gTxtFld.placeholder = Booking_service.LOCATION.titlecontent() //aDictLanguageAddReq["lg6_location"] as? String
                aCell.gImgView.image = UIImage(named: "Icon_add_location")
                aCell.gTxtFld.tag = TAG_LOCATION
                aCell.gTxtFld.inputAccessoryView = nil
                
                return aCell
            }
                
                //            else if indexPath.row == 1 {
                //                let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTextField, for: indexPath) as! AddRequestTableViewCell
                //
                //                aCell.gTxtFld.delegate = self
                //
                //                aCell.gTxtFld.placeholder = "Contact Number"//aDictLanguageAddReq["lg6_contact_number"] as? String
                //                aCell.gImgView.image = UIImage(named: "Icon_add_location")
                //                aCell.gTxtFld.keyboardType = UIKeyboardType.numberPad
                //                aCell.gTxtFld.text = myStrContactNumber
                //                aCell.gTxtFld.tag = TAG_CONTACT_NUMBER
                //                aCell.gTxtFld.inputAccessoryView = nil
                //
                //                return aCell
                //            }
                
            else if indexPath.row == 1 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierCategory, for: indexPath) as! AddProviderCategoryTableViewCell
                aCell.myBtnCat.tag = TAG_CAT
                
                aCell.myBtnCat.addTarget(self, action: #selector(didTapOnCategory(_:)), for: .touchUpInside)
                aCell.gImgViewIcon.image = UIImage(named: "icon_cat")
                if myStrCatName.count != 0 {
                    
                    aCell.myBtnCat.setTitleColor(.black, for: .normal)
                    aCell.myBtnCat.setTitle(myStrCatName, for: .normal)
                }
                else {
                    
                    aCell.myBtnCat.setTitleColor(.lightGray, for: .normal)
                    aCell.myBtnCat.setTitle(ProviderAndUserScreenTitle.CATEGORY_TITLE.titlecontent(), for: .normal) //aDictLanguageAddReq["lg6_category"] as? String
                }
                return aCell
            }
                
            else if indexPath.row == 2 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierCategory, for: indexPath) as! AddProviderCategoryTableViewCell
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.myBtnCat.contentHorizontalAlignment = .right
                }
                else {
                    aCell.myBtnCat.contentHorizontalAlignment = .left
                }
                aCell.myBtnCat.tag = TAG_SUB_CAT
                aCell.myBtnCat.addTarget(self, action: #selector(didTapOnCategory(_:)), for: .touchUpInside)
                aCell.gImgViewIcon.image = UIImage(named: "icon_new_sub_cat")
                
                aCell.myBtnCat.contentHorizontalAlignment = .left
                if myStrSubCatName.count != 0 {
                    
                    aCell.myBtnCat.setTitleColor(.black, for: .normal)
                    aCell.myBtnCat.setTitle(myStrSubCatName, for: .normal)
                }
                else {
                    
                    aCell.myBtnCat.setTitleColor(.lightGray, for: .normal)
                    aCell.myBtnCat.setTitle(ProviderAndUserScreenTitle.SUBCATEGORY_TITLE.titlecontent(), for: .normal) //aDictLanguageAddReq["lg6_sub_category"] as? String
                }
                
                return aCell
            }
            else if indexPath.row == 3 {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTextField, for: indexPath) as! AddRequestTableViewCell
                
                aCell.gTxtFld.delegate = self
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTxtFld.textAlignment = .right
                }
                else {
                    aCell.gTxtFld.textAlignment = .left
                }
                aCell.gTxtFld.placeholder = CreateService.SERVICE_AMT.titlecontent() //aDictLanguageAddReq["lg6_contact_number"] as? String
                aCell.gImgView.image = UIImage(named: "icon_new_sevice_amount")
                aCell.gTxtFld.keyboardType = UIKeyboardType.numberPad
                aCell.gTxtFld.text = myStrAmount
                aCell.gTxtFld.tag = TAG_AMOUNT
                aCell.gTxtFld.inputAccessoryView = nil
                
                return aCell
            }
            else {
                
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTextField, for: indexPath) as! AddRequestTableViewCell
                
                aCell.gTxtFld.delegate = self
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                    aCell.gTxtFld.textAlignment = .right
                }
                else {
                    aCell.gTxtFld.textAlignment = .left
                }
                aCell.gTxtFld.placeholder = CreateService.DESCRIPTION.titlecontent()//aDictLanguageAddReq["lg6_contact_number"] as? String
                aCell.gImgView.image = UIImage(named: "icon_new_add_about")
                aCell.gTxtFld.keyboardType = UIKeyboardType.alphabet
                aCell.gTxtFld.text = myStrAbout
                aCell.gTxtFld.tag = TAG_ABOUT
                aCell.gTxtFld.inputAccessoryView = nil
                
                return aCell
            }
        }
    }
    
    // MARK: - Collection View delegate and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myAryImgInfo.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        
        HELPER.setRoundCornerView(aView: cell.gContainerView, borderRadius: 10.0)
        
        let aStrIsURL: String = myAryImgInfo[indexPath.row]["is_url"]! as! String
        
        
        if aStrIsURL == "1" {
            
            let aStrListImage: String = myAryImgInfo[indexPath.row]["mobile_image"]! as! String

            cell.galleryImg.setShowActivityIndicator(true)
            cell.galleryImg.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            cell.galleryImg.sd_setImage(with: URL(string: WEB_BASE_URL + aStrListImage), placeholderImage: nil)
        }
        else {
            
            cell.galleryImg.image = myAryImgInfo[indexPath.row]["mobile_image"]! as? UIImage
        }
        
        cell.galleryImg.layer.cornerRadius = 5
        cell.galleryImg.clipsToBounds = true
        cell.gViewRemoveBtnContainer.layer.cornerRadius = cell.gViewRemoveBtnContainer.layer.frame.width / 2
            cell.gViewRemoveBtnContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
            cell.removeBtn.setImage(UIImage(named: "icon_new_login_close_white"), for: .normal)
        cell.removeBtn.tag = indexPath.row
        cell.removeBtn.addTarget(self, action: #selector(removeImageAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }
    
    @objc func removeImageAction(_ sender:UIButton){
        
        let aStrTypeUrl: String = myAryImgInfo[sender.tag]["is_url"]! as! String

        if aStrTypeUrl == "0" {
            
            pickerImg.remove(at: sender.tag)
            pickerDataImg.remove(at: sender.tag)
            myAryImgInfo.remove(at: sender.tag)
            myCollectionView.reloadData()
        }
        else {
            
            HELPER.showAlertControllerIn(aViewController: self, aStrMessage: CreateService.DELETE_IMG.titlecontent() , okButtonTitle: CommonTitle.YES_BTN.titlecontent(), cancelBtnTitle: CommonTitle.NO_BTN.titlecontent(), okActionBlock: { (sucessAction) in
                
                let aStrImageID: String = self.myAryImgInfo[sender.tag]["id"]! as! String
                self.getDeleteServiceImageFromApi(id: aStrImageID, serviceId: self.myStrServiceID, arrayIndex: sender.tag)
                
            }, cancelActionBlock: { (cancelAction) in
                
            })
        }
    }
    
    // MARK: - Textfield Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.tag == TAG_TITLE {
            
            myStrTitle = txtAfterUpdate
        }
            
        else if textField.tag == TAG_LOCATION {
            
            myStrLocation = txtAfterUpdate
        }
            
        else if textField.tag == TAG_CONTACT_NUMBER {
            
            if txtAfterUpdate.count <= 16 {
                
                myStrContactNumber = txtAfterUpdate
                
                return true
            }
                
            else {
                
                return false
            }
        }
        else if textField.tag == TAG_ABOUT {
            
            myStrAbout = txtAfterUpdate
        }
        else if textField.tag == TAG_AMOUNT {
            
            if txtAfterUpdate.count <= 6 {
                
                myStrAmount = txtAfterUpdate
                
                return true
            }
            else {
                
                return false
            }
        }
        
        return true;
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        
        textfield.resignFirstResponder()
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        activeTF = textField
        if textField.tag == TAG_LOCATION {
            
            let newmapViewController:NewMapViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_MAP_VC) as! NewMapViewController
            newmapViewController.isFromAddService = true
            newmapViewController.gStrLat = myStrLat
            newmapViewController.gStrLong = myStrLong
            newmapViewController.completionNewMap = {(lat,long,name) in
                
                if let locname = name {
                    self.myStrLocation = ("\(locname)")//locname + add!
                    
                }
                self.myStrLat = lat ?? self.myStrLat
                self.myStrLong = long ?? self.myStrLong
                let textField:UITextField = self.myTblView.viewWithTag(self.TAG_LOCATION) as! UITextField
                textField.text = self.myStrLocation
            }
    
            self.navigationController?.pushViewController(newmapViewController, animated: true)
            return false
            

        }
        else if textField == myTFTo {
            
            if let txt = myTFFrom.text, txt.count > 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = WEB_DATE_FORMAT
                let myFromDate = dateFormatter.date(from: txt)
                myDatePicker.minimumDate = myFromDate
            }
        }
        else if textField == myTFFrom {
            
           if let txt = myTFTo.text, txt.count > 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = WEB_DATE_FORMAT
                let myFromDate = dateFormatter.date(from: txt)
                myDatePicker.maximumDate = myFromDate
            }
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - CZPicker delegate and datasource
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        if pickerView.tag == TAG_CAT {
            
            return myAryCatInfo.count
        }
        else {
            return myArySubCatInfo.count
        }
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        if pickerView.tag == TAG_CAT {
         
            return myAryCatInfo[row]["category_name"] as? String
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
//
//            return aStrImg as? UIImage
//        }
//        else {
//
//            return myArySubCatInfo[row]["subcategory_image"] as? UIImage
//        }
//    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        
        if pickerView.tag == TAG_CAT {
            
            myStrCatId = myAryCatInfo[row]["id"] as! String
            myStrCatName = myAryCatInfo[row]["category_name"] as! String
            myStrSubCatID = ""
            myStrSubCatName = ""
            let indexPath = NSIndexPath(row: 1, section: 2)
            self.myTblView.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.top)
            getSubCategoryListFromApi(CatId: myStrCatId)
        }
        else {
            
            myStrSubCatName = myArySubCatInfo[row]["subcategory_name"] as! String
            myStrSubCatID = myArySubCatInfo[row]["id"] as! String
            let indexPath = NSIndexPath(row: 2, section: 2)
            self.myTblView.reloadRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.top)
        }
    }

    //MARK: - TextView Delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            textView.text = CreateService.TXT_SERVICE_OFFER.titlecontent()
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        var aDictUpdateInfo = myAryTxtViewInfo[textView.tag]
        aDictUpdateInfo[K_TXT_VIEW_VALUE] = textView.text
        myAryTxtViewInfo[textView.tag] = aDictUpdateInfo
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        
        if value == true {
            if mySwitch.tag == 0 {
                allDaysSelected = true
            }
        }
        else {
            if mySwitch.tag == 0 {
                allDaysSelected = false
                myAryTimeInfo[0][K_TXT_FROM] = ""
                myAryTimeInfo[0][K_TXT_TO] = ""
            }
        }
        self.myTblViewAvailblity.reloadData()
    }
    
    //MARK: - Api request
    
    func getCategoryListFromApi() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
//        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: ALERT_LOADING_CONTENT)
        var aDictParams = [String:String]()
        aDictParams["counts_per_page"] = "10"
        aDictParams["current_page"] = String(currentIndex)
        
        HTTPMANAGER.callGetApiParams(strUrl: WEB_SERVICE_URL + CASE_PROFESSIONAL_CATEGOY, dictParameters: aDictParams, sucessBlock: { response in
            
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
//                    var aDictResponseData = [String:Any]()
                    if let aDictResponseData = response["data"] as? [String:Any] {
//                    aDictResponseData = response["data"] as! [String:Any]
                    
                    self.myAryCatInfo = aDictResponseData["category_list"] as! [[String : Any]]
                    }
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
    
    func getSubCategoryListFromApi(CatId:String) {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams = ["category":CatId]
        aDictParams["counts_per_page"] = "10"
        aDictParams["current_page"] = String(currentIndex)
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_PROFESSIONAL_SUB_CATEGOY, dictParameters: aDictParams, sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    
                    if aDictResponseData.count != 0 {
                        
                        self.myArySubCatInfo = aDictResponseData["subcategory_list"] as! [[String : Any]]
                        HELPER.hideLoadingAnimation()
                    }
                    
                    HELPER.hideLoadingAnimation()
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
    
    func addRequestApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_NO_INTERNET)
            
            return
        }
        
        var aryDescription = [String]()
        
        for index in 0..<myAryTxtViewInfo.count {
            
            if myAryTxtViewInfo[index][K_TXT_VIEW_VALUE]?.count != 0 {
                
                aryDescription.append(myAryTxtViewInfo[index][K_TXT_VIEW_VALUE]!)
            }
        }
        if myStrTitle.count == 0 {
            
            //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_title_cannot_be"] as! String)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.TITLE_CANNOT_BE_EMPTY.titlecontent())
            return
        }
            
        else if aryDescription.count == 0 {
            
            //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_description_can"] as! String)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.ENTER_DESCRIPTION.titlecontent())
            return
        }
            
        else if myStrLocation.count == 0 {
            
            //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_location_addres"] as! String)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.ENTER_LOCATION.titlecontent())
            return
        }
        else if myStrCatId.count == 0 {
            
            //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_please_choose_c"] as! String)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.ENTER_CATEGORY.titlecontent())
            return
        }
        else if myStrSubCatID.count == 0 {
            
            //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_please_choose_s"] as! String)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.ENTER_SUB_CATEGORY.titlecontent())
            return
        }
        else if myStrAmount.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.EMPTY_AMNT.titlecontent())
            return
        }
        else if myStrAbout.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.EMPTY_ABOUT.titlecontent())
            return
        }
        else if myAryImgInfo.count < 3 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.UPLOAD_MINIMUM_IMAGE.titlecontent())
            return
        }
     
        
        var headers:HTTPHeaders? = nil
        if SESSION.getUserToken().count > 0 {
            
            headers = ["Content-Type" : "application/json; charset=utf-8","token": SESSION.getUserToken(),"language":SESSION.getAppLangType()]
        }
        else {
            
            headers = ["Content-Type" : "application/json","token": "8338d6ff4f0878b222f312494c1621a9","language":SESSION.getAppLangType()] //default token
        }
        
//        let temp:String = json(from: aryDescription)!
        //        let temp1 = temp.replacingOccurrences(of: "\\", with: "")
        
//        let temp1 = temp.replacingOccurrences(of: "\\", with: "", options: NSString.CompareOptions.literal, range: nil)
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var dictInfo = [String:Any]()
        dictInfo["service_title"] = myStrTitle
        dictInfo["service_offered"] = json(from: aryDescription)
        dictInfo["service_location"] = myStrLocation
        dictInfo["service_latitude"] = SESSION.getUserLatLong().0
        dictInfo["service_longitude"] = SESSION.getUserLatLong().1
        dictInfo["category"] = myStrCatId
        dictInfo["subcategory"] = myStrSubCatID
        dictInfo["service_amount"] = myStrAmount
        dictInfo["about"] = myStrAbout
        
        let searchPredicate = NSPredicate(format: "is_url CONTAINS[C] %@", "0")
        myAryImgUpload = self.myAryImgInfo.filter { searchPredicate.evaluate(with: $0) };
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if self.myAryImgUpload.count != 0 {
                
                for index in 0..<self.myAryImgUpload.count {
                    
                    let aStrIndex = String(index + 1)
                    var aImgData = Data()
                    aImgData = self.myAryImgUpload[index]["mobile_image_data"] as! Data
                    
                    multipartFormData.append(aImgData, withName: "images[]", fileName: "serviceImage" + aStrIndex + ".jpg", mimeType: "image/jpg")
                }
            }
            for (key, value) in dictInfo {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                         usingThreshold: UInt64.init(), to: WEB_SERVICE_URL + CASE_MY_SERVICE_ADD, method: .post, headers: headers) { (result) in
                            
                            switch result {
                            case .success(let upload, _,_ ):
                                
                                upload.uploadProgress(closure: { (progress) in
                                    //Pvinorint progress
                                    print(progress)
                                    
                                })
                                
                                upload.responseJSON { response in
                                    
                                    HELPER.hideLoadingAnimation()
                                    
                                    if response.result.isSuccess {
                                        
                                        HELPER.hideLoadingAnimation()
                                        print(response)
                                        let jsonDict = response.result.value as? [String:Any]
                                        
                                        let jsonDictSuccess = jsonDict!["response"] as? [String:Any]
                                        
                                        let aIntResponseCode = jsonDictSuccess!["response_code"] as! String
                                        let aMessageResponse = jsonDictSuccess!["response_message"] as! String
                                        
                                        if (Int(aIntResponseCode) == kRESPONSE_CODE_DATA) {
                                            
                                            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                                                
                                                HELPER.hideLoadingAnimation()
                                                self.dismiss(animated: true, completion: nil)
                                            })
                                        }
                                        else if (Int(aIntResponseCode) == kRESPONSE_CODE_NO_DATA) {
                                            
                                            HELPER.hideLoadingAnimation()
                                            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                                        }
                                    }
                                    else {
                                        
                                        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "123")
                                    }
                                }
                            case .failure(let encodingError):
                                print (encodingError.localizedDescription)
                                HELPER.hideLoadingAnimation()
                            }
        }
    }
    
    func editRequestApi()  {
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_NO_INTERNET)
            
            return
        }
        
        var aryDescription = [String]()
        
        for index in 0..<myAryTxtViewInfo.count {
            
            if myAryTxtViewInfo[index][K_TXT_VIEW_VALUE]?.count != 0 {
                
                aryDescription.append(myAryTxtViewInfo[index][K_TXT_VIEW_VALUE]!)
            }
        }
        
        if myStrTitle.count == 0 {
            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_title_cannot_be"] as! String)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.TITLE_CANNOT_BE_EMPTY.titlecontent())
            return
        }
            
        else if aryDescription.count == 0 {
            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_description_can"] as! String)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.ENTER_DESCRIPTION.titlecontent())
            return
        }
            
        else if myStrLocation.count == 0 {
            
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_location_addres"] as! String)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.ENTER_LOCATION.titlecontent())
            return
        }
        
        else if myStrCatId.count == 0 {
            
            //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_please_choose_c"] as! String)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.ENTER_CATEGORY.titlecontent())
            return
        }
        else if myStrSubCatID.count == 0 {
            
            //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_please_choose_s"] as! String)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.ENTER_SUB_CATEGORY.titlecontent())
            return
        }
        else if myStrAmount.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.EMPTY_AMNT.titlecontent())
            return
        }
        else if myStrAbout.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.EMPTY_ABOUT.titlecontent())
            return
        }
        else if myAryImgInfo.count < 3 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: CreateService.UPLOAD_MINIMUM_IMAGE.titlecontent())
            return
        }
        
        
        var headers:HTTPHeaders? = nil
        if SESSION.getUserToken().count > 0 {
            
            headers = ["Content-Type" : "application/json; charset=utf-8","token": SESSION.getUserToken(),"language":SESSION.getAppLangType()]
        }
        else {
            
            headers = ["Content-Type" : "application/json","token": "8338d6ff4f0878b222f312494c1621a9","language":SESSION.getAppLangType()] //default token
        }
        
        var dictInfo = [String:Any]()
        dictInfo["service_title"] = myStrTitle
        dictInfo["service_offered"] = json(from: aryDescription)
        dictInfo["service_location"] = myStrLocation
        dictInfo["service_latitude"] = myStrLat
        dictInfo["service_longitude"] = myStrLong
        dictInfo["category"] = myStrCatId
        dictInfo["subcategory"] = myStrSubCatID
        dictInfo["service_amount"] = myStrAmount
        dictInfo["about"] = myStrAbout
        dictInfo["id"] = myStrServiceID
        
        let searchPredicate = NSPredicate(format: "is_url CONTAINS[C] %@", "0")
        myAryImgUpload = self.myAryImgInfo.filter { searchPredicate.evaluate(with: $0) };
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if self.myAryImgUpload.count != 0 {
                
                for index in 0..<self.myAryImgUpload.count {
                    
                    let aStrIndex = String(index + 1)
                    var aImgData = Data()
                    aImgData = self.myAryImgUpload[index]["mobile_image_data"] as! Data
                    
                    multipartFormData.append(aImgData, withName: "images[]", fileName: "serviceImage" + aStrIndex + ".jpg", mimeType: "image/jpg")
                }
            }
            for (key, value) in dictInfo {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        },
                         usingThreshold: UInt64.init(), to: WEB_SERVICE_URL + CASE_MY_SERVICE_EDIT, method: .post, headers: headers) { (result) in
                            
                            switch result {
                            case .success(let upload, _,_ ):
                                
                                upload.uploadProgress(closure: { (progress) in
                                    //Pvinorint progress
                                    print(progress)
                                    
                                })
                                
                                upload.responseJSON { response in
                                    
                                    HELPER.hideLoadingAnimation()
                                    
                                    if response.result.isSuccess {
                                        
                                        print(response)
                                        let jsonDict = response.result.value as? [String:Any]
                                        
                                        let jsonDictSuccess = jsonDict!["response"] as? [String:Any]
                                        
                                        let aIntResponseCode = jsonDictSuccess!["response_code"] as! String
                                        let aMessageResponse = jsonDictSuccess!["response_message"] as! String
                                        
                                        if (Int(aIntResponseCode) == kRESPONSE_CODE_DATA) {
                                            
                                            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse, okActionBlock: { (action) in
                                                
                                                HELPER.hideLoadingAnimation()
                                                self.dismiss(animated: true, completion: nil)
                                            })
                                        }
                                        else if (Int(aIntResponseCode) == kRESPONSE_CODE_NO_DATA) {
                                            
                                            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
                                        }
                                    }
                                    else {
                                        
                                        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "123")
                                    }
                                }
                            case .failure(let encodingError):
                                print (encodingError.localizedDescription)
                                HELPER.hideLoadingAnimation()
                            }
        }
    }
    
    func getDeleteServiceImageFromApi(id:String,serviceId:String,arrayIndex:Int) {
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams = ["id":id,"service_id":serviceId]
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_SERVICE_IMAGE_DELETE, dictParameters: aDictParams, sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    self.myAryImgInfo.remove(at: arrayIndex)
                    self.myCollectionView.reloadData()
                    HELPER.hideLoadingAnimation()
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
    
    func getMyServiceDetailApi(listId:String) {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["id"] = listId
        
        HTTPMANAGER.callGetApiParams(strUrl: WEB_SERVICE_URL + CASE_MY_SERVICE_DETAIL, dictParameters: aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                var aDictResponseData = [String:Any]()
                aDictResponseData = response["data"] as! [String:Any]
                self.myDicInfo = aDictResponseData
                self.myAryImgInfo = self.myDicInfo["service_image"] as! [[String : Any]]
                
                self.loadData()
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
    
    func callAccountStatusApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["type"] = SESSION.getUserLogInType()
        
        HTTPMANAGER.callGetApiParams(strUrl: WEB_SERVICE_URL + CASE_CHECK_STATUS, dictParameters: aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.hideLoadingAnimation()
                    let aDictResponse = response["data"] as! [String : String]
                    self.myStrAvailability = aDictResponse["availability_details"]!
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
    
    func json(from object:[String]) -> String? {
        
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    @objc func profileBtnTapped(sender: UITapGestureRecognizer!) {
        
        showPhotoAction()
    }
    
    
    
    //MARK:- Image picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        var image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
         image = fixImageOrientation(image)
//        let image = info[UIImagePickerControllerEditedImage] as! UIImage          //Cropped image
        
        var aDictImgTemp = [String : Any]()

        if let data = image.jpegData(compressionQuality: 0.1) {
                
                myImgDta = data
                pickerDataImg.append(data)
                
                aDictImgTemp["is_url"] = "0"
                aDictImgTemp["mobile_image"] = image
                aDictImgTemp["mobile_image_data"] = data
            }
       
        myAryImgInfo.append(aDictImgTemp)

        pickerImg.append(image)
        myCollectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    func fixImageOrientation(_ image: UIImage)->UIImage {
              UIGraphicsBeginImageContext(image.size)
              image.draw(at: .zero)
              let newImage = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
              return newImage ?? image
          }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated:true, completion: nil)
    }
    
    func showPhotoAction () {
        
        let aActionSheetController: UIAlertController = UIAlertController(title: aDictLangSignUp["lg1_choose_picture"] as? String, message: nil, preferredStyle: .actionSheet)
        
        let aActionCancel: UIAlertAction = UIAlertAction(title: aDictLangSignUp["lg1_cancel"] as? String, style: .cancel) { void in
            print("Cancel")
        }
        aActionSheetController.addAction(aActionCancel)
        
        let aActionCamera: UIAlertAction = UIAlertAction(title: aDictLangSignUp["lg1_camera"] as? String, style: .default)
        { void in
            
            self.openCamera()
        }
        aActionSheetController.addAction(aActionCamera)
        
        let aActionGallery: UIAlertAction = UIAlertAction(title: aDictLangSignUp["lg1_gallery"] as? String, style: .default)
        { void in
            
            self.loadGallery()
        }
        aActionSheetController.addAction(aActionGallery)
        
        self.present(aActionSheetController, animated: true, completion: nil)
    }
    
    func loadGallery() {
        
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [(kUTTypeImage as? String)] as! [String]
        picker.navigationBar.barTintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        picker.navigationBar.tintColor = .white
        //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(picker, animated: true, completion: nil)
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
//                    let picker = UIImagePickerController()
//
//                    picker.allowsEditing = true
//                    picker.delegate = self
//                    picker.sourceType = .camera
//                    picker.mediaTypes = ([(kUTTypeImage as? String)] as? [String])!
//                    //        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
//                    self.present(picker, animated: true, completion: nil)
//
//                } else {
//
//
//                    HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: "Enable camera option in settings")
//
//                    //access denied
//                }
//            })
//        }
//    }
    
    
    //MARK: - Button Action
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        
        if mySegmentControl.selectedIndex == 0 {

            myViewSecondSegment.isHidden = true
            myTblView.isHidden = false
            myTblView.reloadData()
        }
            
        else {

            myViewSecondSegment.isHidden = false
            HELPER.setRoundCornerView(aView: myViewGallery, borderRadius: 5.0)
            myBtnChoosePhoto.setTitle(CreateService.BROWSE_FROM_GALLERY.titlecontent(), for: .normal)
            HELPER.setRoundCornerView(aView: myBtnChoosePhoto, borderRadius: 15.0)
            myTblView.isHidden = true
            self.myCollectionView.reloadData()
        }
    }
    
    // Date picker Methods
    @objc func dateChanged(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = WEB_DATE_FORMAT
        myStrDate = formatter.string(from: sender.date)
    }
    
    @objc func timeChanged(_ sender: UIDatePicker) {
        
      curretSelectedTFTag = sender.tag
      self .setTimeInTF(cTime: sender.date)
       
    }
    @objc func donePressed(doneBtnTag:UIBarButtonItem){
        
        curretSelectedTFTag = doneBtnTag.tag
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = WEB_TIME_FORMAT
//        myStrFromTime = dateFormatter.string(from: Date())

        if myStrFromTime.count == 0 {
        self .setTimeInTF(cTime: Date())
        myStrFromTime = ""
        }
        view.endEditing(true)
        self.myTblViewAvailblity.reloadData()
    }
    
    @objc func cancelPressed(){
        view.endEditing(true)
    }
    
    //
    @objc func datePickerDonePressed() {
        
        if myStrDate.count == 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = WEB_DATE_FORMAT
            myStrDate = dateFormatter.string(from: Date())
        }
        if activeTF == myTFFrom {
            myTFFrom.text = myStrDate
        }
        else if activeTF == myTFTo {
            myTFTo.text = myStrDate
        }
        
        activeTF .resignFirstResponder()
    }
    
    
    func setTimeInTF(cTime:Date)  {
        
        if (curretSelectedTFTag <= TAG_DATE_PICKER_TO ) {
            let formatter = DateFormatter()
            formatter.dateFormat = WEB_TIME_FORMAT
            myStrFromTime = formatter.string(from: cTime)
            let index = curretSelectedTFTag - TAG_DATE_PICKER_FROM - 1
            var dict = myAryTimeInfo[index]
            dict[K_TXT_FROM] = myStrFromTime
            myAryTimeInfo[index] = dict
            
        }
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = WEB_TIME_FORMAT
            myStrFromTime = formatter.string(from: cTime)
            let index = curretSelectedTFTag - TAG_DATE_PICKER_TO - 1
            var dict = myAryTimeInfo[index]
            dict[K_TXT_TO] = myStrFromTime
            myAryTimeInfo[index] = dict
        }
    }
    func getCurrentDateAndTime()  {
        
//        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = WEB_DATE_FORMAT
    }
    
    @objc func btnDescscriptionAddAndDelete(_ sender: UIButton) {
        
        if sender.tag + 1 < myAryTxtViewInfo.count {
            
            print(myAryTxtViewInfo)
            
            myAryTxtViewInfo.remove(at: sender.tag)
            
            print(myAryTxtViewInfo)
            
        }
            
        else {
            
            var aStrDescription = String ()
            
            aStrDescription = String(myAryTxtViewInfo.count + 1)
            myAryTxtViewInfo.append([K_TXT_VIEW_VALUE:"",K_TXT_VIEW_LABEL:"Description point " + aStrDescription])
//            myAryTxtViewInfo.append([K_TXT_VIEW_VALUE:"",K_TXT_VIEW_LABEL:(aDictLanguageAddReq["lg6_desc_point"] as? String)! + aStrDescription])
        }
        
        for index in 0..<myAryTxtViewInfo.count {
            
            var aDictUpdateInfo = myAryTxtViewInfo[index]
            
            var aStrDescription = String ()
            aStrDescription = "Description point " + String(index + 1)
//            aStrDescription = (aDictLanguageAddReq["lg6_desc_point"] as? String)! + " " + String(index + 1)

            aDictUpdateInfo[K_TXT_VIEW_LABEL] = aStrDescription
            
            myAryTxtViewInfo[index] = aDictUpdateInfo
        }
        
        print(myAryTxtViewInfo)
        
        myTblView.reloadData()
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        if gClickEditProvide == true {
            
            editRequestApi()
        }
        else {
            
            if myStrAvailability.count != 0 {
                
                if myStrAvailability == "1" {
                    
                    addRequestApi()
                }
                else {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: CreateService.UPDATE_AVAILABILITY.titlecontent(), okActionBlock: { (action) in
                        
                        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_PROVIDER_AVAILABILITY_VC) as! NewProviderAvailabilityViewController
                        aViewController.gClickEditProvide = false
                        self.navigationController?.pushViewController(aViewController, animated: true)
                    })
                }
            }
        }
    }
    
    @objc func didTapOnCategory(_ sender: UIButton) {
        
        if sender.tag == TAG_CAT {
            
            //            let picker = CZPickerView(headerTitle: aDictLanguageAddReq["lg6_category"] as? String, cancelButtonTitle: aDictLanguageAddReq["lg6_cancel"] as? String, confirmButtonTitle: aDictLanguageAddReq["lg6_confirm"] as? String)
            
            let picker = CZPickerView(headerTitle: ProviderAndUserScreenTitle.CATEGORY_TITLE.titlecontent(), cancelButtonTitle: CommonTitle.CANCEL_BUTTON.titlecontent(), confirmButtonTitle: CommonTitle.CONFIRM_BTN.titlecontent())
            
            
            if myAryCatIndexCount.count != 0 {
                
                picker?.setSelectedRows(myAryCatIndexCount)
            }
            
            picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            picker?.delegate = self
            picker?.dataSource = self
            picker?.allowMultipleSelection = false
            picker?.confirmButtonBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            picker?.needFooterView = false
            picker?.tag = sender.tag
            
            picker?.show()
        }
        else {
            
            if myStrSubCatName.count == 0 {
                
                if myStrCatId.count == 0 {
                    
                    //                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: (aDictLanguageAddReq["lg6_please_choose_c"] as? String)!, okActionBlock: { (action) in
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: CreateService.ENTER_CATEGORY.titlecontent(), okActionBlock: { (action) in
                        
                    })
                }
                else {
                    
                    //                    let picker = CZPickerView(headerTitle: aDictLanguageAddReq["lg6_sub_category"] as? String, cancelButtonTitle: aDictLanguageAddReq["lg6_cancel"] as? String, confirmButtonTitle: aDictLanguageAddReq["lg6_confirm"] as? String)
                    
                    let picker = CZPickerView(headerTitle: ProviderAndUserScreenTitle.SUBCATEGORY_TITLE.titlecontent(), cancelButtonTitle: CommonTitle.CANCEL_BUTTON.titlecontent(), confirmButtonTitle: CommonTitle.CONFIRM_BTN.titlecontent())
                    
                    if myArySubCatIndexCount.count != 0 {
                        
                        picker?.setSelectedRows(myArySubCatIndexCount)
                    }
                    
                    picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                    picker?.delegate = self
                    picker?.dataSource = self
                    picker?.allowMultipleSelection = false
                    picker?.confirmButtonBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                    picker?.needFooterView = false
                    picker?.tag = sender.tag
                    picker?.show()
                }
            }
                
                //            else if myStrIsCatId != "1" {
                //
                //                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: "There is no sub category for the selected category..", okActionBlock: { (action) in
                //
                //                })
                //            }
            else {
                
                //                let picker = CZPickerView(headerTitle: aDictLanguageAddReq["lg6_sub_category"] as? String, cancelButtonTitle: aDictLanguageAddReq["lg6_cancel"] as? String, confirmButtonTitle: aDictLanguageAddReq["lg6_confirm"] as? String)
                
                let picker = CZPickerView(headerTitle: ProviderAndUserScreenTitle.SUBCATEGORY_TITLE.titlecontent(), cancelButtonTitle: CommonTitle.CANCEL_BUTTON.titlecontent(), confirmButtonTitle: CommonTitle.CONFIRM_BTN.titlecontent())
                
                
                if myArySubCatIndexCount.count != 0 {
                    
                    picker?.setSelectedRows(myArySubCatIndexCount)
                }
                
                picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                picker?.delegate = self
                picker?.dataSource = self
                picker?.allowMultipleSelection = true
                picker?.confirmButtonBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                picker?.needFooterView = true
                picker?.tag = sender.tag
                picker?.show()
            }
        }
    }
    
    @IBAction func btnChoosePhotoTapped(_ sender: Any) {
   
        showPhotoAction()
    }
    
    func openCamera()
    {
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
    
    func showInfoView() {
        
        myTblView.isHidden = false
        myTblViewAvailblity.isHidden = true
        myViewHeadingAvailblity.isHidden = true
    }
    
    func showAvailablityView() {
        
        myTblView.isHidden = true
        myTblViewAvailblity.isHidden = false
        myViewHeadingAvailblity.isHidden = false
    }
    
    func changeLanguageContent() {
        
//        var aDictLangInfo = SESSION.getLangInfo()
        
//        aDictLanguageAddReq = aDictLangInfo["request_and_provider_list"] as! [String : Any]
//        aDictLanguageCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
//        aDictLangSignUp = aDictLangInfo["sign_up"] as! [String : Any]
        
        aDictLanguageCommon["lg7_done"] = CommonTitle.DONE_BTN.titlecontent()
        aDictLangSignUp["lg1_choose_picture"] = CommonTitle.CHOOSE_PICTURE.titlecontent()
        aDictLangSignUp["lg1_cancel"] = CommonTitle.CANCEL_BUTTON.titlecontent()
        aDictLangSignUp["lg1_camera"] = CommonTitle.CAMERA_BTN.titlecontent()
        aDictLangSignUp["lg1_gallery"] = CommonTitle.GALLERY_BTN.titlecontent()
        aDictLanguageAddReq[""] = CommonTitle.TEST.titlecontent()
    }
    
    // MARK:- Functions
    
    func createToolbar()  {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        
        toolBar.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        let doneButton = UIBarButtonItem(title: CommonTitle.DONE_BTN.titlecontent(), style: UIBarButtonItem.Style.done, target: self, action: #selector(ProvideAddViewController.datePickerDonePressed))
        
        let cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ProvideAddViewController.cancelPressed))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
    }
    
    // MARK:- Left Bar Button Methods
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: "icon_close_white"), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func backBtnTapped() {
        
        self.dismiss(animated: true, completion: nil)
    }
}
