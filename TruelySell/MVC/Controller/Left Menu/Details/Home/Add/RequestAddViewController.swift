//
//  RequestAddViewController.swift
//
//  Created by Yosicare on 30/04/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import UIKit
import CoreLocation

class RequestAddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myBtnSubmit: UIButton!
    
    let cellIdentifierTextField = "AddRequestTableViewCell"
    let cellIdentifierTextView = "AddRequestTextViewTableViewCell"
    
    var myStrTitle = String()
    var myStrLocation = String()
    var myStrDate = String()
    var myStrTime = String()
    var myStrProposedFee = String()
    var myStrContactNumber = String()
    
    var myStrRequestId = String()

    var aDictLanguageAddReq = [String:Any]()
    var aDictLanguageCommon = [String:Any]()
    var aDictLanguageProfile = [String:Any]()
    
    var gAryEditInfo = [[String:Any]]()

    var myAryTxtViewInfo = [[String : String]] ()
    
    var gClickEditRequest = false
    
    let TAG_TITLE = 100
    let TAG_LOCATION = 200
    let TAG_DATE = 300
    let TAG_TIME = 400
    let TAG_PROPOSED_FEE = 500
    let TAG_CONTACT_NUMBER = 600
    
    let K_TXT_VIEW_VALUE : String = "tztview_tzt"
    let K_TXT_VIEW_LABEL : String = "txtview_label"
    
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
        
        changeLanguageContent()
        NAVIGAION.setNavigationTitleWithBackButton(navigationTitle: (aDictLanguageAddReq["lg6_add_request"] as? String)!, aViewController: self)
        setUpLeftBarBackButton()
        
        myTblView.register(UINib.init(nibName: cellIdentifierTextField, bundle: nil), forCellReuseIdentifier: cellIdentifierTextField)
        myTblView.register(UINib.init(nibName: cellIdentifierTextView, bundle: nil), forCellReuseIdentifier: cellIdentifierTextView)
        
        myBtnSubmit.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        myBtnSubmit.setTitle(aDictLanguageAddReq["lg6_submit"] as? String, for: .normal)

        myTblView.tableFooterView = UIView()
        
        if gClickEditRequest == true {
            
            myBtnSubmit.setTitle(aDictLanguageProfile["lg4_lg4_update_prof"] as? String, for: .normal)
        }
        else {
            
            myBtnSubmit.setTitle(aDictLanguageAddReq["lg6_submit"] as? String, for: .normal)
        }
    }
    
    func setUpModel() {
        
        if gClickEditRequest == true {
            
            let aStrJson = gAryEditInfo[0]["description"]
            
            let data = (aStrJson as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String]
                
                for index in 0..<json.count {
                    
                    let dictInfo = [K_TXT_VIEW_VALUE:json[index],K_TXT_VIEW_LABEL:"\(String(describing: (aDictLanguageAddReq["lg6_desc_point"] as? String)!)) \(index + 1)"]
                    myAryTxtViewInfo.append(dictInfo)
                }
                
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }

        } else {
            myAryTxtViewInfo = [[K_TXT_VIEW_VALUE:"",K_TXT_VIEW_LABEL:(aDictLanguageAddReq["lg6_desc_point"] as? String)! + " 1"]]
        }
    }
    
    func loadModel() {
        
        if gClickEditRequest == true {
            
            myStrTitle = gAryEditInfo[0]["title"] as! String
            myStrLocation = gAryEditInfo[0]["location"] as! String
            myStrDate = gAryEditInfo[0]["request_date"] as! String
            myStrTime = gAryEditInfo[0]["request_time"] as! String
            myStrProposedFee = gAryEditInfo[0]["amount"] as! String
            myStrContactNumber = gAryEditInfo[0]["profile_contact_no"] as! String
            myStrRequestId = gAryEditInfo[0]["r_id"] as! String
        }
    }
    
    // MARK: - Table view delegate and data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
        }
            
        else if section == 1 {
            
            return myAryTxtViewInfo.count
        }
            
        else if section == 2 {
            
            return 5
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 60
        }
            
        else if indexPath.section == 1 {
            
            return 100
        }
            
        else if indexPath.section == 2 {
            
            return 60
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTextField, for: indexPath) as! AddRequestTableViewCell
            
            if gClickEditRequest == true {
                
                aCell.gTxtFld.isUserInteractionEnabled = false
                aCell.gTxtFld.delegate = self
                aCell.gLblTitle.text = aDictLanguageAddReq["lg6_title"] as? String
                aCell.gTxtFld.text = myStrTitle
                aCell.gTxtFld.tag = TAG_TITLE
                aCell.gTxtFld.inputAccessoryView = nil
            }else {
                aCell.gTxtFld.isUserInteractionEnabled = true
                aCell.gTxtFld.delegate = self
                aCell.gLblTitle.text = aDictLanguageAddReq["lg6_title"] as? String
                aCell.gTxtFld.text = myStrTitle
                aCell.gTxtFld.tag = TAG_TITLE
                aCell.gTxtFld.inputAccessoryView = nil
            }
            HELPER.setBorderView(aView: aCell.gViewTxtFld, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 5)
            
            return aCell
        }
            
        else if indexPath.section == 1 {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTextView, for: indexPath) as! AddRequestTextViewTableViewCell
            
            HELPER.setBorderView(aView: aCell.gViewTxtView, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 5)
            
            aCell.gTxtView.delegate = self
            
            aCell.gTxtView.text = myAryTxtViewInfo[indexPath.row][K_TXT_VIEW_VALUE]
            aCell.gLblTitle.text = myAryTxtViewInfo[indexPath.row][K_TXT_VIEW_LABEL]
            
            aCell.gTxtView.tag = indexPath.row
            aCell.gBtnClose.tag = indexPath.row
            
            aCell.gBtnClose.addTarget(self, action: #selector(RequestAddViewController.btnDescscriptionAddAndDelete), for: .touchUpInside)
            
            if myAryTxtViewInfo.count == indexPath.row + 1 {
                
                let image = UIImage(named: "icon_add_white")?.withRenderingMode(.alwaysTemplate)
                aCell.gBtnClose.setImage(image, for: .normal)
                aCell.gBtnClose.tintColor = UIColor.green
            }
                
            else {
                
                let image = UIImage(named: "icon_close")?.withRenderingMode(.alwaysTemplate)
                aCell.gBtnClose.setImage(image, for: .normal)
                aCell.gBtnClose.tintColor = UIColor.red
            }
            
            return aCell
        }
            
        else {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTextField, for: indexPath) as! AddRequestTableViewCell
            
            HELPER.setBorderView(aView: aCell.gViewTxtFld, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 5)
            
            aCell.gTxtFld.delegate = self
            
            if indexPath.row == 0 {
                
                aCell.gLblTitle.text = aDictLanguageAddReq["lg6_location"] as? String
                aCell.gTxtFld.text = myStrLocation
                aCell.gTxtFld.tag = TAG_LOCATION
                aCell.gTxtFld.inputAccessoryView = nil
                
            }
                
            else if indexPath.row == 1 {
                
                aCell.gLblTitle.text = aDictLanguageAddReq["lg6_date"] as? String
                aCell.gTxtFld.text = myStrDate
                aCell.gTxtFld.tag = TAG_DATE
                
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                datePicker.minimumDate = Date()
                aCell.gTxtFld.inputView = datePicker
                
                datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
                
                let toolBar = UIToolbar()
                toolBar.barStyle = UIBarStyle.default
                toolBar.isTranslucent = true
                toolBar.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                let doneButton = UIBarButtonItem(title: CommonTitle.DONE_BTN.titlecontent(), style: UIBarButtonItem.Style.done, target: self, action: #selector(RequestAddViewController.donePressed))
                let cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(RequestAddViewController.cancelPressed))
                let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
                toolBar.isUserInteractionEnabled = true
                toolBar.sizeToFit()
                
                aCell.gTxtFld.inputAccessoryView = toolBar
                
            }
                
            else if indexPath.row == 2 {
                
                aCell.gLblTitle.text = aDictLanguageAddReq["lg6_time"] as? String
                aCell.gTxtFld.text = myStrTime
                aCell.gTxtFld.tag = TAG_TIME
                aCell.gTxtFld.inputAccessoryView = nil
                
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .time
                //datePicker.minimumDate = Date()
                
                aCell.gTxtFld.inputView = datePicker
                
                datePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
                
                let toolBar = UIToolbar()
                toolBar.barStyle = UIBarStyle.default
                toolBar.isTranslucent = true
                toolBar.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                let doneButton = UIBarButtonItem(title: CommonTitle.DONE_BTN.titlecontent(), style: UIBarButtonItem.Style.done, target: self, action: #selector(RequestAddViewController.donePressed))
                let cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(RequestAddViewController.cancelPressed))
                let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
                toolBar.isUserInteractionEnabled = true
                toolBar.sizeToFit()
                aCell.gTxtFld.inputAccessoryView = toolBar
            }
                
            else if indexPath.row == 3 {
                
                aCell.gLblTitle.text = aDictLanguageAddReq["lg6_proposed_fee"] as? String
                aCell.gTxtFld.text = myStrProposedFee
                aCell.gTxtFld.tag = TAG_PROPOSED_FEE
                aCell.gTxtFld.keyboardType = UIKeyboardType.decimalPad
                aCell.gTxtFld.inputAccessoryView = nil
                
            }
                
            else if indexPath.row == 4 {
                
                aCell.gLblTitle.text = aDictLanguageAddReq["lg6_contact_number"] as? String
                aCell.gTxtFld.text = myStrContactNumber
                aCell.gTxtFld.tag = TAG_CONTACT_NUMBER
                aCell.gTxtFld.keyboardType = UIKeyboardType.numberPad
                aCell.gTxtFld.inputAccessoryView = nil
                aCell.gTxtFld.inputView = nil
            }
            
            return aCell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            print("delete")
        }
    }
    
    // MARK: - Textfield Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == TAG_LOCATION {
            
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    
                    let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_LOCATION_POPUP_VC) as! LocationPopViewController
                    self.present(aViewController, animated: true, completion: nil)
                    
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    
                    let signupViewController:GoogleMapsViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_GOOGLE_MAPS) as! GoogleMapsViewController
                    signupViewController.isFromSettings = true
                    signupViewController.completion = {(name,add) in
                        
                        if let locname = name {
                            self.myStrLocation = ("\(locname),\(add ?? "")")//locname + add!
                        }
                        let textField:UITextField = self.myTblView.viewWithTag(self.TAG_LOCATION) as! UITextField
                        textField.text = self.myStrLocation
                        
                    }
                    self.navigationController?.pushViewController(signupViewController, animated: true)                    }
            } else {
                
                let signupViewController:GoogleMapsViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_GOOGLE_MAPS) as! GoogleMapsViewController
                
                signupViewController.completion = {(name,add) in
                    
                    if let locname = name {
                        self.myStrLocation = ("\(locname),\(add ?? "")")//locname + add!
                    }
                    let textField:UITextField = self.myTblView.viewWithTag(self.TAG_LOCATION) as! UITextField
                    textField.text = self.myStrLocation
                }
                self.navigationController?.pushViewController(signupViewController, animated: true)
                
            }
            
   
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.tag == TAG_TITLE {
            
            myStrTitle = txtAfterUpdate
        }
            
        else if textField.tag == TAG_LOCATION {
            
            myStrLocation = txtAfterUpdate
        }
            
        else if textField.tag == TAG_DATE {
            
            myStrDate = txtAfterUpdate
        }
            
        else if textField.tag == TAG_TIME {
            
            myStrTime = txtAfterUpdate
        }
            
        else if textField.tag == TAG_PROPOSED_FEE {
            
            myStrProposedFee = txtAfterUpdate
        }
            
        else if textField.tag == TAG_CONTACT_NUMBER{
            
            if txtAfterUpdate.count <= 16 {
                
                myStrContactNumber = txtAfterUpdate
                
                return true
            }
                
            else {
                
                return false
            }
        }
        
        return true;
    }
    
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        
        textfield.resignFirstResponder()
        
        return true
    }
    
    //MARK: - TextView Delegate
    
    //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //
    //        let txtAfterUpdate: NSString = (textView.text ?? "") as NSString
    //
    //        var aDictUpdateInfo = myAryTxtViewInfo[textView.tag]
    //
    //        aDictUpdateInfo[K_TXT_VIEW_VALUE] = txtAfterUpdate as String
    //
    //        myAryTxtViewInfo[textView.tag] = aDictUpdateInfo
    //
    //        return true
    //    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        var aDictUpdateInfo = myAryTxtViewInfo[textView.tag]
        aDictUpdateInfo[K_TXT_VIEW_VALUE] = textView.text
        myAryTxtViewInfo[textView.tag] = aDictUpdateInfo
    }
    
    //MARK: - Api request
    func addRequestApi()  {
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_NO_INTERNET)
            
            return
        }
        
        var aryDescription = [String]()
        
        for index in 0..<myAryTxtViewInfo.count {
            
            if myAryTxtViewInfo[index][K_TXT_VIEW_VALUE]?.count != 0 {
                
                aryDescription.append(myAryTxtViewInfo[index][K_TXT_VIEW_VALUE]!)
            }
        }
        
        if myStrTitle.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_title_cannot_be"] as! String)
            return
        }
            
        else if aryDescription.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_description_can"] as! String)
            return
        }
            
        else if myStrLocation.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_location_addres"] as! String)
            return
        }
            
        else if myStrDate.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_date_cannot_be_"] as! String)
            return
        }
            
        else if myStrTime.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_time_cannot_be_"] as! String)
            return
        }
            
        else if myStrProposedFee.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_proposed_fee_ca"] as! String)
            return
        }
            
        else if myStrContactNumber.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_contact_number_"] as! String)
            return
        }
        
        var dictInfo = [String:String]()
        dictInfo["title"] = myStrTitle
        dictInfo["description"] = json(from: aryDescription)
        dictInfo["location"] = myStrLocation
        dictInfo["request_date"] = myStrDate
        dictInfo["request_time"] = myStrTime
        dictInfo["proposed_fee"] = myStrProposedFee
        dictInfo["contact_number"] = myStrContactNumber
        dictInfo["latitude"] = SESSION.getUserUpdatedLatLonginGoogleSearch().0
        dictInfo["longitude"] = SESSION.getUserUpdatedLatLonginGoogleSearch().1
        
        print(dictInfo)
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_ADD_REQUEST,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        self.completion("refresh")
                        self.dismiss(animated: true, completion: nil)
                    })
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
    
    
    func editRequestApi()  {
        
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_NO_INTERNET)
            
            return
        }
        
        var aryDescription = [String]()
        
        for index in 0..<myAryTxtViewInfo.count {
            
            if myAryTxtViewInfo[index][K_TXT_VIEW_VALUE]?.count != 0 {
                
                aryDescription.append(myAryTxtViewInfo[index][K_TXT_VIEW_VALUE]!)
            }
        }
        
        if myStrTitle.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_title_cannot_be"] as! String)
            return
        }
            
        else if aryDescription.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_description_can"] as! String)
            return
        }
            
        else if myStrLocation.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_location_addres"] as! String)
            return
        }
            
        else if myStrDate.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_date_cannot_be_"] as! String)
            return
        }
            
        else if myStrTime.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_time_cannot_be_"] as! String)
            return
        }
            
        else if myStrProposedFee.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_proposed_fee_ca"] as! String)
            return
        }
            
        else if myStrContactNumber.count == 0 {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aDictLanguageAddReq["lg6_contact_number_"] as! String)
            return
        }
        
        var dictInfo = [String:String]()
        dictInfo["request_id"] = myStrRequestId
        dictInfo["title"] = myStrTitle
        dictInfo["description"] = json(from: aryDescription)
        dictInfo["location"] = myStrLocation
        dictInfo["request_date"] = myStrDate
        dictInfo["request_time"] = myStrTime
        dictInfo["proposed_fee"] = myStrProposedFee
        dictInfo["contact_number"] = myStrContactNumber
        dictInfo["latitude"] = SESSION.getUserUpdatedLatLonginGoogleSearch().0
        dictInfo["longitude"] = SESSION.getUserUpdatedLatLonginGoogleSearch().1
        
        print(dictInfo)
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_UPDATE_REQUEST,dictParameters:dictInfo, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                        self.completion("refresh")
                        self.dismiss(animated: true, completion: nil)
                    })
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
    
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    // Date picker Methods
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = WEB_DATE_FORMAT
        myStrDate = formatter.string(from: sender.date)
    }
    
    @objc func timeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = WEB_TIME_FORMAT
        myStrTime = formatter.string(from: sender.date)
    }
    @objc func donePressed(){
        view.endEditing(true)
        self.myTblView.reloadData()
    }
    
    @objc func cancelPressed(){
        view.endEditing(true)
    }
    
    func getCurrentDateAndTime()  {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = WEB_DATE_FORMAT
        myStrDate = formatter.string(from: date)
        print(myStrDate)
    }
    
    @objc func btnDescscriptionAddAndDelete(_ sender: UIButton) {
        
        if sender.tag + 1 < myAryTxtViewInfo.count {
            
            print(myAryTxtViewInfo)
            
            myAryTxtViewInfo.remove(at: sender.tag)
            
            print(myAryTxtViewInfo)
            
        }
            
        else {
            
            var aStrDescription = String ()
            
            aStrDescription = String(myAryTxtViewInfo.count + 1)
            myAryTxtViewInfo.append([K_TXT_VIEW_VALUE:"",K_TXT_VIEW_LABEL:(aDictLanguageAddReq["lg6_desc_point"] as? String)! + aStrDescription])

        }
        
        for index in 0..<myAryTxtViewInfo.count {
            
            var aDictUpdateInfo = myAryTxtViewInfo[index]
            
            var aStrDescription = String ()
            aStrDescription = (aDictLanguageAddReq["lg6_desc_point"] as? String)! + " " + String(index + 1)
//            aStrDescription = "Description point " + String(index + 1)
            aDictUpdateInfo[K_TXT_VIEW_LABEL] = aStrDescription
            
            myAryTxtViewInfo[index] = aDictUpdateInfo
        }
        
        print(myAryTxtViewInfo)
        
        myTblView.reloadData()
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        
        if gClickEditRequest == true {
            
            editRequestApi()
        }else {
            
            addRequestApi()
        }
    }
    
    func changeLanguageContent() {
        
        let aDictLangInfo = SESSION.getLangInfo()
        
        aDictLanguageAddReq = aDictLangInfo["request_and_provider_list"] as! [String : Any]
        aDictLanguageCommon = aDictLangInfo["common_used_texts"] as! [String : Any]
        aDictLanguageProfile = aDictLangInfo["profile"] as! [String : Any]
    }
    
    // MARK:- Left Bar Button Methods
    func setUpLeftBarBackButton() {
        
        let leftBtn = UIButton(type: .custom)
        leftBtn.setImage(UIImage(named: "icon_close_white"), for: .normal)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        
        let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
    }
    
    @objc func backBtnTapped() {
        
        self.dismiss(animated: true, completion: nil)
    }
}
