

import UIKit

class ProviderHistoryDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myViewLocation: UIView!
    @IBOutlet weak var myBtnLocation: UIButton!
    @IBOutlet weak var myViewBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myBtnStatus: UIButton!
    
    let cellIdentifierList = "ProviderHistoryDetailTableViewCell"
    
    var gStrScreenTitle = String()
    
    var myLatitude = Double()
    var myLongitude = Double()
    var myProviderName = String()
    var myProviderStatus = String()
    
    var gDictInfo = [String:String]()
    var aDictCommon = [String:Any]()
    
    var isFromMybooking = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    

    func setUpUI()  {
        
        changeLanguageContent()
        setUpLeftBarBackButton()
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: gStrScreenTitle, aViewController: self)
        myTblView.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)
        myTblView.tableFooterView = UIView()
        myTblView.delegate = self
        myTblView.dataSource = self
        myBtnStatus.setTitleColor(.white, for: .normal)
        myBtnStatus.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        myViewLocation.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        HELPER.setRoundCornerView(aView: myViewLocation, borderRadius: 5.0)
        if isFromMybooking == true {
            
            myProviderStatus = gDictInfo["is_rate"]!
            let aStrServiceStatus = gDictInfo["service_status"]!
            
            if myProviderStatus == "0" && aStrServiceStatus == "2" {
                myViewBtnHeightConstraint.constant = 50
                myBtnStatus.setTitle(aDictCommon["lg7_rate_now"] as? String, for: .normal)     // My booking rate now options
            }
                
            else {
                
                myViewBtnHeightConstraint.constant = 0
            }
        }
        else {
            
            myProviderStatus = gDictInfo["service_status"]!
            
            if myProviderStatus == "1" {
                
                myViewBtnHeightConstraint.constant = 50
                myBtnStatus.setTitle(aDictCommon["lg7_complete"] as? String, for: .normal)     // History completed options
            }
            else {
                
                myViewBtnHeightConstraint.constant = 0
            }
        }
    }
    
    func setUpModel() {
        
    }

    func loadModel() {
        
    }
    
    // MARK: - TableView delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierList, for: indexPath) as! ProviderHistoryDetailTableViewCell
        
        aCell.gLblName.textColor = .darkGray
        aCell.gLblName.text = gDictInfo["full_name"]
        aCell.gLblDesc.text = gDictInfo["notes"]
        
//        aCell.gLblViews.text = gDictInfo["views"]! + " Views"
        
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewMessage, imageName: "icon_message")
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewCall, imageName: "icon_phonr")
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewLocation, imageName: "icon_location ")
        
        if SESSION.getUserSubscriptionStatus() {
            aCell.gLblMail.text = gDictInfo["email"]
            aCell.gLblPhone.text = gDictInfo["contact_number"]
            aCell.iconPhoneWidth.constant = 10
        }
        else {
            aCell.gLblMail.isHidden = true
            aCell.gLblPhone.isHidden = true
            aCell.iconPhoneWidth.constant = 0
        }
        aCell.gLblLocation.text = gDictInfo["location"]
        aCell.gLblTitleInfo.text = gDictInfo["title"]!
        aCell.gLblDate.text = gDictInfo["service_date"]!
        aCell.gLblTime.text = gDictInfo["service_time"]!
        aCell.gImgViewUser.setShowActivityIndicator(true)
        aCell.gImgViewUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
        let myStrImage =  gDictInfo["profile_img"] ?? ""
        aCell.gImgViewUser.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrImage)), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
        HELPER.setRoundCornerView(aView: aCell.gImgViewUser)
        
        aCell.gBtnShowDirections.isHidden = true
//        aCell.gBtnShowDirections.setTitleColor(HELPER.hexStringToUIColor(hex: SESSION.getAppColor()), for: .normal)
//
//        aCell.gBtnShowDirections.tag = indexPath.row
//        aCell.gBtnShowDirections.addTarget(self, action: #selector(locationBtnDidTapped(_:)), for: .touchUpInside)

        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Api Call
    
    func callCompleteApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        var dictInfo = [String:String]()
        dictInfo = ["book_service_id":gDictInfo["id"],"provider_id":gDictInfo["provider_id"]] as! [String : String]
        
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_PROVIDER_COMPLETE,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    
                    self.myBtnStatus.isHidden = true
                }
                    
                else {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
                
                self.myTblView.reloadData()
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
   // MARK: - Button Action
    @IBAction func btnStatusTapped(_ sender: Any) {
        
        if isFromMybooking == true {
            
            myProviderStatus = gDictInfo["is_rate"]!
            
            if myProviderStatus == "0" {
                
                // My booking rate now options
                
                myViewBtnHeightConstraint.constant = 50
                let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_RATE_NOW_VC) as! RateNowViewController
                aViewController.gStrProviderID = gDictInfo["provider_id"]!
                self.navigationController?.pushViewController(aViewController, animated: true)
            }
                
            else {
                
                myViewBtnHeightConstraint.constant = 0
            }
        }
        else {
            
            // History completed options
            
            myProviderStatus = gDictInfo["service_status"]!
            
            if myProviderStatus == "1" {
                
                myViewBtnHeightConstraint.constant = 50
                callCompleteApi()
            }
            else {
                
                myViewBtnHeightConstraint.constant = 0
            }
        }
    }
    
    @IBAction func btnLocationTapped(_ sender: Any) {
        
        myLatitude = 0.0
        myLongitude = 0.0
        myProviderName = ""
        
        if let aLat = gDictInfo["latitude"], aLat != "" {
            myLatitude = Double(aLat)!
        }
        
        if let aLong = gDictInfo["longitude"], aLong != "" {
            myLongitude = Double(aLong)!
        }
        myProviderName = gDictInfo["full_name"]!
        
        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_GOOGLE_MAP_DIRECTION_VC) as! GoogleMapsDirectionViewController
        aViewController.gDestinationLatitude = myLatitude
        aViewController.gDestinationLongitude = myLongitude
        aViewController.gProviderName = myProviderName
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    @objc func locationBtnDidTapped(_ sender: UIButton) {
        
        myLatitude = 0.0
        myLongitude = 0.0
        myProviderName = ""
        
        if let aLat = gDictInfo["latitude"], aLat != "" {
            myLatitude = Double(aLat)!
        }
        
        if let aLong = gDictInfo["longitude"], aLong != "" {
            myLongitude = Double(aLong)!
        }
        myProviderName = gDictInfo["full_name"]!
        
        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_GOOGLE_MAP_DIRECTION_VC) as! GoogleMapsDirectionViewController
        aViewController.gDestinationLatitude = myLatitude
        aViewController.gDestinationLongitude = myLongitude
        aViewController.gProviderName = myProviderName
        self.navigationController?.pushViewController(aViewController, animated: true)
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
    
    func changeLanguageContent() {
        
        var aDictLangInfo = SESSION.getLangInfo()
        
        aDictCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
    }
    
}
