 

import UIKit

class NewProviderAvailabilityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myViewBottom: UIView!
    @IBOutlet weak var myBtnUpdate: UIButton!
    @IBOutlet weak var myLblHeaderTitle: UILabel!
    
    let cellTableIdentifier = "AvailablityTableViewCell"
        
        let TAG_DATE_PICKER_FROM = 1000
        let TAG_DATE_PICKER_TO = 2000
        var allDaysSelected = false
        var curretSelectedTFTag = 0
        
        var allDaysDeSelected = false
     
        var myArrIsCheck = [["isCheck" : "0"],["isCheck" : "0"],["isCheck" : "0"],["isCheck" : "0"],["isCheck" : "0"],["isCheck" : "0"],["isCheck" : "0"],["isCheck" : "0"]]
        
      
        let FROM_TIME = "from_time"
        let TO_TIME = "to_time"
        let DAY = "day"
        
        let K_TXT_FROM : String = "From"
        let K_TXT_TO : String = "To"
        let K_TXT_INDEX : String = ""
        
        var myStrFromTime = String()
        var myStrToTime = String()
        var myDateFromTime = Date()
     

        var gClickEditProvide = false
        
        var myAryTimeInfo = [[String : String]]()
        var myDictResponseInfo = [String : Any]()
        
        override func viewDidLoad() {
            super.viewDidLoad()

            setUpUI()
            setUpModel()
            loadModel()
            // Do any additional setup after loading the view.
        }
        
        func setUpUI() {
            
            NAVIGAION.setNavigationTitle(aStrTitle: ProviderAvailability.PROVIDER_BUSINESS_HRS.titlecontent(), aViewController: self)
            setUpLeftBarBackButton()
            myTblView.delegate = self
            myTblView.dataSource = self
            myTblView.register(UINib.init(nibName: cellTableIdentifier, bundle: nil), forCellReuseIdentifier: cellTableIdentifier)
            myLblHeaderTitle.text = ProviderAvailability.SELECT_PROVIDERS_BUSINESS_HRS.titlecontent()
            myBtnUpdate.setTitle(ProviderAvailability.UPDATE_HOURS.titlecontent(), for: .normal)
            myBtnUpdate.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
             self.myTblView.tableFooterView = UIView()
            
        }
        
        func setUpModel() {
           
            for var i in 0...7 {
                myAryTimeInfo.append([K_TXT_FROM:"",K_TXT_TO:""])
            }
        }
        
        func loadModel() {
            
             getAvailabilityFromApi()
        }
        
        // MARK: - Tableview Delegate and Datasource
        
        func numberOfSections(in tableView: UITableView) -> Int {
            
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return 8
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 50
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
                let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableIdentifier, for: indexPath) as! AvailablityTableViewCell
                
                HELPER.setBorderView(aView: aCell.gViewFrom, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3)
                HELPER.setBorderView(aView: aCell.gViewTo, borderWidth: 0.5, borderColor: UIColor.lightGray, cornerRadius: 3)
                
                if indexPath.row == 0 {
                    aCell.gLblDays.text = ProviderAvailability.ALL_DAYS.titlecontent() 
                }
                else if indexPath.row == 1 {
                    aCell.gLblDays.text = ProviderAvailability.MONDAY.titlecontent()
                }
                else if indexPath.row == 2 {
                    aCell.gLblDays.text = ProviderAvailability.TUESDAY.titlecontent()
                }
                else if indexPath.row == 3 {
                    aCell.gLblDays.text = ProviderAvailability.WEDNESDAY.titlecontent()
                }
                else if indexPath.row == 4 {
                    aCell.gLblDays.text = ProviderAvailability.THURSDAY.titlecontent()
                }
                else if indexPath.row == 5 {
                    aCell.gLblDays.text = ProviderAvailability.FRIDAY.titlecontent()
                }
                else if indexPath.row == 6 {
                    aCell.gLblDays.text = ProviderAvailability.SATURDAY.titlecontent()
                }
                else if indexPath.row == 7 {
                    aCell.gLblDays.text = ProviderAvailability.SUNDAY.titlecontent()
                }
                
                aCell.gSwitch.addTarget(self, action: #selector(switchChanged(mySwitch:)), for: .valueChanged)
                aCell.gSwitch.tag = indexPath.row
                
                let fromTime = myAryTimeInfo[indexPath.row][K_TXT_FROM] == String(indexPath.row) ? "" :myAryTimeInfo[indexPath.row][K_TXT_FROM]
                
                let toTime = myAryTimeInfo[indexPath.row][K_TXT_TO] == String(indexPath.row) ? "" :myAryTimeInfo[indexPath.row][K_TXT_TO]
            
                aCell.gTxtFldFrom.text = fromTime
                aCell.gTxtFldFrom.tag = indexPath.row
                aCell.gTxtFldFrom.inputAccessoryView = nil
                
                aCell.gTxtFldTo.text = toTime
                aCell.gTxtFldTo.tag = indexPath.row
                aCell.gTxtFldTo.inputAccessoryView = nil
                
                let datePickerForTo = UIDatePicker()
                datePickerForTo.datePickerMode = .time
            if #available(iOS 14, *) {
                datePickerForTo.preferredDatePickerStyle = .wheels
                datePickerForTo.sizeToFit()
            }
    //                        datePickerForTo.maximumDate = Date()

                let datePickerForFrom = UIDatePicker()
                datePickerForFrom.datePickerMode = .time
            if #available(iOS 14, *) {
                datePickerForFrom.preferredDatePickerStyle = .wheels
                datePickerForFrom.sizeToFit()
            }
                //            datePickerForFrom.maximumDate = Date()
            
                datePickerForFrom.tag = TAG_DATE_PICKER_FROM + indexPath.row + 1
                datePickerForTo.tag = TAG_DATE_PICKER_TO + indexPath.row + 1
                
                
                aCell.gTxtFldFrom.inputView = datePickerForFrom
                aCell.gTxtFldTo.inputView = datePickerForTo
            
            let nextTime = Calendar.current.date(byAdding: .second, value: 1, to: myDateFromTime)
            datePickerForTo.minimumDate = nextTime
            

                datePickerForFrom.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
                
                datePickerForTo.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
                
                aCell.gSwitch.isUserInteractionEnabled = true
                aCell.gTxtFldFrom.isUserInteractionEnabled = true
                aCell.gTxtFldTo.isUserInteractionEnabled = true
                
                if myDictResponseInfo.count != 0 {
                    
                    if (aCell.gTxtFldFrom.text?.count)! > 0 && (aCell.gTxtFldTo.text?.count)! > 0{
                        
                        aCell.gSwitch.setOn(true, animated: true)
                        aCell.gSwitch.isUserInteractionEnabled = true
                        aCell.gTxtFldFrom.isUserInteractionEnabled = true
                        aCell.gTxtFldTo.isUserInteractionEnabled = true
                    }
                }
            
            
            if myArrIsCheck[indexPath.row]["isCheck"] == "1" {
                aCell.gSwitch.isUserInteractionEnabled = true
                aCell.gSwitch.setOn(false, animated: true)
               
                aCell.gTxtFldFrom.text = ""
                aCell.gTxtFldTo.text = ""
            }
            
            if myArrIsCheck[indexPath.row]["isCheck"] == "2" {
                aCell.gSwitch.isUserInteractionEnabled = true
                aCell.gSwitch.setOn(true, animated: true)
                
            }
            
            if allDaysSelected == true {
                if indexPath.row != 0 {
                    aCell.gSwitch.isUserInteractionEnabled = false
                    aCell.gSwitch.setOn(false, animated: true)
                   if myAryTimeInfo[indexPath.row]["From"] == "" || myAryTimeInfo[indexPath.row]["To"] == "" {
                    myArrIsCheck[indexPath.row]["isCheck"] = "1"
                    myAryTimeInfo[indexPath.row]["To"] = ""
                    myAryTimeInfo[indexPath.row]["From"] = ""
                    }
                    aCell.gTxtFldFrom.text = myAryTimeInfo[0][K_TXT_FROM]
                    aCell.gTxtFldTo.text = myAryTimeInfo[0][K_TXT_TO]
                    aCell.gTxtFldFrom.isUserInteractionEnabled = false
                    aCell.gTxtFldTo.isUserInteractionEnabled = false
                }
                else {
                    aCell.gTxtFldFrom.text = myAryTimeInfo[0][K_TXT_FROM]
                    aCell.gTxtFldTo.text = myAryTimeInfo[0][K_TXT_TO]
                }
            }

                else {
            
                
                    if aCell.gSwitch.isOn  {
                        if allDaysDeSelected == true {
                        if myAryTimeInfo[indexPath.row]["From"] == "" || myAryTimeInfo[indexPath.row]["To"] == "" {
                            myAryTimeInfo[indexPath.row]["To"] = ""
                            myAryTimeInfo[indexPath.row]["From"] = ""
                               aCell.gSwitch.setOn(false, animated: true)
                              aCell.gSwitch.isUserInteractionEnabled = true
                            aCell.gTxtFldFrom.isUserInteractionEnabled = false
                            aCell.gTxtFldTo.isUserInteractionEnabled = false
                             myArrIsCheck[indexPath.row]["isCheck"] = "1"
                        }
                        else {
                            myArrIsCheck[indexPath.row]["isCheck"] = "2"
                            aCell.gTxtFldFrom.isUserInteractionEnabled = true
                            aCell.gTxtFldTo.isUserInteractionEnabled = true
                            }
                    }
                        else {
                        myArrIsCheck[indexPath.row]["isCheck"] = "2"
                        aCell.gTxtFldFrom.isUserInteractionEnabled = true
                        aCell.gTxtFldTo.isUserInteractionEnabled = true
                        }
                    }
                    else {
                        aCell.gTxtFldFrom.isUserInteractionEnabled = false
                        aCell.gTxtFldTo.isUserInteractionEnabled = false
                    }
                }
                
                aCell.gSwitch.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                aCell.gSwitch.onTintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                // From time
                let toolBar = UIToolbar()
                toolBar.barStyle = UIBarStyle.default
                toolBar.isTranslucent = true
                
                toolBar.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            let doneButton = UIBarButtonItem(title: CommonTitle.DONE_BTN.titlecontent(), style: UIBarButtonItem.Style.done, target: self, action: #selector(ProvideAddViewController.donePressed(doneBtnTag:)))
                doneButton.tag = TAG_DATE_PICKER_FROM + indexPath.row + 1
                
                //Totime
                let toolBar1 = UIToolbar()
                toolBar1.barStyle = UIBarStyle.default
                toolBar1.isTranslucent = true
                
                toolBar1.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            let doneButton1 = UIBarButtonItem(title: CommonTitle.DONE_BTN.titlecontent(), style: UIBarButtonItem.Style.done, target: self, action: #selector(ProvideAddViewController.donePressed(doneBtnTag:)))
                doneButton1.tag = TAG_DATE_PICKER_TO + indexPath.row + 1
                
            let cancelButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ProvideAddViewController.cancelPressed))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
                toolBar.isUserInteractionEnabled = true
                toolBar.sizeToFit()
                
                toolBar1.setItems([cancelButton, spaceButton, doneButton1], animated: false)
                toolBar1.isUserInteractionEnabled = true
                toolBar1.sizeToFit()
                
                aCell.gTxtFldFrom.inputAccessoryView = toolBar
                aCell.gTxtFldTo.inputAccessoryView = toolBar1
                
                aCell.selectionStyle = .none
                
                return aCell
        }
        
        // MARK: - Button Action
        @IBAction func btnUpdateTapped(_ sender: Any) {
            var mycheckBool = Bool()
             for i in 0...myArrIsCheck.count - 1 {
                if myArrIsCheck[i]["isCheck"] == "2" {
                   mycheckBool = true
                    if myAryTimeInfo[i]["From"] == "" && myAryTimeInfo[i]["To"] == "" {
                        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAvailability.SELECT_FROM_TO_TIME.titlecontent())
                        return
                    }
                }
            }
           
            if mycheckBool == true {
                  sendProviderAvailabilityApi()
                mycheckBool = false
            }
            else {
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAvailability.SELECT_DATES.titlecontent())
                HELPER.hideLoadingAnimation()
                return

            }

        }
        
        @objc func switchChanged(mySwitch: UISwitch) {
           let value = mySwitch.isOn
            
            if value == true {
                if mySwitch.tag == 0 {
                    allDaysSelected = true
                    allDaysDeSelected = false
                     myArrIsCheck[mySwitch.tag]["isCheck"] = "2"
                }
                else {
                     allDaysDeSelected = false
                    myArrIsCheck[mySwitch.tag]["isCheck"] = "2"
                }
            }
            else {
                if mySwitch.tag == 0 {
                    allDaysSelected = false
                      allDaysDeSelected = true
                    myAryTimeInfo[0][K_TXT_FROM] = ""
                    myAryTimeInfo[0][K_TXT_TO] = ""
                    myArrIsCheck[mySwitch.tag]["isCheck"] = "1"
                }
                else {
                      myArrIsCheck[mySwitch.tag]["isCheck"] = "1"
                    myAryTimeInfo[mySwitch.tag][K_TXT_FROM] = ""
                    myAryTimeInfo[mySwitch.tag][K_TXT_TO] = ""
                }
            }
            self.myTblView.reloadData()

        }
        
        @objc func timeChanged(_ sender: UIDatePicker) {
            
            curretSelectedTFTag = sender.tag
            self .setTimeInTF(cTime: sender.date)
        }
        
        func setTimeInTF(cTime:Date)  {
            
            if (curretSelectedTFTag <= TAG_DATE_PICKER_TO ) {
                let formatter = DateFormatter()
                formatter.dateFormat = WEB_TIME_FORMAT
                myStrFromTime = formatter.string(from: cTime)
                myDateFromTime = cTime
                let index = curretSelectedTFTag - TAG_DATE_PICKER_FROM - 1
                var dict = myAryTimeInfo[index]
                dict[K_TXT_FROM] = myStrFromTime
                myAryTimeInfo[index] = dict
                
            }
            else {
                let formatter = DateFormatter()
                formatter.dateFormat = WEB_TIME_FORMAT
               
                myStrFromTime = formatter.string(from: cTime)
            

                let index = curretSelectedTFTag - TAG_DATE_PICKER_TO - 1
                var dict = myAryTimeInfo[index]
                dict[K_TXT_TO] = myStrFromTime
                myAryTimeInfo[index] = dict
            }
        }
        
        @objc func donePressed(doneBtnTag:UIBarButtonItem){
            
            curretSelectedTFTag = doneBtnTag.tag
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = WEB_TIME_FORMAT
            //        myStrFromTime = dateFormatter.string(from: Date())
            
            if myStrFromTime.count == 0 {
                self .setTimeInTF(cTime: Date())
                myStrFromTime = ""
            }
            view.endEditing(true)
            self.myTblView.reloadData()
        }
        
        @objc func cancelPressed(){
            view.endEditing(true)
        }
        
        // MARK: - Api call
        func sendProviderAvailabilityApi() {
            if !HELPER.isConnectedToNetwork() {
                       
                       HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                       return
                   }
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
            
            var fromtime = ""
            var toime = ""
            let jsonTimearr:NSMutableArray? = NSMutableArray()
            var isAvailbleSelected = false
            if allDaysSelected == true {
                for index in 0..<myAryTimeInfo.count - 1 {
                    
                    var dict = myAryTimeInfo[index]
                    
                    if index == 0 && (dict[K_TXT_FROM]?.count)! > 0 && (dict[K_TXT_TO]?.count)! > 0  {
                        
                        fromtime = dict[K_TXT_FROM]!
                        toime = dict[K_TXT_TO]!
                        let infoDict = [DAY:"\(index + 1)",FROM_TIME:fromtime,TO_TIME:toime]
                        jsonTimearr?.add(infoDict)
                    }

                    else if index == 0 && (dict[K_TXT_FROM]?.count)! <= 0 && (dict[K_TXT_TO]?.count)! > 0 {
                        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAvailability.SELECT_FROM_TIME.titlecontent())
                        HELPER.hideLoadingAnimation()
                        return
                    }
                    else if index == 0 && (dict[K_TXT_FROM]?.count)! > 0 && (dict[K_TXT_TO]?.count)! <= 0{
                        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAvailability.SELECT_TO_TIME.titlecontent())
                        HELPER.hideLoadingAnimation()
                        return
                    }
                    else {
                        
                        dict[K_TXT_FROM]! = fromtime
                        dict[K_TXT_TO]! = toime
                        myAryTimeInfo[index] = dict
                        let infoDict:[String:String] = [DAY:"\(index + 1)",FROM_TIME:fromtime,TO_TIME:toime]
                        jsonTimearr?.add(infoDict)
                        
                    }
                }
            }
            else {

                for index in 1..<myAryTimeInfo.count  {
                    
                    let dict = myAryTimeInfo[index]
                    if (dict[K_TXT_FROM]?.count)! <= 0 && (dict[K_TXT_TO]?.count)! > 0 {
                        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAvailability.SELECT_FROM_TIME.titlecontent())
                        HELPER.hideLoadingAnimation()
                        return
                    }
                    else if (dict[K_TXT_FROM]?.count)! > 0 && (dict[K_TXT_TO]?.count)! <= 0 {
                        HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAvailability.SELECT_TO_TIME.titlecontent())
                        HELPER.hideLoadingAnimation()
                        return
                    }
                else if (dict[K_TXT_FROM]?.count)! > 0 && (dict[K_TXT_TO]?.count)! > 0 {
                        fromtime = dict[K_TXT_FROM]!
                        toime = dict[K_TXT_TO]!
                        let infoDict:[String:String] = [DAY:"\(index )",FROM_TIME:fromtime,TO_TIME:toime]
                        jsonTimearr?.add(infoDict)
                        isAvailbleSelected = true
                    }

                  
                }
                
                if isAvailbleSelected == false {
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ProviderAvailability.SELECT_DATES.titlecontent())
                    HELPER.hideLoadingAnimation()
                    return
                }
                
            }
            
            var aDictParams = [String:String]()
            aDictParams["availability"] = json(from: jsonTimearr ?? [])
                    
            HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_PROVIDER_AVAILABILITY,dictParameters:aDictParams, sucessBlock: { response in
                
                HELPER.hideLoadingAnimation()
                
                if response.count != 0 {
                    
                    let aDictResponse = response[kRESPONSE] as! [String : String]
                    
                    let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                    
                    if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                        
                        HELPER.hideLoadingAnimation()
                        
                        HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: aMessageResponse!, okActionBlock: { (action) in
                            
                            self.navigationController?.popViewController(animated: true)
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
        
        func getAvailabilityFromApi() {
            if !HELPER.isConnectedToNetwork() {
                       
                       HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
                       return
                   }
            HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
            
            HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_PROVIDER_AVAILABILITY_DETAIL, sucessBlock: { response in
                
                HELPER.hideLoadingAnimation()
                
                if response.count != 0 {
                    
                    let aDictResponse = response[kRESPONSE] as! [String : String]
                    
                    let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                    
                    if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                        
                        var aDictResponseData = [String:Any]()
                        aDictResponseData = response["data"] as! [String:Any]
                        
                        self.myDictResponseInfo = aDictResponseData
                        self.timeAryFormat()
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
        
        func timeAryFormat() {
            
            if myDictResponseInfo.count != 0 {
                
                let aStrJsonForAvailability = myDictResponseInfo["availability"]
                
                let dataForAvail = (aStrJsonForAvailability as AnyObject).data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)!
                
                do {
                    
                    let arrayAvail = try JSONSerialization.jsonObject(with: dataForAvail, options: []) as! [Any]
                    print(arrayAvail)
                    
                    for var i in 0...7 {
                        myAryTimeInfo.append([K_TXT_FROM:"",K_TXT_TO:""])
                        
                    }
                    
                    for info in arrayAvail {
                        
                        let dict:[String:Any] = info as! [String : Any]
                        let fromTime:String = dict["from_time"] as! String
                        let toTime:String = dict["to_time"] as! String
                        let day:String = String(format: "%@", dict["day"] as! CVarArg)//dict["day"] as! String
                        
                        let indexValue = Int(day)
                        var dictInfo = myAryTimeInfo[indexValue!]
                        dictInfo[K_TXT_FROM] = fromTime
                        dictInfo[K_TXT_TO] = toTime
                        
                        myAryTimeInfo[indexValue!] = dictInfo
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
            else {
                for var i in 0...7 {
                    myAryTimeInfo.append([K_TXT_FROM:"",K_TXT_TO:""])
                }
            }
            
            self.myTblView .reloadData()
        }
        
        // MARK:- Left Bar Button Methods
        func setUpLeftBarBackButton() {
            
            let leftBtn = UIButton(type: .custom)
            if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            leftBtn.setImage(UIImage(named: ICON_BACK)?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)               }
                          else {
                             leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
                          }
//            leftBtn.setImage(UIImage(named: ICON_BACK), for: .normal)
            leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            leftBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
            
            let leftBarBtnItem = UIBarButtonItem(customView: leftBtn)
            self.navigationItem.leftBarButtonItem = leftBarBtnItem
        }
        
        @objc func backBtnTapped() {
            
            self.navigationController?.popViewController(animated: true)
        }
        
        // MARK:- Convert to json
        func json(from object:Any) -> String? {
            guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
                return nil
            }
            return String(data: data, encoding: String.Encoding.utf8)
        }
    }
