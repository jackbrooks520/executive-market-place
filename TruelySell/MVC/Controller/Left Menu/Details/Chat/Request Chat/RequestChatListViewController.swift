
import UIKit

class RequestChatListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var myTblview: UITableView!
    
    let cellIdentifierList = "ChatListTableViewCell"
    let cellLazyLoadingIdentifier = "LazyLoadingTableViewCell"
    
    var myAryInfo = [[String:Any]]()
    var aDictScreenTitle = [String:Any]()

    var isLazyLoading:Bool!
    
    var myIntTotalPage = Int()
    var myStrPagewNumber = "1"
    var myIntPagewNumber:Int = 1
    
    var aDictLanguageCommon = [String:Any]()
    var myStrScreenTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        getMessagesFromApi()
    }
    
    func setUpUI() {
        
        changeLanguageContent()
        NAVIGAION.setNavigationTitleWithBarbuttonImage(navigationTitle: myStrScreenTitle, leftButtonImageName: ICON_MENU, rightButtonImageName: "", aViewController: self)
        
        myTblview.delegate = self
        myTblview.dataSource = self
        
        myTblview.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)
        myTblview.register(UINib.init(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellReuseIdentifier: cellLazyLoadingIdentifier)
        
        myTblview.tableFooterView = UIView()
    }
    
    func setUpModel() {
        
        isLazyLoading = false
    }
    
    func loadModel() {
        
        getMessagesFromApi()
    }
    
    // MARK: - TableView delegate adn datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return myAryInfo.count != 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryInfo.count + (isLazyLoading ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row >= myAryInfo.count {
            
            return 50
        }
            
        else {
            
            return  80
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
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierList, for: indexPath) as! ChatListTableViewCell
            
            aCell.gLblTitle.text = (HELPER.returnStringFromNull(self.myAryInfo[indexPath.row]["username"] as AnyObject) as? String) ?? ""  //self.myAryInfo[indexPath.row]["username"] as? String ?? ""
            aCell.gLblDescription.text = (HELPER.returnStringFromNull(self.myAryInfo[indexPath.row]["content"] as AnyObject) as? String) ?? ""  //self.myAryInfo[indexPath.row]["content"] as? String ?? ""
    
            aCell.gViewCount.isHidden = true
            
            var aStrCount = String()
            aStrCount = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["chat_count"] as AnyObject) as! String //myAryInfo[indexPath.row]["chat_count"] as! String
            
            if aStrCount != "0" {
                
                aCell.gViewCount.isHidden = false
                HELPER.setRoundCornerView(aView: aCell.gViewCount)
                aCell.gLblCount.text = aStrCount
            }
            else {
                
                aCell.gViewCount.isHidden = true
            }
            
            // create dateFormatter with UTC time format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let utcDate = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["chat_utc_time"] as AnyObject) as! String //  //self.myAryInfo[indexPath.row]["chat_utc_time"]! as! String
            let date = dateFormatter.date(from: utcDate) // create date from string
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "h:mm a"
            dateFormatter.timeZone = TimeZone.current
            //            let timeStamp = dateFormatter.string(from: date!)
            //            aCell.gLblDateAndTIme.text = (HELPER.timeAgoSinceDate(date: HELPER.convertStringFormatToDate(inputString: timeStamp) as NSDate, numericDates: false))
            
            aCell.gLblDateAndTIme.text = HELPER.timeAgoSinceDate(date: date! as NSDate, numericDates: false)
            
            HELPER.setRoundCornerView(aView: aCell.gImgView)
            
            aCell.gImgView.setShowActivityIndicator(true)
            aCell.gImgView.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            
            let profile_img:String = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["profile_img"] as AnyObject) as? String ?? ""  //myAryInfo[indexPath.row]["profile_img"] as? String ?? ""
            aCell.gImgView.sd_setImage(with: URL(string: WEB_BASE_URL + profile_img), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER) )
            
            return aCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let aViewController:ChatDetailViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHAT_DETAIL) as! ChatDetailViewController
        aViewController.gStrToUserId = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["chat_from"] as AnyObject) as? String ?? ""  //myAryInfo[indexPath.row]["chat_from"]  as? String ?? ""
        aViewController.gStrUserName = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["username"] as AnyObject) as? String ?? ""  //myAryInfo[indexPath.row]["username"] as? String ?? ""
        aViewController.gStrUserProfImg = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["profile_img"] as AnyObject) as? String ?? ""  //myAryInfo[indexPath.row]["profile_img"] as? String ?? ""
        self.navigationController?.pushViewController(aViewController, animated: true)
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
    
    func loadMore() {
        
        getMessagesFromApi()
    }
    
    
    // MARK: - Api call
    
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
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_CHAT_HISTORY_REQUEST,dictParameters:dictInfo, sucessBlock: { response in
            
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
                        
                        self.myAryInfo = aDictResponse["chat_list"] as! [[String : Any]]
                        self.myTblview.reloadData()
                        
                        if self.myAryInfo.count == 0 {
                            
                            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ChatContent.NO_CHAT_AVAILABLE.titlecontent())
                        }
                    }
                    else {
                        
                        for dictInfo in aDictResponse["chat_list"] as! [[String : Any]] {
                            self.myAryInfo.append(dictInfo)
                        }
                    }
                    
                    //                self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_DATA)
                }
                    
                else {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
                
                self.myTblview.reloadData()
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            //            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_SERVER_ERROR)
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
        aDictScreenTitle = aDictLangInfo["navigation"] as! [String : Any]
        aDictLanguageCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
        myStrScreenTitle = aDictScreenTitle["lg3_chat_history"] as! String
    }
}
