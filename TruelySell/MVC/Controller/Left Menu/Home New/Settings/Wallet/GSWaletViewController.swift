//
//  GSWaletViewController.swift
//  Gigs
//
//  Created by Leo Chelliah on 17/09/19.
//  Copyright © 2019 dreams. All rights reserved.
//

import UIKit
import Stripe

class GSWaletViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var transactionTbleView: UITableView!
    @IBOutlet weak var myLblNoTransactions: UILabel!
    
    var myAryWalletHistory = [[String:Any]]()
    var myDictWalletInfo = [String:Any]()
    var gBoolIsFromBooking : Bool = false
    let cellIdentifier: String = "GSWalletTableViewCell"
    let walletBalanceCellIdentifier: String = "WalletBalanceTableViewCell"
    var myIntTotalPage = Int()
    var currentIndex = 1
    var isLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NAVIGAION.setNavigationTitle(aStrTitle: WalletContent.WALLET_TITLE.titlecontent(), aViewController: self)
        myLblNoTransactions.isHidden = true
        setUpLeftBarBackButton()
        getWalletTransactionHistory()
    }
    
    func setUpUI(){
        setUpLeftBarBackButton()
        transactionTbleView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        transactionTbleView.register(UINib.init(nibName: walletBalanceCellIdentifier, bundle: nil), forCellReuseIdentifier: walletBalanceCellIdentifier)
        transactionTbleView.delegate = self
        transactionTbleView.dataSource = self
    }
    
    // MARK: - Tanleview Delegates and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  section == 0  {
            if  myDictWalletInfo.count != 0 {
                return 1
            } else {
                return 0
            }
        }
        else {
            return myAryWalletHistory.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if SESSION.getUserLogInType() == "1" {
                return 230
            }
            else {
                return 160
            }
            
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return WalletContent.TRANS_HISTORY.titlecontent()
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        headerView.backgroundView?.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: walletBalanceCellIdentifier, for: indexPath) as! WalletBalanceTableViewCell
            if SESSION.getUserLogInType() == "1" {
                cell.addBtnViewBG.isHidden = true
                cell.myViewWithDrawFund.isHidden = false
                
                cell.myViewBottomSpaceNSLayoutConstraint.constant = 70
                cell.myViewWithDrawFund.layer.cornerRadius = cell.myViewWithDrawFund.frame.height / 2
                
                cell.gLblTitleWithdrawFund.text = WalletContent.WITHDRAW_FUND.titlecontent()
                cell.myBtnWithDrawFund.addTarget(self, action: #selector(presentAddCashVC), for: .touchUpInside)
            }
            else {
                cell.addBtnViewBG.isHidden = false
                cell.myViewWithDrawFund.isHidden = true
                cell.myViewBottomSpaceNSLayoutConstraint.constant = 20
                cell.amountAddBtn.addTarget(self, action: #selector(presentAddCashVC), for: .touchUpInside)
            }
            
            cell.gLblTitleWalletBalance.text = WalletContent.TOT_WALLET_BAL.titlecontent()
            cell.topBarViewBG.layer.cornerRadius = 15
            cell.topBarViewBG.clipsToBounds = true
            cell.walletBalanceViewBG.layer.cornerRadius = 10
            cell.walletBalanceViewBG.clipsToBounds = true
            cell.walletIconViewBG.layer.cornerRadius = cell.walletIconViewBG.frame.width/2
            cell.walletIconViewBG.clipsToBounds = true
            cell.walletSubViewBG.layer.cornerRadius = 15
            cell.walletSubViewBG.clipsToBounds = true
            cell.addBtnViewBG.layer.cornerRadius = cell.addBtnViewBG.frame.width/2
            cell.addBtnViewBG.clipsToBounds = true
            
            
            let aStrCurrency = (myDictWalletInfo["currency"] as? String)!
            cell.myLblWalletBalance.text = aStrCurrency.html2String + ((myDictWalletInfo["wallet_amt"] as? String)!)
            cell.myLblWalletBalance.textColor = HELPER.hexStringToUIColor(hex: "#57606F")
            return cell
        }
        else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GSWalletTableViewCell
            
            cell.myLblReason.text = HELPER.returnStringFromNull(myAryWalletHistory[indexPath.row]["reason"] as AnyObject) as? String  //myAryWalletHistory[indexPath.row]["reason"] as? String
            let aStrCurrency = HELPER.returnStringFromNull(myAryWalletHistory[indexPath.row]["currency"] as AnyObject) as! String  //(myAryWalletHistory[indexPath.row]["currency"] as? String)!
            let aStrTotalAmount = "\(myAryWalletHistory[indexPath.row]["total_amt"]!)" //HELPER.returnStringFromNull(myAryWalletHistory[indexPath.row]["total_amt"] as AnyObject) as! String  //(myAryWalletHistory[indexPath.row]["total_amt"] as? String)!
            let aStrTaxAmount = "\(myAryWalletHistory[indexPath.row]["txt_amt"]!)" //HELPER.returnStringFromNull(myAryWalletHistory[indexPath.row]["txt_amt"] as AnyObject) as! String  //(myAryWalletHistory[indexPath.row]["txt_amt"] as? String)!
            let aStrCreatedDate = HELPER.returnStringFromNull(myAryWalletHistory[indexPath.row]["created_at"] as AnyObject) as! String  //(myAryWalletHistory[indexPath.row]["created_at"] as? String)!
            //RTL
            cell.myLblTotalAmount.text = WalletContent.TOT_AMT.titlecontent() + aStrCurrency.html2String + aStrTotalAmount
            cell.myLblTaxAmount.text = WalletContent.TAX_AMT.titlecontent() + aStrCurrency.html2String + aStrTaxAmount
            cell.myViewCardIcon.layer.cornerRadius = cell.myViewCardIcon.frame.height / 2
            let dateInputFormat = DateFormatter()
            dateInputFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateInputFormat.date(from: aStrCreatedDate)
            let dateOutputFormat = DateFormatter()
            dateOutputFormat.dateFormat = WEB_DATE_FORMAT
            dateOutputFormat.string(from: date!)
            print(dateOutputFormat.string(from: date!))
            cell.myLblDateCreated.text = dateOutputFormat.string(from: date!)
            let strCreditWallet = myAryWalletHistory[indexPath.row]["credit_wallet"] as? String
            if strCreditWallet == "0.00" ||  strCreditWallet == "0" {
                cell.myLblTransactionAmt.text = aStrCurrency.html2String  +  "\(myAryWalletHistory[indexPath.row]["debit_wallet"]!)"
                cell.myLblTransactionAmt.textColor = HELPER.hexStringToUIColor(hex: DEBIT_COLOR)
                cell.myImgTransactionIcon.image = UIImage(named: "icon_downarrow")
            }
            else {
                cell.myLblTransactionAmt.text = aStrCurrency.html2String  +  "\(myAryWalletHistory[indexPath.row]["credit_wallet"]!)"
                cell.myLblTransactionAmt.textColor = HELPER.hexStringToUIColor(hex: CREDIT_COLOR)
                cell.myImgTransactionIcon.image = UIImage(named: "icon_uparrow")
                
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let aViewController = WalletTransactionDetailsViewController()
            aViewController.strTransId = (myAryWalletHistory[indexPath.row]["id"] as? String)!
            self.navigationController?.pushViewController(aViewController, animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           
           if (offsetY > contentHeight - scrollView.frame.height * 4)  {
              
               if currentIndex <= myIntTotalPage && currentIndex != -1 && myIntTotalPage != 0 && isLoading {
                   isLoading = false
                   getWalletTransactionHistory()
               }
           }
       }
    // MARK: - Api call
    func getWalletTransactionHistory() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["counts_per_page"] = "10"
        aDictParams["current_page"] = String(currentIndex)
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_WALLET_TRANSACTION_HISTORY,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String : Any]
                    let myWalletInfo = aDictResponseData["wallet_info"] as! [String : Any]
                    self.myAryWalletHistory = myWalletInfo["wallet_history"] as! [[String : Any]]
                    
                    self.myDictWalletInfo = myWalletInfo["wallet"] as! [String : Any]
                    if self.myAryWalletHistory.count != 0 {
                        let aDictPagess = aDictResponseData["pages"] as? [String : Any]
                        self.myIntTotalPage = Int(aDictPagess!["total_pages"] as? String ?? "0")!
                        if  self.currentIndex == self.myIntTotalPage || self.myIntTotalPage == 0 {
                            self.isLoading = false
                           
                        } else {
                            self.isLoading = true
                        }
                        
                        self.currentIndex = Int(aDictPagess!["next_page"] as? String ?? "0")!
                        self.myLblNoTransactions.isHidden = true
                        self.transactionTbleView.reloadData()
                        HELPER.hideLoadingAnimation()
                    }
                    else {
                        
                        self.myLblNoTransactions.isHidden = false
                        self.myLblNoTransactions.text = WalletContent.NO_TRANS_FOUND.titlecontent()
                        self.transactionTbleView.reloadData()
                    }
                    
                    
                    //                    if self.myAryWalletHistory.count == 0 {
                    //                        self.myLblNoTransactions.isHidden = false
                    //                    }
                    //                    self.transactionTbleView.reloadData()
                    HELPER.hideLoadingAnimation()
                    
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
    
 
    // MARK:- Button actions
    
    
    @objc func presentAddCashVC() {
        //        userStripeKey()
        let aViewController = GSAddCashViewController()
        let aStrCurrency = (myDictWalletInfo["currency"] as? String)!
        let aStrWalletAmt = (myDictWalletInfo["wallet_amt"] as? String)!
        let aStrCurrencyCode = (myDictWalletInfo["currency_code"] as? String)!
        //          let aStrBankDetails = myDictWalletInfo["bank_details"] as! String
        //        let aStrWalletAmt = aStrCurrency.html2String + ((myDictWalletInfo["wallet_amt"] as? String)!)
        aViewController.aStrWalletAmt = aStrWalletAmt
        aViewController.aStrCurrency  = aStrCurrency
        aViewController.aStrCurrencyCode = aStrCurrencyCode
        //         aViewController.gStrBankDetails = aStrBankDetails
        self.navigationController?.pushViewController(aViewController, animated: true)
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
        if gBoolIsFromBooking {
            APPDELEGATE.loadTabbar()
        }
        else {
        self.navigationController?.popViewController(animated: true)
        }
    }
    
  
    
}
