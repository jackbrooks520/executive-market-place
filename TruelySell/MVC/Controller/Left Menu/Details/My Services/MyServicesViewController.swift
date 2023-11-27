 
import UIKit

class MyServicesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTblView: UITableView!
    
    var isLazyLoading:Bool!
    var isLoadMoreStart:Bool!
    
    let cellIdentifierList = "ProvidersTableViewCell"
    let cellLazyLoadingIdentifier = "LazyLoadingTableViewCell"
    
    var myStrPagewNumber = "1"
    var myAryInfo = [[String:String]]()
    var myStrScreenTitle = String()
    var aDictLanguageCommon = [String:Any]()
    var aDictLanguageReqAndPro = [String:Any]()

    var aStrViews = String()
    var myStrSearchPageNumber = "1"
    var searchTxt = ""
    var searchType = "0"
    // Adv search
    var isAdvSearch = false
    var appDate = ""
    var appTime = ""
    var location = ""
    var priceFrom = ""
    var priceTo = ""
    var myServiceId = ""
    var CatId = ""
    var SubCatId = ""


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
        
        changeLanguageContent()
        if searchTxt.count > 0 {
            NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: myStrScreenTitle, aViewController: self)
            setUpLeftBarBackButton()
        }
        else {
        NAVIGAION.setNavigationTitleWithBarbuttonImage(navigationTitle: myStrScreenTitle, leftButtonImageName: ICON_MENU, rightButtonImageName: "", aViewController: self)
        }
        myTblView.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)
        myTblView.register(UINib.init(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellReuseIdentifier: cellLazyLoadingIdentifier)
    }
    
    func setUpModel() {
        
        isLazyLoading = true
    }
    
    func loadModel() {
        
        if searchTxt.count > 0 {
            getSearchResultsApi()
        }
        else {
           self .getMessagesFromApi()

        }
    }
    // MARK;- Functions
    
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
            
            return  150
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
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierList, for: indexPath) as! ProvidersTableViewCell
            aCell.gLblProfileUser.isHidden = true
            aCell.gLblUserName.text = myAryInfo[indexPath.row]["title"]
            aCell.gLblPhoneNumberValue.text = myAryInfo[indexPath.row]["contact_number"]
            let myFloat = (myAryInfo[indexPath.row]["rating"]! as NSString).floatValue
            
            aCell.gViewRatingBar.isUserInteractionEnabled = false
            aCell.gViewRatingBar.isAbsValue = false
            
            aCell.gLblViews.text = myAryInfo[indexPath.row]["views"]! + aStrViews
            
            aCell.gViewRatingBar.maxValue = 5
            aCell.gViewRatingBar.value = CGFloat(myFloat)
            aCell.gBtnChat.isHidden = true
            HELPER.setRoundCornerView(aView: aCell.gBtnChat, borderRadius: 5)
            
            HELPER.setCardView(cardView: aCell.gmyProfileImg)
            HELPER.setRoundCornerView(aView: aCell.gmyProfileImg)
            aCell.gmyProfileImg.setShowActivityIndicator(true)
            aCell.gmyProfileImg.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gmyProfileImg.sd_setImage(with: URL(string: (WEB_BASE_URL + SESSION.getUserImage())), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
            
            if searchTxt.count > 0 {
                
                let myStrImage:String =  myAryInfo[indexPath.row]["profile_img"] ?? ""
                aCell.gmyProfileImg.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrImage)), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
                HELPER.setRoundCornerView(aView: aCell.gmyProfileImg)
                
                aCell.gLblProfileUser.isHidden = false
                aCell.gLblProfileUser.text = myAryInfo[indexPath.row]["username"]
            }
            let aStrJson = myAryInfo[indexPath.row]["description_details"]!
            
            let data = (aStrJson as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
            
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
            
            return aCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_PROVIDER_DET_VC) as! ProviderDetailsViewController
//        aViewController.gDictInfo = myAryInfo[indexPath.row]
//        aViewController.isClickFromMyService = true
//        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row >= myAryInfo.count {
            
        }
            
        else {
            
            return true
        }
        
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: aDictLanguageReqAndPro["lg6_delete"] as? String) { (action, indexPath) in
            
            self.myServiceId = String(format: "%@", self.myAryInfo[indexPath.row]["p_id"] as! CVarArg)//
            self.myAryInfo.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.myTblView.reloadData()
            
            self.setRemoveMyServiceList()
        }
        
        let edit = UITableViewRowAction(style: .normal, title: aDictLanguageReqAndPro["lg6_edit"] as? String) { (action, indexPath) in
            
            let aViewController:ProvideAddViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_ADD_PROVIDE) as! ProvideAddViewController
//            aViewController.gAryEditInfo = [self.myAryInfo[indexPath.row]]
            aViewController.gClickEditProvide = true
            let naviController = UINavigationController(rootViewController: aViewController)
            self.present(naviController, animated: true, completion: nil)
        }
        
        edit.backgroundColor = UIColor.gray
        delete.backgroundColor = UIColor.red
        
        return [delete, edit]
    }
    
    // MARK: - Scroll view delegate and data source
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetMaxY: Float = Float(scrollView.contentOffset.y + scrollView.bounds.size.height)
        let contentHeight: Float = Float(scrollView.contentSize.height)
        
        let ret = contentOffsetMaxY > contentHeight
        if ret {
            print("testButton is show");
            
            if isLazyLoading {
                isLazyLoading = false
                loadMore()
            }
            
        }else{
            print("testButton is hidden");
        }
    }
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
    }
    
    func loadMore() {
        
        if searchTxt.count > 0 {
            getSearchResultsApi()
        }
        else {
        getMessagesFromApi()
        }
    }
    
    func getMessagesFromApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictInfo = [String:String]()
        dictInfo = ["page":myStrPagewNumber]
        
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_SERVICE_LIST,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponse = [String:Any]()
                    aDictResponse = response["data"] as! [String : Any]
                    
                    let aIntNextPage = aDictResponse["next_page"] as! Int
                    self.myStrPagewNumber = String(aIntNextPage)
                    
                    self.isLazyLoading = aIntNextPage == -1 ? false : true
                    
                    if self.myAryInfo.count == 0 {
                        
                        self.myAryInfo = aDictResponse["provider_list"] as! [[String : String]]
                        self.myTblView.reloadData()
                    }
                    else {
                        
                        for dictInfo in aDictResponse["provider_list"] as! [[String : String]] {
                            self.myAryInfo.append(dictInfo)
                        }
                    }
                    
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
    
    
    func getSearchResultsApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
      
        var dictInfo = [String:String]()
        if isAdvSearch {
            dictInfo = ["page":String(myStrSearchPageNumber),
                        "latitude":SESSION.getUserLatLong().0,
                        "longitude":SESSION.getUserLatLong().1,
                        "search_title":"",
                        "request_date":appDate,
                        "request_time":appTime,
                        "min_price":priceFrom,
                        "max_price":priceTo,
                        "location":location,
                        "searchType":searchType,
                        "category":CatId,
                        "subcategory":SubCatId]
        }
        else {
        dictInfo = ["page":String(myStrSearchPageNumber),
                    "latitude":SESSION.getUserLatLong().0,
                    "longitude":SESSION.getUserLatLong().1,
                    "search_title":searchTxt,
                    "request_date":"",
                    "request_time":"",
                    "min_price":"",
                    "max_price":"",
                    "location":"",
                    "searchType":searchType,
                    "":"",
                    "":""
        ]
        }
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_SERVICE_SEARCH_LIST,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponse = [String:Any]()
                    aDictResponse = response["data"] as! [String : Any]
                    
                    let aIntNextPage = aDictResponse["next_page"] as! Int
                    self.myStrSearchPageNumber = String(aIntNextPage)
                    
                    self.isLazyLoading = aIntNextPage == -1 ? false : true
                    
                    if self.myAryInfo.count == 0 {
                        
                        self.myAryInfo = aDictResponse["provider_list"] as! [[String : String]]
                        self.myTblView.reloadData()
                    }
                    else {
                        
                        for dictInfo in aDictResponse["provider_list"] as! [[String : String]] {
                            self.myAryInfo.append(dictInfo)
                        }
                    }
                    
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
    
    func setRemoveMyServiceList() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictInfo = [String:String]()
        dictInfo = ["service_id":myServiceId]
        
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_SERVICE_REMOVE_LIST,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            if response.count != 0 {
            
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                }
                else {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
        }, failureBlock: { error in
            
           HELPER.hideLoadingAnimation()
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
                
                HELPER.showNetworkWithRetryAlert(viewController: self,alertMessage:ALERT_NO_INTERNET_DESC, retryBlock: {
                    
                    HELPER.removeNetworlAlertIn(viewController: self)
                    self.getMessagesFromApi()
                })
            }
        }
        else if alertType == ALERT_TYPE_NO_DATA {
            
            if myAryInfo.count == 0 {
                
                HELPER.showNoDataWithRetryAlert(viewController: self,alertMessage:ALERT_NO_RECORDS_FOUND, retryBlock: {
                    
                    HELPER.removeNetworlAlertIn(viewController: self)
                    self.getMessagesFromApi()
                })
            }
        }
            
        else if alertType == ALERT_TYPE_SERVER_ERROR {
            
            if myAryInfo.count != 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
            }
                
            else {
                
                HELPER.showNetworkWithRetryAlert(viewController: self,alertMessage:ALERT_TYPE_SERVER_ERROR, retryBlock: {
                    
                    HELPER.removeNetworlAlertIn(viewController: self)
                    self.getMessagesFromApi()
                })
            }
        }
    }
    func changeLanguageContent() {
        
        var aDictLangInfo = SESSION.getLangInfo()
        var aDictScreenTitle = [String:Any]()
        aDictScreenTitle = aDictLangInfo["navigation"] as! [String : Any]
        myStrScreenTitle = aDictScreenTitle["lg3_my_services"] as! String
        aDictLanguageCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
        aDictLanguageReqAndPro = aDictLangInfo["request_and_provider_list"] as! [String : Any]
        aStrViews = aDictLanguageCommon["lg7_views"] as! String
    }
}
