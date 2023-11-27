 

import UIKit
import CZPicker
import MXSegmentedControl
class ProviderServiceListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CZPickerViewDelegate,CZPickerViewDataSource {
    
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myLblNodataContent: UILabel!
    @IBOutlet var mySegmentControl: MXSegmentedControl!
    @IBOutlet var mySegmentHeightConstraint: NSLayoutConstraint!
    let cellTableHeaderIdentifier = "HomeNewHeaderTableViewCell"
    let cellTableViewAllListIdentifier = "NewBookingsListTableViewCell"
    let cellLazyLoadingIdentifier = "LazyLoadingTableViewCell"
    var gIsClickFromMyService: Bool = false
    var gIsClickFromBuyerRequest: Bool = false
    
    var myAryListInfo = [[String:Any]]()
    var myAryFilterType = [String]()
    var myStrFilterName = String()
    var myIntTotalPage = Int()
    var currentIndex = 1
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.myAryListInfo.removeAll()
        if gIsClickFromMyService == true {
            mySegmentHeightConstraint.constant = 50
            if mySegmentControl.selectedIndex == 0 {
                
                getServiceListFromApi(listType: "1")
            }
            
            else {
                getServiceListFromApi(listType: "2")
            }
        }
        else {
            mySegmentHeightConstraint.constant = 0
            getBuyerRequestListFromApi()
        }
        
    }
    
    func setUpUI() {
        
        setUpLeftBarBackButton()
        
        if gIsClickFromMyService == true {
            mySegmentControl.selectedTextColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            mySegmentControl.indicatorColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            
            mySegmentControl.font =  UIFont.systemFont(ofSize: 14)
            mySegmentControl.append(title: HELPER.getTranslateForKey(key: "lbl_active_service", inPage: "newscreens", existingString: "Active Services"))
            mySegmentControl.append(title: HELPER.getTranslateForKey(key: "lbl_inactive_services", inPage: "newscreens", existingString: "InActive Services"))
            
            NAVIGAION.setNavigationTitle(aStrTitle: HomeScreenContents.MY_SERVICE.titlecontent(), aViewController: self)
        
        }
        else {
            
            NAVIGAION.setNavigationTitle(aStrTitle: HomeScreenContents.BUYER_REQUEST.titlecontent(), aViewController: self)
        }
        
        myTblView.isHidden = true
        myLblNodataContent.isHidden = true
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellTableHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellTableHeaderIdentifier)
        myTblView.register(UINib.init(nibName: cellTableViewAllListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableViewAllListIdentifier)
        myTblView.register(UINib.init(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellReuseIdentifier: cellLazyLoadingIdentifier)
        
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        myAryFilterType = [HomeScreenContents.ALL_TITLE.titlecontent(),HomeScreenContents.ACTIVE.titlecontent(),HomeScreenContents.INACTIVE.titlecontent()]
    }
    
    
    // MARK: - Table View delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        if isLoading{
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myAryListInfo.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
        return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var aCell:HomeNewHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellTableHeaderIdentifier) as? HomeNewHeaderTableViewCell
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell?.gLblHeader.textAlignment = .right
            
        }
        else {
            aCell?.gLblHeader.textAlignment = .left
            
        }
        if gIsClickFromMyService == true {
            aCell?.gBtnViewAll.isHidden = true
        }
        aCell?.gLblViewAll.text = ""
        aCell?.gBtnViewAll.tag = section
        aCell?.gLblViewAll.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        aCell?.gBtnViewAll.addTarget(self, action: #selector(self.filterBtnTapped(sender:)), for: .touchUpInside)
        //        let viewAllImg = UIImage(named: "icon_view_all_filter")
        //        let tintedImage = viewAllImg?.withRenderingMode(.alwaysTemplate)
        //        aCell?.gImgViewViewAll.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        //        aCell?.gImgViewViewAll.image = tintedImage
        
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell?.gImgViewViewAll, imageName: "icon_view_all_filter")
        aCell?.backgroundColor = UIColor.clear
        
        if  (aCell == nil) {
            
            let nib:NSArray=Bundle.main.loadNibNamed(cellTableHeaderIdentifier, owner: self, options: nil)! as NSArray
            aCell = nib.object(at: 0) as? HomeNewHeaderTableViewCell
        }
            
        else {
            
            aCell?.gLblHeader.text = HomeScreenContents.MY_SERVICE.titlecontent()
            aCell?.gViewDesign.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            HELPER.setRoundCornerView(aView: aCell!.gViewDesign, borderRadius: 2.5)
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableViewAllListIdentifier, for: indexPath) as! NewBookingsListTableViewCell
        
        HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 15.0)
        HELPER.setRoundCornerView(aView: aCell.gConatinerViewListImg, borderRadius: 10.0)
        HELPER.setRoundCornerView(aView: aCell.gContianerViewUserImg)
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgMapViewAll, imageName: "icon_map_view_all")
        aCell.gHeightConstraintUserImg.constant = 0
      
        aCell.gWidthConstraintServiceActiveStatus.constant = 65
        aCell.gContainerViewMap.isHidden = true
        aCell.gViewServiceType.isHidden = true
        aCell.gLblViewonMapContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        if gIsClickFromMyService == true {
            if mySegmentControl.selectedIndex == 0 {
                aCell.gChatLeadingConstraint.constant = 45
                aCell.gCallHeightConstraint.constant = 30
            }
            else {
                aCell.gCallHeightConstraint.constant = 0
                aCell.gChatLeadingConstraint.constant = 10
            }
            aCell.gViewEditLeadingConstraint.constant = 0
            HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnCall, imageName: "icon_new_edit")
            HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnChat, imageName: "icon_new_delete")
            
            //            aCell.gBtnCall.setImage(UIImage(named: "icon_new_edit"), for: .normal)
            //            aCell.gBtnChat.setImage(UIImage(named: "icon_new_delete"), for: .normal)
        }
        else {
            
            aCell.gBtnCall.setImage(UIImage(named: "icon_new_accept-1"), for: .normal)
            aCell.gBtnChat.setImage(UIImage(named: "icon_new_reject_red"), for: .normal)
        }
        
        if myAryListInfo.count != 0 {
            
            aCell.gBtnCall.tag = indexPath.row
            aCell.gBtnChat.tag = indexPath.row
            if gIsClickFromMyService == true {
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnCall, imageName: "icon_new_edit")
               
                HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnChat, imageName: "icon_new_delete")
                //                aCell.gBtnCall.setImage(UIImage(named: "icon_new_edit"), for: .normal)
                //                aCell.gBtnChat.setImage(UIImage(named: "icon_new_delete"), for: .normal)
                aCell.gBtnCall.addTarget(self, action: #selector(self.editBtnTapped(sender:)), for: .touchUpInside)
                aCell.gBtnChat.addTarget(self, action: #selector(self.deleteBtnTapped(sender:)), for: .touchUpInside)
                
                let aStrListImage: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_image"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["service_image"]! as! String
                let aStrUserImage: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["user_image"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["user_image"]! as! String
                let aStrRatingCount: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating_count"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["rating_count"]! as! String
                let aStrRatingValue:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["ratings"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["ratings"]! as! String
                
                aCell.gImgViewList.setShowActivityIndicator(true)
                aCell.gImgViewList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
                aCell.gImgViewList.sd_setImage(with: URL(string: WEB_BASE_URL + aStrListImage), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
                aCell.gImgViewUser.setShowActivityIndicator(true)
                aCell.gImgViewUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
                aCell.gImgViewUser.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImage), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
                
                aCell.gLblListName.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_title"] as AnyObject) as? String
                aCell.gLblCategory.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["category_name"] as AnyObject) as? String
                aCell.gLblRatingCount.text = "(" + aStrRatingCount + ")"
                
                let aStrCurrency:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["currency"] as AnyObject) as! String  //(myAryListInfo[indexPath.row]["currency"]! as? String)!
                let aStrAmount:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_amount"] as AnyObject) as! String  //(myAryListInfo[indexPath.row]["service_amount"]! as? String)!
                aCell.gLblPrice.text = aStrCurrency + aStrAmount
                
                let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
                
                aCell.gRating.isUserInteractionEnabled = false
                aCell.gRating.isAbsValue = false
                aCell.gRating.maxValue = 5
                aCell.gRating.value = aCGFloatRatingValue
                let aStrServiceStatus: String = myAryListInfo[indexPath.row]["is_active"] as! String
                let aStrAdminVerify: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["admin_verification"] as AnyObject) as! String
                if aStrServiceStatus == "1" {
                    
                    aCell.gLblServiceActiveStatus.text = HomeScreenContents.ACTIVE.titlecontent()
                    aCell.gLblServiceActiveStatus.textColor = HELPER.hexStringToUIColor(hex: ACTIVE_COLOR)
                    aCell.gViewServiceActiveStatus.backgroundColor = HELPER.hexStringToUIColor(hex: "B2F891")
                    HELPER.setBorderView(aView: aCell.gViewServiceActiveStatus, borderWidth: 1.0, borderColor: HELPER.hexStringToUIColor(hex: ACTIVE_COLOR), cornerRadius: 12.0)
                    
                    aCell.gBtnServiceActiveStatus.tag = indexPath.row
                    aCell.gBtnServiceActiveStatus.addTarget(self, action: #selector(self.changeMyServiceStatusToInActive(sender:)), for: .touchUpInside)
                }
                else {
                    aCell.gLblServiceActiveStatus.textColor = HELPER.hexStringToUIColor(hex: IN_ACTIVE_COLOR)
                    aCell.gBtnServiceActiveStatus.tag = indexPath.row
                   aCell.gBtnServiceActiveStatus.addTarget(self, action: #selector(self.changeMyServiceStatusToInActive(sender:)), for: .touchUpInside)
                    aCell.gViewServiceActiveStatus.backgroundColor = HELPER.hexStringToUIColor(hex: "FFD9D9")
                    HELPER.setBorderView(aView: aCell.gViewServiceActiveStatus, borderWidth: 1.0, borderColor: HELPER.hexStringToUIColor(hex: IN_ACTIVE_COLOR), cornerRadius: 12.0)
                    if aStrAdminVerify == "1" {
                    aCell.gLblServiceActiveStatus.text =  HomeScreenContents.INACTIVE.titlecontent()
                    }
                    else {
                        aCell.gLblServiceActiveStatus.text =  CommonTitle.VERIFICATON_PENDING.titlecontent()
                    }
                }
                   
               
            }
            else {
                
                let aStrListImage: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_image"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["service_image"]! as! String
                let aStrUserImage: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["profile_img"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["profile_img"]! as! String
                let aStrRatingCount: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating_count"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["rating_count"]! as! String
                let aStrRatingValue:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["rating"]! as! String
                
                aCell.gImgViewList.setShowActivityIndicator(true)
                aCell.gImgViewList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
                aCell.gImgViewList.sd_setImage(with: URL(string: WEB_BASE_URL + aStrListImage), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
                aCell.gImgViewUser.setShowActivityIndicator(true)
                aCell.gImgViewUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
                aCell.gImgViewUser.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImage), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
                
                aCell.gLblListName.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_title"] as AnyObject) as? String  //myAryListInfo[indexPath.row]["service_title"]! as? String
                aCell.gLblCategory.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["category_name"] as AnyObject) as? String  //myAryListInfo[indexPath.row]["category_name"]! as? String
                aCell.gLblRatingCount.text = "(" + aStrRatingCount + ")"
                
                
                let aStrCurrency:String = (HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["currency_code"] as AnyObject) as? String)!  //(myAryListInfo[indexPath.row]["currency_code"]! as? String)!
                let aStrAmount:String = (HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_amount"] as AnyObject) as? String)!  //(myAryListInfo[indexPath.row]["service_amount"]! as? String)!
                aCell.gLblPrice.text = aStrCurrency.html2String + aStrAmount
                
                let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
                
                aCell.gRating.isUserInteractionEnabled = false
                aCell.gRating.isAbsValue = false
                aCell.gRating.maxValue = 5
                aCell.gRating.value = aCGFloatRatingValue
                
                aCell.gBtnCall.setImage(UIImage(named: "icon_new_accept-1"), for: .normal)
                aCell.gBtnChat.setImage(UIImage(named: "icon_new_reject_red"), for: .normal)
                aCell.gBtnCall.addTarget(self, action: #selector(self.acceptBtnTapped(sender:)), for: .touchUpInside)
                aCell.gBtnChat.addTarget(self, action: #selector(self.declineBtnTapped(sender:)), for: .touchUpInside)
            }
        }
        return aCell
        } else {
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellLazyLoadingIdentifier, for: indexPath) as! LazyLoadingTableViewCell
              aCell.gActivityIndicator.color = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gActivityIndicator.startAnimating()
            
            return aCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if gIsClickFromMyService == true {
            let aStrServiceStatus: String = myAryListInfo[indexPath.row]["is_active"] as! String
            
            if aStrServiceStatus != "0" {
                
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_DETAIL_VC) as! HomeNewDetailViewController
            aViewController.gStrServiceId = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_id"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["service_id"] as! String
            aViewController.isFromProvider = true
            self.navigationController?.pushViewController(aViewController, animated: true)
            }
        }
        else {
            
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_BOOK_DETAIL_VC) as! BookDetailViewController
            aViewController.gStrServiceId = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["id"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["id"] as! String
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
    }
    
    // MARK: - CZPicker delegate and datasource
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        return myAryFilterType.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        return myAryFilterType[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        currentIndex = 1
        self.myAryListInfo.removeAll()
        if row == 0 {
            getServiceListFromApi(listType: "0")
        }
        else if row == 1 {
           getServiceListFromApi(listType: "1")
        }
        else {
            getServiceListFromApi(listType: "2")
        }
    }
    
    // MARK: - Button Action
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        currentIndex = 1
        if mySegmentControl.selectedIndex == 0 {
            self.myAryListInfo.removeAll()
            getServiceListFromApi(listType: "1")
            myTblView.reloadData()
        }
        
        else {
            self.myAryListInfo.removeAll()
            getServiceListFromApi(listType: "2")
            myTblView.reloadData()
        }
    }
    
    @objc func filterBtnTapped(sender: UIButton) {
        
        let picker = CZPickerView(headerTitle: Booking_service.CHOOSE_TYPE.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
        
        picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = false
        picker?.show()
    }
    @objc func editBtnTapped(sender: UIButton) {
        
        let aViewController:ProvideAddViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_ADD_PROVIDE) as! ProvideAddViewController
        aViewController.gClickEditProvide = true
        aViewController.gStrListID = HELPER.returnStringFromNull(myAryListInfo[sender.tag]["service_id"] as AnyObject) as! String  //myAryListInfo[sender.tag]["service_id"]! as! String
        let naviController = UINavigationController(rootViewController: aViewController)
        self.present(naviController, animated: true, completion: nil)
    }
    @objc func deleteBtnTapped(sender: UIButton) {
        
        let aStrServiceId:String = HELPER.returnStringFromNull(myAryListInfo[sender.tag]["service_id"] as AnyObject) as! String  //myAryListInfo[sender.tag]["service_id"]! as! String
        getServiceDeleteApi(listId:aStrServiceId, Index: sender.tag)
    }
    @objc func acceptBtnTapped(sender: UIButton) {
        
    }
    
    @objc func declineBtnTapped(sender: UIButton) {
        
    }

    @objc func changeMyServiceStatusToInActive(sender: UIButton)  {
        let aStrServiceStatus: String = myAryListInfo[sender.tag]["is_active"] as! String
        let aStrAdminVerify: String = HELPER.returnStringFromNull(myAryListInfo[sender.tag]["admin_verification"] as AnyObject) as! String
        if aStrAdminVerify == "1" {
        if aStrServiceStatus == "1" {
            HELPER.showAlertControllerIn(aViewController: self, aStrMessage: Booking_service.INACTIVATE_SERVICE.titlecontent(), okButtonTitle: CommonTitle.YES_BTN.titlecontent(), cancelBtnTitle: CommonTitle.NO_BTN.titlecontent(), okActionBlock: { (sucessAction) in
                
                let aStrServiceId:String = HELPER.returnStringFromNull(self.myAryListInfo[sender.tag]["service_id"] as AnyObject) as! String
                self.getChangeServiceStatusFromApi(statusType: "2", serviceID: aStrServiceId)
                
            }, cancelActionBlock: { (cancelAction) in
                
            })
        }
        else {
            
            HELPER.showAlertControllerIn(aViewController: self, aStrMessage: Booking_service.ACTIVATE_SERVICE.titlecontent(), okButtonTitle: CommonTitle.YES_BTN.titlecontent(), cancelBtnTitle: CommonTitle.NO_BTN.titlecontent(), okActionBlock: { (sucessAction) in
                
                let aStrServiceId:String = HELPER.returnStringFromNull(self.myAryListInfo[sender.tag]["service_id"] as AnyObject) as! String
                self.getChangeServiceStatusFromApi(statusType: "1", serviceID: aStrServiceId)
                
            }, cancelActionBlock: { (cancelAction) in
                
            })
        }
        }
        else {
            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: "Verification Pending!!", okActionBlock: { (action) in
            })
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           
           if (offsetY > contentHeight - scrollView.frame.height * 4)  {
              
               if currentIndex <= myIntTotalPage && currentIndex != -1 && myIntTotalPage != 0 && isLoading {
                   isLoading = false
                   if mySegmentControl.selectedIndex == 0 {
                       
                       getServiceListFromApi(listType: "1")
                   }
                   
                   else {
                       getServiceListFromApi(listType: "2")
                   }
               }
           }
       }
    
    
    // MARK: - Api call
    
    func getServiceListFromApi(listType:String) { //My Service
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        if  self.myAryListInfo.count == 0 {
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        var aDictParams = [String:String]()
        aDictParams["type"] = listType
        aDictParams["counts_per_page"] = "10"
        aDictParams["current_page"] = String(currentIndex)
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_SERVICE_LISTS,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [[String:Any]]()
                    if let aDictData = response["data"] as? [String : Any] {
                    aDictResponseData = aDictData["services"] as! [[String : Any]]
                    if aDictResponseData.count != 0 {
                        if self.myAryListInfo.count == 0 {
                            self.myAryListInfo = aDictResponseData
                        }
                        else {
                            for dictInfo in  aDictResponseData  {
                                self.myAryListInfo.append(dictInfo)
                            }
                        }
                        self.myTblView.isHidden = false
                        self.myLblNodataContent.isHidden = true
                        self.myIntTotalPage = (aDictData["total_pages"] as? Int)!
                        if  self.currentIndex == self.myIntTotalPage || self.myIntTotalPage == 0 {
                            self.isLoading = false
                           
                        } else {
                            self.isLoading = true
                        }
                     
                        self.currentIndex = (aDictData["next_page"] as? Int)!
                        self.myTblView.reloadData()
                    }
                    else {
                        
                        self.myAryListInfo.removeAll()
                        self.myTblView.isHidden = true
                        self.myLblNodataContent.isHidden = false
                        self.isLoading = false
                        self.myLblNodataContent.text = CommonTitle.NO_SERVICES_FOUND.titlecontent()
                        self.myTblView.reloadData()
                    }
                    } else {
                        
                        self.myTblView.isHidden = true
                        self.myLblNodataContent.isHidden = false
                        self.isLoading = false
                        self.myLblNodataContent.text = CommonTitle.NO_SERVICES_FOUND.titlecontent()
                        self.myTblView.reloadData()
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
    
    func getBuyerRequestListFromApi() { //Buyer Request
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["counts_per_page"] = "10"
        aDictParams["current_page"] = String(currentIndex)
        
        HTTPMANAGER.callGetApiParams(strUrl: WEB_SERVICE_URL + CASE_PROVIDER_BUYER_REQUEST, dictParameters: aDictParams, sucessBlock: { response in
            
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [[String:Any]]()
                    if let aDictData = response["data"] as? [String : Any] {
                    aDictResponseData = aDictData["list"] as! [[String : Any]]
                    
                    if aDictResponseData.count != 0 {
                        if self.myAryListInfo.count == 0 {
                            self.myAryListInfo = aDictResponseData
                        }
                        else {
                            for dictInfo in  aDictResponseData  {
                                self.myAryListInfo.append(dictInfo)
                            }
                        }
                        self.myTblView.isHidden = false
                        self.myLblNodataContent.isHidden = true
                        let aDictPagess = aDictData["pages"] as? [String : Any]
                        self.myIntTotalPage = Int(aDictPagess!["total_pages"] as? String ?? "0")!
                        if  self.currentIndex == self.myIntTotalPage || self.myIntTotalPage == 0 {
                            self.isLoading = false
                           
                        } else {
                            self.isLoading = true
                        }
                        
                        self.currentIndex = Int(aDictPagess!["next_page"] as? String ?? "0")!
                        self.myTblView.reloadData()
                    }
                    else {
                        
                        self.myAryListInfo.removeAll()
                        self.myTblView.isHidden = true
                        self.isLoading = false
                        self.myLblNodataContent.isHidden = false
                        self.myLblNodataContent.text = CommonTitle.NO_SERVICES_FOUND.titlecontent()
                        self.myTblView.reloadData()
                    }
                    
                    HELPER.hideLoadingAnimation()
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
    
    func getChangeServiceStatusFromApi(statusType:String,serviceID:String) { //My Service to Active and In-Active
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["status"] = statusType
        aDictParams["service_id"] = serviceID
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_SERVICE_LISTS_ACTIVE_API,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.hideLoadingAnimation()
                    self.currentIndex = 1
                    self.myAryListInfo.removeAll()
                    if self.mySegmentControl.selectedIndex == 0 {
                        self.getServiceListFromApi(listType: "1")
                        
                    }
                    else {
                        self.getServiceListFromApi(listType: "2")
                    }
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA_500) {
                    
                    HELPER.hideLoadingAnimation()
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                    
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                    
                    HELPER.hideLoadingAnimation()
                    self.navigationController?.popViewController(animated: true)
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
    
    func getServiceDeleteApi(listId:String,Index:Int) {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["id"] = listId
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_SERVICE_DELETE,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    self.myAryListInfo.remove(at: Index)
                    self.myTblView.reloadData()
                    
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
