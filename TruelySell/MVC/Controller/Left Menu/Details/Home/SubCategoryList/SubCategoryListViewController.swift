

import UIKit

class SubCategoryListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var myTblView: UITableView!
    
    let cellIdentifierList = "SubCategoryListTableViewCell"
    
    var gStrCatId = String()
    var myArySubCatInfo = [[String:String]]()
    
    var aDictLanguageCommon = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpModel()
        loadModel()

        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        changeLanguageContent()
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: aDictLanguageCommon["lg7_sub_category"] as! String, aViewController: self)
        setUpLeftBarBackButton()
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)
        
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        getSubCategoryListFromApi()
    }
    
    // MARK: - Table view delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myArySubCatInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierList, for: indexPath) as! SubCategoryListTableViewCell
        
        HELPER.setRoundCornerView(aView: aCell.gViewSubCatIcon)
        aCell.gImgViewSubCatIcon.setShowActivityIndicator(true)
        aCell.gImgViewSubCatIcon.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
        let myStrImage =  myArySubCatInfo[indexPath.row]["subcategory_image"] ?? ""
        aCell.gImgViewSubCatIcon.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrImage)), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
        aCell.gLblSubCatName.text = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["subcategory_name"] as AnyObject) as? String       //myArySubCatInfo[indexPath.row]["subcategory_name"]
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell.gImgViewRightArrow.image = UIImage(named: "icon_front_gray")?.withHorizontallyFlippedOrientation()
        }
        else {
            aCell.gImgViewRightArrow.image = UIImage(named: "icon_front_gray")
        }
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_PROV_LIST_VC) as! ProviderListViewController
        aViewController.gStrCatID = gStrCatId
        aViewController.gStrSubCatID = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["subcategory_id"] as AnyObject) as! String       // myArySubCatInfo[indexPath.row]["subcategory_id"]!
        aViewController.gStrScreenTitle = HELPER.returnStringFromNull(myArySubCatInfo[indexPath.row]["subcategory_name"] as AnyObject) as! String       //myArySubCatInfo[indexPath.row]["subcategory_name"]!
        self.navigationController?.pushViewController(aViewController, animated: true)
        
    }
    
    // MARK:- Api Call
    func getSubCategoryListFromApi() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams = ["category":gStrCatId]
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_SUB_CATEGORY, dictParameters: aDictParams, sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    
                    self.myArySubCatInfo = aDictResponseData["category_list"] as! [[String : String]]
                    self.myTblView.reloadData()
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
    
    func changeLanguageContent() {
        
        var aDictLangInfo = SESSION.getLangInfo()
        var aDictScreenTitle = [String:Any]()
        aDictScreenTitle = aDictLangInfo["navigation"] as! [String : Any]
        aDictLanguageCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
    }
}
