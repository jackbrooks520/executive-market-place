 

import UIKit
import MXSegmentedControl
import Presentr
import CoreLocation

class HomeNewViewAllViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    @IBOutlet weak var myLblNoDataContent: UILabel!
    @IBOutlet weak var mySegmentControl: MXSegmentedControl!
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet var myViewEnableLocationContainer: UIView!
    @IBOutlet var myBtnEnableLocation: UIButton!
    
    let cellTableHeaderIdentifier = "HomeNewHeaderTableViewCell"
    let cellTableViewAllListIdentifier = "ViewAllListTableViewCell"
    
    var isFromPopularService : Bool = false
    var isFromTopRatedService : Bool = false
    var isFromNewService : Bool = false
    var myAryListInfo = [[String:Any]]()
    var myIntTotalPage = Int()
    var currentIndex = 1
    var isLoading = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        setUpRightBarButton()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        setUpLeftBarBackButton()
        
        mySegmentControl.append(title: ViewAllServices.POPULAR.titlecontent())
        mySegmentControl.append(title: ViewAllServices.FEATURED.titlecontent())
        mySegmentControl.append(title: ViewAllServices.NEWEST.titlecontent())
        mySegmentControl.font =  UIFont.systemFont(ofSize: 14)
        mySegmentControl.indicatorColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        mySegmentControl.selectedTextColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        if isFromPopularService == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: ViewAllServices.POPULAR_SERVICES.titlecontent(), aViewController: self)
//            getServiceListApi(type: "Popular")
            mySegmentControl.select(index: 0, animated: true)
        }
        else if isFromNewService == true {
            
            NAVIGAION.setNavigationTitle(aStrTitle: CommonTitle.NEWLY_ADDED_SERVICES.titlecontent(), aViewController: self)
//            getServiceListApi(type: "New")
            mySegmentControl.select(index: 2, animated: true)
        }
        else {
            
            NAVIGAION.setNavigationTitle(aStrTitle: ViewAllServices.FEATURED_SERVICES.titlecontent(), aViewController: self)
//            getServiceListApi(type: "Feature")
            mySegmentControl.select(index: 1, animated: true)
        }
        
        myLblNoDataContent.isHidden = true
        myViewEnableLocationContainer.isHidden = true
        myTblView.isHidden = true
        
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellTableHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellTableHeaderIdentifier)
        myTblView.register(UINib.init(nibName: cellTableViewAllListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableViewAllListIdentifier)
    }
    
    func setUpModel() {
        
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
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var aCell:HomeNewHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellTableHeaderIdentifier) as? HomeNewHeaderTableViewCell
        aCell?.gImgViewViewAll.image = UIImage(named: "icon_home_view_all")
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell?.gLblHeader.textAlignment = .right
        }
        else {
            aCell?.gLblHeader.textAlignment = .left
        }
        aCell?.gLblViewAll.text = ""
        aCell?.gBtnViewAll.tag = section
        aCell?.gLblViewAll.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        aCell?.gBtnViewAll.addTarget(self, action: #selector(self.filterBtnTapped(sender:)), for: .touchUpInside)
        
        //        aCell?.gImgViewViewAll.image = UIImage(named: "icon_view_all_filter")
        aCell?.gImgViewViewAll.isHidden = true
        
        aCell?.backgroundColor = UIColor.clear
        
        if  (aCell == nil) {
            
            let nib:NSArray=Bundle.main.loadNibNamed(cellTableHeaderIdentifier, owner: self, options: nil)! as NSArray
            aCell = nib.object(at: 0) as? HomeNewHeaderTableViewCell
        }
        
        else {
            
            if isFromNewService == true {
                
                aCell?.gLblHeader.text = ViewAllServices.NEW_SERVICES.titlecontent() //"Newest Services"
            }
            else if isFromPopularService == true {
                
                aCell?.gLblHeader.text = ViewAllServices.POPULAR_SERVICES.titlecontent()
            }
            else {
                
                aCell?.gLblHeader.text = ViewAllServices.FEATURED_SERVICES.titlecontent()
            }
            
            aCell?.gViewDesign.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            HELPER.setRoundCornerView(aView: aCell!.gViewDesign, borderRadius: 2.5)
        }
        
        return aCell
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
        
        let bookListImg = UIImage(named: "icon_list_book")
        let tintedImage = bookListImg?.withRenderingMode(.alwaysTemplate)
        
        aCell.gImgBookList.image = tintedImage
        aCell.gImgBookList.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        //        aCell.gContainerViewBook.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        //          aCell.gContainerViewBook.layer.opacity = 0.5
        //        aCell.gContainerViewBook.backgroundColor = HELPER.hexStringToUIColor(hex: APP_PINK_COLOR_OPACITY)
        aCell.gLblViewonMapContent.text = ViewAllServices.VIEW_ON_MAP.titlecontent()
        aCell.gLblBookContent.text = ViewAllServices.BOOK.titlecontent()
        
        aCell.gLblViewonMapContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        aCell.gLblBookContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        if myAryListInfo.count != 0 {
            
            let aStrUserImg: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["user_image"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["user_image"] as! String
            let aStrServiceImg: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_image"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["service_image"] as! String
            let aStrRateCount: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating_count"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["rating_count"] as! String
            
            aCell.gImgViewUser.setShowActivityIndicator(true)
            aCell.gImgViewUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewUser.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImg), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
            
            aCell.gImgViewList.setShowActivityIndicator(true)
            aCell.gImgViewList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewList.sd_setImage(with: URL(string: WEB_BASE_URL + aStrServiceImg), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
            
            aCell.gLblListName.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_title"] as AnyObject) as? String  //myAryListInfo[indexPath.row]["service_title"] as? String
            aCell.gLblCategory.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["category_name"] as AnyObject) as? String  //myAryListInfo[indexPath.row]["category_name"] as? String
            aCell.gLblRatingCount.text = "(" + aStrRateCount + ")"
            
            let aStrRatingValue:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["ratings"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["ratings"]! as! String
            let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
            let aStrCurrency = (HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["currency"] as AnyObject) as? String)!  //(myAryListInfo[indexPath.row]["currency"] as? String)!
            let aStrAmount = (HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_amount"] as AnyObject) as? String)!  //(myAryListInfo[indexPath.row]["service_amount"] as? String)!
            
            aCell.gLblPrice.text = aStrCurrency + aStrAmount
            aCell.gRating.isUserInteractionEnabled = false
            aCell.gRating.isAbsValue = false
            
            aCell.gRating.maxValue = 5
            aCell.gRating.value = aCGFloatRatingValue
            
            let aStrlat = (HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_latitude"] as AnyObject) as? String)!  //(myAryListInfo[indexPath.row]["service_latitude"] as? String)!
            let aStrlong = (HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_longitude"] as AnyObject) as? String)!  //(myAryListInfo[indexPath.row]["service_longitude"] as? String)!
            
            if aStrlat.count == 0 || aStrlong.count == 0 {
                
                aCell.gContainerViewMap.isHidden = true
            }
            else {
                
                aCell.gContainerViewMap.isHidden = false
                aCell.gBtnViewonMap.tag = indexPath.row
                aCell.gBtnViewonMap.addTarget(self, action: #selector(self.viewOnMapBtnTapped(sender:)), for: .touchUpInside)
            }
            if SESSION.getUserToken().count == 0 {
                aCell.gBtnFav.isHidden = true
            }
            else {
                aCell.gBtnFav.isHidden = false
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
        aViewController.gStrServiceId = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_id"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["service_id"]! as! String
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    // MARK: - Button Action
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
        addRemoveFavouritesApi(serviceID: aStrServiceId, isFav: String(aStrServiceFav) )
        //        let indexPath = IndexPath(item: aBtnTag, section: 0)
        //        self.myTblView.reloadRows(at: [indexPath], with: .none)
        self.myTblView.reloadData()
        
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
            setUpUI()
        } else {
        }
    }
    
    @IBAction func mySegmentControlTapped(_ sender: Any) {
        self.myAryListInfo.removeAll()
        switch mySegmentControl.selectedIndex
        {
        //show popular service
        case 0:
            
            myLblNoDataContent.isHidden = true
            myViewEnableLocationContainer.isHidden = true
            self.myTblView.isHidden = true
            NAVIGAION.setNavigationTitle(aStrTitle:  ViewAllServices.POPULAR_SERVICES.titlecontent(), aViewController: self)
            getServiceListApi(type: "Popular")
            isFromPopularService = true
            isFromNewService = false
            isFromTopRatedService = false
        //Featured
        case 1:
            
            myLblNoDataContent.isHidden = true
            self.myTblView.isHidden = true
            myViewEnableLocationContainer.isHidden = true
            NAVIGAION.setNavigationTitle(aStrTitle:  ViewAllServices.FEATURED_SERVICES.titlecontent(), aViewController: self)
            getServiceListApi(type: "Feature")
            isFromPopularService = false
            isFromNewService = false
            isFromTopRatedService = true
        //Newly added Service
        case 2:
            
            myLblNoDataContent.isHidden = true
            myViewEnableLocationContainer.isHidden = true
            self.myTblView.isHidden = true
            NAVIGAION.setNavigationTitle(aStrTitle:  CommonTitle.NEWLY_ADDED_SERVICES.titlecontent(), aViewController: self)
            getServiceListApi(type: "New")
            isFromNewService = true
            isFromPopularService = false
            isFromTopRatedService = false
        default:
            break;
        }
        
    }
    
    @IBAction func enableLocationBtnTapped(_ sender: Any) {
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
    
    @objc func filterBtnTapped(sender: UIButton) {
        
        
    }
    
    @objc func viewOnMapBtnTapped(sender: UIButton) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                HELPER.showAlertControllerIn(aViewController: self, aStrMessage: CommonTitle.ENABLE_LOCATION.titlecontent(), okButtonTitle: CommonTitle.ENABLE_LOCATION.titlecontent(), cancelBtnTitle: CommonTitle.NOT_NOW.titlecontent(), okActionBlock: {(sucessAction) in
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
                //        let aStrlat = HELPER.returnStringFromNull(myAryListInfo[btnTag]["service_latitude"] as AnyObject) as? String  //
                let aStrlat = (myAryListInfo[btnTag]["service_latitude"] as? String)!
                //        let aStrlong = (HELPER.returnStringFromNull(myAryListInfo[btnTag]["service_longitude"] as AnyObject) as? String)!  //
                let aStrlong = (myAryListInfo[btnTag]["service_longitude"] as? String)!
                
                let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_GOOGLE_MAP_DIRECTION_VC) as! GoogleMapsDirectionViewController
                aViewController.gDestinationLatitude = Double(aStrlat)!
                aViewController.gDestinationLongitude = Double(aStrlong)!
                aViewController.gProviderName = HELPER.returnStringFromNull(myAryListInfo[btnTag]["service_title"] as AnyObject) as! String
                //        aViewController.gProviderName = myAryListInfo[btnTag]["service_title"] as! String
                self.navigationController?.pushViewController(aViewController, animated: true)
            }
        } else {
        }
    }
    
    // MARK:- Api call
    func addRemoveFavouritesApi(serviceID:String, isFav : String) {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        var aDictParams = [String:String]()
        aDictParams = ["service_id":serviceID, "status": isFav]
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_ADD_REMOVE_FAVOURITES,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           
           if (offsetY > contentHeight - scrollView.frame.height * 4)  {
              
               if currentIndex <= myIntTotalPage && currentIndex != -1 && myIntTotalPage != 0 && isLoading {
                   isLoading = false
                   if mySegmentControl.selectedIndex == 0 {
                       getServiceListApi(type: "Popular")
                   }
                   if mySegmentControl.selectedIndex == 1 {
                       getServiceListApi(type: "Feature")
                   }
                   else {
                       getServiceListApi(type: "New")
                   }
               }
           }
       }
   
    func getServiceListApi(type:String) {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams = ["latitude":SESSION.getUserLatLong().0, "longitude":SESSION.getUserLatLong().1,"type":type,"counts_per_page" : "10", "current_page" : String(currentIndex)]
  
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_VIEW_ALL,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    
                    aDictResponseData = response["data"] as! [String : Any]
                    
                    if aDictResponseData.count != 0 {
                       
                            if self.myAryListInfo.count == 0 {
                                self.myAryListInfo = aDictResponseData["service_list"] as! [[String : Any]]
                            }
                            else {
                                for dictInfo in  aDictResponseData["service_list"] as! [[String : Any]]  {
                                    self.myAryListInfo.append(dictInfo)
                                }
                            }
                        self.myIntTotalPage = Int(aDictResponseData["total_pages"] as? String ?? "0")!
                        if  self.currentIndex == self.myIntTotalPage || self.myIntTotalPage == 0 {
                            self.isLoading = false
                           
                        } else {
                            self.isLoading = true
                        }
                        
                        self.currentIndex = Int(aDictResponseData["next_page"] as? String ?? "0")!
                        self.myLblNoDataContent.isHidden = true
                        self.myViewEnableLocationContainer.isHidden = true
                        self.myTblView.isHidden = false
//                        self.myAryListInfo = aDictResponseData["service_list"] as! [[String : Any]]
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
        //        let rightBtn2 = UIButton(type: .custom)
        if SESSION.getUserToken().count == 0 {
            rightBtn1.setImage(UIImage(named: "icon_home_login_20"), for: .normal)
        }
        else {
            rightBtn1.setImage(UIImage(named: ICON_MAP), for: .normal)
        }
      
        //        rightBtn2.setImage(UIImage(named: "icon_search_white_20"), for: .normal)
        
        rightBtn1.addTarget(self, action: #selector(rightBtn1Tapped), for: .touchUpInside)
        //        rightBtn2.addTarget(self, action: #selector(rightBtn2Tapped), for: .touchUpInside)
        
        let rightBarBtnItem1 = UIBarButtonItem(customView: rightBtn1)
        //        let rightBarBtnItem2 = UIBarButtonItem(customView: rightBtn2)
        
        self.navigationItem.rightBarButtonItems = [rightBarBtnItem1]
    }
    
    @objc func rightBtn1Tapped() {
        if SESSION.getUserToken().count == 0 {
            
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_USER_LOGIN_VC) as! UserLogInViewController
            aViewController.isFromTabbar = true
            let width = ModalSize.full
            let height =  ModalSize.full //ModalSize.fluid(percentage: 0.50) //ModalSize.half //
            
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
            //        customPresenter.backgroundTap = .noAction
            self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
        } else {
            
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
   
}
