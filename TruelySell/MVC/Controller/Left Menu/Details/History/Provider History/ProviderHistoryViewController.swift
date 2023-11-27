 

import UIKit
import MXSegmentedControl
import CZPicker

var REQUESTED_PROVIDER = "1"
var ACCEPTED_PROVIDER = "2"
var ALL_PROVIDER = "3"

class ProviderHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,CZPickerViewDelegate, CZPickerViewDataSource {
    
    @IBOutlet weak var mySegmentControl: MXSegmentedControl!
    
    @IBOutlet weak var myBtnAdd: UIButton!
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var filterbtnView: UIView!
    
    var myLatitude = Double()
    var myLongitude = Double()
    var myProviderName = String()
    
    var isLazyLoading:Bool!
    
    var isLazyLoadingReqSegment:Bool!
    var isLazyLoadingProviderSegment:Bool!
    
    let cellIdentifierProviderHistoryList = "MyProviderHistoryTableViewCell"
    
    let cellIdentifierList = "MyRequestTableViewCell"
    let cellIdentifierProvider = "ProvidersTableViewCell"
    let cellLazyLoadingIdentifier = "LazyLoadingTableViewCell"
    
    var myStrReqPageNumber = "1"
    var myStrProviderPageNumber = "1"
    
    //    var selectedStr = "Requested"
    var selectedStr = String()
    
    var myAryInfo = [[String:String]]()
    
    var myAryProviderMyBook = [[String:String]]()
    var myAryProviderMyBookHistory = [[String:String]]()

    var myAryReqInfo = [[String:String]]()
    var myAryProviderInfo = [[String:String]]()
    var myStrScreenTitle = String()
    
    var aDictLanguageCommon = [String:Any]()
    var aDictLanguageHistory = [String:Any]()
    
    var myAryDefaultInfo = [String] ()
    var requestType = ALL_PROVIDER
    
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
        selectedStr = (aDictLanguageHistory["lg6_all"] as? String)!
        NAVIGAION.setNavigationTitleWithBarbuttonImage(navigationTitle:selectedStr.count > 0 ? selectedStr : myStrScreenTitle, leftButtonImageName: ICON_MENU, rightButtonImageName: "", aViewController: self)
        
        myTblView.tableFooterView = UIView()
        
        myTblView.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)
        myTblView.register(UINib.init(nibName: cellLazyLoadingIdentifier, bundle: nil), forCellReuseIdentifier: cellLazyLoadingIdentifier)
        myTblView.register(UINib.init(nibName: cellIdentifierProvider, bundle: nil), forCellReuseIdentifier: cellIdentifierProvider)
        myTblView.register(UINib.init(nibName: cellIdentifierProviderHistoryList, bundle: nil), forCellReuseIdentifier: cellIdentifierProviderHistoryList)
        
        filterbtnView.isHidden = true

        mySegmentControl.font =  UIFont.systemFont(ofSize: 14)
        mySegmentControl.indicatorColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        mySegmentControl.selectedTextColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        myAryDefaultInfo.append((aDictLanguageHistory["lg6_requested"] as? String)!)
        myAryDefaultInfo.append((aDictLanguageHistory["lg6_accepted"] as? String)!)
        myAryDefaultInfo.append((aDictLanguageHistory["lg6_all"] as? String)!)
        
        HELPER.setRoundCornerView(aView: filterbtnView)
        filterbtnView.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
    }
    
    func setUpModel() {
        
        isLazyLoading = false
        isLazyLoadingProviderSegment = false
        isLazyLoadingReqSegment = false
        
        mySegmentControl.append(title: (aDictLanguageCommon["lg7_my_bookings"] as? String)!)
        mySegmentControl.append(title: (aDictLanguageCommon["lg7_history"] as? String)!)
    }
    
    func loadModel() {
        
        getPendingApi()
    }
    
    // MARK: - Table view delegate and data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1 //myAryInfo.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if mySegmentControl.selectedIndex == 0 {
            
            return myAryProviderMyBook.count
        }
        else {
            
            return myAryProviderMyBookHistory.count
        }
        
        //return myAryInfo.count + (isLazyLoading ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if indexPath.row >= myAryInfo.count {
//
//            return 50
//        }
//
//        else {
        
            return  130
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
        
//        else {
        
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierProviderHistoryList, for: indexPath) as! MyProviderHistoryTableViewCell
            
            if mySegmentControl.selectedIndex == 0 {
                
                if myAryProviderMyBook.count != 0 {
                    
//                    aCell.gImgDateIcon.isHidden = true
//                    aCell.gImgTimeIcon.isHidden = true
                    
                    let aStrStatus = myAryProviderMyBook[indexPath.row]["service_status"]
                    
                    if aStrStatus == "1" {
                        
                        aCell.gLblProviderStatus.text = aDictLanguageHistory["lg6_pending"] as? String

                    }
                    else {
                        
                        aCell.gLblProviderStatus.text = aDictLanguageHistory["lg6_completed"] as? String
                    }
                    
                    aCell.gBtnShowDirections.setTitleColor(HELPER.hexStringToUIColor(hex: SESSION.getAppColor()), for: .normal)
                    
                    aCell.gLblTitle.text = myAryProviderMyBook[indexPath.row]["title"]
                    aCell.gLblDate.text = myAryProviderMyBook[indexPath.row]["service_date"]
                    aCell.gLblTime.text = myAryProviderMyBook[indexPath.row]["service_time"]
                    aCell.gLblUserName.text = myAryProviderMyBook[indexPath.row]["requester_name"]
                    aCell.gLblBullet1.text = myAryProviderMyBook[indexPath.row]["notes"]
                    
                    aCell.gmyProfileImg.setShowActivityIndicator(true)
                    aCell.gmyProfileImg.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
                    let myStrImage =  myAryProviderMyBook[indexPath.row]["profile_img"] ?? ""
                    aCell.gmyProfileImg.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrImage)), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
                    HELPER.setRoundCornerView(aView: aCell.gmyProfileImg)
                    
                    aCell.gBtnShowDirections.isHidden = true
                    
//                    aCell.gBtnShowDirections.tag = indexPath.row
//                    aCell.gBtnShowDirections.addTarget(self, action: #selector(didTapOnShowDirection(_:)), for: .touchUpInside)

                    return aCell
                }
            }
            else {
                
                if myAryProviderMyBookHistory.count != 0 {
                    
//                    aCell.gImgDateIcon.isHidden = true
//                    aCell.gImgTimeIcon.isHidden = true
//                    aCell.gLblDate.isHidden = true
//                    aCell.gLblTime.isHidden = true
                    
                    let aStrStatus = myAryProviderMyBookHistory[indexPath.row]["service_status"]
                    
                    if aStrStatus == "1" {
                        
                        aCell.gLblProviderStatus.text = aDictLanguageHistory["lg6_pending"] as? String
                        
                    }
                    else {
                        
                        aCell.gLblProviderStatus.text = aDictLanguageHistory["lg6_completed"] as? String
                    }

                    aCell.gLblTitle.text = myAryProviderMyBookHistory[indexPath.row]["title"]
                    aCell.gLblDate.text = myAryProviderMyBookHistory[indexPath.row]["service_date"]
                    aCell.gLblTime.text = myAryProviderMyBookHistory[indexPath.row]["service_time"]
                    aCell.gLblUserName.text = myAryProviderMyBookHistory[indexPath.row]["requester_name"]
                    aCell.gLblBullet1.text = myAryProviderMyBookHistory[indexPath.row]["notes"]
                    aCell.gmyProfileImg.setShowActivityIndicator(true)
                    aCell.gmyProfileImg.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
                    let myStrImage =  myAryProviderMyBookHistory[indexPath.row]["profile_img"] ?? ""
                    aCell.gmyProfileImg.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrImage)), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
                    HELPER.setRoundCornerView(aView: aCell.gmyProfileImg)
                    
                    aCell.gBtnShowDirections.isHidden = true
//                    aCell.gBtnShowDirections.tag = indexPath.row
//                    aCell.gBtnShowDirections.addTarget(self, action: #selector(didTapOnShowDirectionHistory(_:)), for: .touchUpInside)
                    
                    return aCell
                }
            }
        
            return aCell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if mySegmentControl.selectedIndex == 0 {
            
            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_PROVIDE_HISTORY_DETAIL_VC) as! ProviderHistoryDetailViewController
            aViewController.gDictInfo = myAryProviderMyBook[indexPath.row]
            aViewController.gStrScreenTitle = myAryProviderMyBook[indexPath.row]["title"]!
            aViewController.isFromMybooking = true
            self.navigationController?.pushViewController(aViewController, animated: true)
            
        }
        else {
            
            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_PROVIDE_HISTORY_DETAIL_VC) as! ProviderHistoryDetailViewController
            aViewController.gDictInfo = myAryProviderMyBookHistory[indexPath.row]
            aViewController.gStrScreenTitle = myAryProviderMyBook[indexPath.row]["title"]!
            aViewController.isFromMybooking = false
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
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
//                loadMore()
            }
        }else{
            print("testButton is hidden");
        }
    }
    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        
        //        updateArrayInfo()
        
        if mySegmentControl.selectedIndex == 0 {
            
            getPendingApi()
        }
            
        else {
            
            getCompletedApi()
        }
        
        self.myTblView.reloadData()
    }
    
    func loadMore() {
        
        self.mySegmentControl.selectedIndex == 0 ?  self.getPendingApi(): self.getCompletedApi()
    }
    
    // MARK: - Call Api
    //My Booking
    func getPendingApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
        
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
//        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_BOOKING_PROVIDER,dictParameters:dictParameters, sucessBlock: { response in
        
            HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_MY_BOOKING_PROVIDER, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
                
                if response.count != 0 {
                    
                    var aDictResponse = response[kRESPONSE] as! [String : String]
                    
                    let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                    
                    if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                        
                        var aDictResponse = [String:Any]()
                        aDictResponse = response["data"] as! [String : Any]
                        
                        //                let aIntNextPage = aDictResponse["next_page"] as! Int
                        //                self.myStrReqPageNumber = String(aIntNextPage)
                        //
                        //                self.isLazyLoadingReqSegment = aIntNextPage == -1 ? false : true
                        //
                        //                if self.myAryReqInfo.count == 0 {
                        
                        self.myAryProviderMyBook = aDictResponse["booking_list"] as! [[String : String]]
                        self.myTblView.reloadData()
                        //                }
                        //                else {
                        
                        //                    for dictInfo in aDictResponse["request_list"] as! [[String : String]] {
                        //                        self.myAryReqInfo.append(dictInfo)
                        //                    }
                        //                }
                        
                        //                self.updateArrayInfo()
                        //                self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_DATA)
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
    
    func getCompletedApi() {
        
        if !HELPER.isConnectedToNetwork() {
            
            self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_INTERNET)
            return
        }
      
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
//        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_HISTORY_PROVIDER,dictParameters:dictParameters, sucessBlock: { response in
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_HISTORY_PROVIDER, sucessBlock: { response in
        
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponse = [String:Any]()
                    aDictResponse = response["data"] as! [String : Any]
                    
                    self.myAryProviderMyBookHistory = aDictResponse["booking_list"] as! [[String : String]]
                    self.myTblView.reloadData()
                    //                }
                    //                else {
                    //
                    //                    for dictInfo in aDictResponse["request_list"] as! [[String : String]] {
                    //                        self.myAryProviderInfo.append(dictInfo)
                    //                    }
                    //                }
                    
                    //                self.updateArrayInfo()
                    //                self.handleNodataAndErrorMessage(alertType: ALERT_TYPE_NO_DATA)
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
    
    // Butto Actions
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        
        self.createPicker()
    }
    
    @objc func didTapOnShowDirection(_ sender: UIButton) {
        
        myLatitude = 0.0
        myLongitude = 0.0
        myProviderName = ""
        
        if let aLat = myAryProviderMyBook[sender.tag]["latitude"], aLat != "" {
            myLatitude = Double(aLat)!
        }
        
        if let aLong = myAryProviderMyBook[sender.tag]["longitude"], aLong != "" {
            myLongitude = Double(aLong)!
        }
        myProviderName = myAryProviderMyBook[sender.tag]["full_name"]!

        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_GOOGLE_MAP_DIRECTION_VC) as! GoogleMapsDirectionViewController
        aViewController.gDestinationLatitude = myLatitude
        aViewController.gDestinationLongitude = myLongitude
        aViewController.gProviderName = myProviderName
        self.navigationController?.pushViewController(aViewController, animated: true)
        
    }
    
    @objc func didTapOnShowDirectionHistory(_ sender: UIButton) {
        
        myLatitude = 0.0
        myLongitude = 0.0
        myProviderName = ""
        
        if let aLatHistory = myAryProviderMyBook[sender.tag]["latitude"], aLatHistory != "" {
            myLatitude = Double(aLatHistory)!
        }
        
        if let aLongHistory = myAryProviderMyBook[sender.tag]["longitude"], aLongHistory != "" {
            myLongitude = Double(aLongHistory)!
        }
        myProviderName = myAryProviderMyBook[sender.tag]["full_name"]!
        
        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_GOOGLE_MAP_DIRECTION_VC) as! GoogleMapsDirectionViewController
        aViewController.gDestinationLatitude = myLatitude
        aViewController.gDestinationLongitude = myLongitude
        aViewController.gProviderName = myProviderName
        self.navigationController?.pushViewController(aViewController, animated: true)
        
    }
    
    // MARK:- Functions
    
    func createPicker()  {
        
        let picker = CZPickerView(headerTitle: CommonTitle.HISTORY.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
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
            requestType = REQUESTED_PROVIDER
        }
        else if row == 1 {
            requestType = ACCEPTED_PROVIDER
        }
        else if row == 2 {
            requestType = ALL_PROVIDER
        }
        self.myAryInfo.removeAll()
        NAVIGAION.setNavigationTitleWithBarbuttonImage(navigationTitle: selectedStr.count > 0 ? selectedStr : myStrScreenTitle, leftButtonImageName: ICON_MENU, rightButtonImageName: "", aViewController: self)
        if mySegmentControl.selectedIndex == 0 {
            myStrReqPageNumber = "1"
            self.myAryReqInfo.removeAll()
            self .getPendingApi()
        }
        else {
            myStrProviderPageNumber = "1"
            self.myAryProviderInfo .removeAll()
            self .getCompletedApi()
        }
    }
    
//    func updateArrayInfo() {
//
//        if self.mySegmentControl.selectedIndex == 0 {
//
//            myAryInfo = myAryReqInfo
//            self.isLazyLoading = self.isLazyLoadingReqSegment
//        }
//
//        else {
//
//            myAryInfo = myAryProviderInfo
//            self.isLazyLoading = self.isLazyLoadingProviderSegment
//        }
//    }
    
    func changeLanguageContent() {
        
        var aDictLangInfo = SESSION.getLangInfo()
        var aDictScreenTitle = [String:Any]()
        aDictScreenTitle = aDictLangInfo["navigation"] as! [String : Any]
        aDictLanguageCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
        aDictLanguageHistory = aDictLangInfo["request_and_provider_list"] as! [String : Any]
        myStrScreenTitle = HELPER.returnStringFromNull(aDictScreenTitle["lg3_history"] as AnyObject) as! String  //aDictScreenTitle["lg3_history"] as! String
    }
    
    //    @IBAction func addBtnTapped(_ sender: Any) {
    //
    //        if mySegmentControl.selectedIndex == 0 {
    //
    //            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_ADD_REQUEST)
    //            let naviController = UINavigationController(rootViewController: aViewController)
    //            self.present(naviController, animated: true, completion: nil)
    //        }
    //
    //        else {
    //
    //            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_ADD_PROVIDE)
    //            let naviController = UINavigationController(rootViewController: aViewController)
    //            self.present(naviController, animated: true, completion: nil)
    //        }
    //    }
}
