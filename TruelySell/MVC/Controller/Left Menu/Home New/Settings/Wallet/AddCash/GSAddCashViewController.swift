

import UIKit
import Stripe
import Braintree
import Razorpay
import Paystack


class GSAddCashViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,BTViewControllerPresentingDelegate, BTAppSwitchDelegate, RazorpayPaymentCompletionProtocol,PSTCKPaymentCardTextFieldDelegate {
    
    
    @IBOutlet weak var myTblView: UITableView!
    
    let walletTopupCurrentBalanceCellIdentifier: String = "WalletTopupCurrentBalanceTableViewCell"
    let walletAddCashCellIdentifier: String = "WalletAddCashTableViewCell"
    let walletAddNewCardCellIdentifier: String = "AddNewCardTableViewCell"
    let walletWithdrawCashIdentifier: String = "GSWithdrawCashTableViewCell"
    let PaymentGateWaysTableViewCellIdentifier: String = "PaymentGateWaysTableViewCell"
    
    let TAG_CARD_NUMBER = 1000
    let TAG_CARD_EXPIRY_DATE = 2000
    let TAG_CARD_CVV = 3000
    let TAG_ADD_CASH = 4000
    let cardParams = PSTCKCardParams.init()
    var myStrCardNo = String()
    var myStrCardCvv = String()
    var myStrCardExp = String()
    
    var strTotalAmont = String()
    var aStrWalletAmt = String()
    var aStrCurrency = String()
    var aStrCurrencyCode = String()
    var gStrBankDetails = String()
    var myDictWalletInfo = [String:Any]()
    var strBraintreeClientId = String()
    var strPayStackKey = String()
    
    var gBoolPayPallSelected = Bool()
    var gPaymentStatus = String()
    var braintreeClient: BTAPIClient?
    
    var myStrPayPallEnabled = String()
    var myStrStripeEnabled = String()
    var myStrRazorPayEnabled = String()
    var myStrPayStackEnabled = String()
    var myStrPaySolutionsEnabled = String()
    var myStrMerchantId = String()
    var myArrPayment = [String]()
    var razorpay: RazorpayCheckout!
    
    
    var strEmail = String()
    var strReference = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if SESSION.getUserLogInType() == "1" {
            NAVIGAION.setNavigationTitle(aStrTitle: WalletContent.WITHDRAW_WALLET_TITLE.titlecontent(), aViewController: self)
        }
        else {
            NAVIGAION.setNavigationTitle(aStrTitle: WalletContent.TOPUP_WALLET_TITLE.titlecontent(), aViewController: self)
        }
        
        setUpLeftBarBackButton()
        getWalletTransactionHistory()
        getuserKey()
    }
    
    func setUpUI() {
        
        setUpLeftBarBackButton()
//        getClientId()
        //        setTopBarView()
        
        myTblView.register(UINib.init(nibName: walletTopupCurrentBalanceCellIdentifier, bundle: nil), forCellReuseIdentifier: walletTopupCurrentBalanceCellIdentifier)
        myTblView.register(UINib.init(nibName: walletAddCashCellIdentifier, bundle: nil), forCellReuseIdentifier: walletAddCashCellIdentifier)
        myTblView.register(UINib.init(nibName: walletAddNewCardCellIdentifier, bundle: nil), forCellReuseIdentifier: walletAddNewCardCellIdentifier)
        myTblView.register(UINib.init(nibName: walletWithdrawCashIdentifier, bundle: nil), forCellReuseIdentifier: walletWithdrawCashIdentifier)
        myTblView.register(UINib.init(nibName: PaymentGateWaysTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: PaymentGateWaysTableViewCellIdentifier)
      
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.reloadData()
        
    }
    
    // MARK: - Tableview Delegates and datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if SESSION.getUserLogInType() == "1" {
//            return 3
            return 4
        }
        else {
            return 4
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        }
        else if indexPath.section == 1 {
            return 110
        }
        else {
            if SESSION.getUserLogInType() == "1" {
                if indexPath.section == 2 {
                    return CGFloat((myArrPayment.count) * 45)
                }
                return 60
            }
            else {
                if indexPath.section == 2 {
                    return CGFloat(myArrPayment.count * 45)
                }
                else {
                    if gPaymentStatus == "1" {
                        return 260
                    }
                   else if gPaymentStatus == "3" {
                        return 260
                    }
                    return 60
                    
                }
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        else if section == 1 {
            return 30
        }
        else {
            if SESSION.getUserLogInType() == "1" {
                if section == 2 {
                    return 30

                }
                return 0
            }
            else {
                if section == 2 {
                    return 30
                    
                }
                else {
                    if gPaymentStatus == "1" {
                        return 30
                    }
                    else if gPaymentStatus == "3" {
                        return 30
                    }
                    return 0
                    
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
      
        let headerView = view as! UITableViewHeaderFooterView
        
        if section == 1 {
            headerView.textLabel?.text = WalletContent.ADD_CASH.titlecontent()
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
        if section == 2 {
            headerView.textLabel?.text = WalletContent.SELECT_PAYMENT_METHOD.titlecontent()
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
        if section == 3 {
            headerView.textLabel?.text = WalletContent.ADD_CARD.titlecontent()
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        headerView.tintColor = UIColor.white
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: walletTopupCurrentBalanceCellIdentifier, for: indexPath) as! WalletTopupCurrentBalanceTableViewCell
            
            cell.gViewWalletView.layer.cornerRadius = cell.gViewWalletView.frame.height / 2
            cell.gLblWalletBalenceHeading.text = WalletContent.CURRENT_BAL.titlecontent()
            cell.gImgWalletIcon.image = UIImage(named: "wallet-icon")
            let aCurrentBalance = aStrCurrency.html2String + aStrWalletAmt
            cell.gLblCurrentBalance.text = aCurrentBalance
            
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                cell.gLblCurrentBalance.textAlignment = .left
            }
            else {
                cell.gLblCurrentBalance.textAlignment = .right
            }
            return cell
            
        }
        
        else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: walletAddCashCellIdentifier, for: indexPath) as! WalletAddCashTableViewCell
            
            cell.gBtnOneThousand.layer.cornerRadius = cell.gBtnOneThousand.frame.height / 2
            cell.gBtnOneThousand.setTitle("1,000", for: .normal)
            cell.gBtnOneThousand.setTitleColor(UIColor.white, for: .normal)
            
            cell.gBtnTwoThousand.layer.cornerRadius = cell.gBtnTwoThousand.frame.height / 2
            cell.gBtnTwoThousand.setTitle("2,000", for: .normal)
            cell.gBtnTwoThousand.setTitleColor(UIColor.white, for: .normal)
            
            cell.gBtnThreeThousand.layer.cornerRadius = cell.gBtnThreeThousand.frame.height / 2
            cell.gBtnThreeThousand.setTitle("3,000", for: .normal)
            cell.gBtnThreeThousand.setTitleColor(UIColor.white, for: .normal)
            
            cell.gViewTxtFld.layer.borderWidth = 1
            cell.gViewTxtFld.layer.borderColor = UIColor.lightGray.cgColor
            cell.gViewTxtFld.layer.cornerRadius = 10
            
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                cell.gTxtFldCash.textAlignment = .right
            }
            else {
                cell.gTxtFldCash.textAlignment = .left
            }
            
            if strTotalAmont != "" {
                cell.gTxtFldCash.text  = strTotalAmont
            }
            
            cell.gTxtFldCash.delegate = self
            cell.gTxtFldCash.tag =  TAG_ADD_CASH
            cell.gBtnOneThousand.addTarget(self, action: #selector(addingOneThousandAmt), for: .touchUpInside)
            cell.gBtnTwoThousand.addTarget(self, action: #selector(addingTwoThousandAmt), for: .touchUpInside)
            cell.gBtnThreeThousand.addTarget(self, action: #selector(addingThreeThousandAmt), for: .touchUpInside)
            
            return cell
            
        }
            
        else {
            
            if SESSION.getUserLogInType() == "1" {
                if indexPath.section == 2 {

                    let aCell = tableView.dequeueReusableCell(withIdentifier: PaymentGateWaysTableViewCellIdentifier, for: indexPath) as! PaymentGateWaysTableViewCell

                    aCell.gLblPayPall.text = "PayPal"//WalletContent.PAYPAL.titlecontent()
                    aCell.gLblStripe.text = "Stripe"//WalletContent.STRIPE.titlecontent()
                    aCell.gLblRazorPay.text = "RazorPay"
                    aCell.gLblPayStack.text = "PayStack"
                    aCell.gLblPaySolutions.text = "PaySolutions"
                    if gPaymentStatus == "0" {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_tick_gray")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
                    }
                    else if gPaymentStatus == "1" {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_tick_gray")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
                    }
                    else if gPaymentStatus == "2" {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_tick_gray")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
                    }
                    else if gPaymentStatus == "3" {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_tick_gray")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
                    }
                    else if gPaymentStatus == "4" {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_tick_gray")
                    }
                    else {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
                    }

                    if myStrPayPallEnabled == "1" {
                        aCell.gViewPayPallContainer.isHidden = false
                        aCell.gPaypallHeightConstraint.constant = 40
                    }
                    else if myStrPayPallEnabled == "0" {
                        aCell.gViewPayPallContainer.isHidden = true
                         aCell.gPaypallHeightConstraint.constant = 0
                    }
                    if myStrStripeEnabled == "1" {
                        aCell.gViewStripeContainer.isHidden = false
                        aCell.gStripeHeightConstraint.constant = 40
                    }
                    else  if myStrStripeEnabled == "0" {
                        aCell.gViewStripeContainer.isHidden = true
                         aCell.gStripeHeightConstraint.constant = 0
                    }
                    if myStrRazorPayEnabled == "1" {
                        aCell.gViewRazorPayContainer.isHidden = false
                        aCell.gRazorPayHeightConstraint.constant = 40
                    }
                    else if myStrRazorPayEnabled == "0" {
                        aCell.gViewRazorPayContainer.isHidden = true
                        aCell.gRazorPayHeightConstraint.constant = 0
                    }
                    if myStrPayStackEnabled == "1" {
                        aCell.gViewPayStack.isHidden = false
                        aCell.gPayStackHeightConstraint.constant = 40
                    }
                    else if myStrPayStackEnabled == "0" {
                        aCell.gViewPayStack.isHidden = true
                        aCell.gPayStackHeightConstraint.constant = 0
                    }
                    aCell.gViewPaysolutions.isHidden = true
                    aCell.gPaySolutionsHeightConstraint.constant = 0

                    aCell.gBtnPayPal.addTarget(self, action: #selector(PayPallBtnTapped), for: .touchUpInside)
                    aCell.gBtnStripe.addTarget(self, action: #selector(StripeBtnTapped), for: .touchUpInside)
                    aCell.gBtnRazorPay.addTarget(self, action: #selector(RazorPayBtnTapped), for: .touchUpInside)
                    aCell.gBtnPayStack.addTarget(self, action: #selector(PayStackBtnTapped), for: .touchUpInside)
                    aCell.gBtnPaySolutions.addTarget(self, action: #selector(PaySolutionsBtnTapped), for: .touchUpInside)
                    return aCell

                }
                else {
                let aCell = tableView.dequeueReusableCell(withIdentifier: walletWithdrawCashIdentifier, for: indexPath) as! GSWithdrawCashTableViewCell
                
                aCell.gViewWithdrawContainer.layer.cornerRadius = aCell.gViewWithdrawContainer.layer.frame.height / 2
                aCell.gViewWithdrawContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                aCell.gBtnWithdrawCash.setTitle(WalletContent.WITHDRAW_CASH.titlecontent(), for: .normal)
                aCell.gBtnWithdrawCash.setTitleColor(UIColor.white, for: .normal)
                aCell.gBtnWithdrawCash.addTarget(self, action: #selector(AddCashBtnTapped), for: .touchUpInside)
                return aCell
                }
                
            }
                
            else {
                if indexPath.section == 2 {
                    
                    let aCell = tableView.dequeueReusableCell(withIdentifier: PaymentGateWaysTableViewCellIdentifier, for: indexPath) as! PaymentGateWaysTableViewCell
                    
                    aCell.gLblPayPall.text = "PayPal"//WalletContent.PAYPAL.titlecontent()
                    aCell.gLblStripe.text = "Stripe"//WalletContent.STRIPE.titlecontent()
                    aCell.gLblRazorPay.text = "RazorPay"
                    aCell.gLblPayStack.text = "PayStack"
                    aCell.gLblPaySolutions.text = "PaySolutions"
                    
                    if gPaymentStatus == "0" {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_tick_gray")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
                    }
                    else if gPaymentStatus == "1" {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_tick_gray")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
                    }
                    else if gPaymentStatus == "2" {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_tick_gray")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
                    }
                    else if gPaymentStatus == "3" {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_tick_gray")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
                    }
                    else if gPaymentStatus == "4" {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_tick_gray")
                    }
                    
                    else {
                        aCell.gImgPayPallRadioImg.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gRadioImgStripe.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioRazorPay.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgRadioPayStack.image = UIImage(named: "icon_radio_untick_blue")
                        aCell.gImgPaysolutions.image = UIImage(named: "icon_radio_untick_blue")
                    }
                    if myStrPayPallEnabled == "1" {
                        aCell.gViewPayPallContainer.isHidden = false
                        aCell.gPaypallHeightConstraint.constant = 40
                    }
                    else if myStrPayPallEnabled == "0" {
                        aCell.gViewPayPallContainer.isHidden = true
                         aCell.gPaypallHeightConstraint.constant = 0
                    }
                    if myStrStripeEnabled == "1" {
                        aCell.gViewStripeContainer.isHidden = false
                        aCell.gStripeHeightConstraint.constant = 40
                    }
                    else  if myStrStripeEnabled == "0" {
                        aCell.gViewStripeContainer.isHidden = true
                         aCell.gStripeHeightConstraint.constant = 0
                    }
                    if myStrRazorPayEnabled == "1" {
                        aCell.gViewRazorPayContainer.isHidden = false
                        aCell.gRazorPayHeightConstraint.constant = 40
                    }
                    else if myStrRazorPayEnabled == "0" {
                        aCell.gViewRazorPayContainer.isHidden = true
                        aCell.gRazorPayHeightConstraint.constant = 0
                    }
                    if myStrPayStackEnabled == "1" {
                        aCell.gViewPayStack.isHidden = false
                        aCell.gPayStackHeightConstraint.constant = 40
                    }
                    else if myStrPayStackEnabled == "0" {
                        aCell.gViewPayStack.isHidden = true
                        aCell.gPayStackHeightConstraint.constant = 0
                    }
                    if myStrPaySolutionsEnabled == "1" {
                        aCell.gViewPaysolutions.isHidden = false
                        aCell.gPaySolutionsHeightConstraint.constant = 40
                    }
                    else if myStrPaySolutionsEnabled == "0" {
                        aCell.gViewPaysolutions.isHidden = true
                        aCell.gPaySolutionsHeightConstraint.constant = 0
                    }
                    
                    aCell.gBtnPayPal.addTarget(self, action: #selector(PayPallBtnTapped), for: .touchUpInside)
                    aCell.gBtnStripe.addTarget(self, action: #selector(StripeBtnTapped), for: .touchUpInside)
                    aCell.gBtnRazorPay.addTarget(self, action: #selector(RazorPayBtnTapped), for: .touchUpInside)
                    aCell.gBtnPayStack.addTarget(self, action: #selector(PayStackBtnTapped), for: .touchUpInside)
                    aCell.gBtnPaySolutions.addTarget(self, action: #selector(PaySolutionsBtnTapped), for: .touchUpInside)
                    return aCell
                    
                }
                    
                else {
                    
                    if gPaymentStatus == "1" || gPaymentStatus == "3" {
                        let aCell = tableView.dequeueReusableCell(withIdentifier: walletAddNewCardCellIdentifier, for: indexPath) as! AddNewCardTableViewCell
                        
                        aCell.gViewAddCash.layer.cornerRadius = aCell.gViewAddCash.frame.height / 2
                        aCell.gViewAddCash.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                        aCell.gViewContainer.layer.borderWidth = 1
                        aCell.gViewContainer.layer.borderColor = UIColor.lightGray.cgColor
                        aCell.gViewContainer.layer.cornerRadius = 10
                        
                        aCell.gViewCardNumberContainer.layer.cornerRadius = 5
                        aCell.gViewCardNumberContainer.layer.borderWidth = 0.3
                        aCell.gViewCardNumberContainer.layer.borderColor = UIColor.lightGray.cgColor
                        
                        aCell.gViewCardExpiryContainer.layer.cornerRadius = 5
                        aCell.gViewCardExpiryContainer.layer.borderWidth = 0.3
                        aCell.gViewCardExpiryContainer.layer.borderColor = UIColor.lightGray.cgColor
                        
                        
                        
                        aCell.gViewCvvContainer.layer.cornerRadius = 5
                        aCell.gViewCvvContainer.layer.borderWidth = 0.3
                        aCell.gViewCvvContainer.layer.borderColor = UIColor.lightGray.cgColor
                        //            aCell.gLblDebitCreditCard.text = "Debit / Credit Card"
                        aCell.gLblCardExpiry.text = WalletContent.CARD_EXP.titlecontent()
                        aCell.gLblCVV.text = WalletContent.CARD_CVV.titlecontent()
                        aCell.gLblPrivacyMsg.text = WalletContent.PRIVACY_MSG.titlecontent()
                        aCell.gLblDebitCreditCard.text = WalletContent.DEBIT_CREDIT_CARD.titlecontent()
                        if SESSION.getUserLogInType() == "1" {
                            aCell.gBtnAddCash.setTitle(WalletContent.WITHDRAW_CASH.titlecontent() , for: .normal)
                        }
                            
                            
                        else {
                            aCell.gBtnAddCash.setTitle(WalletContent.ADD_CASH_SECURE.titlecontent() , for: .normal)
                            
                        }
                        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                            aCell.gTxtFldCardNumber.textAlignment = .right
                            aCell.gTxtFldExpiry.textAlignment = .right
                            aCell.gTxtFldCvv.textAlignment = .right
                        }
                        else {
                            aCell.gTxtFldCardNumber.textAlignment = .left
                            aCell.gTxtFldExpiry.textAlignment = .left
                            aCell.gTxtFldCvv.textAlignment = .left
                        }
                        aCell.gBtnAddCash.addTarget(self, action: #selector(AddCashBtnTapped), for: .touchUpInside)
                        
                        HELPER.translateTextField(textField: aCell.gTxtFldCardNumber, key: "txt_fld_card_num", inPage: "wallet_screen", isPlaceHolderEnabled: true)
                        HELPER.translateTextField(textField: aCell.gTxtFldExpiry, key: "txt_fld_exp_mnth", inPage: "wallet_screen", isPlaceHolderEnabled: true)
                        HELPER.translateTextField(textField: aCell.gTxtFldCvv, key: "txt_fld_cvv", inPage: "wallet_screen", isPlaceHolderEnabled: true)
      
                        aCell.gTxtFldCardNumber.tag = TAG_CARD_NUMBER
                        aCell.gTxtFldCardNumber.inputType = .integer
                        aCell.gTxtFldCardNumber.formatter = CardNumberFormatter()
                        
                        var validation = Validation()
                        validation.maximumLength = "1234 5678 1234 5678".count
                        validation.minimumLength = "1234 5678 1234 5678".count
                        let characterSet = NSMutableCharacterSet.decimalDigit()
                        characterSet.addCharacters(in: " ")
                        validation.characterSet = characterSet as CharacterSet
                        let inputValidator = InputValidator(validation: validation)
                        aCell.gTxtFldCardNumber.inputValidator = inputValidator
                        
                        aCell.gTxtFldExpiry.tag = TAG_CARD_EXPIRY_DATE
                        aCell.gTxtFldExpiry.inputType = .integer
                        aCell.gTxtFldExpiry.formatter = CardExpirationDateFormatter()
                                                
                        var validation1 = Validation()
                        validation1.minimumLength = 1
                        let inputValidator1 = CardExpirationDateInputValidator(validation: validation1)
                        aCell.gTxtFldExpiry.inputValidator = inputValidator1
                        
                        aCell.gTxtFldCvv.tag = TAG_CARD_CVV
                        aCell.gTxtFldCvv.inputType = .integer
                        
                        
                        var validation2 = Validation()
                        validation2.maximumLength = "CVVV".count
                        validation2.minimumLength = "CVV".count
                        validation2.characterSet = NSCharacterSet.decimalDigits
                        let inputValidator2 = InputValidator(validation: validation2)
                        aCell.gTxtFldCvv.inputValidator = inputValidator2
                        
                        return aCell
                    }
                        
//                    else if gPaymentStatus == "2" {
//
//                        let aCell = tableView.dequeueReusableCell(withIdentifier: walletWithdrawCashIdentifier, for: indexPath) as! GSWithdrawCashTableViewCell
//
//                        aCell.gViewWithdrawContainer.layer.cornerRadius = aCell.gViewWithdrawContainer.layer.frame.height / 2
//                        aCell.gViewWithdrawContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
//                        aCell.gBtnWithdrawCash.setTitle(WalletContent.ADD_CASH_SECURE.titlecontent(), for: .normal)
//                        aCell.gBtnWithdrawCash.setTitleColor(UIColor.white, for: .normal)
//                        aCell.gBtnWithdrawCash.addTarget(self, action: #selector(AddCashRazorPayBtnTapped), for: .touchUpInside)
//                        return aCell
//
//                    }
                    else {
                        
                        let aCell = tableView.dequeueReusableCell(withIdentifier: walletWithdrawCashIdentifier, for: indexPath) as! GSWithdrawCashTableViewCell
                     
                        aCell.gViewWithdrawContainer.layer.cornerRadius = aCell.gViewWithdrawContainer.layer.frame.height / 2
                        aCell.gViewWithdrawContainer.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                        aCell.gBtnWithdrawCash.setTitle(WalletContent.ADD_CASH_SECURE.titlecontent(), for: .normal)
                        aCell.gBtnWithdrawCash.setTitleColor(UIColor.white, for: .normal)
                        aCell.gBtnWithdrawCash.addTarget(self, action: #selector(AddCashThroughPayPallRazorPayTapped), for: .touchUpInside)
                        return aCell
                   
                    }
                }
            }
        }
        
    }
    
    // MARK: - Textfield Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.tag == TAG_ADD_CASH {
            
            strTotalAmont = txtAfterUpdate
        }
        
        return true;
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        
        textfield.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // MARK:-  Private Functions
    @objc func doneClicked() {
        
        self.view.endEditing(true)
    }
    
    
    
    
    
    // MARK:-  RazorPay Delegates
    public func onPaymentError(_ code: Int32, description str: String){
        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: CommonTitle.BTN_OK.titlecontent(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
       
    }
    
    public func onPaymentSuccess(_ payment_id: String){
         self.sendToken(tokenId: payment_id, paymentType: "razorpay")
//        let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: CommonTitle.BTN_OK.titlecontent(), style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    // MARK:-  Button Actions
    
    @objc func addingOneThousandAmt(){
        strTotalAmont = "1000"
        myTblView.reloadData()
    }
    
    @objc func addingTwoThousandAmt(){
        strTotalAmont = "2000"
        myTblView.reloadData()        }
    
    @objc func addingThreeThousandAmt(){
        strTotalAmont = "3000"
        myTblView.reloadData()        }
    @objc func PayPallBtnTapped(){
        gBoolPayPallSelected = true
        gPaymentStatus = "0"
        //        UIView.animate(withDuration: 0.4) {
        //            self.myTblView.reloadSections([2], with: .none)
        //             self.myTblView.reloadSections([3], with: .none)
        ////               HELPER.hideLoadingAnimation()
        //                       }
        myTblView.reloadData()
    }
    @objc func StripeBtnTapped(){
        gBoolPayPallSelected = false
        gPaymentStatus = "1"
        //        UIView.animate(withDuration: 0.4) {
        //             self.myTblView.reloadSections([2], with: .none)
        //               self.myTblView.reloadSections([3], with: .none)
        ////               HELPER.hideLoadingAnimation()
        //                       }
        myTblView.reloadData()
    }
    
    @objc func RazorPayBtnTapped(){
        gPaymentStatus = "2"
        myTblView.reloadData()
    }
    @objc func PayStackBtnTapped(){
        gPaymentStatus = "3"
        myTblView.reloadData()
    }
    @objc func PaySolutionsBtnTapped(){
        gPaymentStatus = "4"
        myTblView.reloadData()
    }
      
    @objc func AddCashBtnTapped(){
        let myIntWalletAmount = (aStrWalletAmt as NSString).integerValue
        
        let myIntTotalAmount = (strTotalAmont as NSString).integerValue
        
        if strTotalAmont == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CASH_EMPTY_FIELD.titlecontent())
        }
        else if SESSION.getUserLogInType() == "2" {
            if myIntTotalAmount <= 1 {
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_ENTER_AMOUNT_GREATER_THAN_ONE.titlecontent())
            }
            else {
                sendBookingToApi()
            }
        }
        else  {
            if myIntTotalAmount  > myIntWalletAmount  {
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_ENTER_AMOUNT_LESS_THAN_WALLET_AMOUNT.titlecontent() )
            }
            else if myIntTotalAmount <= 1{
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_ENTER_AMOUNT_GREATER_THAN_ONE.titlecontent())
            }
            else {
                gStrBankDetails = myDictWalletInfo["stripe_bank"] as? String ?? "0"
                if gStrBankDetails == "0" {
                    let aViewController = GSStripeViewController()
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if gStrBankDetails == "1" {
                    withdrawCashToApi()
                }
            }
        }
    }
    
    @objc func AddCashThroughPayPallRazorPayTapped(){
        let myIntTotalAmount = (strTotalAmont as NSString).integerValue
        if strTotalAmont == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CASH_EMPTY_FIELD.titlecontent())
        }
        else if myIntTotalAmount <= 1 {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_ENTER_AMOUNT_GREATER_THAN_ONE.titlecontent())
        }
        else if gPaymentStatus == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.SELECT_PAYMENT_METHOD.titlecontent())
        }
        else {
            if gPaymentStatus == "0" {
                AddCashPayPall()
            }
            else if gPaymentStatus == "4" {
                let aViewController = GSWkWebViewViewController()
                aViewController.gStrTitle = "Payment"
                aViewController.gStrContent = "\(WEB_BASE_URL)home/paysolutionapi?refno=\(self.strReference)&merchantid=\(self.myStrMerchantId)&productdetail=wallet&customeremail=\(SESSION.getUserInfoNew().1)&total=\(strTotalAmont)"
        
                self.navigationController?.pushViewController(aViewController, animated: true)
            }
            else {
                AddCashRazorPayBtnTapped()
            }
           
        }
    }
    func AddCashPayPall() {
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
               
               // Example: Initialize BTAPIClient, if you haven't already
               
               let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
               payPalDriver.viewControllerPresentingDelegate = self
               payPalDriver.appSwitchDelegate = self
               // Do any additional setup after loading the view.
               let request = BTPayPalRequest(amount: self.strTotalAmont)
               request.currencyCode = self.aStrCurrencyCode
               request.billingAgreementDescription = "" //Displayed in customer's PayPal account
               payPalDriver.requestBillingAgreement(request) { (tokenizedPayPalAccount, error) -> Void in
                   HELPER.hideLoadingAnimation()
                   if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                       //                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                       let token = tokenizedPayPalAccount.nonce
                       let orderId = tokenizedPayPalAccount.clientMetadataId
                       HELPER.hideLoadingAnimation()
                       self.withdrawCashToPaypalApi(noncetoken: token, orderId: orderId!)
                       // Send payment method nonce to your server to create a transaction
                   } else if let error = error {
                   } else {
                    
                   }
               }
    }
    
     func AddCashRazorPayBtnTapped(){
         let myIntTotalAmount = (strTotalAmont as NSString).integerValue
       
        let aIntAmtConver = myIntTotalAmount * 100
        let options: [String:Any] = [
            "amount": "\(aIntAmtConver)", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": self.aStrCurrencyCode,//We support more that 92 international currencies.
            "prefill": [
                "contact": "",
                "email": ""
            ],
            "theme": [
                "color": "#" + SESSION.getAppColor()
            ]
            
        ]
//"\(aIntAmtConver)"
        //         "order_id": "order_DBJOWzybf0sJbb",
        razorpay.open(options)
    }
    
    // MARK:- Api Call

    func withdrawCashToPaypalApi(noncetoken: String, orderId: String) {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["amount"] = self.strTotalAmont
        aDictParams["payload_nonce"] = noncetoken
        aDictParams["orderID"] = orderId
        
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_BRAINTEE_PAYPAL ,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        
                        self.navigationController?.popViewController(animated: true)
                    })
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
    
    func withdrawCashToApi() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["amount"] = self.strTotalAmont
        aDictParams["currency_code"] = self.aStrCurrencyCode
        if gPaymentStatus == "0" {
            aDictParams["paytype"] = "paypall"
            aDictParams["tokenid"] = self.strReference
        }
        else  if gPaymentStatus == "1" {
            aDictParams["paytype"] = "stripe"
        }
        else  if gPaymentStatus == "2" {
            aDictParams["paytype"] = "razorpay"
        }
        else  if gPaymentStatus == "3" {
            aDictParams["paytype"] = "paystack"
        }
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_WALLET_WITHDRAW ,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : Any]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                let code = aDictResponse[kRESPONSE_CODE]!
                if  "\(code)" == "200" {
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse as! String) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                    
                else {
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse as! String)
                }
            }
            
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }
    
    
    func getWalletTransactionHistory() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        let aDictParams = [String:String]()
       
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_WALLET_TRANSACTION_HISTORY,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String : Any]
                    
                    self.myDictWalletInfo = aDictResponseData //aDictResponseData["wallet_info"] as! [String : Any]
                    
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
    
    func sendBookingToApi() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        if gPaymentStatus == "3"  {
            if (strPayStackKey == "" || !strPayStackKey.hasPrefix("pk_")) {
                HELPER.hideLoadingAnimation()
                showOkayableMessage("You need to set your Paystack public key.", message:"You can find your public key at https://dashboard.paystack.co/#/settings/developer .")
                // You need to set your Paystack public key.
                return
            }
            
            Paystack.setDefaultPublicKey(strPayStackKey)
        }
        let aTxtFieldCardNo = self.view.viewWithTag(TAG_CARD_NUMBER) as! FormTextField
        let aTxtFieldCardExpiry = self.view.viewWithTag(TAG_CARD_EXPIRY_DATE) as! FormTextField
        let aTxtFieldCardCVV = self.view.viewWithTag(TAG_CARD_CVV) as! FormTextField
        
        if aTxtFieldCardNo.text == "" && aTxtFieldCardExpiry.text == "" && aTxtFieldCardCVV.text == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ENTER_CARD_DETAILS.titlecontent())
        }
        else if aTxtFieldCardNo.text == ""  {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CARD_NUMBER.titlecontent())
        }
        else if aTxtFieldCardExpiry.text == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CARD_EXPIRY.titlecontent())
        }
        else if aTxtFieldCardCVV.text == "" {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.ALERT_CVV.titlecontent())
        }
        else {
            let validCardNumber = aTxtFieldCardNo.validate()
            let validCardExpirationDate = aTxtFieldCardExpiry.validate()
            let validCVC = aTxtFieldCardCVV.validate()
            
            print(validCardNumber)
            print(validCardExpirationDate)
            print(validCVC)
            
            var aStrMonth = Int()
            var aStrYear = Int()
            
            let aExpirationDate = aTxtFieldCardExpiry.text?.components(separatedBy: "/")
            
            aStrMonth = Int(aExpirationDate![0])!
            aStrYear = Int(aExpirationDate![1])!
            
            if  validCardNumber && validCardExpirationDate && validCVC {
                if gPaymentStatus == "3" {
                  
                    cardParams.number = aTxtFieldCardNo.text
                    cardParams.cvc = aTxtFieldCardCVV.text
                    
                    cardParams.expMonth = UInt(aStrMonth)
                    cardParams.expYear = UInt(aStrYear)
                    
                  
                    changeCurrency(paymentType: "paystack", currency: "NGN")
                }
                else {
                let card: STPCardParams = STPCardParams()
                card.number = aTxtFieldCardNo.text
                card.expMonth = UInt(aStrMonth)
                card.expYear = UInt(aStrYear)
                card.cvc = aTxtFieldCardCVV.text
                card.currency = aStrCurrencyCode
                HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
                
                STPAPIClient.shared.createToken(withCard: card) { token, error in
                    if let token = token {
                        
                        let aTransactionId = token.tokenId as String
                        self.sendToken(tokenId: aTransactionId, paymentType: "stripe")
                        // withdraw to bank method
//                        if SESSION.getUserLogInType() == "1" {
//                            var aDictParams = [String:String]()
//
//                            aDictParams["amount"] = self.strTotalAmont
//                            aDictParams["tokenid"] = aTransactionId
//                            HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_WITHDRAW_PROVIDER, dictParameters: aDictParams , sucessBlock: { (response) in
//
//                                HELPER.hideLoadingAnimation()
//                                if response.count != 0 {
//
//                                    var aDictResponse = response[kRESPONSE] as! [String : String]
//
//                                    let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
//
//                                    if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
//
//                                        HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
//
//                                            self.navigationController?.popViewController(animated: true)
//                                        })
//                                    }
//                                    else {
//
//                                        HELPER.hideLoadingAnimation()
//                                        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
//                                    }
//                                }
//
//
//                            }, failureBlock: { error in
//
//                                HELPER.hideLoadingAnimation()
//                                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
//                            })
//                        }
//                        else {

//                        }
                        
                    } else {
                        HELPER.hideLoadingAnimation()
                        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: (error?.localizedDescription)!)
                    }
                }
            }
            }
                
            else {
                HELPER.hideLoadingAnimation()
                HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.NOT_VALID_CARD.titlecontent())
            }
        }
        
    }
    
    func sendToken(tokenId : String, paymentType : String){
    var aDictParams = [String:String]()
     
    aDictParams["amount"] = self.strTotalAmont
    aDictParams["currency"] = self.aStrCurrencyCode
    aDictParams["tokenid"] = tokenId//aTransactionId
    aDictParams["paytype"] = paymentType
    if !HELPER.isConnectedToNetwork() {
        
        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
        return
    }
        HELPER.showLoadingViewAnimation(viewController: self)
    HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_ADD_USER_WALLET, dictParameters: aDictParams , sucessBlock: { (response) in
        
        HELPER.hideLoadingAnimation()
        if response.count != 0 {
            
            var aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                    
                    self.navigationController?.popViewController(animated: true)
                })
            }
            else {
                
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
        }
        
        
    }, failureBlock: { error in
        
        HELPER.hideLoadingAnimation()
        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
    })
    }
    
    func changeCurrency(paymentType : String , currency : String) {
    var aDictParams = [String:String]()
    
    aDictParams["user_currency_code"] = self.aStrCurrencyCode
    aDictParams["amount"] = self.strTotalAmont
    aDictParams["paytype"] = paymentType
    aDictParams["conversion_currency"] = currency
    if !HELPER.isConnectedToNetwork() {
        
        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
        return
    }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
    HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_CURRENCY_CONVERT, dictParameters: aDictParams , sucessBlock: { (response) in
        
        HELPER.hideLoadingAnimation()
        if response.count != 0 {
            
            let aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                let transactionParams = PSTCKTransactionParams.init();
                var aDictResponseData = [String:Any]()
                aDictResponseData = response["data"] as! [String : Any]
                let myIntTotalAmount = Double(truncating: aDictResponseData["currency_amount"] as? NSNumber ?? 0)
                let aIntAmtConver = myIntTotalAmount * 100
                transactionParams.email = self.strEmail;
                transactionParams.amount = UInt(aIntAmtConver);
                transactionParams.currency = currency;
                transactionParams.reference = self.strReference;
                
                let dictParams: NSMutableDictionary = [
                    "recurring": true
                ];
                let arrParams: NSMutableArray = [
                    "0","go"
                ];
                do {
                    try transactionParams.setMetadataValueDict(dictParams, forKey: "custom_filters");
                    try transactionParams.setMetadataValueArray(arrParams, forKey: "custom_array");
                } catch {
                    print(error)
                }
                // use library to create charge and get its reference
                PSTCKAPIClient.shared().chargeCard(self.cardParams, forTransaction: transactionParams, on: self, didEndWithError: { (error, reference) in
                    print(error)
                    if error._code == PSTCKErrorCode.PSTCKExpiredAccessCodeError.rawValue{
                    }
                    if error._code == PSTCKErrorCode.PSTCKConflictError.rawValue{
                    }
                    if let errorDict = (error._userInfo as! NSDictionary?){
                        if let errorString = errorDict.value(forKeyPath: "com.paystack.lib:ErrorMessageKey") as! String? {
                            if let reference=reference {
                                HELPER.hideLoadingAnimation()
                                self.showOkayableMessage("An error occured while completing "+reference, message: errorString)
                          
                            } else {
                                HELPER.hideLoadingAnimation()
                                self.showOkayableMessage("An error occured", message: errorString)
                                //                        self.outputOnLabel(str: errorString)
                            }
                        }
                    }
                    
                }, didRequestValidation: { (reference) in
                }, willPresentDialog: {
        
                }, dismissedDialog: {
                }) { (reference) in
                    HELPER.hideLoadingAnimation()
                    self.sendToken(tokenId: reference, paymentType: "paystack")
                }
                return
            }
            else {
                
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
        }
        
        
    }, failureBlock: { error in
        
        HELPER.hideLoadingAnimation()
        HELPER .showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
    })
    }
    
    func getuserKey() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
       HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_STRIPE_KEY, sucessBlock: {response in
            
//            HELPER.hideLoadingAnimation()
            HELPER.hideLoadingAnimation(viewController: self)
            
            var aDictResponse = [String:Any]()
            aDictResponse = response["response"] as! [String : Any]
            
            let aIntResponseCode = aDictResponse["response_code"] as! String
            let aMessageResponse = aDictResponse["response_message"] as! String
            var myDictKey = [String:Any]()
            
            if aIntResponseCode == "200" {
                
                myDictKey = response["data"] as! [String:Any]
             
                if (myDictKey["publishable_key"] as! String).count > 0 {
                    
                    StripeAPI.defaultPublishableKey = myDictKey["publishable_key"] as? String
                }
                else {
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: WalletContent.CONTACT_FOR_STRIPE_ACCESS.titlecontent())
                }
                self.strPayStackKey =  myDictKey["paystack_apikey"] as? String ?? ""
                self.strReference = String(myDictKey["paystack_ref_key"] as? Int ?? 0)
                self.strBraintreeClientId = myDictKey["braintree_key"] as? String ?? ""
                self.strEmail = myDictKey["email"] as? String ?? ""
                self.braintreeClient = BTAPIClient(authorization: self.strBraintreeClientId)!
                self.razorpay = RazorpayCheckout.initWithKey(myDictKey["razorpay_apikey"] as! String, andDelegate: self)
                self.myStrPayStackEnabled = myDictKey["paystack_option"] as? String ?? ""
                self.myStrRazorPayEnabled = myDictKey["razor_option"] as? String ?? ""
                self.myStrStripeEnabled = myDictKey["stripe_option"] as? String ?? ""
                self.myStrPayPallEnabled = myDictKey["paypal_option"] as? String ?? ""
               
                self.myStrMerchantId = myDictKey["merchant_id"] as? String ?? ""
                self.myArrPayment.removeAll()
                if self.myStrPayStackEnabled == "1" {
                    self.myArrPayment.append("paystack")
                }
                if  self.myStrRazorPayEnabled == "1" {
                    self.myArrPayment.append("Razor")
                }
                if  self.myStrStripeEnabled == "1" {
                    self.myArrPayment.append("stripe")
                }
                if  self.myStrPayPallEnabled == "1" {
                    self.myArrPayment.append("paypall")
                }
                if SESSION.getUserLogInType() != "1" {
                self.myStrPaySolutionsEnabled = myDictKey["paysolution_option"] as? String ?? ""
                    if  self.myStrPaySolutionsEnabled == "1" {
                        self.myArrPayment.append("paysolutions")
                    }
                }
                self.myTblView.reloadData()
            }
            else if aIntResponseCode == "404" {
                HELPER.hideLoadingAnimation()
                
            }
            else {
                 HELPER.hideLoadingAnimation(viewController: self)
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse)
            }
            
        }, failureBlock: { error in
            
             HELPER.hideLoadingAnimation(viewController: self)
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
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
    
    
    // MARK: - BTViewControllerPresentingDelegate
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - BTAppSwitchDelegate
    
    
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
    // MARK: Helpers
    func showOkayableMessage(_ title: String, message: String){
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
//    func getClientId() {
//        if !HELPER.isConnectedToNetwork() {
//
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
//            return
//        }
//
//        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
//
//        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_BRAINTEE_CLIENT_ID, sucessBlock: { response in
//            HELPER.hideLoadingAnimation()
//            let aDictResponse = response[kRESPONSE] as! [String : String]
//
//            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
//
//            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
//
//                var aDictResponseData = [String:Any]()
//                aDictResponseData = response["data"] as! [String : Any]
//
//                self.strBraintreeClientId = aDictResponseData["braintree_key"] as! String
//                //                print(self.strBraintreeClientId)
//            }
//            else {
//                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
//            }
//
//        }, failureBlock: { error in
//
//            HELPER.hideLoadingAnimation()
//            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
//        })
//    }
