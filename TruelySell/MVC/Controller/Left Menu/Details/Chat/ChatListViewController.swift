
import UIKit

class ChatListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myLblNoDataContent: UILabel!
    @IBOutlet var myTblview: UITableView!
    
    @IBOutlet weak var myLblChatTitle: UILabel!
    let cellIdentifierList = "ChatListTableViewCell"
    let cellLazyLoadingIdentifier = "LazyLoadingTableViewCell"
 
    var myAryInfo = [[String:Any]]()
    
    var isLazyLoading:Bool!
    
    var myIntTotalPage = Int()
    var myStrPagewNumber = "1"
    var myIntPagewNumber:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NAVIGAION.hideNavigationBar(aViewController: self)
        getMessagesFromApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        myLblNoDataContent.isHidden = true
        myTblview.isHidden = true
        myTblview.delegate = self
        myTblview.dataSource = self
        myLblChatTitle.text = TabBarScreen.TAB_CHAT.titlecontent()
        myTblview.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)
        myTblview.register(UINib.init(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellReuseIdentifier: cellLazyLoadingIdentifier)

        myTblview.tableFooterView = UIView()
    }
    
    func setUpModel() {
        
        isLazyLoading = false
    }
    
    func loadModel() {
        
//        getMessagesFromApi()
    }
    
    // MARK: - TableView delegate adn datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return myAryInfo.count != 0 ? 1 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return myAryInfo.count //+ (isLazyLoading ? 1 : 0)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

//        if indexPath.row >= myAryInfo.count {
//
//            return 50
//        }
//        else {

            return  80
//        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        if indexPath.row >= myAryInfo.count {
//
//            let aCell = tableView.dequeueReusableCell(withIdentifier: cellLazyLoadingIdentifier, for: indexPath) as! LazyLoadingTableViewCell
//
//            aCell.gActivityIndicator.startAnimating()
//
//            return aCell
//        }
//
//        else {
 
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierList, for: indexPath) as! ChatListTableViewCell

            aCell.gLblTitle.text = HELPER.returnStringFromNull(self.myAryInfo[indexPath.row]["name"] as AnyObject) as? String ?? ""  //self.myAryInfo[indexPath.row]["name"] as? String ?? ""
            aCell.gLblDescription.text = HELPER.returnStringFromNull(self.myAryInfo[indexPath.row]["message"] as AnyObject) as? String ?? "" //self.myAryInfo[indexPath.row]["message"] as? String ?? ""
            
            aCell.gViewCount.isHidden = true
            
        
            // create dateFormatter with UTC time format
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
////            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//            let utcDate = HELPER.returnStringFromNull(self.myAryInfo[indexPath.row]["datetime"] as AnyObject) as! String
//            let date = dateFormatter.date(from: utcDate)
            
//        aCell.gLblDateAndTIme.text = HELPER.timeAgoSinceDate(date: date! as NSDate, numericDates: false)
      
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"
        let showDate = inputFormatter.date(from: self.myAryInfo[indexPath.row]["date"] as? String ?? "")
        inputFormatter.dateFormat = WEB_DATE_FORMAT
        let resultString = inputFormatter.string(from: showDate!)
        aCell.gLblDateAndTIme.text = resultString
        
//        aCell.gLblDateAndTIme.text = HELPER.returnStringFromNull(self.myAryInfo[indexPath.row]["date"] as AnyObject) as! String//HELPER.timeAgoSinceDate(date: date! as NSDate, numericDates: false)

            HELPER.setRoundCornerView(aView: aCell.gImgView)

            aCell.gImgView.setShowActivityIndicator(true)
        aCell.gImgView.setIndicatorStyle(UIActivityIndicatorView.Style.gray)

            let profile_img:String = HELPER.returnStringFromNull(self.myAryInfo[indexPath.row]["profile_img"] as AnyObject) as? String ?? "" //myAryInfo[indexPath.row]["profile_img"] as? String ?? ""
            aCell.gImgView.sd_setImage(with: URL(string: WEB_BASE_URL + profile_img), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER) )

            return aCell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let aViewController:ChatDetailViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHAT_DETAIL) as! ChatDetailViewController
        aViewController.gStrToUserId = HELPER.returnStringFromNull(self.myAryInfo[indexPath.row]["token"] as AnyObject) as? String ?? "" //myAryInfo[indexPath.row]["token"]  as? String ?? ""
        aViewController.gStrUserName = HELPER.returnStringFromNull(self.myAryInfo[indexPath.row]["name"] as AnyObject) as? String ?? "" //myAryInfo[indexPath.row]["name"] as? String ?? ""
        aViewController.gStrUserProfImg = HELPER.returnStringFromNull(self.myAryInfo[indexPath.row]["profile_img"] as AnyObject) as? String ?? "" //myAryInfo[indexPath.row]["profile_img"] as? String ?? ""
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
        
//        getMessagesFromApi()
    }
    
    
    // MARK: - Api call
    
    func getMessagesFromApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictInfo = [String:String]()
        
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_CHAT_HISTORY,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    let aAryResponse = response["data"] as? [[String : Any]]
                    if aAryResponse != nil {
                    if aAryResponse!.count != 0 {
                        
                        self.myLblNoDataContent.isHidden = true
                        self.myTblview.isHidden = false
                        self.myAryInfo = response["data"] as! [[String : Any]]
                        self.myTblview.reloadData()
                    }
                    else {
                        
                        self.myLblNoDataContent.isHidden = false
                        self.myTblview.isHidden = true
                        self.myLblNoDataContent.text = ChatContent.NO_CHAT_AVAILABLE.titlecontent()
                    }
                    }
                    else {
                        
                        self.myLblNoDataContent.isHidden = false
                        self.myTblview.isHidden = true
                        self.myLblNoDataContent.text = ChatContent.NO_CHAT_AVAILABLE.titlecontent()
                    }
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
}
