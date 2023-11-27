//
//  GSPaymentViewController.swift
//  Gigs
//
//  Created by user on 09/06/2018.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class GSPaymentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var myTblview: UITableView!
    
    let cellIdentifier: String = "GSLeftMenuTableViewCell"
    
    var myAryRowInfo = [[String:String]]()
     var myDictProviderInfo = [String:Any]()
    let KMENUTITLE: String = "title"
    let KMENUIMAGENAME: String = "image_name"

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        NAVIGAION.setNavigationTitle(aStrTitle: SettingsLangContents.ACCOUNT_SETTINGS.titlecontent(), aViewController: self)
        setUpLeftBarBackButton()
         getProfileDetailsProviderFromApi()
        
        myTblview.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

        
//        myAryRowInfo = [[KMENUIMAGENAME: "icon_paypal_settings", KMENUTITLE:StripeScrenTitle.SCREEN_TITLE_PAYPAL_SETTINGS.titlecontent()], [KMENUIMAGENAME: "icon_paypal_settings", KMENUTITLE:StripeScrenTitle.SCREEN_TITLE_STRIPE_SETTINGS.titlecontent()]]
        
        myAryRowInfo = [[KMENUIMAGENAME: "", KMENUTITLE:StripeScrenTitle.SCREEN_TITLE_STRIPE_SETTINGS.titlecontent()]]
        
        myTblview.delegate = self
        myTblview.dataSource = self
    }

    func setUpModel() {
        
    }
    
    func loadModel() {
        
    }
    
    
    // MARK: - TableView delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryRowInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GSLeftMenuTableViewCell
        aCell.gLblTitle.text = (myAryRowInfo[indexPath.row][KMENUTITLE])
        aCell.gImgView.image = UIImage(named: myAryRowInfo[indexPath.row][KMENUIMAGENAME]!)
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.myTblview.deselectRow(at: indexPath, animated: true)
        
        let strTitle = myAryRowInfo[indexPath.row][KMENUTITLE]
        
//        if strTitle == StripeScrenTitle.SCREEN_TITLE_PAYPAL_SETTINGS.titlecontent() {
//
//            let aViewController = GSPaypalSettingsViewController()
//            self.navigationController?.pushViewController(aViewController, animated: true)
//        }
//        else if strTitle == StripeScrenTitle.SCREEN_TITLE_STRIPE_SETTINGS.titlecontent() {
//
        if strTitle == StripeScrenTitle.SCREEN_TITLE_STRIPE_SETTINGS.titlecontent() {
            
            let aViewController = GSStripeViewController()
            self.navigationController?.pushViewController(aViewController, animated: true)
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
        
        leftBtn.addTarget(self, action: #selector(questionBackBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func questionBackBtnTapped() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func getProfileDetailsProviderFromApi() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_VIEW_PROVIDER_PROFILE, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    
                    print(aDictResponseData)
                    
                    self.myDictProviderInfo = aDictResponseData
                    
                    
                    var aDictTemp = [String:Any]()
                    var aDictStripe = [String:String]()
                    
                        aDictTemp = self.myDictProviderInfo["stripe_details"] as! [String : Any]
                       
                    aDictStripe["account_holder_name"] = aDictTemp["account_holder_name"] as? String
                             aDictStripe["account_iban"] = aDictTemp["account_iban"] as? String
                             aDictStripe["account_ifsc"] = aDictTemp["account_ifsc"] as? String
                             aDictStripe["account_number"] = aDictTemp["account_number"] as? String
                              aDictStripe["bank_name"] = aDictTemp["bank_name"] as? String
                      aDictStripe["bank_address"] = aDictTemp["bank_address"] as? String
                              aDictStripe["id"] = aDictTemp["id"] as? String
                              aDictStripe["sort_code"] = aDictTemp["sort_code"] as? String
                             aDictStripe["routing_number"] = aDictTemp["routing_number"] as? String
                    
                    SESSION.setUserStripeInfo(dictInfo: aDictStripe)
                    
                    
                    //        myStrSubscription = myDictUserInfo[""] as! String
                    
                    
                    //                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
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
}

