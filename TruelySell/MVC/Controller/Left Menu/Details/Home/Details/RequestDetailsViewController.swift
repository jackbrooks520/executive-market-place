//
//  RequestDetailsViewController.swift
//
//  Created by Yosicare on 29/04/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit

class RequestDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellIdentifierList = "RequestDetailsInfoTableViewCell"
    
    @IBOutlet weak var acceptBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myBtnAcceptReq: UIButton!
    
    var gDictInfo = [String:Any]()
    var aDictLang = [String:Any]()

    typealias CompletionBlock = (String?) -> Void
    var completion: CompletionBlock = { reason  in print(reason ?? false) }
    
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
        
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: gDictInfo["title"]! as! String, aViewController: self)
        myTblView.register(UINib.init(nibName: cellIdentifierList, bundle: nil), forCellReuseIdentifier: cellIdentifierList)
        
        myBtnAcceptReq.setTitle(aDictLang["lg6_accept_request"] as? String, for: .normal)
        myBtnAcceptReq.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        myTblView.tableFooterView = UIView()

        setUpLeftBarBackButton()
        
        myBtnAcceptReq.isHidden = false
        acceptBtnHeight.constant = 40
        var requesterId:String = gDictInfo["requester_id"] as! String
        
        if requesterId == SESSION.getUserId() {
            
            myBtnAcceptReq.isHidden = true
            acceptBtnHeight.constant = 0
        }
    }
    
    func setUpModel() {
       
    }
    
    func loadModel() {
        
    }
    
    // MARK: - Table view delegate and data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierList, for: indexPath) as! RequestDetailsInfoTableViewCell
       
        aCell.gLblName.text = gDictInfo["username"] as? String
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewMessage, imageName: "icon_message")
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewCall, imageName: "icon_phonr")
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewLocation, imageName: "icon_location ")
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewClock, imageName: "icon_clock_red")
        HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewCalendar, imageName: "icon_cal_red")

        
        if SESSION.getUserSubscriptionStatus() {
            aCell.gLblMail.isHidden = false
            aCell.gLblPhone.isHidden = false
            aCell.phoneiconWidth.constant = 10
            aCell.gLblMail.text = gDictInfo["email"] as? String
            aCell.gLblPhone.text = gDictInfo["contact_number"] as? String
        }
        else {
            aCell.gLblMail.isHidden = true
            aCell.gLblPhone.isHidden = true
            aCell.phoneiconWidth.constant = 0
        }
        aCell.gLblTime.text = gDictInfo["request_time"] as? String
        aCell.gLblDate.text = gDictInfo["request_date"] as? String
        aCell.gLblLocation.text = gDictInfo["location"] as? String
        //        let aStrLangFee = aDictLang["lg6_expecting_fee"]
        aCell.gLblFee.text = "Expecting Fees : INR \(gDictInfo["amount"] ?? "")"        
        
        aCell.gLblTitle.text = gDictInfo["title"] as? String 
        
        aCell.gImgViewUser.setShowActivityIndicator(true)
        aCell.gImgViewUser.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
        let myStrImage:String =  (gDictInfo["profile_img"] as? String)!
        aCell.gImgViewUser.sd_setImage(with: URL(string: (WEB_BASE_URL + myStrImage)), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
        HELPER.setRoundCornerView(aView: aCell.gImgViewUser)

        let aStrJson = gDictInfo["description"]
        
        let data = (aStrJson as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
        
        do {
            let arrayString = try JSONSerialization.jsonObject(with: data, options: []) as! [String]
            aCell.gLblDesc.attributedText = add(stringList: arrayString, font: aCell.gLblPhone.font, bullet: "")

        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        aCell.selectionStyle = .none
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func add(stringList: [String],
             font: UIFont,
             bullet: String = "\u{2022}",
             indentation: CGFloat = 20,
             lineSpacing: CGFloat = 2,
             paragraphSpacing: CGFloat = 12,
             textColor: UIColor = .gray,
             bulletColor: UIColor = .red) -> NSAttributedString {
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        //paragraphStyle.firstLineHeadIndent = 0
        //paragraphStyle.headIndent = 20
        //paragraphStyle.tailIndent = 1
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        
        return bulletList
    }
    
    
    @IBAction func acceptReqBtnTapped(_ sender: Any) {
        
//        if SESSION.getUserSubscriptionStatus() {
        
            if !HELPER.isConnectedToNetwork() {
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                return
            }
            
            let paramDict = ["request_id":self.gDictInfo["r_id"]]
            
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
            
            HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_MY_REQUEST_ACCEPT, dictParameters: paramDict as! [String : String], sucessBlock: { (response) in
                print(response)
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                print(response)
                HELPER.hideLoadingAnimation()
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        self.completion("refresh")
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_VALIDATION) {
                    
//                    HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                    
                    let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SUBSCRIPTION_POPUP_VC) as! SubscriptionPopupViewController
                    
                    aViewController.modalPresentationStyle = .overFullScreen
                    aViewController.modalTransitionStyle = .crossDissolve
                    let naviController = UINavigationController(rootViewController: aViewController)
                    self.present(naviController, animated: true, completion: nil)
                    
                }
                
            }) { (error) in
                print(error)
                HELPER.hideLoadingAnimation()
            }
//        } else {
//            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SUBSCRIPTION_POPUP_VC) as! SubscriptionPopupViewController
//
//            aViewController.modalPresentationStyle = .overFullScreen
//            aViewController.modalTransitionStyle = .crossDissolve
//            let naviController = UINavigationController(rootViewController: aViewController)
//            self.present(naviController, animated: true, completion: nil)
//        }
    }
    func changeLanguageContent() {
        
        var aDictLangInfo = SESSION.getLangInfo()
        aDictLang = aDictLangInfo["request_and_provider_list"] as! [String : Any]
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
