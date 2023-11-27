

import UIKit
import Alamofire
import Photos
import MobileCoreServices
import Starscream

var isChatDetailVisible = true
let GETLANGUAGECHANGE = NSNotification.Name("GetlanguageChange")
let GETCHATDETAILS = NSNotification.Name("GetChatDetails")

class ChatDetailViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WebSocketDelegate {
    
    
    @IBOutlet var myCollectionView: UICollectionView!
    @IBOutlet var btnSend: UIButton!
    @IBOutlet var inputToolbar: UIView!
    @IBOutlet var textView: GrowingTextView!
    @IBOutlet var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var myViewSendBtnContainer: UIView!
    
    var socket: WebSocket!
    
    var isLazyLoading:Bool!
    var isBackPressed:Bool = false
    var isLoadMoreStart:Bool!
    var myIntTotalPage = Int()
    var myStrPagewNumber = "1"
    var myIntPagewNumber:Int = 1
    
    var myAryInfo = [[String:String]]()
    
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
        websocketSetUP()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isChatDetailVisible = false
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
        
        
        //        socket = WebSocket(url: URL(string: WEB_CHAT_WEBSOCKET)!)
        //        socket.delegate = self
        //
        isChatDetailVisible = true
        
        textView.delegate = self
        textView.layer.cornerRadius = 4.0
        myViewSendBtnContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        HELPER.setRoundCornerView(aView: myViewSendBtnContainer)
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            textView.textAlignment = .right
            let origImage = UIImage(named: "icon_send_arrow")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            btnSend.setImage(tintedImage?.withHorizontallyFlippedOrientation(), for: .normal)
            //            btnSend.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            
        }
        else {
            let origImage = UIImage(named: "icon_send_arrow")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            btnSend.setImage(tintedImage, for: .normal)
            //                      btnSend.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
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
            
            
            self.myAryInfo.append((info.userInfo as! [String : String]))
            self.myCollectionView.reloadData()
            
            let lastItemIndex = IndexPath(item: self.myAryInfo.count - 1, section: 1)
            self.myCollectionView?.scrollToItem(at: lastItemIndex, at: .top, animated: true)
            
        }
        
    }
    
    func setUpModel() {
        
        self.myStrPagewNumber = "1"
        isLazyLoading = false
        btnSend.isEnabled = false
    }
    
    func loadModel() {
        
        getMessagesDetailApi()
    }
    
    func websocketSetUP() {
        
        let request = URLRequest(url: URL(string: WEB_SOCKET_URL)!)
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    // MARK: - Collection View Delegate and Datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myAryInfo.count
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let chatfrom:String = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["sender_token"] as AnyObject) as! String     //myAryInfo[indexPath.row]["sender_token"] as! String
        if chatfrom == SESSION.getUserToken() {
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReciverIdentifier, for: indexPath) as! ChatReciverCollectionViewCell
            
            aCell.gLblMessage.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["message"] as AnyObject) as? String     //myAryInfo[indexPath.row]["message"] as? String
            HELPER.setRoundCornerView(aView: aCell.gViewBubble, borderRadius: 5.0)
            
            // create dateFormatter with UTC time format
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let utcDate = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["utc_date_time"] as AnyObject) as! String
//            let date = dateFormatter.date(from: utcDate) // create date from string
//
//            // change to a readable time format and change to local time zone
//            dateFormatter.dateFormat = "h:mm a"
//            dateFormatter.timeZone = TimeZone.current
//            let timeStamp = dateFormatter.string(from: date!)
          //  aCell.gLblDate.text = timeStamp
            
            let dateAsString = utcDate
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let date1 = dateFormatter1.date(from: dateAsString)
            dateFormatter1.dateFormat = WEB_TIME_FORMAT
            let timeStamp = dateFormatter1.string(from: date1!)
            aCell.gLblDate.text = timeStamp
            return aCell
        }
        
        else {
            
            let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellSenderIdentifier, for: indexPath) as! ChatSenderCollectionViewCell
            
            aCell.gLblMessage.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["message"] as AnyObject) as? String ?? ""    //myAryInfo[indexPath.row]["message"] as? String ?? ""
            HELPER.setRoundCornerView(aView: aCell.gViewBubble, borderRadius: 5.0)
            aCell.gViewBubble.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            // create dateFormatter with UTC time format
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let utcDate = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["utc_date_time"] as AnyObject) as! String     //self.myAryInfo[indexPath.row]["created_at"]! as! String
//            if utcDate != "" {
//                let date = dateFormatter.date(from: utcDate) // create date from string
//
//                // change to a readable time format and change to local time zone
//                dateFormatter.dateFormat = "h:mm a"
//                dateFormatter.timeZone = TimeZone.current
//                let timeStamp = dateFormatter.string(from: date!)
//
//                aCell.gLblDate.text = timeStamp
//            }
            let dateAsString = utcDate
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let date1 = dateFormatter1.date(from: dateAsString)
            dateFormatter1.dateFormat = WEB_TIME_FORMAT
            let timeStamp = dateFormatter1.string(from: date1!)
            aCell.gLblDate.text = timeStamp
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                aCell.gLblDate.textAlignment = .left
            }
            else {
                aCell.gLblDate.textAlignment = .right
            }
            aCell.gLblMessage.textColor = UIColor.white
            aCell.gLblDate.textColor = UIColor.white
            
            return aCell
        }
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //        if indexPath.section == 0 {
        //
        //            return CGSize(width: collectionView.frame.size.width, height: 50)
        //        }
        //
        //        else {
        
        let strContent = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["content"] as AnyObject) as? String ?? ""     //myAryInfo[indexPath.row]["content"] as? String ?? ""
        
        return CGSize(width: collectionView.frame.size.width, height: calculateContentHeight(strMessageContent: strContent))
        //        }
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
    // MARK:- Websocket Delegate Methods.
    func websocketDidConnect(socket: WebSocketClient) {
        
        HELPER.hideLoadingAnimationWS()
        
        var aDictSendTextWebSocketa = [String:Any]()
        var aDictSendTextWebSocketb = [String:Any]()
        aDictSendTextWebSocketb["id"] = SESSION.getUserProviderID()
        aDictSendTextWebSocketb["name"] =   SESSION.getUserInfoNew().0
        if SESSION.getUserLogInType() == "1" {
        aDictSendTextWebSocketb["usertype"] =  "provider"
        }
        else{
            aDictSendTextWebSocketb["usertype"] =  "user" // "provider"
        }
        aDictSendTextWebSocketa["user"] = aDictSendTextWebSocketb
        aDictSendTextWebSocketa["type"] = "registration"
        let aJSONDict = json(from: aDictSendTextWebSocketa)
        if socket.isConnected == true {
            socket.write(string: aJSONDict!)
        }
        print("websocket is connected")
    }
    
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("\(e)")
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
            
            
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        let aStrJson = text
        
        print(text)
        
        let dict = convertToDictionary(text: aStrJson)
        
        let receiveType = (dict!["type"].map { $0 as? String } ?? "")
        
        if receiveType == "receive" {
            
            let aContent = (dict!["message"].map { $0 as? String } ?? "")
            let aToToken = (dict!["to_res"].map { $0 as? String } ?? "")
            let aFromToken = (dict!["from_user"].map { $0 as? String } ?? "")
            let aUTCTime = (dict!["chattime"].map { $0 as? String } ?? "")
            let chatID = (dict!["chat_id"].map { $0 as? String } ?? "")
            let aStrContent:String = HELPER.returnStringFromNull(aContent as AnyObject) as! String
            let aStrToToken:String = HELPER.returnStringFromNull(aToToken as AnyObject) as! String
            let aStrFromToken:String = HELPER.returnStringFromNull(aFromToken as AnyObject) as! String
            let aStrUTCTime:String = HELPER.returnStringFromNull(aUTCTime as AnyObject) as! String
            let aStrChatId:String = HELPER.returnStringFromNull(chatID as AnyObject) as! String
            
            
            if aStrContent.count != 0 && aStrToToken.count != 0 && aStrFromToken.count != 0 {
                
                if aStrContent != "null" && aStrToToken != "null" && aStrFromToken != "null" {
                    
                    //                    if (aStrFromToken == gStrToUserId && aStrToToken == SESSION.getUserToken()) || (aStrFromToken == SESSION.getUserToken() && aStrToToken == gStrToUserId) {
                    
                    if aStrToToken == gStrToUserId || aStrFromToken == gStrToUserId {
                        
                        var aDictReceiveMsg = [String:String]()
                        
                        aDictReceiveMsg["sender_token"] = aStrFromToken
                        aDictReceiveMsg["message"] = aStrContent
                        aDictReceiveMsg["chat_to"] = aStrToToken
                        aDictReceiveMsg["utc_date_time"] = aStrUTCTime
                        aDictReceiveMsg["chat_id"] = aStrChatId
                        
                        
                        self.myAryInfo.append(aDictReceiveMsg)
                        //                        self.myCollectionView.reloadData()
                        //                        let indexpath = IndexPath(item: self.myAryInfo.count - 1, section: 0)
                        //                        self.myCollectionView.scrollToItem(at: indexpath, at: .bottom, animated: true)
                        
                        self.myCollectionView.reloadData()
                        let section = self.numberOfSections(in: self.myCollectionView) - 1
                        let item = self.myCollectionView.numberOfItems(inSection: section) - 1
                        let lastIndexPath = IndexPath(item: item, section: section)
                        self.myCollectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
                        
                    }
                }
            }
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
    
    
    
    // MARK: - Api call
    
    func getMessagesDetailApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            //            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var aDictParams = [String:String]()
        aDictParams = ["to_token":gStrToUserId]
        
        let startDate = Date()
        //
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_CHAT_DETAIL ,dictParameters:aDictParams, sucessBlock: { (response) in
            
            let executionTime = Date().timeIntervalSince(startDate)
            print("execution time (s) in chatDetail for " + SESSION.getUserId() + " is: " + String(executionTime))
            
            //        HTTPMANAGER.getChatDetail(parameter: dictGetComments, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aResponse = response["response"] as? [String:Any]
            let aIntResponseCode = aResponse!["response_code"] as? String
            let aMessageResponse = aResponse!["response_message"] as? String
            let aDictResponseInfo = response["data"] as? [String:Any]
            //            guard
            //                var aResponse = response["response"] as? [String:Any]
            //            var aIntResponseCode = aResponse["response_code"] as? Int,
            //                var aMessageResponse = aResponse["response_message"] as? String,
            //                let aDictResponseInfo = response["data"] as? [String:Any]
            //            else {
            //                print("user logged in from another device")
            //
            //                print("returning from getMessageDetails from GSChatDetailsViewController")
            //               return
            //            }
            //            aMessageResponse = (response["message"] as? String)! //HELPER.mapToLanguage(string: (response["message"] as? String)!)
            
            //var aDictResponseInfo = [String:Any]()
            
            
            //print(aDictResponseInfo)
            
            if (Int(aIntResponseCode!) == RESPONSE_CODE_200) {
                
                //                    self.socket.connect()
                
                //                self.myIntTotalPage = aDictResponseInfo!["total_pages"] as! Int
                //
                //                if self.myIntTotalPage == 0 {
                //
                //                    self.isLazyLoading = false
                //                }
                
                //                else {
                
                //                    self.isLazyLoading = self.myIntTotalPage == self.myIntPagewNumber ? false : true
                
                //                    self.myIntPagewNumber = self.myIntPagewNumber + 1
                //                    self.myStrPagewNumber = String(describing: self.myIntPagewNumber)
                //self.myAryInfo.removeAll()
                //print(aDictResponseInfo["chat_details"])
                
                if self.myAryInfo.count == 0 {
                    
                    self.myAryInfo = aDictResponseInfo!["chat_history"] as! [[String : String]]
                    
                    self.myCollectionView.reloadData()
                    let section = self.numberOfSections(in: self.myCollectionView) - 1
                    let item = self.myCollectionView.numberOfItems(inSection: section) - 1
                    let lastIndexPath = IndexPath(item: item, section: section)
                    self.myCollectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
                }
                else {
                    var myAryInfoUpdate = [[String:String]]()
                    for dictInfo in aDictResponseInfo!["chat_history"] as! [[String : String]] {
                        
                        myAryInfoUpdate.append(dictInfo)
                        print(self.myAryInfo)
                    }
                    
                    for dictInfoUpdate in self.myAryInfo {
                        
                        myAryInfoUpdate.append(dictInfoUpdate)
                    }
                    
                    self.myAryInfo = myAryInfoUpdate
                    
                }
                //                }
                //                self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_DATA)
            }
            
            
            else {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
            
            self.isLoadMoreStart = false
            self.myCollectionView.reloadData()
            
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
        
        var messageSocket = [String : String]()
   
        if SESSION.getUserLogInType() == "1" {
            messageSocket =  ["from_user": SESSION.getUserToken(), "to_user": gStrToUserId, "message": strMessage, "type": "message" , "usertype" :   "provider"]
        }
        else{
            messageSocket =  ["from_user": SESSION.getUserToken(), "to_user": gStrToUserId, "message": strMessage, "type": "message" , "usertype" :   "user"]
        }
        let aJSONDict = json(from: messageSocket)
        if socket.isConnected == true {
            
            self.btnSend.isUserInteractionEnabled = true
            self.textView.text = ""
            btnSend.isEnabled = false
            socket.write(string: aJSONDict!)
        }
        
    }
    func handleNodataAndErrorMessage(alertType:String) {
        
        HELPER.hideLoadingAnimation(viewController: self)
        
        let alertType = alertType
        
        if alertType == ALERT_TYPE_NO_INTERNET {
            
            if myAryInfo.count != 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            }
            
            else {
                
                HELPER.showNetworkWithRetryAlert(viewController: self,alertMessage:ALERT_NO_INTERNET_DESC, retryBlock: {
                    
                    HELPER.removeNetworlAlertIn(viewController: self)
                    self.getMessagesDetailApi()
                })
            }
        }
        
        else if alertType == ALERT_TYPE_NO_DATA {
            
            if myAryInfo.count == 0 {
                
                HELPER.showNoDataWithRetryAlert(viewController: self,alertMessage:ALERT_NO_RECORDS_FOUND, retryBlock: {
                    
                    HELPER.removeNetworlAlertIn(viewController: self)
                    self.getMessagesDetailApi()
                })
            }
        }
        
        else if alertType == ALERT_TYPE_SERVER_ERROR {
            
            if myAryInfo.count != 0 {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_UNABLE_TO_REACH_DESC)
            }
            
            else {
                
                HELPER.showNetworkWithRetryAlert(viewController: self,alertMessage:ALERT_UNABLE_TO_REACH_DESC, retryBlock: {
                    
                    HELPER.removeNetworlAlertIn(viewController: self)
                    self.getMessagesDetailApi()
                })
            }
        }
    }
    
    
    // MARK: - Button Action
    
    @IBAction func sendBtnTapped(_ sender: Any) {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        btnSend.isEnabled = false
        
        sendMessageDetails(strMessage:textView.text)
    }
    
    
    func json(from object:[String:Any]) -> String? {
        
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
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
    
    // MARK: - Convert JSON format
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
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
        
        HELPER.hideLoadingAnimationWS()
        isBackPressed = true
        //        socket.disconnect()
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUprightBarEditButton() {
        
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imgView.image = #imageLiteral(resourceName: "icon_profile_placeholder")
        imgView.contentMode = .scaleAspectFit
        
        imgView.layer.cornerRadius = 15
        imgView.layer.masksToBounds = true
        
        
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

extension ChatDetailViewController: GrowingTextViewDelegate {
    
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



extension Array
{
    func filterDuplicate<T>(_ keyValue:@escaping (Element)->T) -> [Element]
    {
        var uniqueKeys = Set<String>()
        //        print({uniqueKeys.insert("\(keyValue($0))").inserted})
        print(uniqueKeys)
        return filter{uniqueKeys.insert("\(keyValue($0))").inserted}
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
