

import UIKit
import Presentr
import CoreLocation

class NewSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
   
   @IBOutlet weak var myViewColor: UIView!
   @IBOutlet weak var myLblNoDataContent: UILabel!
   @IBOutlet weak var myTblView: UITableView!
   @IBOutlet weak var myLblRelatedServices: UILabel!
   @IBOutlet var myViewEnableLocationContainer: UIView!
   @IBOutlet var myBtnEnableLocation: UIButton!
   
   let cellTableViewAllListIdentifier = "ViewAllListTableViewCell"
   
   var myAryListInfo = [[String:Any]]()
   var gBoolIsFromFavourite: Bool = false
   var gStrSearchTitle = String()
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
       NotificationCenter.default.addObserver(self,
                                              selector: #selector(applicationDidBecomeActive),
                                              name: UIApplication.didBecomeActiveNotification,
                                              object: nil)
   }
   
   func setUpUI() {
       
       
       myViewColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
       HELPER.setRoundCornerView(aView: myViewColor, borderRadius: 2.5)
       
       myTblView.isHidden = true
       myLblNoDataContent.isHidden = true
       myViewEnableLocationContainer.isHidden = true
       
       setUpLeftBarBackButton()
       if gBoolIsFromFavourite == false {
           setUpRightBarButton()
       }
       NAVIGAION.setNavigationTitle(aStrTitle: gStrSearchTitle, aViewController: self)
       
       myTblView.delegate = self
       myTblView.dataSource = self
       myTblView.register(UINib.init(nibName: cellTableViewAllListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableViewAllListIdentifier)
   }
   
   func setUpModel() {
       
   }
   
   func loadModel() {
       if gBoolIsFromFavourite {
           myLblRelatedServices.isHidden = false
           myLblRelatedServices.text = gStrSearchTitle
           getfavServices()
       }
       else {
           myLblRelatedServices.isHidden = false
           myLblRelatedServices.text = ViewAllServices.RELATED_SERVICES.titlecontent()
           getServiceListApi(searchTitle: gStrSearchTitle)
       }
   }
   
   // MARK: - Table View delegate and datasource
   func numberOfSections(in tableView: UITableView) -> Int {
       
       return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       return myAryListInfo.count
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
       return 150
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableViewAllListIdentifier, for: indexPath) as! ViewAllListTableViewCell
       
       HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 15.0)
       HELPER.setRoundCornerView(aView: aCell.gContainerViewBook, borderRadius: 15.0)
       HELPER.setRoundCornerView(aView: aCell.gConatinerViewListImg, borderRadius: 15.0)
       HELPER.setRoundCornerView(aView: aCell.gContianerViewUserImg)
       HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgLocation, imageName: "icon_map_view_all")
       //                aCell.gContainerViewBook.backgroundColor = HELPER.hexStringToUIColor(hex: APP_PINK_COLOR_OPACITY)
       //        aCell.gContainerViewBook.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
       //        aCell.gContainerViewBook.layer.opacity = 0.5
       
       aCell.gLblViewonMapContent.text = ViewAllServices.VIEW_ON_MAP.titlecontent()
       aCell.gLblBookContent.text = ViewAllServices.BOOK.titlecontent()
       let bookListImg = UIImage(named: "icon_list_book")
       let tintedImage = bookListImg?.withRenderingMode(.alwaysTemplate)
       
       aCell.gImgBookList.image = tintedImage
       aCell.gImgBookList.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
       aCell.gLblViewonMapContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
       aCell.gLblBookContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
       
       if myAryListInfo.count != 0 {
           let aStrUserImg = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["provider_img"] as AnyObject) as! String
           let aStrServiceImg: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_image"] as AnyObject) as! String   //myAryListInfo[indexPath.row]["service_image"] as! String
           let aStrRateCount: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating_count"] as AnyObject) as! String   //myAryListInfo[indexPath.row]["rating_count"] as! String
           let aStrCurrency = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["currency"] as AnyObject) as! String   //(myAryListInfo[indexPath.row]["currency"] as? String)!
           let aStrAmount = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_amount"] as AnyObject) as! String   //(myAryListInfo[indexPath.row]["service_amount"] as? String)!
           
           aCell.gImgViewUser.setShowActivityIndicator(true)
           aCell.gImgViewUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
           aCell.gImgViewUser.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImg), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
           
           aCell.gImgViewList.setShowActivityIndicator(true)
           aCell.gImgViewList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
           aCell.gImgViewList.sd_setImage(with: URL(string: WEB_BASE_URL + aStrServiceImg), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
           
           aCell.gLblListName.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_title"] as AnyObject) as? String   //myAryListInfo[indexPath.row]["service_title"] as? String
           aCell.gLblCategory.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["category_name"] as AnyObject) as? String   //myAryListInfo[indexPath.row]["category_name"] as? String
           aCell.gLblPrice.text = aStrCurrency.html2String + aStrAmount
           aCell.gLblRatingCount.text = "(" + aStrRateCount + ")"
           
           let aStrRatingValue:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating"] as AnyObject) as! String   //myAryListInfo[indexPath.row]["rating"]! as! String
           let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
           
           aCell.gRating.isUserInteractionEnabled = false
           aCell.gRating.isAbsValue = false
           
           aCell.gRating.maxValue = 5
           aCell.gRating.value = aCGFloatRatingValue
           if SESSION.getUserToken().count == 0 {
               aCell.gBtnFav.isHidden = true
           }
           else {
               aCell.gBtnFav.isHidden = false
               //                if (myAryListInfo[indexPath.row]["service_favorite"] as? NSString)?.doubleValue == 1 {
               if myAryListInfo[indexPath.row]["service_favorite"] as? String == "1" {
                   
                   aCell.gBtnFav.isSelected = true
               }
               else {
                   aCell.gBtnFav.isSelected = false
               }
               aCell.gBtnFav.tag = indexPath.row
               aCell.gBtnFav.addTarget(self, action: #selector(favouriteBtnTapped), for: .touchUpInside)
           }
           
           
       }
       
       return aCell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
       let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_DETAIL_VC) as! HomeNewDetailViewController
       aViewController.gStrServiceId = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_id"] as AnyObject) as! String   //myAryListInfo[indexPath.row]["service_id"]! as! String
       self.navigationController?.pushViewController(aViewController, animated: true)
   }
   
   // MARK:- Api call
   func getfavServices() {
       if !HELPER.isConnectedToNetwork() {
           
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
           return
       }
       HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
       var aDictParams = [String:String]()
       aDictParams["counts_per_page"] = "10"
       aDictParams["current_page"] = String(currentIndex)
       
       HTTPMANAGER.callGetApiParams(strUrl: WEB_SERVICE_URL + CASE_FAVOURITE_LIST, dictParameters: aDictParams, sucessBlock: { response in
           HELPER.hideLoadingAnimation()
           
           if response.count != 0 {
               
               var aDictResponse = response[kRESPONSE] as! [String : String]
               
               let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
               
               if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                   
                   var aDictResponseData = [[String:Any]]()
                   let aDataResponse = response["data"] as! [String : Any]
                   aDictResponseData = aDataResponse["userfavorites"] as! [[String : Any]]
                 
                   if aDictResponseData.count != 0 {
                       if self.myAryListInfo.count == 0 {
                           self.myAryListInfo = aDictResponseData
                       }
                       else {
                           for dictInfo in  aDictResponseData  {
                               self.myAryListInfo.append(dictInfo)
                           }
                       }
                       self.myIntTotalPage = Int(aDataResponse["total_pages"] as? String ?? "0")!
                       if  self.currentIndex == self.myIntTotalPage || self.myIntTotalPage == 0 {
                           self.isLoading = false
                          
                       } else {
                           self.isLoading = true
                       }
                       self.currentIndex = Int(aDataResponse["next_page"] as? String ?? "0")!
                       self.myTblView.isHidden = false
                       self.myLblNoDataContent.isHidden = true
                       self.myViewEnableLocationContainer.isHidden = true
//                        self.myAryListInfo = aDictResponseData
                       self.myTblView.reloadData()
                   }
                   else {
                       self.isLoading = false
                       if CLLocationManager.locationServicesEnabled() {
                           switch CLLocationManager.authorizationStatus() {
                           case .notDetermined, .restricted, .denied:
                               print("No access")
                               self.myViewEnableLocationContainer.isHidden = false
                               self.myViewEnableLocationContainer.layer.cornerRadius =  self.myViewEnableLocationContainer.layer.frame.height / 2
                               self.myViewEnableLocationContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                               self.myBtnEnableLocation.setTitle(CommonTitle.ENABLE_LOCATION.titlecontent(), for: .normal)
                               self.myBtnEnableLocation.setTitleColor(UIColor.white, for: .normal)
                               self.myLblNoDataContent.text = CommonTitle.ENABLE_LOCATION_VALIDATION.titlecontent()
                           case .authorizedAlways, .authorizedWhenInUse:
                               print("Access")
                               self.myViewEnableLocationContainer.isHidden = true
                               if self.gBoolIsFromFavourite {
                                   self.myLblNoDataContent.text = CommonTitle.NO_FAVOURITES.titlecontent()
                               }
                               else {
                                   self.myLblNoDataContent.text = CommonTitle.NO_SERVICES_FOUND.titlecontent()
                               }
                           }
                       } else {
                       }
                       
                       
                       self.myLblNoDataContent.isHidden = false
                       self.myTblView.isHidden = true
                       
                   }
                   
                   HELPER.hideLoadingAnimation()
               }
               else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                   
               }
               else {
                   
                   
                   if CLLocationManager.locationServicesEnabled() {
                       switch CLLocationManager.authorizationStatus() {
                       case .notDetermined, .restricted, .denied:
                           print("No access")
                           self.myViewEnableLocationContainer.isHidden = false
                           self.myViewEnableLocationContainer.layer.cornerRadius =  self.myViewEnableLocationContainer.layer.frame.height / 2
                           self.myViewEnableLocationContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                           self.myBtnEnableLocation.setTitle(CommonTitle.ENABLE_LOCATION.titlecontent(), for: .normal)
                           self.myBtnEnableLocation.setTitleColor(UIColor.white, for: .normal)
                           self.myLblNoDataContent.text = CommonTitle.ENABLE_LOCATION_VALIDATION.titlecontent()
                       case .authorizedAlways, .authorizedWhenInUse:
                           print("Access")
                           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                           self.myViewEnableLocationContainer.isHidden = true
                           self.myLblNoDataContent.text = CommonTitle.NO_SERVICES_FOUND.titlecontent()
                       }
                   } else {
                   }
                   
                   
                   self.myLblNoDataContent.isHidden = false
                   self.myTblView.isHidden = true
                   
                   
               }
           }
           
       }, failureBlock: { error in
           
           HELPER.hideLoadingAnimation()
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
       })
   }
   func scrollViewDidScroll(_ scrollView: UIScrollView) {
          let offsetY = scrollView.contentOffset.y
          let contentHeight = scrollView.contentSize.height
          
          if (offsetY > contentHeight - scrollView.frame.height * 4)  {
             
              if currentIndex <= myIntTotalPage && currentIndex != -1 && myIntTotalPage != 0 && isLoading {
                  isLoading = false
                  getfavServices()
              }
          }
      }
   func getServiceListApi(searchTitle:String) {
       if !HELPER.isConnectedToNetwork() {
           
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
           return
       }
       HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
       
       var aDictParams = [String:String]()
       aDictParams = ["latitude":SESSION.getUserLatLong().0, "longitude":SESSION.getUserLatLong().1,"text":searchTitle, "counts_per_page": "10" , "current_page": String(currentIndex)]
  
       HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_NEW_SEARCH,dictParameters:aDictParams, sucessBlock: { response in
           
           HELPER.hideLoadingAnimation()
           
           if response.count != 0 {
               
               var aDictResponse = response[kRESPONSE] as! [String : String]
               
               let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
               
               if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                   var aDictResponseData = [[String:Any]]()
           
                       if let aDictData = response["data"] as? [String:Any] {
                           aDictResponseData = aDictData["service_list"] as! [[String : Any]]
                
                       }
                
                   if aDictResponseData.count != 0 {
                       
                       self.myTblView.isHidden = false
                       self.myLblNoDataContent.isHidden = true
                       self.myViewEnableLocationContainer.isHidden = true
                       self.myAryListInfo = aDictResponseData
                       self.myTblView.reloadData()
                   }
                   else {
                       
                       if CLLocationManager.locationServicesEnabled() {
                           switch CLLocationManager.authorizationStatus() {
                           case .notDetermined, .restricted, .denied:
                               print("No access")
                               self.myViewEnableLocationContainer.isHidden = false
                               self.myViewEnableLocationContainer.layer.cornerRadius =  self.myViewEnableLocationContainer.layer.frame.height / 2
                               self.myViewEnableLocationContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                               self.myBtnEnableLocation.setTitle(CommonTitle.ENABLE_LOCATION.titlecontent(), for: .normal)
                               self.myBtnEnableLocation.setTitleColor(UIColor.white, for: .normal)
                               self.myLblNoDataContent.text = CommonTitle.ENABLE_LOCATION_VALIDATION.titlecontent()
                           case .authorizedAlways, .authorizedWhenInUse:
                               print("Access")
                               self.myViewEnableLocationContainer.isHidden = true
                               self.myLblNoDataContent.text = CommonTitle.NO_SERVICES_FOUND.titlecontent()
                           }
                       } else {
                       }
                       
                       
                       self.myLblNoDataContent.isHidden = false
                       self.myTblView.isHidden = true
                       
                   }
                   
                   HELPER.hideLoadingAnimation()
               }
               else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                   
               }
               else {
                   
                   
                   if CLLocationManager.locationServicesEnabled() {
                       switch CLLocationManager.authorizationStatus() {
                       case .notDetermined, .restricted, .denied:
                           print("No access")
                           self.myViewEnableLocationContainer.isHidden = false
                           self.myViewEnableLocationContainer.layer.cornerRadius =  self.myViewEnableLocationContainer.layer.frame.height / 2
                           self.myViewEnableLocationContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                           self.myBtnEnableLocation.setTitle(CommonTitle.ENABLE_LOCATION.titlecontent(), for: .normal)
                           self.myBtnEnableLocation.setTitleColor(UIColor.white, for: .normal)
                           self.myLblNoDataContent.text = CommonTitle.ENABLE_LOCATION_VALIDATION.titlecontent()
                       case .authorizedAlways, .authorizedWhenInUse:
                           print("Access")
                           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                           self.myViewEnableLocationContainer.isHidden = true
                           self.myLblNoDataContent.text = CommonTitle.NO_SERVICES_FOUND.titlecontent()
                       }
                   } else {
                   }
                   
                   
                   self.myLblNoDataContent.isHidden = false
                   self.myTblView.isHidden = true
                   
                   
               }
           }
       }, failureBlock: { error in
           
           HELPER.hideLoadingAnimation()
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
       })
   }
   
   func addRemoveFavouritesApi(serviceID:String, isFav : String) {
       if !HELPER.isConnectedToNetwork() {
           
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
           return
       }
       HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
       var aDictParams = [String:String]()
       aDictParams = ["service_id":serviceID, "status": isFav]
       
       HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_ADD_REMOVE_FAVOURITES,dictParameters:aDictParams, sucessBlock: { [self] response in
           
           HELPER.hideLoadingAnimation()
           
           if response.count != 0 {
               
               let aDictResponse = response[kRESPONSE] as! [String : String]
               let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
               if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                   if self.gBoolIsFromFavourite {
                       self.myAryListInfo.removeAll()
                       self.getfavServices()
                   }
                   //                    else {
                   //                        self.getServiceListApi(searchTitle: gStrSearchTitle)
                   //                    }
                   
               }
               else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                   
                   self.myTblView.reloadData()
                   HELPER.hideLoadingAnimation()
                   //                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
               }
               
               else {
                   HELPER.hideLoadingAnimation()
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
               }
           }
           
       }, failureBlock: { error in
           self.myTblView.reloadData()
           HELPER.hideLoadingAnimation()
           HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
       })
   }
   
   // MARK:- Button Action
   @objc func favouriteBtnTapped(sender: UIButton) {
       
       
       let aBtnTag = sender.tag
       let aStrFav = myAryListInfo[aBtnTag]["service_favorite"] as? String
       
       if aStrFav == "1" {
           myAryListInfo[aBtnTag]["service_favorite"]  = "0"
       }
       else {
           myAryListInfo[aBtnTag]["service_favorite"] = "1"
       }
       let aStrServiceId = myAryListInfo[aBtnTag]["service_id"]  as! String
       
       let aStrServiceFav = myAryListInfo[aBtnTag]["service_favorite"] as! String
       addRemoveFavouritesApi(serviceID: aStrServiceId, isFav: aStrServiceFav )
       let indexPath = IndexPath(item: aBtnTag, section: 0)
       self.myTblView.reloadRows(at: [indexPath], with: .none)
       
   }
   @IBAction func enableBtnTapped(_ sender: Any) {
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
   }
   @objc func applicationDidBecomeActive() {
       if CLLocationManager.locationServicesEnabled() {
           switch CLLocationManager.authorizationStatus() {
           case .notDetermined, .restricted, .denied:
               print("No access")
               SESSION.setUserLatLong(lat: "", long: "")
               
           case .authorizedAlways, .authorizedWhenInUse:
               print("Access")
               
               
           }
           getServiceListApi(searchTitle: gStrSearchTitle)
       } else {
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
       leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
       
       leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
       
       let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
       self.navigationItem.leftBarButtonItem = leftBarBtnItem
   }
   
   @objc func backBtnTapped() {
       
       self.navigationController?.popViewController(animated: true)
   }
   
   func setUpRightBarButton() {
       if SESSION.getUserToken().count == 0 {
       let rightBtn1 = UIButton(type: .custom)
               let rightBtn2 = UIButton(type: .custom)
       rightBtn1.setImage(UIImage(named: "icon_home_login_20"), for: .normal)
               rightBtn2.setImage(UIImage(named: ICON_MAP), for: .normal)
       
       rightBtn1.addTarget(self, action: #selector(rightBtn1Tapped), for: .touchUpInside)
               rightBtn2.addTarget(self, action: #selector(rightBtn2Tapped), for: .touchUpInside)
       
       let rightBarBtnItem1 = UIBarButtonItem(customView: rightBtn1)
               let rightBarBtnItem2 = UIBarButtonItem(customView: rightBtn2)
       
       self.navigationItem.rightBarButtonItems = [rightBarBtnItem1, rightBarBtnItem2]
       } else {
           let rightBtn2 = UIButton(type: .custom)
           rightBtn2.setImage(UIImage(named: ICON_MAP), for: .normal)
           rightBtn2.addTarget(self, action: #selector(rightBtn2Tapped), for: .touchUpInside)
           let rightBarBtnItem2 = UIBarButtonItem(customView: rightBtn2)
           
           self.navigationItem.rightBarButtonItems = [rightBarBtnItem2]
       }
   }
   
   @objc func rightBtn1Tapped() {
       
       let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_PROVIDER_LOGIN_VC) as! ProviderLogInViewController
       
       let width = ModalSize.full
       let height =  ModalSize.full//ModalSize.fluid(percentage: 0.50)
       
       //        let width = ModalSize.custom(size: 320)
       //        let height = ModalSize.custom(size: 300)
       
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
   @objc func rightBtn2Tapped() {
       
       let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SERVIDE_LIST_MAP) as! ServiceListInMapViewController
     
       let aNavi = UINavigationController(rootViewController: aViewController)
       if #available(iOS 13.0, *) {
           aViewController.isModalInPresentation = true
       } else {
       }
       aViewController.myAryJobList = myAryListInfo
       aNavi.modalPresentationStyle = .fullScreen
       self.navigationController?.present(aNavi, animated: true, completion: nil)
   }

   
}

