 

import UIKit
import CoreLocation

class ServicesListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    @IBOutlet weak var myViewColor: UIView!
    @IBOutlet weak var myLblNoDataContent: UILabel!
    @IBOutlet weak var myTblView: UITableView!
    
    @IBOutlet var myViewEnableLocationContainer: UIView!
    @IBOutlet weak var myLblHeaderTitleRelatedServices: UILabel!
    @IBOutlet var myBtnEnableLocation: UIButton!
    let cellTableViewAllListIdentifier = "ViewAllListTableViewCell"
    
    var myAryListInfo = [[String:Any]]()
    var gStrSubCatId = String()
    var gStrSubCatName = String()
    
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
        myLblHeaderTitleRelatedServices.text = ViewAllServices.RELATED_SERVICES.titlecontent()
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            myLblHeaderTitleRelatedServices.textAlignment = .right
        }
        else {
            myLblHeaderTitleRelatedServices.textAlignment = .left
        }
        HELPER.setRoundCornerView(aView: myViewColor, borderRadius: 2.5)
        myLblNoDataContent.isHidden = true
        myViewEnableLocationContainer.isHidden = true
        myTblView.isHidden = true
        NAVIGAION.setNavigationTitle(aStrTitle: gStrSubCatName, aViewController: self)
        setUpLeftBarBackButton()
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellTableViewAllListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableViewAllListIdentifier)
    }
    
    func setUpModel() {
        setUpRightBarButton()
    }
    
    func loadModel() {
        
        getServiceListApi(type: gStrSubCatId)
    }
    
    // MARK: - Table View delegate and datasource
    
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
//        aCell.gContainerViewBook.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
//          aCell.gContainerViewBook.layer.opacity = 0.5
        //        aCell.gContainerViewBook.backgroundColor = HELPER.hexStringToUIColor(hex: APP_PINK_COLOR_OPACITY)
        aCell.gLblViewonMapContent.text = ViewAllServices.VIEW_ON_MAP.titlecontent()
        aCell.gLblBookContent.text = ViewAllServices.BOOK.titlecontent()
        
        aCell.gLblViewonMapContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        aCell.gLblBookContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        let bookListImg = UIImage(named: "icon_list_book")
        let tintedImage = bookListImg?.withRenderingMode(.alwaysTemplate)
        
        aCell.gImgBookList.image = tintedImage
        aCell.gImgBookList.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        if myAryListInfo.count != 0 {
            
            let aStrUserImg: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["profile_img"] as AnyObject) as! String
            let aStrServiceImg: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_image"] as AnyObject) as! String
            let aStrRateCount: String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating_count"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["rating_count"] as! String
            let aStrCurrency = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["currency"] as AnyObject) as! String  //(myAryListInfo[indexPath.row]["currency"] as? String)!
            let aStrAmount = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_amount"] as AnyObject) as! String  //(myAryListInfo[indexPath.row]["service_amount"] as? String)!
            
            aCell.gImgViewUser.setShowActivityIndicator(true)
            aCell.gImgViewUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewUser.sd_setImage(with: URL(string: WEB_BASE_URL + aStrUserImg), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
            
            aCell.gImgViewList.setShowActivityIndicator(true)
            aCell.gImgViewList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewList.sd_setImage(with: URL(string: WEB_BASE_URL + aStrServiceImg), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
            
            aCell.gLblListName.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["service_title"] as AnyObject) as? String  //myAryListInfo[indexPath.row]["service_title"] as? String
            aCell.gLblCategory.text = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["category_name"] as AnyObject) as? String  //myAryListInfo[indexPath.row]["category_name"] as? String
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                aCell.gLblPrice.textAlignment = .right
            }
            else {
                aCell.gLblPrice.textAlignment = .left
            }
            aCell.gLblPrice.text = aStrCurrency.html2String + aStrAmount
            
            aCell.gLblRatingCount.text = "(" + aStrRateCount + ")"
            
            let aStrRatingValue:String = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["rating"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["rating"]! as! String
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
                if myAryListInfo[indexPath.row]["service_favorite"] as? Int == 1 {

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
        aViewController.gStrServiceId = HELPER.returnStringFromNull(myAryListInfo[indexPath.row]["id"] as AnyObject) as! String  //myAryListInfo[indexPath.row]["id"]! as! String
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    // MARK:- Button Action
    @objc func favouriteBtnTapped(sender: UIButton) {
        
      
        let aBtnTag = sender.tag
        let aStrFav = myAryListInfo[aBtnTag]["service_favorite"] as? Int
        if aStrFav == 1 {
            myAryListInfo[aBtnTag]["service_favorite"]  = 0
        }
        else {
            myAryListInfo[aBtnTag]["service_favorite"] = 1
        }
        let aStrServiceId = myAryListInfo[aBtnTag]["id"]  as! String
      
        let aStrServiceFav = myAryListInfo[aBtnTag]["service_favorite"] as! Int
        addRemoveFavouritesApi(serviceID: aStrServiceId, isFav: String(aStrServiceFav) )
        let indexPath = IndexPath(item: aBtnTag, section: 0)
        self.myTblView.reloadRows(at: [indexPath], with: .none)
 
    }
    @IBAction func EnableLocationBtnTapped(_ sender: Any) {
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
            getServiceListApi(type: gStrSubCatId)
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
    
    func getServiceListApi(type:String) {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["subcategory_id"] = type
        aDictParams["latitude"] = SESSION.getUserLatLong().0
        aDictParams["longitude"] = SESSION.getUserLatLong().1
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_VIEW_SUB_CATEGORY,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [[String:Any]]()
                    aDictResponseData = response["data"] as! [[String : Any]]
                    
                    if aDictResponseData.count != 0 {
                        self.myLblNoDataContent.isHidden = true
                        self.myViewEnableLocationContainer.isHidden = true
                        self.myTblView.isHidden = false
                        self.self.myAryListInfo = aDictResponseData
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
       
        rightBtn1.setImage(UIImage(named: ICON_MAP), for: .normal)
              
        rightBtn1.addTarget(self, action: #selector(rightBtn1Tapped), for: .touchUpInside)
        
        let rightBarBtnItem1 = UIBarButtonItem(customView: rightBtn1)
        
        self.navigationItem.rightBarButtonItems = [rightBarBtnItem1]
    }
    
    @objc func rightBtn1Tapped() {
      
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SERVIDE_LIST_MAP) as! ServiceListInMapViewController
        aViewController.myAryJobList = myAryListInfo
            let aNavi = UINavigationController(rootViewController: aViewController)
            if #available(iOS 13.0, *) {
                aViewController.isModalInPresentation = true
            } else {
            }
            aNavi.modalPresentationStyle = .fullScreen
            self.navigationController?.present(aNavi, animated: true, completion: nil)
    }
    
}
