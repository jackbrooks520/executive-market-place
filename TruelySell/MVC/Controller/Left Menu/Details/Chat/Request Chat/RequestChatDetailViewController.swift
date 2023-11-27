
import UIKit
import Alamofire
import Photos
import MobileCoreServices

var isChatRequestDetailVisible = true

class RequestChatDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var inputToolbar: UIView!
    @IBOutlet var textView: GrowingTextView!
    @IBOutlet var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var myViewSendBtnContainer: UIView!
    
    var isLazyLoading:Bool!
    
    var myIntTotalPage = Int()
    var myStrPagewNumber = "1"
    var myIntPagewNumber:Int = 1
    
    var myAryInfo = [[String:Any]]()
    
    var gStrToUserId = String()
    var gStrUserName = String()
    var gStrUserProfImg = String()
    
    let cellSenderIdentifier = "ChatSenderCollectionViewCell"
    let cellReciverIdentifier = "ChatReciverCollectionViewCell"
    let cellLazyLoadingIdentifier = "LazyLoadingCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isChatRequestDetailVisible = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: gStrUserName, aViewController: self)
        setUpLeftBarBackButton()
        //  setUprightBarEditButton()
        SESSION.setCurrentChatUserName(aStrUserName: gStrUserName)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        myCollectionView.register(UINib(nibName: cellSenderIdentifier, bundle: nil), forCellWithReuseIdentifier: cellSenderIdentifier)
        myCollectionView.register(UINib(nibName: cellReciverIdentifier, bundle: nil), forCellWithReuseIdentifier: cellReciverIdentifier)
        myCollectionView.register(UINib(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellWithReuseIdentifier: cellLazyLoadingIdentifier)
        
        //        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: btnSend as! UIImageView!, imageName: "icon_send")
        
        isChatRequestDetailVisible = true
        
        textView.layer.cornerRadius = 4.0
//        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
//            textView.textAlignment = .right
//            btnSend.setImage(UIImage(named: "icon_send")?.withHorizontallyFlippedOrientation(), for: .normal)
//        }
//        else {
//             textView.textAlignment = .left
//             btnSend.setImage(UIImage(named: "icon_send"), for: .normal)
//        }
//        HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: btnSend, imageName: "icon_send")
        HELPER.setRoundCornerView(aView: myViewSendBtnContainer)
       
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                   textView.textAlignment = .right
                   let origImage = UIImage(named: "icon_send_arrow")
                       let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                       btnSend.setImage(tintedImage?.withHorizontallyFlippedOrientation(), for: .normal)
//                   btnSend.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                  
               }
               else {
                   let origImage = UIImage(named: "icon_send_arrow")
                                 let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                                 btnSend.setImage(tintedImage, for: .normal)
//                             btnSend.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                                        textView.textAlignment = .left
               }
              

        textView.placeholder = ChatContent.ENTER_MESSAGE.titlecontent()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.minHeight = 40
        textView.maxHeight = 100
        // textView.delegate = self as! UITextViewDelegate
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
        
        // *** Listen to keyboard show / hide ***
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
        
        
        // *** Customize GrowingTextView ***
        textView.layer.cornerRadius = 4.0
        
        NotificationCenter.default.addObserver(forName: GETCHATDETAILS, object: nil, queue: nil) { (info) in
            
            
            self.myAryInfo.append((info.userInfo as! [String : Any]))
            self.myCollectionView.reloadData()
            
            let lastItemIndex = IndexPath(item: self.myAryInfo.count - 1, section: 1)
            self.myCollectionView?.scrollToItem(at: lastItemIndex, at: .top, animated: true)
            
        }
        
    }
    
    func setUpModel() {
        
        self.myStrPagewNumber = "1"
        isLazyLoading = false
        btnSend.isEnabled = true
    }
    
    func loadModel() {
        
        getMessagesDetailApi()
    }
    
    // MARK: - Collection View Delegate and Datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
        }
            
        else {
            
            return myAryInfo.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellLazyLoadingIdentifier, for: indexPath) as! LazyLoadingCollectionViewCell
            
            aCell.gActivityIndicator.color = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            
            if isLazyLoading {
                
                aCell.gActivityIndicator.isHidden = false
                aCell.gActivityIndicator.color = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                aCell.gActivityIndicator.startAnimating()
            }
                
            else {
                
                aCell.gActivityIndicator.stopAnimating()
                aCell.gActivityIndicator.isHidden = true
            }
            
            return aCell
        }
            
        else {
            
            var chatfrom:String = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["chat_from"] as AnyObject) as! String //myAryInfo[indexPath.row]["chat_from"] as! String
            if chatfrom == SESSION.getUserId() {
                
                let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReciverIdentifier, for: indexPath) as! ChatReciverCollectionViewCell
                
                aCell.gLblMessage.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["content"] as AnyObject) as? String //myAryInfo[indexPath.row]["content"] as? String
                HELPER.setRoundCornerView(aView: aCell.gViewBubble, borderRadius: 5.0)
                
                // create dateFormatter with UTC time format
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                let utcDate = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["chat_utc_time"] as AnyObject) as! String //self.myAryInfo[indexPath.row]["chat_utc_time"]! as! String
                let date = dateFormatter.date(from: utcDate) // create date from string
                
                // change to a readable time format and change to local time zone
                dateFormatter.dateFormat = WEB_TIME_CHAT_FORMAT
                dateFormatter.timeZone = TimeZone.current
                let timeStamp = dateFormatter.string(from: date!)
                
                aCell.gLblDate.text = timeStamp
                
                return aCell
            }
                
            else {
                
                let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellSenderIdentifier, for: indexPath) as! ChatSenderCollectionViewCell
                
                
                aCell.gLblMessage.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["content"] as AnyObject) as? String ?? "" //myAryInfo[indexPath.row]["content"] as? String ?? ""
                HELPER.setRoundCornerView(aView: aCell.gViewBubble, borderRadius: 5.0)
                aCell.gViewBubble.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                aCell.gLblDate.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["time"] as AnyObject) as? String  //myAryInfo[indexPath.row]["time"] as? String
                aCell.gLblMessage.textColor = UIColor.white
                aCell.gLblDate.textColor = UIColor.white
                if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                                           aCell.gLblDate.textAlignment = .left
                                      }
                                        else {
                                            aCell.gLblDate.textAlignment = .right
                                      }
                
                return aCell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            return CGSize(width: collectionView.frame.size.width, height: 50)
        }
            
        else {
            
            let strContent = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["content"] as AnyObject) as? String ?? "" //myAryInfo[indexPath.row]["content"] as? String ?? ""
            
            return CGSize(width: collectionView.frame.size.width, height: calculateContentHeight(strMessageContent: strContent))
        }
    }
    
    func calculateContentHeight(strMessageContent:String) -> CGFloat {
        
        let maxLabelSize:CGSize = CGSize(width: 300, height: 9999)
        
        //var maxLabelSize: CGSize = CGSize(self.view.frame.size.width - 100, CGFloat(9999))
        
        let contentNSString = strMessageContent
        
        let expectedLabelSize = contentNSString.boundingRect(with: maxLabelSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14)], context: nil)
        
        print("\(expectedLabelSize)")
        return expectedLabelSize.size.height + 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y == 0 {
            
            print("At the top")
            
            if isLazyLoading {
                isLazyLoading = false
                loadMore()
            }
        }
    }
    
    func loadMore() {
        
        getMessagesDetailApi()
    }
    
    func UTCToLocal(date:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: dt!)
    }
    
    // MARK: - Api call
    
    func getMessagesDetailApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictInfo = [String:String]()
        dictInfo = ["page":myStrPagewNumber,"chat_id":gStrToUserId]
        
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_CHAT_DETAIL_REQUEST ,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponse = [String:Any]()
                    aDictResponse = response["data"] as! [String : Any]
                    
                    let aIntNextPage = aDictResponse["next_page"] as! Int
                    self.myStrPagewNumber = String(aIntNextPage)
                    
                    self.isLazyLoading = aIntNextPage == -1 ? false : true
                    
                    self.isLazyLoading = false
                    
                    var myAryInfoUpdate = [[String:Any]]()
                    
                    myAryInfoUpdate = aDictResponse["chat_list"] as! [[String : Any]]
                    
                    if self.myAryInfo.count == 0 {
                        
                        self.myAryInfo = aDictResponse["chat_list"] as! [[String : Any]]
                        
                        self.myCollectionView.reloadData()
                        
                        if self.myAryInfo.count > 0 {
                            let lastItemIndex = IndexPath(item: self.myAryInfo.count - 1, section: 1)
                            self.myCollectionView?.scrollToItem(at: lastItemIndex, at: .top, animated: true)
                        }
                    }
                        
                    else {
                        
                        var myAryInfoUpdate = [[String:Any]]()
                        
                        for dictInfo in aDictResponse["chat_list"] as! [[String : String]] {
                            
                            myAryInfoUpdate.append(dictInfo)
                            print(self.myAryInfo)
                        }
                        
                        for dictInfoUpdate in self.myAryInfo {
                            
                            myAryInfoUpdate.append(dictInfoUpdate)
                        }
                        
                        self.myAryInfo = myAryInfoUpdate
                    }
                    
                    //                print(response)
                    //
                    //                var asda = Array<[String:String]>()
                //
                //                asda = myAryInfoUpdate
                //
                //                self.myAryInfo = asda.filterDuplicate{ (($0 as AnyObject).date) } //as! [[String : String]]
                //                print(asda)
                //                print(self.myAryInfo)
                
                self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_DATA)
            }
                
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
            
            self.myCollectionView.reloadData()
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_SERVER_ERROR)
        })
    }
    
    
    //Send Message
    func sendMessageDetails(strMessage:String) {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictInfo = [String:String]()
        
        dictInfo = ["to":gStrToUserId,"content":strMessage]
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_CHAT_SEND_REQUEST ,dictParameters:dictInfo, sucessBlock: { response in
            
            print(response)
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                
                self.btnSend.isEnabled = true
                self.textView.text = ""
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseInfo = [String:Any]()
                    aDictResponseInfo = response["data"] as! [String : Any]
                    
                    self.myAryInfo.append(aDictResponseInfo)
                    self.myCollectionView.reloadData()
                    
                    let lastItemIndex = IndexPath(item: self.myAryInfo.count - 1, section: 1)
                    self.myCollectionView?.scrollToItem(at: lastItemIndex, at: .top, animated: true)
                }
                else {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
        }, failureBlock: { error in
            
            self.btnSend.isEnabled = true
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
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
    
    // MARK: - Button Action
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        
        btnSend.isEnabled = false
        sendMessageDetails(strMessage:textView.text)
    }
    
    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        
        if let endFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            var keyboardHeight = UIScreen.main.bounds.height - endFrame.origin.y
            
            if #available(iOS 11, *) {
                
                if keyboardHeight > 0 {
                    
                    keyboardHeight = keyboardHeight - view.safeAreaInsets.bottom
                    
                }
                
            }
            
            textViewBottomConstraint.constant = keyboardHeight + 8
            
            view.layoutIfNeeded()
            
        }
        
    }
    
    // MARK: - Left Bar Button Methods
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
    
    func setUprightBarEditButton() {
        
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imgView.image = #imageLiteral(resourceName: "icon_profile_placeholder")
        imgView.contentMode = .scaleAspectFit
        
        imgView.layer.cornerRadius = 15
        imgView.layer.masksToBounds = true
        
        //        let leftBtn = UIButton(type: .custom)
        //        leftBtn.setImage(#imageLiteral(resourceName: "icon_profile_placeholder"), for: .normal)
        //        leftBtn.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        //
        //        //leftBtn.backgroundColor = UIColor.red
        //        leftBtn.layer.cornerRadius = 18
        //        leftBtn.layer.masksToBounds = true
        //
        //        leftBtn.contentMode = .center
        
        //  imgView.sd_setImage(with: URL(string: WEB_BASE_URL + gStrUserProfImg), for: .normal, placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
        
        let task = URLSession.shared.dataTask(with: URL(string: WEB_BASE_URL + gStrUserProfImg)!) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                
                //leftBtn.setImage(UIImage(data: data), for: .normal)
                imgView.image = UIImage(data: data)
                
                imgView.layer.cornerRadius = 15
                imgView.layer.masksToBounds = true
            }
        }
        
        task.resume()
        
        let leftBarBtnItem = UIBarButtonItem(customView: imgView)
        
        self.navigationItem.rightBarButtonItem = leftBarBtnItem
    }
    
}


extension RequestChatDetailViewController: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0 {
            
            btnSend.isEnabled = false
        }
            
        else {
            
            btnSend.isEnabled = true
        }
    }
    
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveLinear], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}



//extension Array
//{
//    func filterDuplicate<T>(_ keyValue:@escaping (Element)->T) -> [Element]
//    {
//        var uniqueKeys = Set<String>()
//        //        print({uniqueKeys.insert("\(keyValue($0))").inserted})
//        print(uniqueKeys)
//        return filter{uniqueKeys.insert("\(keyValue($0))").inserted}
//    }
//}
