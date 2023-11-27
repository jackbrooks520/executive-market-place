

import UIKit
import AARatingBar
import Presentr
import CoreLocation

class HomeNewViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var myBtnLogIn: UIButton!
    @IBOutlet weak var myContainerViewSearch: UIView!
    @IBOutlet weak var myTxtFldSearch: UITextField!
    @IBOutlet weak var myLblFirstContent: UILabel!
    @IBOutlet weak var myLblMiddleContent: UILabel!
    @IBOutlet weak var myImgViewHeader: UIImageView!
    @IBOutlet weak var myContainerHeaderImg: UIView!
    @IBOutlet weak var myTblView: UITableView!
    
    let cellCategoryCollectionIdentifier = "HomeNewCategoryCollectionViewCell"
    let cellServiceListCollectionIdentifier = "ServiceListNewCollectionViewCell"
    let cellTableHeaderIdentifier = "HomeNewHeaderTableViewCell"
    let cellTableCollectionViewIdentifier = "HomeNewCollectionViewTableViewCell"
    let cellTableCollectionViewCategoryIdentifier = "HomeNewCategoryTableViewCell"
    
    var myAryInfo = [[String:Any]]()
    
    let K_ARRAYINFO = "aryinfo"
    let K_TITLE = "title"
    let K_TITLE_CATEGORY = "Category"
    let K_TITLE_POPULAR_SERVICE = "Popular Services"
    let K_TITLE_NEW_SERVICE = "Newly Added Services"
    let K_TITLE_TOP_RATED_SERVICE = "Top Rated Services"
    
    var myStrSearchTitle = String()
    var TAG_SEARCH = 340
    var myIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpModel()
        loadModel()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NAVIGAION.hideNavigationBar(aViewController: self)
        super.viewWillAppear(animated)
        
        if SESSION.getUserToken().count != 0 {
            myBtnLogIn.isHidden = true
        }
        else {
            myBtnLogIn.isHidden = false
            myBtnLogIn.setImage(UIImage(named: "icon_home_login"), for: .normal)
            
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        let middleContentText = NSMutableAttributedString()
        
        middleContentText.append(NSAttributedString(string: CommonTitle.WORLDSLARGEST.titlecontent(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]));
        middleContentText.append(NSAttributedString(string: CommonTitle.MARKETPLACE.titlecontent(), attributes: [NSAttributedString.Key.foregroundColor: HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())]))
        
        myLblMiddleContent.attributedText = middleContentText
        getHomeApi()
    }
    @objc func applicationDidBecomeActive() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                SESSION.setUserLatLong(lat: "", long: "")
                getHomeApi()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                getHomeApi()
            }
        } else {
        }
        
    }
    
    func setUpUI() {
        
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellTableHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellTableHeaderIdentifier)
        myTblView.register(UINib.init(nibName: cellTableCollectionViewIdentifier, bundle: nil), forCellReuseIdentifier: cellTableCollectionViewIdentifier)
        myTblView.register(UINib.init(nibName: cellTableCollectionViewCategoryIdentifier, bundle: nil), forCellReuseIdentifier: cellTableCollectionViewCategoryIdentifier)
        
        HELPER.setBorderView(aView: myContainerViewSearch, borderWidth: 1.5, borderColor: .lightGray, cornerRadius: 20.0)
        
        let firstContentText = NSMutableAttributedString()
        firstContentText.append(NSAttributedString(string: CommonTitle.TRUELY.titlecontent() , attributes: [NSAttributedString.Key.foregroundColor: HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())]));
//        firstContentText.append(NSAttributedString(string: HOME_PAGE_APP_LAST_NAME, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]))
        myLblFirstContent.attributedText = firstContentText
        
        
        HELPER.translateTextField(textField: myTxtFldSearch, key: "txt_fld_search", inPage: "home_screen", isPlaceHolderEnabled: true)
        //        myTxtFldSearch.placeholder = "What are you looking for?"
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            myTxtFldSearch.textAlignment = .right
        }
        else {
            myTxtFldSearch.textAlignment = .left
        }
        
        myTxtFldSearch.tag = TAG_SEARCH
        myTxtFldSearch.delegate = self
        
        self.setUpRightBarButton()
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        //        sendDeviceTokenToApi()
    }
    func setUpRightBarButton() {
        
        
        
        let rightBtn3 = UIButton(type: .custom)
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            rightBtn3.setImage(UIImage(named: ICON_MAP)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        }
        else {
            rightBtn3.setImage(UIImage(named: ICON_MAP), for: .normal)
        }
        rightBtn3.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        rightBtn3.addTarget(self, action: #selector(mapBtnTapped), for: .touchUpInside)
        
        
        let rightBarBtnItem3 = UIBarButtonItem(customView: rightBtn3)
        self.navigationItem.rightBarButtonItems = [rightBarBtnItem3]
        
    }
    
    @objc func mapBtnTapped() {
        let aViewController = ServiceListInMapViewController()
        let aNavi = UINavigationController(rootViewController: aViewController)
        if #available(iOS 13.0, *) {
            aViewController.isModalInPresentation = true
        } else {
        }
        aNavi.modalPresentationStyle = .fullScreen
        self.present(aNavi, animated: true, completion: nil)
    }
    // MARK: - Table View delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return myAryInfo.count != 0 ? myAryInfo.count : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        return myAryInfo[section][K_TITLE] as? String == K_TITLE_CATEGORY ? 0 : 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var aCell:HomeNewHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellTableHeaderIdentifier) as? HomeNewHeaderTableViewCell
        let viewAllImg = UIImage(named: "icon_home_view_all")
        let tintedImage = viewAllImg?.withRenderingMode(.alwaysTemplate)
        aCell?.gImgViewViewAll.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell?.gLblHeader.textAlignment = .right
            aCell?.gLblViewAll.textAlignment = .left
            
            aCell?.gImgViewViewAll.image = tintedImage?.withHorizontallyFlippedOrientation()
        }
        else {
            aCell?.gLblHeader.textAlignment = .left
            aCell?.gLblViewAll.textAlignment = .right
            aCell?.gImgViewViewAll.image = tintedImage
        }
        aCell?.gBtnViewAll.tag = section
        aCell?.gLblViewAll.text = CommonTitle.VIEW_ALL.titlecontent()
        aCell?.gLblViewAll.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        aCell?.gBtnViewAll.addTarget(self, action: #selector(self.viewAllBtnTapped(sender:)), for: .touchUpInside)
        
        
        
        
        aCell?.backgroundColor = UIColor.clear
        
        if  (aCell == nil) {
            
            let nib:NSArray=Bundle.main.loadNibNamed(cellTableHeaderIdentifier, owner: self, options: nil)! as NSArray
            aCell = nib.object(at: 0) as? HomeNewHeaderTableViewCell
        }
        
        else {
            
            if section == 1 {
                
                aCell?.gLblHeader.text = CommonTitle.POPULAR_SERVICES.titlecontent()
                aCell?.gViewDesign.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
                HELPER.setRoundCornerView(aView: aCell!.gViewDesign, borderRadius: 2.5)
            }
            else if section == 2 {
                
                aCell?.gLblHeader.text = CommonTitle.NEWLY_ADDED_SERVICES.titlecontent()
                aCell?.gViewDesign.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                HELPER.setRoundCornerView(aView: aCell!.gViewDesign, borderRadius: 2.5)
            } else {
                aCell?.gLblHeader.text = ViewAllServices.FEATURED_SERVICES.titlecontent()
                aCell?.gViewDesign.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                HELPER.setRoundCornerView(aView: aCell!.gViewDesign, borderRadius: 2.5)
            }
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_CATEGORY {
            
            return 130
        }
        else {
            
            return 200//170
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_CATEGORY {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableCollectionViewCategoryIdentifier, for: indexPath) as! HomeNewCategoryTableViewCell
            
            
            aCell.gCollectionView.delegate = self
            aCell.gCollectionView.dataSource = self
            aCell.gCollectionView.tag = indexPath.section
            
            aCell.gCollectionView.register(UINib(nibName: cellCategoryCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellCategoryCollectionIdentifier)
            
            aCell.gCollectionView.reloadData()
            
            return aCell
        }
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_POPULAR_SERVICE {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableCollectionViewIdentifier, for: indexPath) as! HomeNewCollectionViewTableViewCell
            
            let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:Any]]
            
            if aAryInfo.count != 0 {
                
                aCell.gCategoryCollectionView.isHidden = false
                aCell.gLblNoRecordContent.isHidden = true
                aCell.gViewEnableLocationContainer.isHidden = true
                aCell.gCategoryCollectionView.delegate = self
                aCell.gCategoryCollectionView.dataSource = self
                aCell.gCategoryCollectionView.tag = indexPath.section
                
                aCell.gCategoryCollectionView.register(UINib(nibName: cellServiceListCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellServiceListCollectionIdentifier)
                aCell.gCategoryCollectionView.reloadData()
                
            }
            else {
                
                if CLLocationManager.locationServicesEnabled() {
                    switch CLLocationManager.authorizationStatus() {
                    case .notDetermined, .restricted, .denied:
                        print("No access")
                        aCell.gViewEnableLocationContainer.isHidden = false
                        aCell.gViewEnableLocationContainer.layer.cornerRadius = aCell.gViewEnableLocationContainer.layer.frame.height / 2
                        aCell.gBtnEnableLocation.setTitle(CommonTitle.ENABLE_LOCATION.titlecontent(), for: .normal)
                        aCell.gViewEnableLocationContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                        aCell.gBtnEnableLocation.setTitleColor(UIColor.white, for: .normal)
                        aCell.gLblNoRecordVerticalConstraint.constant = -30
                        aCell.gLblNoRecordContent.text = CommonTitle.ENABLE_LOCATION_VALIDATION.titlecontent()
                        aCell.gBtnEnableLocation.addTarget(self, action: #selector(self.btnLocationEnableTapped(_:)), for: .touchUpInside)
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                        
                        aCell.gLblNoRecordVerticalConstraint.constant = 0
                        aCell.gViewEnableLocationContainer.isHidden = true
                        aCell.gLblNoRecordContent.text = HomeScreenContents.NO_POPULAR_SERVICE.titlecontent()
                    }
                } else {
                }
                aCell.gLblNoRecordContent.isHidden = false
                aCell.gCategoryCollectionView.isHidden = true
                //
                //                aCell.gCategoryCollectionView.isHidden = true
                //                aCell.gLblNoRecordContent.isHidden = false
                //                aCell.gLblNoRecordContent.text = HomeScreenContents.NO_POPULAR_SERVICE.titlecontent()
                
            }
            
            return aCell
        }
        else if myAryInfo[indexPath.section][K_TITLE] as? String == K_TITLE_NEW_SERVICE {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableCollectionViewIdentifier, for: indexPath) as! HomeNewCollectionViewTableViewCell
            
            let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:Any]]
            
            if aAryInfo.count != 0 {
                
                aCell.gCategoryCollectionView.isHidden = false
                aCell.gLblNoRecordContent.isHidden = true
                aCell.gViewEnableLocationContainer.isHidden = true
                aCell.gCategoryCollectionView.delegate = self
                aCell.gCategoryCollectionView.dataSource = self
                aCell.gCategoryCollectionView.tag = indexPath.section
                
                aCell.gCategoryCollectionView.register(UINib(nibName: cellServiceListCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellServiceListCollectionIdentifier)
                
                aCell.gCategoryCollectionView.reloadData()
            }
            else {
                
                if CLLocationManager.locationServicesEnabled() {
                    switch CLLocationManager.authorizationStatus() {
                    case .notDetermined, .restricted, .denied:
                        print("No access")
                        aCell.gViewEnableLocationContainer.isHidden = false
                        aCell.gViewEnableLocationContainer.layer.cornerRadius = aCell.gViewEnableLocationContainer.layer.frame.height / 2
                        aCell.gBtnEnableLocation.setTitle(CommonTitle.ENABLE_LOCATION.titlecontent(), for: .normal)
                        aCell.gViewEnableLocationContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                        aCell.gBtnEnableLocation.setTitleColor(UIColor.white, for: .normal)
                        aCell.gLblNoRecordVerticalConstraint.constant = -30
                        aCell.gLblNoRecordContent.text = CommonTitle.ENABLE_LOCATION_VALIDATION.titlecontent()
                        aCell.gBtnEnableLocation.addTarget(self, action: #selector(self.btnLocationEnableTapped(_:)), for: .touchUpInside)
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                        
                        aCell.gLblNoRecordVerticalConstraint.constant = 0
                        aCell.gViewEnableLocationContainer.isHidden = true
                        aCell.gLblNoRecordContent.text = HomeScreenContents.NO_NEWLY_ADDED_SERVICE.titlecontent()
                    }
                } else {
                }
                aCell.gLblNoRecordContent.isHidden = false
                aCell.gCategoryCollectionView.isHidden = true
                
            }
            
            return aCell
        } else {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableCollectionViewIdentifier, for: indexPath) as! HomeNewCollectionViewTableViewCell
            
            let aAryInfo = myAryInfo[indexPath.section][K_ARRAYINFO] as! [[String:Any]]
            
            if aAryInfo.count != 0 {
                
                aCell.gCategoryCollectionView.isHidden = false
                aCell.gLblNoRecordContent.isHidden = true
                aCell.gViewEnableLocationContainer.isHidden = true
                aCell.gCategoryCollectionView.delegate = self
                aCell.gCategoryCollectionView.dataSource = self
                aCell.gCategoryCollectionView.tag = indexPath.section
                
                aCell.gCategoryCollectionView.register(UINib(nibName: cellServiceListCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellServiceListCollectionIdentifier)
                
                aCell.gCategoryCollectionView.reloadData()
            }
            else {
                
                if CLLocationManager.locationServicesEnabled() {
                    switch CLLocationManager.authorizationStatus() {
                    case .notDetermined, .restricted, .denied:
                        print("No access")
                        aCell.gViewEnableLocationContainer.isHidden = false
                        aCell.gViewEnableLocationContainer.layer.cornerRadius = aCell.gViewEnableLocationContainer.layer.frame.height / 2
                        aCell.gBtnEnableLocation.setTitle(CommonTitle.ENABLE_LOCATION.titlecontent(), for: .normal)
                        aCell.gViewEnableLocationContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                        aCell.gBtnEnableLocation.setTitleColor(UIColor.white, for: .normal)
                        aCell.gLblNoRecordVerticalConstraint.constant = -30
                        aCell.gLblNoRecordContent.text = CommonTitle.ENABLE_LOCATION_VALIDATION.titlecontent()
                        aCell.gBtnEnableLocation.addTarget(self, action: #selector(self.btnLocationEnableTapped(_:)), for: .touchUpInside)
                    case .authorizedAlways, .authorizedWhenInUse:
                        print("Access")
                        
                        aCell.gLblNoRecordVerticalConstraint.constant = 0
                        aCell.gViewEnableLocationContainer.isHidden = true
                        aCell.gLblNoRecordContent.text = "No Services found"
                    }
                } else {
                }
                aCell.gLblNoRecordContent.isHidden = false
                aCell.gCategoryCollectionView.isHidden = true
                
            }
            
            return aCell
        }
    }
    
    // MARK: - Collection View Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_CATEGORY {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:String]]
            
            return aAryInfo.count + 1
        }
        else if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_POPULAR_SERVICE {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:Any]]
            
            return aAryInfo.count
        }
        else {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:Any]]
            
            return aAryInfo.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_CATEGORY {
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCategoryCollectionIdentifier, for: indexPath) as! HomeNewCategoryCollectionViewCell
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:String]]
            
            if indexPath.row < aAryInfo.count {
                
                aCell.gContainerViewHeightConstraint.constant = 50
                HELPER.setRoundCornerView(aView: aCell.gContainerViewImg)
                HELPER.setRoundCornerView(aView: aCell.gImgViewCategory)
                aCell.gImgViewCategory.isHidden = false
                aCell.gImgViewMore.isHidden = true
                aCell.gImgViewCategory.setShowActivityIndicator(true)
                aCell.gImgViewCategory.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
                aCell.gImgViewCategory.sd_setImage(with: URL(string: WEB_BASE_URL + aAryInfo[indexPath.row]["category_image"]!), placeholderImage: UIImage(named: "icon_home_category"))
                
                aCell.gLblCategoryName.text = aAryInfo[indexPath.row]["category_name"]
            }
            else {
                aCell.gContainerViewHeightConstraint.constant = 50
                HELPER.setRoundCornerView(aView: aCell.gContainerViewImg)
                //                HELPER.setRoundCornerView(aView: aCell.gImgViewCategory)
                aCell.gImgViewCategory.isHidden = true
                aCell.gImgViewMore.isHidden = false
                let dottedImg = UIImage(named: "icon_more_dotted")
                let tintedImage = dottedImg?.withRenderingMode(.alwaysTemplate)
                
                aCell.gImgViewMore.image = tintedImage
                aCell.gImgViewMore.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                
                aCell.gLblCategoryName.text = CommonTitle.VIEW_MORE.titlecontent()
            }
            
            return aCell
        }
        else  if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_POPULAR_SERVICE {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:Any]]
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellServiceListCollectionIdentifier, for: indexPath) as! ServiceListNewCollectionViewCell
            
            HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
            aCell.gImgViewUserImage.clipsToBounds = true
            HELPER.setBorderView(aView:  aCell.gContainerViewUserImage, borderWidth: 2, borderColor: UIColor.white, cornerRadius: 5)
            
            //            HELPER.setRoundCornerView(aView: aCell.gContainerViewUserImage)
            //            HELPER.setRoundCornerView(aView: aCell.gImgViewUserImage)
            HELPER.setRoundCornerView(aView: aCell.gContainerViewCategory, borderRadius: 5)
            HELPER.setRoundCornerView(aView: aCell.gViewDistance, borderRadius: 5)
            if SESSION.getUserLatLong().0 != "" && SESSION.getUserLatLong().1 != "" && aAryInfo[indexPath.row]["service_latitude"] as! String != "" && aAryInfo[indexPath.row]["service_longitude"] as! String != "" {
                aCell.gViewDistance.isHidden = false
            let firsLocation = CLLocation(latitude:Double(SESSION.getUserLatLong().0)!, longitude:Double(SESSION.getUserLatLong().1)!)
            let doubleServiceLat = Double(aAryInfo[indexPath.row]["service_latitude"] as? String ?? "0.0")!
            let doubleServiceLong = Double(aAryInfo[indexPath.row]["service_longitude"]as? String ?? "0.0")!
            let secondLocation = CLLocation(latitude: doubleServiceLat, longitude: doubleServiceLong)
            let distance = firsLocation.distance(from: secondLocation) / 1000
            aCell.gLblDistance.text = " \(String(format:"%.02f", distance)) KM"
                aCell.gLblDistance.textColor = UIColor.black
            } else {
                aCell.gViewDistance.isHidden = true
            }
           
            aCell.gImgViewUserImage.setShowActivityIndicator(true)
            aCell.gImgViewUserImage.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            let STR_USER_IMG = aAryInfo[indexPath.row]["user_image"] as! String
            aCell.gImgViewUserImage.sd_setImage(with: URL(string: WEB_BASE_URL + STR_USER_IMG), placeholderImage: UIImage(named: ICON_PLACEHOLDER_SQUARE))
            
            aCell.gImgViewServiceList.setShowActivityIndicator(true)
            aCell.gImgViewServiceList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            let STR_SERVICE_IMG = aAryInfo[indexPath.row]["service_image"] as! String
            aCell.gImgViewServiceList.sd_setImage(with: URL(string: WEB_BASE_URL + STR_SERVICE_IMG), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
            
            aCell.gLblServiceName.text = aAryInfo[indexPath.row]["service_title"] as! String
            aCell.gLblCategoryName.text = aAryInfo[indexPath.row]["category_name"] as! String
            let STR_RATING_COUNT = aAryInfo[indexPath.row]["rating_count"] as! String
            aCell.gLblRateCount.text = "(" + STR_RATING_COUNT + ")"
            
            let aStrRatingValue:String = aAryInfo[indexPath.row]["ratings"] as! String
            let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
            let aStrCurrency = (aAryInfo[indexPath.row]["currency"]) as! String
            let aStrAmount = (aAryInfo[indexPath.row]["service_amount"])!
            aCell.gLblPrice.text = aStrCurrency + "\(aStrAmount)"
            aCell.gLblPrice.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gViewRatingBar.isUserInteractionEnabled = false
            aCell.gViewRatingBar.isAbsValue = false
            
            aCell.gViewRatingBar.maxValue = 5
            aCell.gViewRatingBar.value = aCGFloatRatingValue
            
            //            aCell.gLblCategoryName.text = "&#8377;".html2String
            
            //            if indexPath.row % 2 == 0 {
            //
            //                aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            //            }
            //            else {
            //
            //                aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            //            }
            aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            
            aCell.gViewDistance.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            //            HELPER.setRoundCornerView(aView: aCell.gViewColor, borderRadius: 2.5)
            
            if SESSION.getUserToken().count == 0 {
                aCell.gBtnFav.isHidden = true
            }
            else {
                aCell.gBtnFav.isHidden = false
                //                if (aAryInfo[indexPath.row]["service_favorite"] as? NSString)?.doubleValue == 1 {
                if  aAryInfo[indexPath.row]["service_favorite"] as? String == "1" {
                    aCell.gBtnFav.isSelected = true
                }
                else {
                    aCell.gBtnFav.isSelected = false
                }
                aCell.gBtnFav.removeTarget(nil, action: nil, for: .touchUpInside)
                aCell.gBtnFav.tag = indexPath.row
                aCell.gBtnFav.addTarget(self, action: #selector(favouriteBtnTapped), for: .touchUpInside)
            }
            
            return aCell
        }
        else  if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_NEW_SERVICE {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:Any]]
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellServiceListCollectionIdentifier, for: indexPath) as! ServiceListNewCollectionViewCell
            
            HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
            //            HELPER.setRoundCornerView(aView: aCell.gContainerViewCategory, borderRadius: 2.0)
            HELPER.setBorderView(aView:  aCell.gContainerViewUserImage, borderWidth: 2, borderColor: UIColor.white, cornerRadius: 5)
            
            //            HELPER.setRoundCornerView(aView: aCell.gContainerViewUserImage)
            //            HELPER.setRoundCornerView(aView: aCell.gImgViewUserImage)
            HELPER.setRoundCornerView(aView: aCell.gContainerViewCategory, borderRadius: 5)
            HELPER.setRoundCornerView(aView: aCell.gViewDistance, borderRadius: 5)
            aCell.gViewDistance.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            //            aCell.gViewColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            //            aCell.gContainerViewUserImage.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            
            aCell.gImgViewUserImage.setShowActivityIndicator(true)
            aCell.gImgViewUserImage.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            let IMAGE = aAryInfo[indexPath.row]["user_image"] as! String
            aCell.gImgViewUserImage.sd_setImage(with: URL(string: WEB_BASE_URL + IMAGE), placeholderImage: UIImage(named: ICON_PLACEHOLDER_SQUARE))
            if SESSION.getUserLatLong().0 != "" && SESSION.getUserLatLong().1 != "" && aAryInfo[indexPath.row]["service_latitude"] as! String != "" && aAryInfo[indexPath.row]["service_longitude"] as! String != "" {
            let firsLocation = CLLocation(latitude:Double(SESSION.getUserLatLong().0)!, longitude:Double(SESSION.getUserLatLong().1)!)
            let doubleServiceLat = Double(aAryInfo[indexPath.row]["service_latitude"] as? String ?? "0.0")!
            let doubleServiceLong = Double(aAryInfo[indexPath.row]["service_longitude"]as? String ?? "0.0")!
            let secondLocation = CLLocation(latitude: doubleServiceLat, longitude: doubleServiceLong)
            let distance = firsLocation.distance(from: secondLocation) / 1000
            aCell.gLblDistance.text = " \(String(format:"%.02f", distance)) KM"
            aCell.gLblDistance.textColor = UIColor.black
            } else {
                aCell.gViewDistance.isHidden = true
            }
            aCell.gImgViewServiceList.setShowActivityIndicator(true)
            aCell.gImgViewServiceList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            let SERVICE_IMG = aAryInfo[indexPath.row]["service_image"] as! String
            aCell.gImgViewServiceList.sd_setImage(with: URL(string: WEB_BASE_URL + SERVICE_IMG), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
            
            aCell.gLblServiceName.text = aAryInfo[indexPath.row]["service_title"] as! String
            aCell.gLblCategoryName.text = aAryInfo[indexPath.row]["category_name"] as! String
            let STR_RATING = aAryInfo[indexPath.row]["rating_count"] as! String
            aCell.gLblRateCount.text = "(" + STR_RATING + ")"
            
            let aStrRatingValue:String = aAryInfo[indexPath.row]["ratings"] as! String
            let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
            let aStrCurrency = (aAryInfo[indexPath.row]["currency"]) as! String
            let aStrAmount = (aAryInfo[indexPath.row]["service_amount"])!
            
            aCell.gLblPrice.text = aStrCurrency + "\(aStrAmount)"
            aCell.gLblPrice.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gViewRatingBar.isUserInteractionEnabled = false
            aCell.gViewRatingBar.isAbsValue = false
            
            aCell.gViewRatingBar.maxValue = 5
            aCell.gViewRatingBar.value = aCGFloatRatingValue
            aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            //            if indexPath.row % 2 == 0 {
            //
            //                aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            //            }
            //            else {
            //
            //                aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            //            }
            
            //            HELPER.setRoundCornerView(aView: aCell.gViewColor, borderRadius: 2.5)
            if SESSION.getUserToken().count == 0 {
                aCell.gBtnFav.isHidden = true
            }
            else {
                aCell.gBtnFav.isHidden = false
                //                if (aAryInfo[indexPath.row]["service_favorite"] as? NSString)?.doubleValue == 1 {
                if  aAryInfo[indexPath.row]["service_favorite"] as? String == "1" {
                    aCell.gBtnFav.isSelected = true
                }
                else {
                    aCell.gBtnFav.isSelected = false
                }
                aCell.gBtnFav.removeTarget(nil, action: nil, for: .touchUpInside)
                aCell.gBtnFav.tag = indexPath.row
                aCell.gBtnFav.addTarget(self, action: #selector(newServicefavouriteBtnTapped), for: .touchUpInside)
            }
            
            return aCell
        } else {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:Any]]
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellServiceListCollectionIdentifier, for: indexPath) as! ServiceListNewCollectionViewCell
            
            HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
            //            HELPER.setRoundCornerView(aView: aCell.gContainerViewCategory, borderRadius: 2.0)
            HELPER.setBorderView(aView:  aCell.gContainerViewUserImage, borderWidth: 2, borderColor: UIColor.white, cornerRadius: 5)
            
            //            HELPER.setRoundCornerView(aView: aCell.gContainerViewUserImage)
            //            HELPER.setRoundCornerView(aView: aCell.gImgViewUserImage)
            HELPER.setRoundCornerView(aView: aCell.gContainerViewCategory, borderRadius: 5)
            HELPER.setRoundCornerView(aView: aCell.gViewDistance, borderRadius: 5)
            aCell.gViewDistance.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            //            aCell.gViewColor.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            //            aCell.gContainerViewUserImage.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            
            aCell.gImgViewUserImage.setShowActivityIndicator(true)
            aCell.gImgViewUserImage.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            let IMAGE = aAryInfo[indexPath.row]["user_image"] as! String
            aCell.gImgViewUserImage.sd_setImage(with: URL(string: WEB_BASE_URL + IMAGE), placeholderImage: UIImage(named: ICON_PLACEHOLDER_SQUARE))
            if SESSION.getUserLatLong().0 != "" && SESSION.getUserLatLong().1 != "" && aAryInfo[indexPath.row]["service_latitude"] as! String != "" && aAryInfo[indexPath.row]["service_longitude"] as! String != "" {
            let firsLocation = CLLocation(latitude:Double(SESSION.getUserLatLong().0)!, longitude:Double(SESSION.getUserLatLong().1)!)
            let doubleServiceLat = Double(aAryInfo[indexPath.row]["service_latitude"] as? String ?? "0.0")!
            let doubleServiceLong = Double(aAryInfo[indexPath.row]["service_longitude"]as? String ?? "0.0")!
            let secondLocation = CLLocation(latitude: doubleServiceLat, longitude: doubleServiceLong)
            let distance = firsLocation.distance(from: secondLocation) / 1000
            aCell.gLblDistance.text = " \(String(format:"%.02f", distance)) KM"
            aCell.gLblDistance.textColor = UIColor.black
            } else {
                aCell.gViewDistance.isHidden = true
            }
            aCell.gImgViewServiceList.setShowActivityIndicator(true)
            aCell.gImgViewServiceList.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            let SERVICE_IMG = aAryInfo[indexPath.row]["service_image"] as! String
            aCell.gImgViewServiceList.sd_setImage(with: URL(string: WEB_BASE_URL + SERVICE_IMG), placeholderImage: UIImage(named: MENU_SERVICE_PLACEHOLDER))
            
            aCell.gLblServiceName.text = aAryInfo[indexPath.row]["service_title"] as! String
            aCell.gLblCategoryName.text = aAryInfo[indexPath.row]["category_name"] as! String
            let STR_RATING = aAryInfo[indexPath.row]["rating_count"] as! String
            aCell.gLblRateCount.text = "(" + STR_RATING + ")"
            
            let aStrRatingValue:String = aAryInfo[indexPath.row]["ratings"] as! String
            let aCGFloatRatingValue = CGFloat((aStrRatingValue as NSString).floatValue)
            let aStrCurrency = (aAryInfo[indexPath.row]["currency"]) as! String
            let aStrAmount = (aAryInfo[indexPath.row]["service_amount"])!
            
            aCell.gLblPrice.text = aStrCurrency + "\(aStrAmount)"
            aCell.gLblPrice.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gViewRatingBar.isUserInteractionEnabled = false
            aCell.gViewRatingBar.isAbsValue = false
            
            aCell.gViewRatingBar.maxValue = 5
            aCell.gViewRatingBar.value = aCGFloatRatingValue
            aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            //            if indexPath.row % 2 == 0 {
            //
            //                aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            //            }
            //            else {
            //
            //                aCell.gContainerViewCategory.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            //            }
            
            //            HELPER.setRoundCornerView(aView: aCell.gViewColor, borderRadius: 2.5)
            if SESSION.getUserToken().count == 0 {
                aCell.gBtnFav.isHidden = true
            }
            else {
                aCell.gBtnFav.isHidden = false
                //                if (aAryInfo[indexPath.row]["service_favorite"] as? NSString)?.doubleValue == 1 {
                if  aAryInfo[indexPath.row]["service_favorite"] as? String == "1" {
                    aCell.gBtnFav.isSelected = true
                }
                else {
                    aCell.gBtnFav.isSelected = false
                }
                aCell.gBtnFav.removeTarget(nil, action: nil, for: .touchUpInside)
                aCell.gBtnFav.tag = indexPath.row
                aCell.gBtnFav.addTarget(self, action: #selector(featuredServicefavouriteBtnTapped), for: .touchUpInside)
            }
            
            return aCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_CATEGORY {
            
            return CGSize(width: 100, height: 130)
        }
        else {
            
            return CGSize(width: 250, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_CATEGORY {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:String]]
            
            if indexPath.row == aAryInfo.count {
                
                let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_CATEGORY_VC) as! NewCategoryViewController
                self.navigationController?.pushViewController(aViewController, animated: true)
            }
            else {
                
                let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_SUB_CATEGORY_VC) as! NewSubCategoryViewController
                aViewController.gStrCatId = aAryInfo[indexPath.row]["id"]!
                aViewController.gStrCatName = aAryInfo[indexPath.row]["category_name"]!
                self.navigationController?.pushViewController(aViewController, animated: true)
            }
        }
        else if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_POPULAR_SERVICE {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:Any]]
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_DETAIL_VC) as! HomeNewDetailViewController
            aViewController.gStrServiceId = aAryInfo[indexPath.row]["service_id"] as! String
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
        
        else if myAryInfo[collectionView.tag][K_TITLE] as? String == K_TITLE_NEW_SERVICE {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:Any]]
            
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_DETAIL_VC) as! HomeNewDetailViewController
            aViewController.gStrServiceId = aAryInfo[indexPath.row]["service_id"] as! String
            self.navigationController?.pushViewController(aViewController, animated: true)
        } else {
            
            let aAryInfo = myAryInfo[collectionView.tag][K_ARRAYINFO] as! [[String:Any]]
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_DETAIL_VC) as! HomeNewDetailViewController
            aViewController.gStrServiceId = aAryInfo[indexPath.row]["service_id"] as! String
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
    }
    
    // MARK: - Textfield Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.tag == TAG_SEARCH {
            
            myStrSearchTitle = txtAfterUpdate
        }
        
        return true;
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        
        textfield.resignFirstResponder()
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
                let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SEARCH_LIST_VC) as! NewSearchViewController
                aViewController.gStrSearchTitle = myStrSearchTitle
                self.navigationController?.pushViewController(aViewController, animated: true)
                
            }
        } else {
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK: - Button Action
    @objc func featuredServicefavouriteBtnTapped(sender: UIButton) {
        
        var aAryInfo = myAryInfo[3][K_ARRAYINFO] as! [[String:Any]]
        
        let aBtnTag = sender.tag
        //        let aStrFav = (aAryInfo[aBtnTag]["service_favorite"] as? NSString)?.doubleValue
        let aStrFav = aAryInfo[aBtnTag]["service_favorite"] as? String
        if aStrFav == "1" {
            aAryInfo[aBtnTag]["service_favorite"]  = "0"
        }
        else {
            aAryInfo[aBtnTag]["service_favorite"] = "1"
        }
        let aStrServiceId = aAryInfo[aBtnTag]["service_id"]  as! String
        
        let aStrServiceFav = aAryInfo[aBtnTag]["service_favorite"] as! String
        addRemoveFavouritesApi(serviceID: aStrServiceId, isFav: String(aStrServiceFav) )
        
    }
    @objc func newServicefavouriteBtnTapped(sender: UIButton) {
        
        var aAryInfo = myAryInfo[2][K_ARRAYINFO] as! [[String:Any]]
        
        let aBtnTag = sender.tag
        //        let aStrFav = (aAryInfo[aBtnTag]["service_favorite"] as? NSString)?.doubleValue
        let aStrFav = aAryInfo[aBtnTag]["service_favorite"] as? String
        if aStrFav == "1" {
            aAryInfo[aBtnTag]["service_favorite"]  = "0"
        }
        else {
            aAryInfo[aBtnTag]["service_favorite"] = "1"
        }
        let aStrServiceId = aAryInfo[aBtnTag]["service_id"]  as! String
        
        let aStrServiceFav = aAryInfo[aBtnTag]["service_favorite"] as! String
        addRemoveFavouritesApi(serviceID: aStrServiceId, isFav: String(aStrServiceFav) )
        
    }
    @objc func favouriteBtnTapped(sender: UIButton) {
        
        var aAryInfo = myAryInfo[1][K_ARRAYINFO] as! [[String:Any]]
        
        let aBtnTag = sender.tag
        let aStrFav = aAryInfo[aBtnTag]["service_favorite"] as? String
        //        let aStrFav = (aAryInfo[aBtnTag]["service_favorite"] as? NSString)?.doubleValue
        if aStrFav == "1" {
            aAryInfo[aBtnTag]["service_favorite"]  = "0"
        }
        else {
            aAryInfo[aBtnTag]["service_favorite"] = "1"
        }
        let aStrServiceId = aAryInfo[aBtnTag]["service_id"]  as! String
        let aStrServiceFav = aAryInfo[aBtnTag]["service_favorite"] as! String
        addRemoveFavouritesApi(serviceID: aStrServiceId, isFav: String(aStrServiceFav) )
        
    }
    @IBAction func btnLogInTapped(_ sender: Any) {
        
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_PROVIDER_LOGIN_VC) as! ProviderLogInViewController
        
        let width = ModalSize.full
        let height = ModalSize.full// ModalSize.half
        
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
    
    @objc func btnLocationEnableTapped(_ sender: Any) {
        
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
    
    @objc func viewAllBtnTapped(sender: UIButton) {
        
        if sender.tag == 1 {
            
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_VIEW_ALL_VC) as! HomeNewViewAllViewController
            aViewController.isFromPopularService = true
            aViewController.isFromNewService = false
            aViewController.isFromTopRatedService = false
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
       else if sender.tag == 2 {
            
            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_VIEW_ALL_VC) as! HomeNewViewAllViewController
            aViewController.isFromPopularService = false
            aViewController.isFromNewService = true
           aViewController.isFromTopRatedService = false
            self.navigationController?.pushViewController(aViewController, animated: true)
       } else {
           let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_VIEW_ALL_VC) as! HomeNewViewAllViewController
           aViewController.isFromPopularService = false
           aViewController.isFromNewService = false
           aViewController.isFromTopRatedService = true
           self.navigationController?.pushViewController(aViewController, animated: true)
       }
    }
    
    // MARK: - Api call
    func addRemoveFavouritesApi(serviceID:String, isFav : String) {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        var aDictParams = [String:String]()
        aDictParams = ["service_id":serviceID, "status": isFav]
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_ADD_REMOVE_FAVOURITES,dictParameters:aDictParams, sucessBlock: { response in
            
            
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    self.getHomeApi()
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
    func getHomeApi() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams = ["latitude":SESSION.getUserLatLong().0, "longitude":SESSION.getUserLatLong().1]
      
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_HOME ,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    
                    self.myAryInfo.removeAll()
                    if aDictResponseData.count != 0 {
                        
                        //Add category
                        
                        var aAryCategoryInfo = [[String:String]]()
                        var aDictCategoryInfo = [String:Any]()
                        
                        aAryCategoryInfo = aDictResponseData["category_list"] as! [[String:String]]
                        
                        aDictCategoryInfo[self.K_TITLE] = self.K_TITLE_CATEGORY
                        aDictCategoryInfo[self.K_ARRAYINFO] = aAryCategoryInfo
                        
                        self.myAryInfo.append(aDictCategoryInfo)
                        
                        //Popular Services
                        
                        var aAryPopularInfo = [[String:Any]]()
                        var aDictPopularInfo = [String:Any]()
                        
                        aAryPopularInfo = aDictResponseData["popular_services"] as! [[String:Any]]
                        
                        aDictPopularInfo[self.K_TITLE] = self.K_TITLE_POPULAR_SERVICE
                        aDictPopularInfo[self.K_ARRAYINFO] = aAryPopularInfo
                        
                        self.myAryInfo.append(aDictPopularInfo)
                        
                        //Newly Added Services
                        
                        var aAryNewlyAddedInfo = [[String:Any]]()
                        var aDictNewlyAddedInfo = [String:Any]()
                        
                        aAryNewlyAddedInfo = aDictResponseData["new_services"] as! [[String:Any]]
                        
                        aDictNewlyAddedInfo[self.K_TITLE] = self.K_TITLE_NEW_SERVICE
                        aDictNewlyAddedInfo[self.K_ARRAYINFO] = aAryNewlyAddedInfo
                        
                        self.myAryInfo.append(aDictNewlyAddedInfo)
                        
                        var aAryTopRatedServices = [[String:Any]]()
                        var aDictTopRatedServices = [String:Any]()
                        
                        aAryTopRatedServices = aDictResponseData["top_rating_services"] as! [[String:Any]]
                        
                        aDictTopRatedServices[self.K_TITLE] = self.K_TITLE_TOP_RATED_SERVICE
                        aDictTopRatedServices[self.K_ARRAYINFO] = aAryTopRatedServices
                        
                        self.myAryInfo.append(aDictTopRatedServices)
                    }
                    
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
    
}

//Extension to convert html to attributed string
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
