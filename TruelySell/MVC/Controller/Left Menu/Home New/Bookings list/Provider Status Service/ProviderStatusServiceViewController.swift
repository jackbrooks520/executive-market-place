 
import UIKit
import AARatingBar
import CZPicker

class ProviderStatusServiceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CZPickerViewDelegate,CZPickerViewDataSource {
    
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myLblNoDataContent: UILabel!
    
    let cellTableHeaderIdentifier = "HomeNewHeaderTableViewCell"
    let cellTableViewAllListIdentifier = "NewBookingsListTableViewCell"
    
    var myAryListInfo = [[String:Any]]()
    var myAryFilterType = [String]()
    
    var myStrFilterName = String()
    var myStrFilterTypeKey = String()
    
    var isFromInProgress:Bool = false
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
    
    func setUpUI() {
        
        setUpLeftBarBackButton()
        
        if isFromInProgress == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: HomeScreenContents.IN_PROGRESS_SERVICES.titlecontent(), aViewController: self)
        }
        else {
            
            NAVIGAION.setNavigationTitle(aStrTitle: HomeScreenContents.COMPLETED_SERVICES.titlecontent(), aViewController: self)
        }
        myTblView.isHidden = true
        myLblNoDataContent.isHidden = true
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellTableHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellTableHeaderIdentifier)
        myTblView.register(UINib.init(nibName: cellTableViewAllListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableViewAllListIdentifier)
    }
    
    func setUpModel() {
        
        myAryFilterType = [HomeScreenContents.ALL_TITLE.titlecontent(),Booking_service.INPROGRESS_TITLE.titlecontent(),Booking_service.COMPLETED_TITLE.titlecontent(),Booking_service.CANCELLED_TITLE.titlecontent()]
    }
    
    func loadModel() {
        
        if isFromInProgress == true {
            
            getServiceListFromApi(serviceType: "2")
        }
        else {
            
            getServiceListFromApi(serviceType: "3")
        }
    }
    
    
    // MARK: - Table View delegate and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryListInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var aCell:HomeNewHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellTableHeaderIdentifier) as? HomeNewHeaderTableViewCell
        aCell?.gImgViewViewAll.image = UIImage(named: "icon_home_view_all")
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell!.gLblHeader.textAlignment = .right
        }
        else {
            aCell!.gLblHeader.textAlignment = .left
        }
        aCell?.gLblViewAll.text = ""
        aCell?.gBtnViewAll.tag = section
        aCell?.gLblViewAll.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        aCell?.gBtnViewAll.addTarget(self, action: #selector(self.filterBtnTapped(sender:)), for: .touchUpInside)
        
        aCell?.gImgViewViewAll.isHidden = true
        
        aCell?.backgroundColor = UIColor.clear
        
        if  (aCell == nil) {
            
            let nib:NSArray=Bundle.main.loadNibNamed(cellTableHeaderIdentifier, owner: self, options: nil)! as NSArray
            aCell = nib.object(at: 0) as? HomeNewHeaderTableViewCell
        }
            
        else {
            
            aCell?.gLblHeader.text = TabBarScreen.TAB_BOOKINGS.titlecontent()
            aCell?.gViewDesign.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            HELPER.setRoundCornerView(aView: aCell!.gViewDesign, borderRadius: 2.5)
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableViewAllListIdentifier, for: indexPath) as! NewBookingsListTableViewCell
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgMapViewAll, imageName: "icon_map_view_all")
        //TO BE CHECKED
        HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnChat, imageName: "icon_new_chat")
        HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnCall, imageName: "icon_new_call")
        aCell.gWidthConstraintServiceActiveStatus.constant = 0
        if indexPath.row % 2 == 0 {
            
            aCell.gViewServiceType.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        }
        else {
            
            aCell.gViewServiceType.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
        }
        
        HELPER.setRoundCornerView(aView: aCell.gViewServiceType, borderRadius: 10.0)
        HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 15.0)
        HELPER.setRoundCornerView(aView: aCell.gConatinerViewListImg, borderRadius: 10.0)
        HELPER.setRoundCornerView(aView: aCell.gContianerViewUserImg)
        
        aCell.gHeightConstraintUserImg.constant = 40
        aCell.gLblViewonMapContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        if myAryListInfo.count != 0 {
            
            let aStrListImage:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_image"] as AnyObject) as! String //myAryListInfo[indexPath.row]["service_image"]! as! String
            let aStrUserImage:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["profile_img"] as AnyObject) as! String //myAryListInfo[indexPath.row]["profile_img"]! as! String
            let aStrUserRatingCount:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating_count"] as AnyObject) as! String //myAryListInfo[indexPath.row]["rating_count"]! as! String
            let aStrServiceStatus:String =  HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["status"] as AnyObject) as! String //myAryListInfo[indexPath.row]["status"]! as! String
            
            let aStrCurrency:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["currency"] as AnyObject) as! String //myAryListInfo[indexPath.row]["currency"]! as! String
            let aStrAmount:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_amount"] as AnyObject) as! String //myAryListInfo[indexPath.row]["service_amount"]! as! String
            
            aCell.gLblPrice.text = aStrCurrency.html2String + aStrAmount
            aCell.gImgViewList.setShowActivityIndicator(true)
            aCell.gImgViewList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewList.sd_setImage(with: URL(string: WEB_BASE_URL + aStrListImage), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
            aCell.gImgViewUser.setShowActivityIndicator(true)
            aCell.gImgViewUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewUser.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImage), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
            
            aCell.gLblListName.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_title"] as AnyObject) as? String //myAryListInfo[indexPath.row]["service_title"]! as? String
            aCell.gLblCategory.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["category_name"] as AnyObject) as? String //myAryListInfo[indexPath.row]["category_name"]! as? String
            aCell.gLblRatingCount.text = "(" + aStrUserRatingCount + ")"
            
            if aStrServiceStatus == "1" {
                
                aCell.gViewServiceTypeName.text = Booking_service.PENDING_TITLE.titlecontent()
            }
            else if aStrServiceStatus == "2" || aStrServiceStatus == "3" {
                
                aCell.gViewServiceTypeName.text = Booking_service.INPROGRESS_TITLE.titlecontent()
            }
            else if aStrServiceStatus == "6" {
                
                aCell.gViewServiceTypeName.text = Booking_service.COMPLETED_TITLE.titlecontent() 
            }
            else if aStrServiceStatus == "7" {
                
                aCell.gViewServiceTypeName.text = Booking_service.CANCELLED_TITLE.titlecontent()
            }
            else if aStrServiceStatus == "8" {
                
                aCell.gViewServiceTypeName.text = Booking_service.COMPLETED_TITLE.titlecontent()
            }
            else if aStrServiceStatus == "5" {
                aCell.gViewServiceTypeName.text = Booking_service.REJECTED_TITLE.titlecontent()
            }
            let aStrRatingValue:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating"] as AnyObject) as! String //(myAryListInfo[indexPath.row]["rating"] as? String)!
            let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
            
            aCell.gRating.isUserInteractionEnabled = false
            aCell.gRating.isAbsValue = false
            
            aCell.gRating.maxValue = 5
            aCell.gRating.value = aCGFloatRatingValue
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_BOOK_DETAIL_VC) as! BookDetailViewController
        aViewController.gStrServiceId = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["id"] as AnyObject) as! String //myAryListInfo[indexPath.row]["id"]! as! String
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    // MARK: - CZPicker delegate and datasource
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        return myAryFilterType.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        return myAryFilterType[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        
        myStrFilterName = myAryFilterType[row]
        if row == 0 {
                   myStrFilterTypeKey = "1"
//                   getServiceListFromApi()
               }
               else if row == 1 {
                   myStrFilterTypeKey = "2"
//                           getServiceListFromApi()
               }
               else if row == 2 {
                   myStrFilterTypeKey = "3"
//                   getServiceListFromApi()
               }
               else {
                   myStrFilterTypeKey = "4"
//                   getServiceListFromApi()
               }
        

    }
    
    // MARK: - Button Action
    
    @objc func filterBtnTapped(sender: UIButton) {
        
        let picker = CZPickerView(headerTitle: Booking_service.CHOOSE_SERVICE_TYPE.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
        
        picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = false
        picker?.show()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           
           if (offsetY > contentHeight - scrollView.frame.height * 4)  {
              
               if currentIndex <= myIntTotalPage && currentIndex != -1 && myIntTotalPage != 0 && isLoading {
                   isLoading = false
                   if isFromInProgress == true {
                       
                       getServiceListFromApi(serviceType: "2")
                   }
                   else {
                       
                       getServiceListFromApi(serviceType: "3")
                   }
               }
           }
       }
    
    // MARK: - Api call
    
    func getServiceListFromApi(serviceType:String) { //My Booking List
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["type"] = SESSION.getUserLogInType()
        aDictParams["status"] = serviceType
        aDictParams["counts_per_page"] = "10"
        aDictParams["current_page"] = String(currentIndex)
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_BOOKING_LIST,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [[String:Any]]()
                    if let aDictData = response["data"] as? [String : Any] {
                    aDictResponseData = aDictData["booking_list"] as! [[String : Any]]
                    
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
                        self.myLblNoDataContent.isHidden = true
//                        self.myAryListInfo = aDictResponseData
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
                        self.isLoading = false
                        self.myTblView.isHidden = true
                        self.myLblNoDataContent.isHidden = false
                        self.myLblNoDataContent.text = CommonTitle.NO_SERVICES_FOUND.titlecontent()
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
    
    func setUpRightBarButton() {
        
        let rightBtn1 = UIButton(type: .custom)
        let rightBtn2 = UIButton(type: .custom)
        rightBtn1.setImage(UIImage(named: "icon_home_login_20"), for: .normal)
        rightBtn2.setImage(UIImage(named: "icon_search_white_20"), for: .normal)
        
        //        rightBtn1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //        rightBtn2.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
        
        rightBtn1.addTarget(self, action: #selector(rightBtn1Tapped), for: .touchUpInside)
        rightBtn2.addTarget(self, action: #selector(rightBtn2Tapped), for: .touchUpInside)
        
        let rightBarBtnItem1 = UIBarButtonItem(customView: rightBtn1)
        let rightBarBtnItem2 = UIBarButtonItem(customView: rightBtn2)
        
        self.navigationItem.rightBarButtonItems = [rightBarBtnItem1,rightBarBtnItem2]
    }
    
    @objc func rightBtn1Tapped() {
        
        
    }
    
    @objc func rightBtn2Tapped() {
        
        
    }
    
}
