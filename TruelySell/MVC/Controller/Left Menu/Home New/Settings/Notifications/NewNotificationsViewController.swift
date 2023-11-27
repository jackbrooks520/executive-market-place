 

import UIKit

class NewNotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var myLblNoDataContent: UILabel!
    @IBOutlet weak var myTblView: UITableView!
    
    let cellTableListIdentifier = "NewSettingsNotifocationTableViewCell"
    
    var myAryNotificationListInfo = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: SettingsLangContents.NOTIFICATION_LIST.titlecontent(), aViewController: self)
        setUpLeftBarBackButton()
        
        myTblView.isHidden = true
        myLblNoDataContent.isHidden = true
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellTableListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableListIdentifier)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        getNotificationListFromApi()
    }

    // MARK: - TableView delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryNotificationListInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableListIdentifier, for: indexPath) as! NewSettingsNotifocationTableViewCell
        
        aCell.gViewUserImg.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        HELPER.setRoundCornerView(aView: aCell.gViewUserImg)
        HELPER.setRoundCornerView(aView: aCell.gImgViewUserImg)
        
        if myAryNotificationListInfo.count != 0 {
         
            let aStrName:String = HELPER.returnStringFromNull(myAryNotificationListInfo[indexPath.row]["name"] as AnyObject) as! String  //myAryNotificationListInfo[indexPath.row]["name"]! as! String
            let aStrMessage:String = HELPER.returnStringFromNull(myAryNotificationListInfo[indexPath.row]["message"] as AnyObject) as! String  //myAryNotificationListInfo[indexPath.row]["message"]! as! String
            let aStrProfImg:String = HELPER.returnStringFromNull(myAryNotificationListInfo[indexPath.row]["profile_img"] as AnyObject) as! String  //myAryNotificationListInfo[indexPath.row]["profile_img"]! as! String
            
            aCell.gLblNotificationContent.text = aStrName + " " + aStrMessage
            aCell.gImgViewUserImg.setShowActivityIndicator(true)
            aCell.gImgViewUserImg.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gImgViewUserImg.sd_setImage(with: URL(string: WEB_BASE_URL + aStrProfImg), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
            
            // create dateFormatter with UTC time format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let utcDate = HELPER.returnStringFromNull(myAryNotificationListInfo[indexPath.row]["utc_date_time"] as AnyObject) as! String  //myAryNotificationListInfo[indexPath.row]["utc_date_time"]! as! String
            let date = dateFormatter.date(from: utcDate) // create date from string
            
            aCell.gLblTime.text = HELPER.timeAgoSinceDate(date: date! as NSDate, numericDates: false)

            
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK:- Api Call
    func getNotificationListFromApi() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_NEW_NOTIFICATION_LIST, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    self.myAryNotificationListInfo = aDictResponseData["notification_list"] as! [[String : Any]]
                    
                    if self.myAryNotificationListInfo.count != 0 {
                        
                        self.myTblView.isHidden = false
                        self.myLblNoDataContent.isHidden = true
                        self.myTblView.reloadData()
                        HELPER.hideLoadingAnimation()
                    }
                    else {
                        
                        self.myTblView.isHidden = true
                        self.myLblNoDataContent.isHidden = false
                        self.myLblNoDataContent.text = SettingsLangContents.NO_NOTIFICATION_FOUND.titlecontent()
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
}
