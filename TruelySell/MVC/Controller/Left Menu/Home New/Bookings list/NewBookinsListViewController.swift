

import UIKit
import AARatingBar
import CZPicker
import CoreLocation

class NewBookinsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CZPickerViewDelegate,CZPickerViewDataSource,CLLocationManagerDelegate {
   
   @IBOutlet weak var myBtnFilter: UIButton!
   @IBOutlet weak var myViewColorLine: UIView!
   @IBOutlet weak var myLblNoDataContent: UILabel!
   @IBOutlet weak var myTblView: UITableView!
   @IBOutlet weak var myLblTitleMyBookings: UILabel!
   @IBOutlet weak var myImgFilter: UIImageView!
   
   @IBOutlet weak var myLblBookingsHeader: UILabel!
   let cellTableHeaderIdentifier = "HomeNewHeaderTableViewCell"
   let cellTableViewAllListIdentifier = "NewBookingsListTableViewCell"
   
   var myAryListInfo = [[String:Any]]()
   var myAryFilterType = [String]()
   
   var myStrFilterName = String()
   var myStrFilterTypeKey = String()
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
       
       NAVIGAION.hideNavigationBar(aViewController: self)
       super.viewWillAppear(animated)
       myStrFilterTypeKey = "1"
       self.myAryListInfo.removeAll()
       getServiceListFromApi()
       
   }
   
   func setUpUI() {
       
       setUpLeftBarBackButton()
       myLblTitleMyBookings.text = TabBarScreen.TAB_BOOKINGS.titlecontent()
       myLblBookingsHeader.text = TabBarScreen.TAB_BOOKINGS.titlecontent()
       if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
           myLblBookingsHeader.textAlignment = .right
       }
       else {
           myLblBookingsHeader.textAlignment = .left
       }
       HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: myImgFilter, imageName: "icon_view_all_filter")
       //        NAVIGAION.setNavigationTitle(aStrTitle: "My Bookings", aViewController: self)
       myViewColorLine.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
       HELPER.setRoundCornerView(aView: myViewColorLine, borderRadius: 2.5)
       myLblNoDataContent.isHidden = true
       myTblView.isHidden = true
       
       myTblView.delegate = self
       myTblView.dataSource = self
       myTblView.register(UINib.init(nibName: cellTableHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellTableHeaderIdentifier)
       myTblView.register(UINib.init(nibName: cellTableViewAllListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableViewAllListIdentifier)
   }
   
   func setUpModel() {
       
       myAryFilterType = [HomeScreenContents.ALL_TITLE.titlecontent(),Booking_service.PENDING_TITLE.titlecontent(),Booking_service.COMPLETED_TITLE.titlecontent(),Booking_service.CANCELLED_TITLE.titlecontent()]
   }
   
   func loadModel() {
       
   }
   
   
   // MARK: - Table View delegate and datasource
   func numberOfSections(in tableView: UITableView) -> Int {
       
       return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       return myAryListInfo.count
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
       return 0
   }
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
       var aCell:HomeNewHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellTableHeaderIdentifier) as? HomeNewHeaderTableViewCell
       
       aCell?.gLblViewAll.text = ""
       aCell?.gBtnViewAll.tag = section
       aCell?.gLblViewAll.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
       aCell?.gBtnViewAll.addTarget(self, action: #selector(self.filterBtnTapped(sender:)), for: .touchUpInside)
       HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell?.gImgViewViewAll, imageName: "icon_view_all_filter")
       
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
       HELPER.setRoundCornerView(aView: aCell.gImgViewUser)
       aCell.gHeightConstraintUserImg.constant = 40
       aCell.gLblViewonMapContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
       aCell.gLblViewonMapContent.text = ViewAllServices.VIEW_ON_MAP.titlecontent()
       if myAryListInfo.count != 0 {
           
           let aStrListImage:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_image"] as AnyObject) as! String
           let aStrUserImage:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["profile_img"] as AnyObject) as! String
           let aStrUserRatingCount:String =  HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating_count"] as AnyObject) as! String
           let aStrServiceStatus:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["status"] as AnyObject) as! String
           
           let aStrCurrency:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["currency"] as AnyObject) as! String
           let aStrAmount:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_amount"] as AnyObject) as! String
           
           aCell.gLblPrice.text = aStrCurrency.html2String + aStrAmount
           aCell.gImgViewList.setShowActivityIndicator(true)
           aCell.gImgViewList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
           aCell.gImgViewList.sd_setImage(with: URL(string: WEB_BASE_URL + aStrListImage), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
           aCell.gImgViewUser.setShowActivityIndicator(true)
           aCell.gImgViewUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
           aCell.gImgViewUser.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImage), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
           
           aCell.gLblListName.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_title"] as AnyObject) as? String
           aCell.gLblCategory.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["category_name"] as AnyObject) as? String
           aCell.gLblRatingCount.text = "(" + aStrUserRatingCount + ")"
           let myStrIsCod = myAryListInfo[indexPath.row]["cod"] as? String ?? ""
           if aStrServiceStatus == "1" {
               
               aCell.gViewServiceTypeName.text = Booking_service.PENDING_TITLE.titlecontent()
           }
           else if aStrServiceStatus == "2" || aStrServiceStatus == "3" {
               
               aCell.gViewServiceTypeName.text = Booking_service.INPROGRESS_TITLE.titlecontent()
           }
           else if aStrServiceStatus == "5" {
               aCell.gViewServiceTypeName.text = Booking_service.REJECTED_TITLE.titlecontent()
           }
           else if aStrServiceStatus == "6" {
               if myStrIsCod  == "1" {
                   aCell.gViewServiceTypeName.text = Booking_service.COD_PENDING.titlecontent()
               }
               else {
                   aCell.gViewServiceTypeName.text = Booking_service.COMPLETED_TITLE.titlecontent()
               }
               
           }
           else if aStrServiceStatus == "7" {
               
               aCell.gViewServiceTypeName.text = Booking_service.CANCELLED_TITLE.titlecontent()
           }
           else if aStrServiceStatus == "8" {
               
               aCell.gViewServiceTypeName.text = Booking_service.COMPLETED_TITLE.titlecontent()
           }
           let aStrRatingValue:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating"] as AnyObject) as! String  //(myAryListInfo[indexPath.row]["rating"] as? String)!
           let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
           
           aCell.gRating.isUserInteractionEnabled = false
           aCell.gRating.isAbsValue = false
           
           aCell.gRating.maxValue = 5
           aCell.gRating.value = aCGFloatRatingValue
           
           let aStrlat = (myAryListInfo[indexPath.row]["latitude"] as? String)!
           let aStrlong = (myAryListInfo[indexPath.row]["longitude"] as? String)!
           
           if aStrlat.count == 0 || aStrlong.count == 0 {
               
               aCell.gContainerViewMap.isHidden = true
           }
           else {
               
               aCell.gContainerViewMap.isHidden = false
               aCell.gBtnViewonMap.tag = indexPath.row
               aCell.gBtnViewonMap.addTarget(self, action: #selector(self.viewOnMapBtnTapped(sender:)), for: .touchUpInside)
           }
           HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnChat, imageName: "icon_new_chat")
           HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnCall, imageName: "icon_new_call")
           
           aCell.gBtnChat.tag = indexPath.row
           aCell.gBtnCall.tag = indexPath.row
           aCell.gBtnChat.addTarget(self, action: #selector(self.chatBtnTapped(sender:)), for: .touchUpInside)
           aCell.gBtnCall.addTarget(self, action: #selector(self.callBtnTapped(sender:)), for: .touchUpInside)
       }
       
       return aCell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if myAryListInfo.count != 0 {
       let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_BOOK_DETAIL_VC) as! BookDetailViewController
       aViewController.gStrServiceId = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["id"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["id"]! as! String
           
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
       
       myStrFilterName = myAryFilterType[row]
       if row == 0 {
           myStrFilterTypeKey = "1"
           getServiceListFromApi()
       }
       else if row == 1 {
           myStrFilterTypeKey = "2"
           getServiceListFromApi()
       }
       else if row == 2 {
           myStrFilterTypeKey = "3"
           getServiceListFromApi()
       }
       else {
           myStrFilterTypeKey = "4"
           getServiceListFromApi()
       }
       
      
   }
   
   // MARK: - Button Action
   
   @objc func filterBtnTapped(sender: UIButton) {
       
       
   }
   
   @IBAction func btnFilterTapped(_ sender: Any) {
       
       let picker = CZPickerView(headerTitle: Booking_service.CHOOSE_SERVICE_TYPE.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
       
       picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
       picker?.delegate = self
       picker?.dataSource = self
       picker?.needFooterView = false
       picker?.show()
   }
   
   @objc func viewOnMapBtnTapped(sender: UIButton) {
       
       if CLLocationManager.locationServicesEnabled() {
           switch CLLocationManager.authorizationStatus() {
           case .notDetermined, .restricted, .denied:
               print("No access")
               HELPER.showAlertControllerIn(aViewController: self, aStrMessage: CommonTitle.ENABLE_LOCATION_VALIDATION.titlecontent(), okButtonTitle: CommonTitle.ENABLE_LOCATION.titlecontent(), cancelBtnTitle: CommonTitle.NOT_NOW.titlecontent(), okActionBlock: {(sucessAction) in
                   guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                       return
                   }
                   
                   if UIApplication.shared.canOpenURL(settingsUrl) {
                       if #available(iOS 10.0, *) {
                           UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                               print("Settings opened: \(success)") // Prints true
                           })
                       } else {
                           // Fallback on earlier versions
                       }
                   }
               }, cancelActionBlock: { (cancelAction) in
                   
               })
               
           case .authorizedAlways, .authorizedWhenInUse:
               print("Access")
               let btnTag = sender.tag
               let aStrlat = (myAryListInfo[btnTag]["latitude"] as? String)!
               let aStrlong = (myAryListInfo[btnTag]["longitude"] as? String)!
               
               let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_GOOGLE_MAP_DIRECTION_VC) as! GoogleMapsDirectionViewController
               aViewController.gDestinationLatitude = Double(aStrlat)!
               aViewController.gDestinationLongitude = Double(aStrlong)!
               aViewController.gProviderName = HELPER.returnStringFromNull(myAryListInfo[btnTag]["service_title"] as AnyObject) as! String  //myAryListInfo[btnTag]["service_title"] as! String
               self.navigationController?.pushViewController(aViewController, animated: true)
           }
       } else {
       }
       
       
       
   }
   
   @objc func callBtnTapped(sender: UIButton) {
       
       if let phoneno = HELPER.returnStringFromNull(myAryListInfo[sender.tag]["mobileno"] as AnyObject) as? String  //myAryListInfo[sender.tag]["mobileno"]! as? String
       {
           guard let number = URL(string: "tel://" + phoneno) else { return }
           if #available(iOS 10.0, *) {
               UIApplication.shared.open(number)
           } else {
               // Fallback on earlier versions
           }
       }
   }
   
   @objc func chatBtnTapped(sender: UIButton) {
       
       let aViewController:ChatDetailViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHAT_DETAIL) as! ChatDetailViewController
       aViewController.gStrToUserId = HELPER.returnStringFromNull(myAryListInfo[sender.tag]["token"] as AnyObject) as? String ?? "" //myAryListInfo[sender.tag]["token"]  as? String ?? ""
       aViewController.gStrUserName = HELPER.returnStringFromNull(myAryListInfo[sender.tag]["name"] as AnyObject) as? String ?? "" //myAryListInfo[sender.tag]["name"] as? String ?? ""
       aViewController.gStrUserProfImg = HELPER.returnStringFromNull(myAryListInfo[sender.tag]["profile_img"] as AnyObject) as? String ?? "" //myAryListInfo[sender.tag]["profile_img"] as? String ?? ""
       self.navigationController?.pushViewController(aViewController, animated: true)
   }
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let offsetY = scrollView.contentOffset.y
          let contentHeight = scrollView.contentSize.height
          
          if (offsetY > contentHeight - scrollView.frame.height * 4)  {
             
              if currentIndex <= myIntTotalPage && currentIndex != -1 && myIntTotalPage != 0 && isLoading {
                  isLoading = false
                  getServiceListFromApi()
              }
          }
      }
  
   // MARK: - Api call
   func getServiceListFromApi() { //My Booking List
       if !HELPER.isConnectedToNetwork() {
           
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
           return
       }
       HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
       
       var aDictParams = [String:String]()
       aDictParams["type"] = SESSION.getUserLogInType()
       aDictParams["status"] = myStrFilterTypeKey
       aDictParams["counts_per_page"] = "10"
       aDictParams["current_page"] = String(currentIndex)
       HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_BOOKING_LIST,dictParameters:aDictParams, sucessBlock: { response in
           
           HELPER.hideLoadingAnimation()
           
           if response.count != 0 {
               
               var aDictResponse = response[kRESPONSE] as! [String : String]
               
               let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
               
               if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                   
                   var aDictResponseData = [[String:Any]]()
                 
                   if let aDictData = response["data"] as? [String : Any] {
                   aDictResponseData = aDictData["booking_list"] as! [[String : Any]]
                   
                   if aDictResponseData.count != 0 {
                       if self.myAryListInfo.count == 0 {
                           self.myAryListInfo = aDictResponseData
                       }
//                        else {
//                            for dictInfo in  aDictResponseData  {
//                                self.myAryListInfo.append(dictInfo)
//                            }
//                        }
                       self.myLblNoDataContent.isHidden = true
                       self.myTblView.isHidden = false
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
                       
                       self.myLblNoDataContent.isHidden = false
                       self.myTblView.isHidden = true
                       self.isLoading = false
                       self.myLblNoDataContent.text = CommonTitle.NO_SERVICES_FOUND.titlecontent()
                   }
                   
                   HELPER.hideLoadingAnimation()
                   }else {
                       
                       self.myLblNoDataContent.isHidden = false
                       self.myTblView.isHidden = true
                       self.isLoading = false
                       self.myLblNoDataContent.text = CommonTitle.NO_SERVICES_FOUND.titlecontent()
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
