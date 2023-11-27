 
import UIKit
import AARatingBar

class RateNowViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate {
 
    let cellIdentifierListFirst = "RateNowFirstTableViewCell"
    let cellIdentifierListSecond = "RateNowSecondTableViewCell"
    let cellIdentifierListThird = "RateNowThirdTableViewCell"
    let cellCollectionIdentifier = "RateOptionsCollectionViewCell"
    
    @IBOutlet weak var myTblView: UITableView!
    
    var myAryInfo = [[String:String]]()
    
    var aDictCommon = [String:Any]()
    
    var myStrRateID = String()
    var myStrStarRate = String()
    var myStrComments = String()
    var gStrProviderID = String()
    var gStrBookingID = String()
    
    let TAG_COMMENTS : Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        setUpLeftBarBackButton()
//        changeLanguageContent()
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: CommonTitle.RATE_NOW.titlecontent(), aViewController: self)
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellIdentifierListFirst, bundle: nil), forCellReuseIdentifier: cellIdentifierListFirst)
        myTblView.register(UINib.init(nibName: cellIdentifierListSecond, bundle: nil), forCellReuseIdentifier: cellIdentifierListSecond)
        myTblView.register(UINib.init(nibName: cellIdentifierListThird, bundle: nil), forCellReuseIdentifier: cellIdentifierListThird)
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        getRateOptionsApi()
    }
    
    // MARK: - Tableview Delegate and Datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 180
        }
        else if indexPath.section == 1 {
            
            return 180
        }
        else {
            
            return 300
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierListFirst, for: indexPath) as! RateNowFirstTableViewCell
            //RTL
            aCell.gLblRateContentFirst.text = BookingDetailService.SERVICE_EXPERIENCE.titlecontent()
            return aCell
        }
        else if indexPath.section == 1 {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierListSecond, for: indexPath) as! RateNowSecondTableViewCell
            
            aCell.gCollectionView.delegate = self
            aCell.gCollectionView.dataSource = self
            
            aCell.gCollectionView.register(UINib(nibName: cellCollectionIdentifier, bundle: nil), forCellWithReuseIdentifier: cellCollectionIdentifier)
            
            aCell.gCollectionView.reloadData()
            
            return aCell
        }
        else {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierListThird, for: indexPath) as! RateNowThirdTableViewCell
            
            HELPER.setBorderView(aView: aCell.gViewTextView, borderWidth: 1.0, borderColor: .darkGray, cornerRadius: 10.0)
            HELPER.setRoundCornerView(aView: aCell.gViewBtnSubmit, borderRadius: 10.0)
            
            aCell.gViewRatingBar.isUserInteractionEnabled = true
            aCell.gLblLeaveCommentsContent.text = Booking_service.LEAVE_COMMENTS.titlecontent()//aDictCommon["lg7_leave_your_comm"] as! String
            aCell.gViewRatingBar.ratingDidChange = { rateValue in
                
                self.myStrStarRate = String(describing:rateValue)
            }
            
            aCell.gTxtViewComments.delegate = self
            aCell.gTxtViewComments.tag = TAG_COMMENTS
            aCell.gBtnSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            aCell.gBtnSubmit.addTarget(self, action: #selector(btnSubmitTapped), for: .touchUpInside)
            return aCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - CollectionView Delegate and Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myAryInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCollectionIdentifier, for: indexPath) as! RateOptionsCollectionViewCell
        
        var isRateStatus = String()
        isRateStatus = myAryInfo[indexPath.row]["status"]!
        
        if isRateStatus == "1" {
            
            aCell.gLblRateOptionContent.textColor = .darkGray
        }
        else {
            
            aCell.gLblRateOptionContent.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        }
        
        HELPER.setBorderView(aView: aCell.gContainerView, borderWidth: 1.0, borderColor: .darkGray, cornerRadius: 10.0)
        aCell.gLblRateOptionContent.text = myAryInfo[indexPath.row]["name"]
        return aCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        myStrRateID = myAryInfo[indexPath.row]["id"]!
        
        for i in 0..<myAryInfo.count {
            
            if indexPath.row == i {
                
                myAryInfo[indexPath.row]["status"] = "0"
            }
            else {
                
                myAryInfo[i]["status"] = "1"
            }
        }
        
        myTblView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ((collectionView.frame.size.width) / 2 ) - 10.0 , height: 50.0)
    }
    
    //MARK: - TextView Delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.tag == TAG_COMMENTS {
            
            if textView.textColor == UIColor.lightGray {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.tag == TAG_COMMENTS {
            
            if textView.text == "" {
                
                textView.text = Booking_service.LEAVE_COMMENTS.titlecontent()
                textView.textColor = UIColor.lightGray
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let textViewText: NSString = (textView.text ?? "") as NSString
        let txtAfterUpdate = textViewText.replacingCharacters(in: range, with: text)
        
        if textView.tag == TAG_COMMENTS {
            
            myStrComments = txtAfterUpdate
        }
        
        return true
    }
    
    // MARK: - Button Action
    @objc func btnSubmitTapped()  {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        if myStrRateID.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: Booking_service.SELECT_REVIEW_TYPE.titlecontent())
            return
        }
        else if myStrStarRate.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: BookingDetailService.RATE_SERVICE.titlecontent())
            return
        }
        else if myStrComments.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: Booking_service.ENTER_COMMENTS.titlecontent())
            return
        }
        else {
            
            callRateApi()
        }
    }
    
    // MARK: - Api Call
    //Rate Options
    func getRateOptionsApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_RATE_LIST, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponse = [String:Any]()
                    aDictResponse = response["data"] as! [String : Any]
                    
                    self.myAryInfo = aDictResponse["review_type"] as! [[String : String]]
                    self.myTblView.reloadData()
                }
                    
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                    
                    //                self.updateArrayInfo()
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
    
    func callRateApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        let paramDict = ["rating":myStrStarRate,"review":myStrComments,"service_id":gStrBookingID,"type":myStrRateID,"booking_id":gStrProviderID]
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_RATE_SUBMIT, dictParameters: paramDict , sucessBlock: { (response) in
            print(response)
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                print(response)
                HELPER.hideLoadingAnimation()
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aDictResponse[kRESPONSE_MESSAGE]!, okActionBlock: { (action) in
                        
                        APPDELEGATE.loadTabbar()
                        //                    self.navigationController?.popViewController(animated: true)
                    })
                    
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_VALIDATION) {
                    
                    
                    HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictResponse[kRESPONSE_MESSAGE]!)
                    
                }
            }
            
        }) { (error) in
            print(error)
        }
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
                
                
                //                HELPER.showNetworkWithRetryAlert(viewController: self,alertMessage:ALERT_NO_INTERNET_DESC, retryBlock: {
                //
                //                    HELPER.removeNetworlAlertIn(viewController: self)
                //                    self.mySegmentControl.selectedIndex == 0 ?  self.getRequestApi(): self.getProvideApi()
                //                })
            }
        }
            
        else if alertType == ALERT_TYPE_NO_DATA {
            
            if myAryInfo.count == 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_RECORDS_FOUND)
                
                //                HELPER.showNoDataWithRetryAlert(viewController: self,alertMessage:ALERT_NO_RECORDS_FOUND, retryBlock: {
                //
                //                    HELPER.removeNetworlAlertIn(viewController: self)
                //                    self.mySegmentControl.selectedIndex == 0 ?  self.getRequestApi(): self.getProvideApi()
                //                })
            }
        }
            
        else if alertType == ALERT_TYPE_SERVER_ERROR {
            
            if myAryInfo.count != 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
            }
                
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
                
                //                HELPER.showNetworkWithRetryAlert(viewController: self,alertMessage:ALERT_UNABLE_TO_REACH_DESC, retryBlock: {
                //
                //                    HELPER.removeNetworlAlertIn(viewController: self)
                //                    self.mySegmentControl.selectedIndex == 0 ?  self.getRequestApi(): self.getProvideApi()
                //                })
            }
        }
    }
    
    // MARK: - Private Function=
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
