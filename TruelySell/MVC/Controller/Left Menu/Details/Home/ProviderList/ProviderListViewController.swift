//
//  ProviderListViewController.swift
//
//  Created by user on 27/03/19.
//  Copyright © 2019 dreams. All rights reserved.
//

import UIKit
import CoreLocation

class ProviderListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SearchViewControllerDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var myTblView: UITableView!
    
    @IBOutlet weak var customSearchView: SearchView!
    @IBOutlet weak var searchView: UIView!
        
    @IBOutlet weak var myBtnAdd: UIButton!
    
    @IBOutlet var myViewAdd: UIView!
    @IBOutlet weak var myBtnForSearchContainer: UIButton!
    
    var myAryInfo = [[String:String]]()
    var myAryProviderInfo = [[String:String]]()

    var aDictLangDashBoard = [String:Any]()
    var aDictLanguageCommon = [String:Any]()
    
    var gStrCatID = String()
    var gStrSubCatID = String()
    var aStrViews = String()
    var gStrScreenTitle = String()

    let cellIdentifierProvider = "ProvidersTableViewCell"
    let cellLazyLoadingIdentifier = "LazyLoadingTableViewCell"
    
    var myStrProviderPageNumber = "1"
    
    var searchActive : Bool = false
    var isLazyLoading:Bool!
    var isLazyLoadingProviderSegment:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        setUpLeftBarBackButton()
        changeLanguageContent()
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: gStrScreenTitle, aViewController: self)
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellIdentifierProvider, bundle: nil), forCellReuseIdentifier: cellIdentifierProvider)
        myTblView.register(UINib.init(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellReuseIdentifier: cellLazyLoadingIdentifier)
        
        HELPER.setRoundCornerView(aView: myViewAdd)
        myViewAdd.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        myBtnForSearchContainer.isHidden = true
        customSearchView.isHidden = true
        searchView.isHidden = true
//        self.setUpRightBarButton()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_LOCATION_POPUP_VC) as! LocationPopViewController
                self.present(aViewController, animated: true, completion: nil)
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        } else {
        }
        myViewAdd.isHidden = true
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        getProvideApi()
    }
    
    // MARK: - Table view delegate and data source
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return myAryInfo.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryInfo.count + (isLazyLoading ? 1 : 0)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row >= myAryInfo.count {
            
            return 50
        }
            
        else {
            
            return  120
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= myAryInfo.count {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellLazyLoadingIdentifier, for: indexPath) as! LazyLoadingTableViewCell
            aCell.gActivityIndicator.color = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gActivityIndicator.startAnimating()
            
            return aCell
        }
            
        else {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierProvider, for: indexPath) as! ProvidersTableViewCell
            
            var aStrJson = ""
            if myAryInfo[indexPath.row]["description_details"] != nil {
                aStrJson = myAryInfo[indexPath.row]["description_details"]!
            }
            
            let myFloat = (myAryInfo[indexPath.row]["rating"]! as NSString).floatValue
            
            aCell.gViewRatingBar.isUserInteractionEnabled = false
            aCell.gViewRatingBar.isAbsValue = false
            
            aCell.gViewRatingBar.maxValue = 5
            aCell.gViewRatingBar.value = CGFloat(myFloat)
            
            aCell.gLblViews.text = myAryInfo[indexPath.row]["views"]! + aStrViews
            aCell.gmyProfileImg.setShowActivityIndicator(true)
            aCell.gmyProfileImg.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            let myStrImage =  myAryInfo[indexPath.row]["profile_img"] ?? ""
            aCell.gmyProfileImg.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrImage)), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
            
            HELPER.setRoundCornerView(aView: aCell.gmyProfileImg)
            let data = aStrJson.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            
            aCell.gLblBullet1.isHidden = true
            aCell.gLblBullet2.isHidden = true
            aCell.gLblBullet3.isHidden = true
            
            aCell.gImgViewBullet1.isHidden = true
            aCell.gImgViewBullet2.isHidden = true
            aCell.gImgViewBullet3.isHidden = true
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String]
                
                for index in 0..<json.count {
                    
                    if index == 0 {
                        
                        aCell.gLblBullet1.isHidden = false
                        aCell.gImgViewBullet1.isHidden = false
                        aCell.gLblBullet1.text = json[index]
                    }
                        
                    else if index == 1 {
                        
                        aCell.gLblBullet2.isHidden = false
                        aCell.gImgViewBullet2.isHidden = false
                        aCell.gLblBullet2.text = json[index]
                    }
                        
                    else if index == 2 {
                        
                        aCell.gLblBullet3.isHidden = false
                        aCell.gImgViewBullet3.isHidden = false
                        aCell.gLblBullet3.text = json[index]
                    }
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            //                aCell.gLblUserName.text = myAryInfo[indexPath.row]["username"]! + " - " + myAryInf≈o[indexPath.row]["title"]!
            
            aCell.gLblUserName.text = myAryInfo[indexPath.row]["title"]!
            aCell.gLblProfileUser.text =  myAryInfo[indexPath.row]["username"]!
            
            if SESSION.getUserSubscriptionStatus() {
                
                aCell.calendarBtnWidth.constant = 10
                aCell.gLblContactNumber.isHidden = false
                aCell.gLblPhoneNumberValue.isHidden = false
                aCell.gLblContactNumber.text = aDictLanguageCommon["lg7_contact_number"] as? String
                aCell.gLblPhoneNumberValue.text = myAryInfo[indexPath.row]["contact_number"]
            }
            else {
                aCell.calendarBtnWidth.constant = 0
                aCell.gLblContactNumber.isHidden = true
                aCell.gLblPhoneNumberValue.isHidden = true
            }
            aCell.gBtnChat.isHidden = false
            let providerId = String(format: "%@", self.myAryInfo[indexPath.row]["provider_id"] as! CVarArg)
            
            aCell.gBtnChat.tag = indexPath.row
            aCell.gBtnChat.setTitle(aDictLanguageCommon["lg7_chat"] as? String, for: .normal)
            aCell.gBtnChat.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            HELPER.setRoundCornerView(aView: aCell.gBtnChat, borderRadius: 5)
            aCell.gBtnChat.addTarget(self, action: #selector(didTapOnChat(_:)), for: .touchUpInside)
            
            if providerId == SESSION.getUserId() {
                aCell.gBtnChat.isHidden = true
            }
            aCell.selectionStyle = .none
            
            return aCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

//        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_PROVIDER_DET_VC) as! ProviderDetailsViewController
//        aViewController.gDictInfo = myAryInfo[indexPath.row]
//        aViewController.completion = {(name) in
//            
//            self.myAryProviderInfo.removeAll()
//            self.myStrProviderPageNumber = "1"
//            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: ALERT_LOADING_CONTENT)
//            self.getProvideApi()
//        }
//        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    // MARK:- Functions
    func setUpRightBarButton() {
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.setImage(UIImage(named: ICON_SEARCH_WHITE), for: .normal)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        rightBtn.addTarget(self, action: #selector(rightBtnTapped), for: .touchUpInside)
        
        let rightBarBtnItem = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
    }
    @objc func rightBtnTapped() {
        
        searchView.isHidden = false
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            HELPER.setBorderView(aView: self.customSearchView, borderWidth: 2, borderColor:HELPER.hexStringToUIColor(hex: SESSION.getAppColor()), cornerRadius: 4)
            
            self.customSearchView.isHidden = false
            self.myBtnForSearchContainer.isHidden = false
        })
        customSearchView.searchBar.text = ""
        customSearchView.advancedSearchBtn.setTitle(aDictLangDashBoard["lg6_advanced_search"] as? String, for: .normal)
        customSearchView.advancedSearchBtn.addTarget(self, action: #selector(advancesSearchTapped), for: .touchUpInside)
        //        customSearchView.backBtn.addTarget(self, action: #selector(backTapped), for: .SESSION.getAppColor())
        customSearchView.advancedSearchBtn.setTitleColor(HELPER.hexStringToUIColor(hex: SESSION.getAppColor()), for: .normal)
        customSearchView.delegate = self
        
    }
    
    // MARK:- Api call
    func getProvideApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.hideLoadingAnimation()
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictInfo = [String:String]()
        
        dictInfo = ["latitude":SESSION.getUserLatLong().0,"page":myStrProviderPageNumber, "longitude":SESSION.getUserLatLong().1,"category":gStrCatID,"subcategory":gStrSubCatID]
        
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SERVICE_LIST,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponse = [String:Any]()
                    aDictResponse = response["data"] as! [String : Any]
                    
                    let aIntNextPage = aDictResponse["next_page"] as! Int
                    self.myStrProviderPageNumber = String(aIntNextPage)
                    
                    self.isLazyLoadingProviderSegment = aIntNextPage == -1 ? false : true
                    
                    if self.myAryProviderInfo.count == 0 {
                        
                        self.myAryProviderInfo = aDictResponse["provider_list"] as! [[String : String]]
                    }
                    else {
                        
                        for dictInfo in aDictResponse["provider_list"] as! [[String : String]] {
                            self.myAryProviderInfo.append(dictInfo)
                        }
                    }
                    
                    self.updateArrayInfo()
                    self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_DATA)
                }
                    
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                    
                    self.updateArrayInfo()
                    self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_DATA)
                }
                    
                else {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
                
                self.myTblView.reloadData()
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_SERVER_ERROR)
        })
    }
    
    func handleNodataAndErrorMessage(alertType:String) {
        
        HELPER.hideLoadingAnimation()
        
        let alertType = alertType
        
        if alertType == ALERT_TYPE_NO_INTERNET {
            
            if myAryInfo.count != 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            }
                
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                        
            }
        }
            
        else if alertType == ALERT_TYPE_NO_DATA {
            
            if myAryInfo.count == 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_RECORDS_FOUND)
                
               
            }
        }
            
        else if alertType == ALERT_TYPE_SERVER_ERROR {
            
            if myAryInfo.count != 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
            }
                
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
                
              
            }
        }
    }
    
    func updateArrayInfo() {
        
            myAryInfo = myAryProviderInfo
            self.isLazyLoading = self.isLazyLoadingProviderSegment
    }
    
    @objc func didTapOnChat(_ sender: UIButton) {
        
        if SESSION.getUserSubscriptionStatus() {
            
            print(sender.tag)
            
            let aViewController:ChatDetailViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHAT_DETAIL) as! ChatDetailViewController
            aViewController.gStrToUserId = myAryInfo[sender.tag]["provider_id"]!
            aViewController.gStrUserName = myAryInfo[sender.tag]["username"]!
            aViewController.gStrUserProfImg = HELPER.returnStringFromNull(myAryInfo[sender.tag]["profile_img"] as AnyObject) as! String //myAryInfo[sender.tag]["profile_img"]!
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
        else {
            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SUBSCRIPTION_POPUP_VC) as! SubscriptionPopupViewController
            
            aViewController.modalPresentationStyle = .overFullScreen
            aViewController.modalTransitionStyle = .crossDissolve
            let naviController = UINavigationController(rootViewController: aViewController)
            self.present(naviController, animated: true, completion: nil)
        }
    }
    
    // MARK:- Button Actions
    
    @IBAction func searchBarContainerBtnTapped(_ sender: Any) {
        
        self.view .endEditing(true)
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.customSearchView.isHidden = true
            self.myBtnForSearchContainer.isHidden = true
            
        })
        searchView.isHidden = true
        
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        
            if SESSION.getUserSubscriptionStatus() {
                let aViewController:ProvideAddViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_ADD_PROVIDE) as! ProvideAddViewController
                aViewController.completion = {(name) in
                    
                    self.myAryProviderInfo.removeAll()
                    self.myStrProviderPageNumber = "1"
                    HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: ALERT_LOADING_CONTENT)
                    self.getProvideApi()
                }
                let naviController = UINavigationController(rootViewController: aViewController)
                self.present(naviController, animated: true, completion: nil)
            }
            else {
                let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SUBSCRIPTION_POPUP_VC) as! SubscriptionPopupViewController
                
                aViewController.modalPresentationStyle = .overFullScreen
                aViewController.modalTransitionStyle = .crossDissolve
                let naviController = UINavigationController(rootViewController: aViewController)
                self.present(naviController, animated: true, completion: nil)
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
    
    @objc func advancesSearchTapped()  {
        
//        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_ADVANCED_SEARCH_VC) as! AdvancedSearchViewController
//        aViewController.isFromProviderList = true
//        aViewController.selectedIndex = 1
//        let naviController = UINavigationController(rootViewController: aViewController)
//        self.present(naviController, animated: true, completion: nil)
    }
    
    
    // MARK:- Custom Search Delegate Methods
    func didTapOnSearch(searchText: String) {
        searchActive = true;

            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_MY_SERVICES) as! MyServicesViewController
            aViewController.searchTxt = searchText
            aViewController.searchType = "1"
            
            self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    // MARK:- Language
    func changeLanguageContent() {
        
        var aDictLangInfo = SESSION.getLangInfo()
        aDictLangDashBoard = aDictLangInfo["request_and_provider_list"] as! [String : Any]
        aDictLanguageCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
        
        aStrViews = aDictLanguageCommon["lg7_views"] as! String
    }
}
