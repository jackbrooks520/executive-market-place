 

import UIKit
import CZPicker
import Presentr
import CoreLocation

class NewSettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CZPickerViewDelegate,CZPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var myTblView: UITableView!
    @IBOutlet weak var myLblSettingTitle: UILabel!
    
    let cellTableHeaderIdentifier = "HomeNewHeaderTableViewCell"
    let cellTableProfileIdentifier = "NewSettingsProfileTableViewCell"
    let cellTableListIdentifier = "NewSettingsTableViewCell"
    
    var myAryLangInfo = [String]()
    //    var countryImages = [UIImage]()
    var myStrLangName = String()
    var myAryLangList = [[String:String]]()
    var myStrLangType = String()
    var myDictProviderInfo = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpModel()
        loadModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        NAVIGAION.setNavigationTitle(aStrTitle: "Settings", aViewController: self)
        NAVIGAION.hideNavigationBar(aViewController: self)
        myLblSettingTitle.text = SettingsLangContents.SETTINGS_TITLE.titlecontent()//"Settings"
        myTblView.reloadData()
        super.viewWillAppear(animated)
    }
    
    func setUpUI() {
        
        myTblView.delegate = self
        myTblView.dataSource = self
        myTblView.register(UINib.init(nibName: cellTableHeaderIdentifier, bundle: nil), forCellReuseIdentifier: cellTableHeaderIdentifier)
        myTblView.register(UINib.init(nibName: cellTableProfileIdentifier, bundle: nil), forCellReuseIdentifier: cellTableProfileIdentifier)
        myTblView.register(UINib.init(nibName: cellTableListIdentifier, bundle: nil), forCellReuseIdentifier: cellTableListIdentifier)
    }
    
    func setUpModel() {
        
        
    }
    
    func loadModel() {
        callLanguageList()
        if SESSION.getUserLogInType() == "1" {
        getProfileDetailsProviderFromApi()
        }
    }
    
    // MARK: - TableView delegate and datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            if SESSION.getUserLogInType() == "1" {
                return 4
            }
            else {
                return 6
            }
            
        }
        else if section == 2 {
            if SESSION.getUserLogInType() == "1" {
                return 6
            }
            else {
                return 5
            }
            
        }
        else {
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            
            return 0
        }
        else {
            
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 130
        }
        else {
            
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var aCell:HomeNewHeaderTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellTableHeaderIdentifier) as? HomeNewHeaderTableViewCell
        
        
        aCell?.gImgViewViewAll.image = UIImage(named: "icon_home_view_all")
        if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
            aCell?.gLblHeader.textAlignment = .right
        }
        else {
            aCell?.gLblHeader.textAlignment = .left
        }
        aCell?.gLblViewAll.text = ""
        aCell?.gViewAll.isHidden = true
        aCell?.gBtnViewAll.isUserInteractionEnabled = false
        
        aCell?.backgroundColor = UIColor.clear
        
        if  (aCell == nil) {
            
            let nib:NSArray=Bundle.main.loadNibNamed(cellTableHeaderIdentifier, owner: self, options: nil)! as NSArray
            aCell = nib.object(at: 0) as? HomeNewHeaderTableViewCell
        }
        
        else {
            
            if section == 1 {
                
                aCell?.gLblHeader.text = SettingsLangContents.REGIONAL_TITLE.titlecontent()
            }
            else {
                
                aCell?.gLblHeader.text = SettingsLangContents.OTHERS_TITLE.titlecontent()
            }
            
            aCell?.gViewDesign.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getSecondaryAppColor())
            HELPER.setRoundCornerView(aView: aCell!.gViewDesign, borderRadius: 2.5)
        }
        
        if section == 1 {
            
            aCell?.gLblHeader.text = SettingsLangContents.REGIONAL_TITLE.titlecontent()
        }
        else {
            
            aCell?.gLblHeader.text = SettingsLangContents.OTHERS_TITLE.titlecontent()
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableProfileIdentifier, for: indexPath) as! NewSettingsProfileTableViewCell
            
            HELPER.setBorderView(aView: aCell.gViewEdit, borderWidth: 0.5, borderColor: .darkGray, cornerRadius: 15.0)
            //RTL
            aCell.gLblEditContent.text = SettingsLangContents.EDIT_PROFILE_TITLE.titlecontent()
            aCell.gContainerViewUserImage.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            HELPER.setRoundCornerView(aView: aCell.gContainerViewUserImage)
            HELPER.setRoundCornerView(aView: aCell.gImgViewUserImage)
            
            aCell.gLblName.text = SESSION.getUserInfoNew().0
            aCell.gLblEmail.text = SESSION.getUserInfoNew().1
            
            aCell.gImgViewUserImage.setShowActivityIndicator(true)
            //
            //           let origImage = UIImage(named: "icon_profile_placeholder")
            //                 let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            //
            //
            //            aCell.gImgViewUserImage.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            //            aCell.gImgViewUserImage.setIndicatorStyle(UIActivityIndicatorViewStyle.gray)
            //              aCell.gImgViewUserImage.sd_setImage(with: URL(string: WEB_BASE_URL + SESSION.getUserImage()), placeholderImage: tintedImage )
            
            aCell.gImgViewUserImage.sd_setImage(with: URL(string: WEB_BASE_URL + SESSION.getUserImage()), placeholderImage: UIImage(named: MENU_USER_PLACEHOLDER))
            
            return aCell
        }
        else if indexPath.section == 1 {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableListIdentifier, for: indexPath) as! NewSettingsTableViewCell
            
            if SESSION.getUserLogInType() == "1" {
                
                if indexPath.row == 0 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    //                    HELPER.changeTheButtonImageColorWithHex(hex: SESSION.getAppColor(), button: aCell.gBtnAlreadyUser, imageName: "icon_new_uncheck")
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_notification")
                    
                    //                    aCell.gImgViewFirst.image = UIImage(named: "icon_new_notification")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    //                    aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = SettingsLangContents.NOTIFICATIONS_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if  indexPath.row == 1 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_account_details")
                    
                    //                    aCell.gImgViewFirst.image = UIImage(named: "icon_new_account_details")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()
                        aCell.gLblListName.textAlignment = .right
                    }
                    else {
                        aCell.gLblListName.textAlignment = .left
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    //                    aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = SettingsLangContents.WALLET_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 2 {
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_lang")
                    
                    //     aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_lang")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()
                        aCell.gLblListType.textAlignment = .left
                    }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        aCell.gLblListType.textAlignment = .right
                        
                    }
                    //   aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = SettingsLangContents.LANGUAGE_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = false
                    aCell.gLblListType.text = SESSION.getAppLanguage()
                    aCell.gViewLine.isHidden = false
                }
                
                else {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_theme")
                    //                    aCell.gImgViewFirst.image = UIImage(named: "")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()
                        aCell.gLblListName.textAlignment = .right
                    }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        aCell.gLblListName.textAlignment = .left
                    }
                    //                                   aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = SettingsLangContents.CHANGE_COLOR_TITLE.titlecontent() 
                    aCell.gLblListType.isHidden = true
                    
                    aCell.gViewLine.isHidden = true
                }
                if aCell.gLblListType.isHidden {
                    aCell.gListTypeWidth.constant = 0
                } else {
                    aCell.gListTypeWidth.constant = 80
                }
            }
            else {
                if indexPath.row == 0 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_notification")
                    //                    aCell.gImgViewFirst.image = UIImage(named: "icon_new_notification")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    }
                    //                    aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = SettingsLangContents.NOTIFICATIONS_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 1 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_notification")
                    //                    aCell.gImgViewFirst.image = UIImage(named: "icon_new_notification")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    }
                    //                    aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = CommonTitle.FAVOURITES.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 2 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_account_details")
                    //                    aCell.gImgViewFirst.image = UIImage(named: "icon_new_account_details")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    //                    aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = SettingsLangContents.WALLET_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 3 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_location")
                    //                    aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_location")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()
                        aCell.gLblListType.textAlignment = .left
                    }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        aCell.gLblListType.textAlignment = .right
                        
                    }
                    //                    aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = SettingsLangContents.CHANGE_LOCATION_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = false
                    
                    let aStrLocName: String = SESSION.getLocationNameUpdate()
                    
                    if aStrLocName.count != 0 {
                        
                        aCell.gLblListType.text = aStrLocName
                    }
                    else {
                        
                        aCell.gLblListType.text = ""
                    }
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 4 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_lang")
                    //                    aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_lang")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()
                        aCell.gLblListType.textAlignment = .left
                    }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        aCell.gLblListType.textAlignment = .right
                    }
                    //                                   aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = SettingsLangContents.LANGUAGE_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = false
                    aCell.gLblListType.text = SESSION.getAppLanguage()
                    aCell.gViewLine.isHidden = false
                }
                
                else {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_theme")
                    //                    aCell.gImgViewFirst.image = UIImage(named: "")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()
                        aCell.gLblListType.textAlignment = .left
                    }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        aCell.gLblListType.textAlignment = .right
                    }
                    //                                   aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = SettingsLangContents.CHANGE_COLOR_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    
                    aCell.gViewLine.isHidden = true
                }
                if aCell.gLblListType.isHidden {
                    aCell.gListTypeWidth.constant = 0
                } else {
                    aCell.gListTypeWidth.constant = 80
                }
                  
            }
            return aCell
        }
        else {
            
            let aCell = tableView.dequeueReusableCell(withIdentifier: cellTableListIdentifier, for: indexPath) as! NewSettingsTableViewCell
            if SESSION.getUserLogInType() == "1" {
                if indexPath.row == 0 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_account_details")
                    //                    aCell.gImgViewFirst.image = UIImage(named: "")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()
                        aCell.gLblListType.textAlignment = .left
                    }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        aCell.gLblListType.textAlignment = .right
                    }
                    //                                   aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                    aCell.gLblListName.text = SettingsLangContents.ACCOUNT_SETTINGS.titlecontent()
                    aCell.gLblListType.isHidden = true
                    
                    aCell.gViewLine.isHidden = false
                }
                
                else if indexPath.row == 1 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_contact")
                    //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_contact")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    aCell.gLblListName.text = SettingsLangContents.MAKE_SUGGESSION_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 2 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_t&c")
                    //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_t&c")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    aCell.gLblListName.text = SettingsLangContents.TEARMS_AND_CONDITION_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 3 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_share_app")
                    //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_share_app")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    aCell.gLblListName.text = SettingsLangContents.SHARE_APP_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 4 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_rate_us")
                    
                    //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_rate_us")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    aCell.gLblListName.text = SettingsLangContents.RATE_APP_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_logout")
                    
                    //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_logout")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()
                        aCell.gLblListName.textAlignment = .right
                    }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        aCell.gLblListName.textAlignment = .left
                    }
                    aCell.gLblListName.text = SettingsLangContents.LOGOUT_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = true
                }
                if aCell.gLblListType.isHidden {
                    aCell.gListTypeWidth.constant = 0
                } else {
                    aCell.gListTypeWidth.constant = 80
                }
            }
            else {
                
                
                if indexPath.row == 0 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_contact")
                    //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_contact")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    aCell.gLblListName.text = SettingsLangContents.MAKE_SUGGESSION_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 1 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_t&c")
                    //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_t&c")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    aCell.gLblListName.text = SettingsLangContents.TEARMS_AND_CONDITION_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 2 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_share_app")
                    //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_share_app")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    aCell.gLblListName.text = SettingsLangContents.SHARE_APP_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else if indexPath.row == 3 {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_rate_us")
                    
                    //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_rate_us")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    aCell.gLblListName.text = SettingsLangContents.RATE_APP_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = false
                }
                else {
                    
                    HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
                    HELPER.changeTheImageViewColorWithHex(hex: SESSION.getAppColor(), imageView: aCell.gImgViewFirst, imageName: "icon_new_settings_logout")
                    
                    //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_logout")
                    if UIView.appearance().semanticContentAttribute == .forceRightToLeft {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")?.withHorizontallyFlippedOrientation()                           }
                    else {
                        aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
                        
                    }
                    aCell.gLblListName.text = SettingsLangContents.LOGOUT_TITLE.titlecontent()
                    aCell.gLblListType.isHidden = true
                    aCell.gViewLine.isHidden = true
                }
                if aCell.gLblListType.isHidden {
                    aCell.gListTypeWidth.constant = 0
                } else {
                    aCell.gListTypeWidth.constant = 80
                }
            }
            
            //            else {
            //
            //                HELPER.setRoundCornerView(aView: aCell.gContainerView, borderRadius: 10.0)
            //                aCell.gImgViewFirst.image = UIImage(named: "icon_new_settings_delete")
            //                aCell.gimgViewLast.image = UIImage(named: "icon_new_circle_arrow")
            //                aCell.gLblListName.text = "Delete account"
            //                aCell.gLblListType.isHidden = true
            //                aCell.gViewLine.isHidden = true
            //            }
            return aCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_MY_PROFILE) as! MyProfileViewController
            aViewController.isFromProvider = true
            self.navigationController?.pushViewController(aViewController, animated: true)
            
        }
        else if indexPath.section == 2 {
            if SESSION.getUserLogInType() == "1" {
                if indexPath.row == 0 {
                    let aViewController = GSStripeViewController()
                    self.navigationController?.pushViewController(aViewController, animated: true)
//                    let aViewController = GSPaymentViewController()
//                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if indexPath.row == 1 {
                    
                    let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_WEBVIEW_VC) as! WebViewViewController
                    aViewController.gStrTitle = SettingsLangContents.MAKE_SUGGESSION_TITLE.titlecontent()
                    aViewController.gStrContent = CONTACT_URL
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if indexPath.row == 2 {
                    
                    let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_WEBVIEW_VC) as! WebViewViewController
                    aViewController.gStrTitle = SettingsLangContents.TEARMS_AND_CONDITION_TITLE.titlecontent()
                    aViewController.gStrContent = TERMS_CONDITION_URL
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if indexPath.row == 3 {
                    
                    if APP_STORE_URL.count != 0 {
                        
                        share()
                    }
                }
                else if indexPath.row == 4 {
                    
                    if APP_STORE_URL.count != 0 {
                        
                        let url = URL(string : APP_STORE_URL)!
                        UIApplication.shared.open(URL(string: "\(url)")!)
                    }
                }
                else  { //logout
                    
                    HELPER.showAlertControllerIn(aViewController: self, aStrMessage: SettingsLangContents.SURE_WANT_TO_LOGOUT.titlecontent(), okButtonTitle: CommonTitle.YES_BTN.titlecontent(), cancelBtnTitle: CommonTitle.NO_BTN.titlecontent(), okActionBlock: { (sucessAction) in
                        
                        self.getLogoutApi()
                        
                    }, cancelActionBlock: { (cancelAction) in
                        
                    })
                }
            }
            else {
                if indexPath.row == 0 {
                    
                    let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_WEBVIEW_VC) as! WebViewViewController
                    aViewController.gStrTitle = SettingsLangContents.MAKE_SUGGESSION_TITLE.titlecontent()
                    aViewController.gStrContent = CONTACT_URL
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if indexPath.row == 1 {
                    
                    let aViewController = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_WEBVIEW_VC) as! WebViewViewController
                    aViewController.gStrTitle = SettingsLangContents.TEARMS_AND_CONDITION_TITLE.titlecontent()
                    aViewController.gStrContent = TERMS_CONDITION_URL
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if indexPath.row == 2 {
                    
                    if APP_STORE_URL.count != 0 {
                        
                        share()
                    }
                }
                else if indexPath.row == 3 {
                    
                    if APP_STORE_URL.count != 0 {
                        
                        let url = URL(string : APP_STORE_URL)!
                        UIApplication.shared.open(URL(string: "\(url)")!)
                    }
                }
                else  { //logout
                    
                    HELPER.showAlertControllerIn(aViewController: self, aStrMessage: SettingsLangContents.SURE_WANT_TO_LOGOUT.titlecontent(), okButtonTitle: CommonTitle.YES_BTN.titlecontent(), cancelBtnTitle: CommonTitle.NO_BTN.titlecontent(), okActionBlock: { (sucessAction) in
                        
                        self.getLogoutApi()
                        
                    }, cancelActionBlock: { (cancelAction) in
                        
                    })
                }
            }
            
            
        }
        else {
            
            if SESSION.getUserLogInType() == "1" {
                
                if indexPath.row == 0 {
                    
                    let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SETTINGS_NOTIFICATIONS) as! NewNotificationsViewController
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if indexPath.row == 1 {
                    let aViewController = GSWaletViewController()
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if indexPath.row == 2  {
                    let picker = CZPickerView(headerTitle: SettingsLangContents.CHOOSE_LANGUAGE.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
                    picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                    picker?.delegate = self
                    picker?.dataSource = self
                    picker?.needFooterView = false
                    picker?.show()
                }
                
                else {
                    let aViewController = GSChangeColorViewController()
                    let width = ModalSize.full
                    let height = ModalSize.fluid(percentage: 0.60)
                    
                    //        let width = ModalSize.custom(size: 320)
                    //        let height = ModalSize.custom(size: 300)
                    
                    let center = ModalCenterPosition.center
                    let customType = PresentationType.custom(width: width, height: height, center: center)
                    
                    let customPresenter = Presentr(presentationType: customType)
                    customPresenter.transitionType = .coverVertical
                    customPresenter.dismissTransitionType = .coverVertical
                    customPresenter.roundCorners = true
                    customPresenter.dismissOnSwipe = false
                    customPresenter.dismissOnSwipeDirection = .default
                    customPresenter.blurBackground = false
                    customPresenter.blurStyle = .extraLight
                    //                     customPresenter.dismissOnTap = true
                    
                    self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
                    
                }
            }
            else {
                
                if indexPath.row == 0 {
                    
                    let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SETTINGS_NOTIFICATIONS) as! NewNotificationsViewController
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if indexPath.row == 1 {
                    let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_SEARCH_LIST_VC) as! NewSearchViewController
                    aViewController.gBoolIsFromFavourite = true
                    aViewController.gStrSearchTitle =  CommonTitle.FAVOURITE_LIST.titlecontent()
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if indexPath.row == 2 {
                    let aViewController = GSWaletViewController()
                    self.navigationController?.pushViewController(aViewController, animated: true)
                }
                else if indexPath.row == 3 {
                    
                    if CLLocationManager.locationServicesEnabled() {
                        switch CLLocationManager.authorizationStatus() {
                        case .notDetermined, .restricted, .denied:
                            print("No access")
                            SESSION.setUserLatLong(lat: "", long: "")
                            HELPER.showAlertControllerIn(aViewController: self, aStrMessage: CommonTitle.ENABLE_LOCATION_VALIDATION.titlecontent(), okButtonTitle: CommonTitle.ENABLE_LOCATION.titlecontent(), cancelBtnTitle: CommonTitle.NOT_NOW.titlecontent(), okActionBlock: {(sucessAction) in
                                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                    return
                                }
                                
                                if UIApplication.shared.canOpenURL(settingsUrl) {
                                    if #available(iOS 10.0, *) {
                                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                            print("Settings opened: \(success)") // Prints true
                                        })
                                    } else {
                                        // Fallback on earlier versions
                                    }
                                }
                            }, cancelActionBlock: { (cancelAction) in
                                
                            })
                            
                        case .authorizedAlways, .authorizedWhenInUse:
                            print("Access")
                            let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_MAP_VC) as! NewMapViewController
                            aViewController.isFromAddService = false
                            
                            if SESSION.getUserLatLong().0.count != 0 && SESSION.getUserLatLong().1.count != 0 {
                                
                                aViewController.gStrLat = SESSION.getUserLatLong().0
                                aViewController.gStrLong = SESSION.getUserLatLong().1
                            }
                            
                            self.navigationController?.pushViewController(aViewController, animated: true)
                        }
                    } else {
                    }
                    
                }
                else if indexPath.row == 4 {
                    let picker = CZPickerView(headerTitle: SettingsLangContents.CHOOSE_LANGUAGE.titlecontent(), cancelButtonTitle: "", confirmButtonTitle: "")
                    picker?.headerBackgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
                    picker?.delegate = self
                    picker?.dataSource = self
                    picker?.needFooterView = false
                    picker?.show()
                }
                
                else {
                    let aViewController = GSChangeColorViewController()
                    let width = ModalSize.full
                    let height = ModalSize.fluid(percentage: 0.50)
                    
                    //        let width = ModalSize.custom(size: 320)
                    //        let height = ModalSize.custom(size: 300)
                    
                    let center = ModalCenterPosition.center
                    let customType = PresentationType.custom(width: width, height: height, center: center)
                    
                    let customPresenter = Presentr(presentationType: customType)
                    customPresenter.transitionType = .coverVertical
                    customPresenter.dismissTransitionType = .coverVertical
                    customPresenter.roundCorners = true
                    customPresenter.dismissOnSwipe = false
                    customPresenter.dismissOnSwipeDirection = .default
                    customPresenter.blurBackground = false
                    customPresenter.blurStyle = .extraLight
                    //                     customPresenter.dismissOnTap = true
                    
                    self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    // MARK: - CZPicker delegate and datasource
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        
        return myAryLangList.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        
        return myAryLangList[row]["language"]
    }
    
    //    func czpickerView(_ pickerView: CZPickerView!, imageForRow row: Int) -> UIImage! {
    //
    //        if row == 0 {
    //
    //            return countryImages[0]
    //        }
    //        else if row == 1 {
    //
    //            return countryImages[1]
    //        }
    //        else {
    //
    //            return countryImages[2]
    //        }
    //    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int) {
        myStrLangType = myAryLangList[row]["language_value"]!
        let aLangTag = myAryLangList[row]["tag"]!
        let myStrLangName = myAryLangList[row]["language"]!
        SESSION.setAppLangType(aStrAppLangType: myStrLangType)
        SESSION.setAppLanguage(aStrAppLang: myStrLangName)
        callLanguage(langType: myStrLangType, aLangTag: aLangTag)
        
    }
    
    @objc func share(){
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //        let textToShare = "Check out my app" + ".\n"
        let textToShare = SettingsLangContents.REFERENCE_Text.titlecontent() + ".\n"
        
        if let myWebsite = URL(string: APP_STORE_URL) {//Enter link to your app here
//            let referenceCode = SettingsLangContents.REFERENCE_CODE.titlecontent() + SESSION.getReferenceCode()
            //            let objectsToShare = [textToShare, myWebsite,referenceCode, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            
//            let objectsToShare = [textToShare, myWebsite,referenceCode] as [Any]
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            //            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    
    
    
    //MARK: - Api Call
    //Language Detail
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
                             aDictStripe["account_ifsc"] = aDictTemp["ifsc_code"] as? String
                             aDictStripe["account_number"] = aDictTemp["acc_no"] as? String
                              aDictStripe["bank_name"] = aDictTemp["bank_name"] as? String
                      aDictStripe["bank_address"] = aDictTemp["bank_addr"] as? String
                              aDictStripe["id"] = aDictTemp["id"] as? String
                              aDictStripe["sort_code"] = aDictTemp["sort_code"] as? String
                             aDictStripe["routing_number"] = aDictTemp["routing_number"] as? String
                    aDictStripe["contact_number"] = aDictTemp["contact_number"] as? String
                    aDictStripe["email"] = aDictTemp["paypal_email_id"] as? String
             
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
    func callLanguage(langType:String, aLangTag: String) {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var dictParameters = [String:Any]()
        dictParameters["language"] = langType
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_LANGUAGE_TYPE, dictParameters: dictParameters as! [String : String], sucessBlock: { (response) in
            
            HELPER.hideLoadingAnimation()
            var aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                
                HELPER.hideLoadingAnimation(viewController: self)
                
                if aLangTag.uppercased() == "RTL" {
                    SESSION.setIsRtl(isRightToLeft: true)
                }
                else {
                    SESSION.setIsRtl(isRightToLeft: false)
                }
                
                var aDictData = [String:Any]()
                var aDictLanguage = [String:Any]()
                
                
                
                aDictData = response["data"] as! [String : Any]
                aDictLanguage = aDictData["language"] as! [String : Any]
                
                SESSION.setLangInfo(dictInfo: aDictLanguage)
                
                SESSION.setIsAppLaunchFirstTime(isLogin: true)
                
                //                 NotificationCenter.default.post(name: Notification.Name("callleftmenu"), object: nil)
                
                //                self.myTblView.reloadData()
                
                APPDELEGATE.loadTabbar()
            }
            
            else {
                
                HELPER.hideLoadingAnimation()
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                
                
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
    
    
    //LogOut
    func getLogoutApi() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["deviceid"] = SESSION.getDeviceToken()
        aDictParams["device_type"] = "iOS"
        aDictParams["type"] = SESSION.getUserLogInType()
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_NEW_LOGOUT,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    SESSION.setUserLogInType(aStrUserLogInType: "")
                    SESSION.setUserToken(aStrUserToken: "")
                    SESSION.setUserInfoNew(name: "", email: "", mobilenumber: "")
                    SESSION.setUserImage(aStrUserImage: "")
                    SESSION.setReferenceCode(aStrReferenceCode: "")
                    APPDELEGATE.loadTabbar()
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
    
    //Delete Account
    func getDeleteAccountApi() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["type"] = SESSION.getUserLogInType()
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_NEW_DELETE_ACCOUNT,dictParameters: aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : String]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    SESSION.setUserLogInType(aStrUserLogInType: "")
                    SESSION.setUserToken(aStrUserToken: "")
                    SESSION.setUserInfoNew(name: "", email: "", mobilenumber: "")
                    SESSION.setUserImage(aStrUserImage: "")
                    APPDELEGATE.loadTabbar()
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                    
                }
                else {                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }
    //Language List
    func callLanguageList() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            
            return
        }
        
        HELPER.showLoadingViewAnimation(viewController: self)
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_LANGUAGE_LIST, sucessBlock: {response in
            
            HELPER.hideLoadingAnimation(viewController: self)
            
            let aDictResponse = response[kRESPONSE] as! [String : String]
            
            let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
            
            if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                
                
                self.myAryLangList = response["data"] as! [[String : String]]
                self.myTblView.reloadData()
            }
            else {
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
            }
            
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation(viewController: self)
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: error)
        })
    }
}
