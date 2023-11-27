//
//  ViewReplyCommentsViewController.swift
//  VRS
//
//  Created by user on 07/03/19.
//  Copyright © 2019 DreamGuys. All rights reserved.
//

import UIKit
import SDWebImage

class ViewReplyCommentsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var myImgUserImage: UIImageView!
    @IBOutlet weak var myContainerViewImage: UIView!
    @IBOutlet weak var myLblCommentTime: UILabel!
    @IBOutlet weak var myLblUserCommnet: UILabel!
    @IBOutlet weak var myLblUserName: UILabel!
    @IBOutlet weak var myBtnSend: UIButton!
    @IBOutlet weak var myTxtFldComments: UITextField!
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myViewSendBtnContainer: UIView!
    
    let cellTableListIdentifier = "ViewCommentsTableViewCell"
    
    var myAryInfo = [[String:Any]]()
    
    var gDictCommentInfo = [String:Any]()
    var aDictLanguageCommon = [String:Any]()
    
    var gStrCommentId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        changeLanguageContent()
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: aDictLanguageCommon["lg7_replies"] as! String, aViewController: self)
       
//        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
//            myTxtFldComments.textAlignment = .right
//
//            myBtnSend.setImage(UIImage(named: "icon_send")?.withHorizontallyFlippedOrientation(), for: .normal)
//        }
//        else {
//            myTxtFldComments.textAlignment = .left
//             myBtnSend.setImage(UIImage(named: "icon_send"), for: .normal)
//        }
        HELPER.setRoundCornerView(aView: myViewSendBtnContainer)
        myViewSendBtnContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                   myTxtFldComments.textAlignment = .right
                   let origImage = UIImage(named: "icon_send_arrow")
                       let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                       myBtnSend.setImage(tintedImage?.withHorizontallyFlippedOrientation(), for: .normal)
//                   myBtnSend.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                  
               }
               else {
                   let origImage = UIImage(named: "icon_send_arrow")
                                 let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                                 myBtnSend.setImage(tintedImage, for: .normal)
//                             myBtnSend.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                                        myTxtFldComments.textAlignment = .left
               }
              
        
        setUpLeftBarBackButton()
        myTblView.delegate = self
        myTblView.dataSource = self
        
        myTblView.register(UINib.init(nibName: cellTableListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableListIdentifier)
        
        myLblUserName.text = gDictCommentInfo["name"] as? String
        myLblCommentTime.text = gDictCommentInfo["days_ago"] as? String
        myLblUserCommnet.text = gDictCommentInfo["comment"] as? String
        
        HELPER.setRoundCornerView(aView: myContainerViewImage)
        
        myImgUserImage.setShowActivityIndicator(true)
        myImgUserImage.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
        var aStrImage = String()
        
        aStrImage = gDictCommentInfo["profile_image"] as! String
        myImgUserImage.sd_setImage(with: URL(string:WEB_BASE_URL + aStrImage), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
    }
    
    func setUpModel() {
        
    }
    
    func loadModel() {
        
        callReplayCommments()
    }

    // MARK: - Tableview delegate and datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myAryInfo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell:ViewCommentsTableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellTableListIdentifier) as? ViewCommentsTableViewCell)!
        
        aCell.gBtnReply.isHidden = true
        aCell.gBtnShowMoreReplies.isHidden = true
        
        HELPER.setRoundCornerView(aView: aCell.gViewUserImage)
        aCell.gImgViewUserProfile.setShowActivityIndicator(true)
        aCell.gImgViewUserProfile.setIndicatorStyle(UIActivityIndicatorView.Style.gray)
        var aStrImage = String()
        
        aStrImage = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["profile_image"] as AnyObject) as! String   //myAryInfo[indexPath.row]["profile_image"] as! String
        aCell.gImgViewUserProfile.sd_setImage(with: URL(string: WEB_BASE_URL + aStrImage), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
        
        aCell.gLblUserName.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["name"] as AnyObject) as? String   //myAryInfo[indexPath.row]["name"] as? String
        aCell.gLblUserComments.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["replies"] as AnyObject) as? String   //myAryInfo[indexPath.row]["replies"] as? String
        aCell.gLblCommentTime.text = HELPER.returnStringFromNull(myAryInfo[indexPath.row]["days_ago"] as AnyObject) as? String   //myAryInfo[indexPath.row]["days_ago"] as? String
        
        return aCell
    }
    
    
    // MARK: - Api Call
    func callReplayCommments() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        gStrCommentId = gDictCommentInfo["comment_id"] as! String
        
        var aDictParams = [String:String]()
        aDictParams["comment_id"] = gStrCommentId
        
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_USER_COMMENTS_REPLY_LIST, dictParameters: aDictParams, sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            
            var aDictResponses = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponses[kRESPONSE_MESSAGE]
            let aIntResponseCode = aDictResponses[kRESPONSE_CODE]
            
            if Int(aIntResponseCode!) == kRESPONSE_CODE_DATA {
                
                var aDictResponse = [String:Any]()
                aDictResponse = response["data"] as! [String : Any]
                
                self.myAryInfo = aDictResponse["replies_list"] as! [[String : Any]]
                self.myTblView.reloadData()
            }
                
            else if Int(aIntResponseCode!) == kRESPONSE_CODE_VALIDATION {
                
                HELPER.hideLoadingAnimation()
                self.myAryInfo = [[String:Any]] ()
                self.myTblView.isHidden = true
                //                    self.myContainerViewNodata.isHidden = false
                self.myTblView.reloadData()
                
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
                
            else {
                
                HELPER.hideLoadingAnimation()
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
            
        }) { (String) in
            
            HELPER.hideLoadingAnimation()
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: String)
        }
    }
    
    //Post Comment For replay button
    func callSendReplayCommments() {
        if !HELPER.isConnectedToNetwork() {
                   
                   HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                   return
               }
        var aDictParams = [String:String]()
        aDictParams["p_id"] = gDictCommentInfo["provider_id"] as? String
        aDictParams["comment_id"] = gDictCommentInfo["comment_id"] as? String
        aDictParams["replies"] = myTxtFldComments.text
        
        if self.myAryInfo.count == 0 {
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        }
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_ADD_USER_COMMENTS_REPLIES, dictParameters: aDictParams, sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            
            var aDictResponses = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponses[kRESPONSE_MESSAGE]
            let aIntResponseCode = aDictResponses[kRESPONSE_CODE]
            
            if Int(aIntResponseCode!) == kRESPONSE_CODE_DATA {
                
                self.myTxtFldComments.resignFirstResponder()
                self.myTxtFldComments.text = ""
                
                var aDictResponse = [String:Any]()
                aDictResponse = response["data"] as! [String : Any]
                
                self.myAryInfo.insert(aDictResponse, at: 0)
                self.myTblView.reloadData()
            }
                
            else if Int(aIntResponseCode!) == kRESPONSE_CODE_VALIDATION {
                
                HELPER.hideLoadingAnimation()
                self.myAryInfo = [[String:Any]] ()
                self.myTblView.isHidden = true
                //                    self.myContainerViewNodata.isHidden = false
                self.myTblView.reloadData()
                
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
                
            else {
                
                HELPER.hideLoadingAnimation()
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
            
        }) { (String) in
            
            HELPER.hideLoadingAnimation()
            HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: String)
        }
    }

    // MARK: - Button Action
    @IBAction func btnSendTapped(_ sender: Any) {
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        if myTxtFldComments.text?.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_REQUIRED_FIELDS)
        }
        else {
            
                callSendReplayCommments()
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
    
    func changeLanguageContent() {
        
        var aDictLangInfo = SESSION.getLangInfo()
        var aDictScreenTitle = [String:Any]()
        aDictScreenTitle = aDictLangInfo["navigation"] as! [String : Any]
        aDictLanguageCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
    }
}
