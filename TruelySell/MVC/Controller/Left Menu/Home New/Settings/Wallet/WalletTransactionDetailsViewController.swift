//
//  WalletTransactionDetailsViewController.swift
//  TruelySell
//
//  Created by DreamGuys Tech on 04/02/21.
//  Copyright © 2021 dreams. All rights reserved.
//

import UIKit

class WalletTransactionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet var myTblView: UITableView!
    
    let ProfileHeaderTableViewCellIdentifier = "ProfileHeaderTableViewCell"
    let cellProfile = "MyProfileTableViewCell"

    var strTransId = String()
    var myAry = [String]()
    var myDictData = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
       
        // Do any additional setup after loading the view.
    }
    
    func setUpUI() {
        
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: ProfileHeaderTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: ProfileHeaderTableViewCellIdentifier)
        myTblView.register(UINib.init(nibName: cellProfile, bundle: nil), forCellReuseIdentifier: cellProfile)
        myAry = [String]()
    }
    
    func setUpModel() {
        getProfileDetailsUserFromApi()
        setUpLeftBarBackButton()
     
    }
    
    func loadModel() {
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAry.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let aCell:ProfileHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: ProfileHeaderTableViewCellIdentifier) as? ProfileHeaderTableViewCell
        
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell?.gLblHeader.textAlignment = .right
        }
        else {
            aCell?.gLblHeader.textAlignment = .left
        }
       
            aCell?.gLblHeader.text = WalletContent.WALLET_PAYMENT_HISTORY.titlecontent()
            aCell?.gLblHeader.font = UIFont.boldSystemFont(ofSize: 14)
            aCell?.gViewSameAsContainer.isHidden = true
       
        return aCell
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellProfile, for: indexPath) as! MyProfileTableViewCell
        if myAry[indexPath.row] == "Cerdit Wallet" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["credit_wallet"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Debit Wallet" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["debit_wallet"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Date" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["created_at"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Reason" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["reason"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Service" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["service_title"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Location" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["location"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Amount" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["amount"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Paid Status" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["paid_status"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Total Amount" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["total_amt"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Free Amount" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["fee_amt"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Net Amount" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["net_amt"] as AnyObject) as? String
        }
        else if myAry[indexPath.row] == "Amount Refund" {
            aCell.gTextfield.text = HELPER.returnStringFromNull(myDictData["amount_refund"] as AnyObject) as? String
        }
        else {
            aCell.gTextfield.text = ""
        }
        
  
        aCell.gLabel.text = myAry[indexPath.row]
        aCell.gLabel.textColor = UIColor.black
        aCell.gTextfield.textColor = UIColor.black
        aCell.gTextfield.isUserInteractionEnabled = false
        aCell.subscription_btn_width.constant = 0
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell.gTextfield.textAlignment = .right
            aCell.gLabel.textAlignment = .right
        }
        else {
            aCell.gTextfield.textAlignment = .left
            aCell.gLabel.textAlignment = .left
        }
        return aCell
    }
    
        
        //MARK:- Api call
        
        func getProfileDetailsUserFromApi() {
            if !HELPER.isConnectedToNetwork() {
                
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                return
            }
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
            
            var aDictParams = [String:String]()
            aDictParams["wallet_txn_id"] = strTransId
            HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_TRANSACTION_DETAIL,dictParameters:aDictParams, sucessBlock: { response in
                HELPER.hideLoadingAnimation()
                
                if response.count != 0 {
                    
                    var aDictResponse = response[kRESPONSE] as! [String : String]
                    
                    let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                    
                    if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                        
                        var aDictResponseData = [String:Any]()
                        aDictResponseData = response["data"] as! [String:Any]
                        self.myDictData = aDictResponseData
                        print(aDictResponseData)
                        if self.myDictData["reason"] as! String == "Wallet Top Up" {
                            self.myAry = ["Cerdit Wallet", "Debit Wallet" , "Date", "Reason", "Amount", "Paid Status", "Total Amount", "Free Amount", "Net Amount", "Amount Refund"]
                        }
                        else {
                            self.myAry = ["Cerdit Wallet", "Debit Wallet" , "Date", "Reason", "Service", "Location", "Amount", "Paid Status", "Total Amount", "Free Amount", "Net Amount", "Amount Refund"]
//                            self.myAry = ["User Name", "Provider Name", "Service Title", "Location", "Cerdit Wallet", "Debit Wallet" , "Date", "Reason", "Service", "Location", "Amount", "Reason", "Paid Status", "Total Amount", "Free Amount", "Net Amount", "Amount Refund"]
                        }
                      
                        self.myTblView.reloadData()
                    }
                    else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                        
                    }
                    else {
                        HELPER.hideLoadingAnimation()
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
    
   
}
