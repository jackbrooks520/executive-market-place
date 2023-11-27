 
import UIKit
import CZPicker

var PENDINGREQUEST = "0"
var ACCEPTEDREQUEST = "1"
var COMPLETEDREQUEST = "2"
var ALLREQUEST = ""

class MyRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,CZPickerViewDelegate, CZPickerViewDataSource  {
    
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var filterbtnView: UIView!

    var isLazyLoading = Bool()
    
    let cellIdentifierList = "MyRequestTableViewCell"
    let cellLazyLoadingIdentifier = "LazyLoadingTableViewCell"
    
    var myAryInfo = [[String:Any]]()
    
    var aDictLanguageCommon = [String:Any]()
    var aDictLanguageReqAndPro = [String:Any]()

    var myStrPagewNumber = "1"
    var myStrScreenTitle = String()
    var myStrSearchPageNumber = "1"
    var searchTxt = ""
    var searchType = "0"
    var myAryDefaultInfo = [String] ()
    var myRequestId = ""
    var selectedStr = ""
    var requestType = ALLREQUEST

    // Adv search
    var isAdvSearch = false
    var appDate = ""
    var appTime = ""
    var location = ""
    var priceFrom = ""
    var priceTo = ""
    
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
        myTblView.tableFooterView = UIView()
        myTblView.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)
        myTblView.register(UINib.init(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellReuseIdentifier: cellLazyLoadingIdentifier)
        evo_drawerController?.gestureShouldRecognizeTouchBlock = nil
        
        HELPER.setRoundCornerView(aView: filterbtnView)
        filterbtnView.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        myAryDefaultInfo.append(Booking_service.PENDING_TITLE.titlecontent())
        myAryDefaultInfo.append(Booking_service.ACCEPTED_TITLE.titlecontent())
        myAryDefaultInfo.append(Booking_service.COMPLETED_TITLE.titlecontent())
        myAryDefaultInfo.append(HomeScreenContents.ALL_TITLE.titlecontent())

        
    }
    
    func setUpModel() {
        
        isLazyLoading = false
    }
    
    func loadModel() {
        
        if searchTxt.count > 0 {
            self .getSearchResultsApi()
        }
        else {
           self .getMessagesFromApi()

        }
    }
    
    // MARK;- Functions
    
    // MARK:- Left Bar Button Methods
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func backBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // Butto Actions
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        
        self.createPicker()
    }
    
    // MARK:- Functions
    
    func createPicker()  {
        
        let picker = CZPickerView(headerTitle: CommonTitle.FILTER.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
        picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = false
        picker?.show()
    }
    
    //MARK: - CZPickerDelegate Methods
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        return myAryDefaultInfo.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        return myAryDefaultInfo[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        
        selectedStr = myAryDefaultInfo[row]
        if row == 0 {
            requestType = PENDINGREQUEST
        }
        else if row == 1 {
            requestType = ACCEPTEDREQUEST
        }
        else if row == 2 {
            requestType = COMPLETEDREQUEST
        }
        else if row == 3 {
            requestType = ALLREQUEST
        }
        myStrPagewNumber = "1"
        self.myAryInfo.removeAll()
        NAVIGAION.setNavigationTitleWithBarbuttonImage(navigationTitle: selectedStr.count > 0 ? selectedStr : myStrScreenTitle, leftButtonImageName: ICON_MENU, rightButtonImageName: "", aViewController: self)
       
        self .getMessagesFromApi()
        
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
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierList, for: indexPath) as! MyRequestTableViewCell
            
            aCell.gLblProfileUser.isHidden = true
            
            if searchTxt.count > 0 {
                 aCell.gLblProfileUser.isHidden = false
                let uName:String = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["username"] as AnyObject) as! String  //myAryInfo[indexPath.row]["username"]! as! String
                let title:String = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["title"] as AnyObject) as! String  //myAryInfo[indexPath.row]["title"]! as! String
                aCell.gLblUserName.text =  title
                aCell.gLblProfileUser.text = uName
            }
            else {
                aCell.gLblUserName.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["title"] as AnyObject) as? String  //myAryInfo[indexPath.row]["title"] as? String
                
            }
//            if let statusStr = myAryInfo[indexPath.row]["status"]  {
            
                aCell.gLblStatus.textColor =  HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            
            let status = String(format: "%@", myAryInfo[indexPath.row]["status"] as! CVarArg)
                if status == "0" {
                    aCell.gLblStatus.text = aDictLanguageReqAndPro["lg6_pending"] as? String
                }
                else if status == "1" {
                    aCell.gLblStatus.text = aDictLanguageReqAndPro["lg6_accepted"] as? String
                }
                else if status == "2" {
                    aCell.gLblStatus.text = aDictLanguageReqAndPro["lg6_completed"] as? String
                }
//            }
            
            
            aCell.gLblDate.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["request_date"] as AnyObject) as? String //myAryInfo[indexPath.row]["request_date"] as? String
            aCell.gLblTime.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["request_time"] as AnyObject) as? String //myAryInfo[indexPath.row]["request_time"] as? String
            aCell.gLblAmount.textColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            
            let amountStr:String = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["amount"] as AnyObject) as! String //myAryInfo[indexPath.row]["amount"]! as! String
            let amountCodeStr:String = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["currency_code"] as AnyObject) as! String //myAryInfo[indexPath.row]["currency_code"]! as! String
            aCell.gLblAmount.text = amountCodeStr + " " + amountStr
            
            HELPER.setCardView(cardView: aCell.gmyProfileImg)
            HELPER.setRoundCornerView(aView: aCell.gmyProfileImg)
            aCell.gmyProfileImg.setShowActivityIndicator(true)
            aCell.gmyProfileImg.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
            aCell.gmyProfileImg.sd_setImage(with: URL(string: (WEB_BASE_URL + SESSION.getUserImage())), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
            
            if searchTxt.count > 0 {
                
                let myStrImage:String =  HELPER.returnStringFromNull(myAryInfo[indexPath.row]["profile_img"] as AnyObject) as! String //myAryInfo[indexPath.row]["profile_img"] as! String
                aCell.gmyProfileImg.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrImage)), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
                HELPER.setRoundCornerView(aView: aCell.gmyProfileImg)
            }
            let aStrJson = myAryInfo[indexPath.row]["description"]!
            
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
        
        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_REQ_DET_VC) as! RequestDetailsViewController
        aViewController.gDictInfo = myAryInfo[indexPath.row]
        self.navigationController?.pushViewController(aViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row >= myAryInfo.count {

        }
        
        else {
            
            let statusRequestor = String(format: "%@", self.myAryInfo[indexPath.row]["status"] as! CVarArg)
            
            if statusRequestor == "0" {
                return true
            }
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let statusRequestor = String(format: "%@", self.myAryInfo[indexPath.row]["status"] as! CVarArg)

        if statusRequestor == "0" {
            
            let delete = UITableViewRowAction(style: .destructive, title: aDictLanguageReqAndPro["lg6_delete"] as? String) { (action, indexPath) in
                
                self.myRequestId = String(format: "%@", self.myAryInfo[indexPath.row]["r_id"] as! CVarArg)//
                self.myAryInfo.remove(at: indexPath.row)
               // tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.myTblView .reloadData()
                
                if self.myAryInfo.count == 0 {
                    
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_NO_DATA)
                }
                
                self.setRemoveMyRequestList()
                
            }
            
            let edit = UITableViewRowAction(style: .normal, title: aDictLanguageReqAndPro["lg6_edit"] as? String) { (action, indexPath) in
                
                let aViewController:RequestAddViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_ADD_REQUEST) as! RequestAddViewController
                print(self.myAryInfo[indexPath.row])
                aViewController.gAryEditInfo = [self.myAryInfo[indexPath.row]]
                aViewController.gClickEditRequest = true
                let naviController = UINavigationController(rootViewController: aViewController)
                self.present(naviController, animated: true, completion: nil)
                
            }
            
            edit.backgroundColor = UIColor.gray
            delete.backgroundColor = UIColor.red
            
            return [delete, edit]
        }
        return nil
    }
    
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let deleteAction = UITableViewRowAction(style: .normal, title:"Delete") { (rowAction, indexPath) in
//            print("delete clicked")
//        }
//
//        let editAction = UITableViewRowAction(style: .normal, title:"Edit") { (rowAction, indexPath) in
//            print("delete clicked")
//        }
//
//        deleteAction.backgroundColor = UIColor(patternImage:UIImage(named: ICON_BACK)!)
//        editAction.backgroundColor = UIColor(patternImage:UIImage(named: ICON_BACK)!)
//
//        editAction.backgroundColor = UIColor.gray
//        deleteAction.backgroundColor = UIColor.red
//
//        return [deleteAction,editAction]
//    }
    
    
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
    
    // MARK: - Button Action
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
    
    // MARK: - Api call
    func getMessagesFromApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictInfo = [String:String]()
        dictInfo = ["filter_by":requestType,"page":myStrPagewNumber]//,"latitude":SESSION.getUserLatLong().0,"longitude":SESSION.getUserLatLong().1]
        
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_REQUEST_LIST,dictParameters:dictInfo, sucessBlock: { response in
            
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
                    
                    if self.myAryInfo.count == 0 {
                        
                        self.myAryInfo = aDictResponse["request_list"] as! [[String : Any]]
                        self.myTblView.reloadData()
                    }
                    else {
                        
                        for dictInfo in aDictResponse["request_list"] as! [[String : Any]] {
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
                        "latitude":SESSION.getUserUpdatedLatLonginGoogleSearch().0,
                        "longitude":SESSION.getUserUpdatedLatLonginGoogleSearch().1,
                        "search_title":"",
                        "request_date":appDate,
                        "request_time":appTime,
                        "min_price":priceFrom,
                        "max_price":priceTo,
                        "location":location,
                        "searchType":searchType]
        }
        else {
            dictInfo = ["page":String(myStrSearchPageNumber),
                        "latitude":SESSION.getUserUpdatedLatLonginGoogleSearch().0,
                        "longitude":SESSION.getUserUpdatedLatLonginGoogleSearch().1,
                        "search_title":searchTxt,
                        "request_date":"",
                        "request_time":"",
                        "min_price":"",
                        "max_price":"",
                        "location":"",
                        "searchType":searchType,
//                "category":searchType,
//                "subcategory":searchType
            ]
        }
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SEARCH_LIST,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponse = [String:Any]()
                    aDictResponse = response["data"] as! [String : Any]
                    
                    let aIntNextPage = aDictResponse["next_page"] as! Int
                    self.myStrSearchPageNumber = String(aIntNextPage)
                    
                    self.isLazyLoading = aIntNextPage == -1 ? false : true
                    
                    if self.myAryInfo.count == 0 {
                        
                        self.myAryInfo = aDictResponse["request_list"] as! [[String : Any]]
                        self.myTblView.reloadData()
                    }
                    else {
                        
                        for dictInfo in aDictResponse["request_list"] as! [[String : String]] {
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
    
    func setRemoveMyRequestList() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        var dictInfo = [String:String]()
        dictInfo = ["request_id":myRequestId]
        
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_REQUEST_REMOVE_LIST,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
             
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
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
    
    //delete Function
    @objc func deleteBtnTapped(sender: UIButton) {
        
//        if myAryExtrasInfo.count > 2  {
//            myAryExtrasInfo.remove(at: sender.tag)
//            self .getLastGigsValuesinArray()
//            myTblView.reloadData()
//        }
    }
    
    func getLastGigsValuesinArray()  {
        
//        var dict = myAryExtrasInfo[myAryExtrasInfo.count - 1]
//        self.myStrGigTitleExtra = dict[self.TITLE] as! String
//        self.myStrGigPriceExtra = dict[self.PRICE] as! String
//        self.myStrGigDeliveryDayExtra = dict[self.DAYS] as! String
    }
    
    func changeLanguageContent() {
        
        let aDictLangInfo = SESSION.getLangInfo()
        var aDictScreenTitle = [String:Any]()
        aDictScreenTitle = aDictLangInfo["navigation"] as! [String : Any]
        aDictLanguageCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
        myStrScreenTitle = aDictScreenTitle["lg3_my_requests"] as! String
        aDictLanguageReqAndPro = aDictLangInfo["request_and_provider_list"] as! [String : Any]
    }
}
