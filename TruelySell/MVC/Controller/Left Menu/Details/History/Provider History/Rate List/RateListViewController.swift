 

import UIKit
import AARatingBar

class RateListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var myTblView: UITableView!
    
    let cellIdentifierList = "RateListTableViewCell"
    
    var gStrQuesId = String()
    var myAryInfo = [[String:Any]]()
    var aDictCommon = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI()  {
        
        setUpLeftBarBackButton()
        changeLanguageContent()
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: (aDictCommon["lg7_view_reviews"] as? String)!, aViewController: self)
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)

    }
    
    func setUpModel()  {
        
    }
    
    func loadModel()  {
        
        callRateListApi()
    }

    // MARK: - Tableview Delegate and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierList, for: indexPath) as! RateListTableViewCell
        
        aCell.gLblName.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["reviewer"] as AnyObject) as! String  //(myAryInfo[indexPath.row]["reviewer"] as! String)
        aCell.gLblComments.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["review"] as AnyObject) as! String //(myAryInfo[indexPath.row]["review"] as! String)
        HELPER.setRoundCornerView(aView: aCell.gViewUserImg)
        
        let myFloat = (myAryInfo[indexPath.row]["rating"] as! NSString).floatValue
        
        aCell.gViewRatingBar.isUserInteractionEnabled = false
        aCell.gViewRatingBar.isAbsValue = false
        
        aCell.gViewRatingBar.maxValue = 5
        aCell.gViewRatingBar.value = CGFloat(myFloat)
        aCell.selectionStyle = .none
        
        aCell.gImgUser.setShowActivityIndicator(true)
        aCell.gImgUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
        let profile_img:String = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["profile_img"] as AnyObject) as? String ?? "" //myAryInfo[indexPath.row]["profile_img"] as? String ?? ""
        aCell.gImgUser.sd_setImage(with: URL(string: WEB_BASE_URL + profile_img), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Api Call
    func callRateListApi() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        let paramDict = ["p_id":gStrQuesId,"page":"1"]
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_RATE_REVIEW_LIST, dictParameters: paramDict , sucessBlock: { (response) in
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
            
            HELPER.hideLoadingAnimation()
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                var aDictResponse = [String:Any]()
                aDictResponse = response["data"] as! [String : Any]
                
                self.myAryInfo = aDictResponse["review_list"] as! [[String : Any]]
                self.myTblView.reloadData()
            }
            else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_VALIDATION) {
                
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictResponse[kRESPONSE_MESSAGE]!)
            }
            else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictResponse[kRESPONSE_MESSAGE]!)
            }
            }
            
        }) { (error) in
            print(error)
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
