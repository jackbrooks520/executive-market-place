
import UIKit
import Presentr

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        //        setupMiddleButton()
        if SESSION.getUserToken().count == 0 {
            getLoginType()
        }
        
        self.tabBar.backgroundColor = UIColor.white
        
        let aUserType:String = SESSION.getUserLogInType()
        var tabOne = UIViewController()
        if aUserType == "1" { //Provider
            
            // Create Tab one
            tabOne = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_PROVIDER_VC)
            let tabOneBarItem = UITabBarItem(title: TabBarScreen.TAB_HOME.titlecontent(), image: UIImage(named: "icon_tab_home_grey"), selectedImage: UIImage(named: "icon_tab_home_grey"))
            tabOne.tabBarItem = tabOneBarItem
            
            self.tabBar.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            
            // Create Tab two
            let tabTwo = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHAT_LIST)
            let tabTwoBarItem2 = UITabBarItem(title: TabBarScreen.TAB_CHAT.titlecontent(), image: UIImage(named: "icon_tab_chat_grey"), selectedImage: UIImage(named: "icon_tab_chat_grey"))
            
            tabTwo.tabBarItem = tabTwoBarItem2
            
           
            // Create Tab four
            let tabFour = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_BOOKING_LIST_VC)
            
            let tabFourBarItem4 = UITabBarItem(title: TabBarScreen.TAB_BOOKINGS.titlecontent(), image: UIImage(named: "icon_tab_bookings_grey"), selectedImage: UIImage(named: "icon_tab_bookings_grey"))
            tabFour.tabBarItem = tabFourBarItem4
            
            // Create Tab five
            let tabFive = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_SETINGS_VC)
            let tabFiveBarItem5 = UITabBarItem(title: TabBarScreen.TAB_SETTINGS.titlecontent(), image: UIImage(named: "icon_tab_settings_grey"), selectedImage: UIImage(named: "icon_tab_settings_grey"))
            
            tabFive.tabBarItem = tabFiveBarItem5
            
            self.viewControllers = [tabOne, tabTwo, tabFour, tabFive]
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for:.normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: HELPER.hexStringToUIColor(hex: SESSION.getAppColor())], for:.selected)
     
        }
        else { //User or Guest
            
            // Create Tab one
            tabOne = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_VC)
            let tabOneBarItem = UITabBarItem(title: TabBarScreen.TAB_HOME.titlecontent(), image: UIImage(named: "icon_tab_home_grey"), selectedImage: UIImage(named: "icon_tab_home_pink"))
            tabOne.tabBarItem = tabOneBarItem
            
            self.tabBar.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
            
            // Create Tab two
            let tabTwo = DASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_CHAT_LIST)
            let tabTwoBarItem2 = UITabBarItem(title: TabBarScreen.TAB_CHAT.titlecontent(), image: UIImage(named: "icon_tab_chat_grey"), selectedImage: UIImage(named: "icon_tab_chat_grey"))
            
            tabTwo.tabBarItem = tabTwoBarItem2
            
         
            // Create Tab four
            let tabFour = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_BOOKING_LIST_VC)
            
            let tabFourBarItem4 = UITabBarItem(title: TabBarScreen.TAB_BOOKINGS.titlecontent(), image: UIImage(named: "icon_tab_bookings_grey"), selectedImage: UIImage(named: "icon_tab_bookings_grey"))
            tabFour.tabBarItem = tabFourBarItem4
            
            // Create Tab five
            let tabFive = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_SETINGS_VC)
            let tabFiveBarItem5 = UITabBarItem(title: TabBarScreen.TAB_SETTINGS.titlecontent(), image: UIImage(named: "icon_tab_settings_grey"), selectedImage: UIImage(named: "icon_tab_settings_grey"))
            
            tabFive.tabBarItem = tabFiveBarItem5
            
            self.viewControllers = [tabOne, tabTwo, tabFour, tabFive]
            
        
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTimezoneType()
        self.tabBar.tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: HELPER.hexStringToUIColor(hex: SESSION.getAppColor())], for:.selected)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 0 { //Home
            
            
        }
        else if tabBarController.selectedIndex == 1 { //Chat
            
            if SESSION.getUserToken().count == 0 {
                
                self.LogInUserScreen()
            }
            else {
                
            }
        }
        
        else if tabBarController.selectedIndex == 2 { //Bookings
            
            if SESSION.getUserToken().count == 0 {
                
                self.LogInUserScreen()
            }
            else {
                
                
            }
        }
        else { //Settings
            
            if  SESSION.getUserToken().count == 0 {
                
                self.LogInUserScreen()
            }
            else {
                
                
            }
        }
        viewController.viewWillAppear(true)
    }
    
    func setupMiddleButton() {
        
        let menuButton = UIButton(frame: CGRect(x: 40, y: 40, width: 64, height: 64))
        var menuButtonFrame = menuButton.frame
        
        var SafeAreaHeight:CGFloat
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            
            SafeAreaHeight = window.frame.maxY - safeFrame.maxY + 5
            menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - SafeAreaHeight
        } else {
            // Fallback on earlier versions
        }
        
        //        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 5
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        view.addSubview(menuButton)
        menuButton.setImage(UIImage(named: "icon_tab_logo"), for: .normal)
        menuButton.backgroundColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        menuButton.layer.cornerRadius = 32
        menuButton.isUserInteractionEnabled = false
        
        view.layoutIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func LogInUserScreen() {
        
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_NEW_USER_LOGIN_VC) as! UserLogInViewController
        aViewController.isFromTabbar = true
        let width = ModalSize.full
        let height =  ModalSize.full //ModalSize.fluid(percentage: 0.50) //ModalSize.half //
        
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
        //        customPresenter.backgroundTap = .noAction
        self.customPresentViewController(customPresenter, viewController: aViewController, animated: true, completion: nil)
    }
    
    
    func getTimezoneType() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        //        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_DATE_TIME_FORMAT, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : Any]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                let aIntResponseCode = aDictResponse[kRESPONSE_CODE] as! Int
                if (aIntResponseCode == kRESPONSE_CODE_DATA) {
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    WEB_DATE_FORMAT = aDictResponseData["date_format"]  as? String ?? strStaticDateFormat
                    
                }
                
                else {
                    HELPER.hideLoadingAnimation()
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse as! String)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }
    
    func getLoginType() {
        if !HELPER.isConnectedToNetwork() {
            
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_NO_INTERNET_DESC)
            return
        }
        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL + CASE_LOGIN_TYPE, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                var aDictResponse = response[kRESPONSE] as! [String : Any]
                
                let aMessageResponse = aDictResponse[kRESPONSE_MESSAGE]
                let aIntResponseCode = aDictResponse[kRESPONSE_CODE] as! Int
                if (aIntResponseCode == kRESPONSE_CODE_DATA) {
                    
                    var aDictResponseData = [String:Any]()
                    aDictResponseData = response["data"] as! [String:Any]
                    let aLoginType = aDictResponseData["login_type"] as! String
                    if aLoginType == "email" {
                        SESSION.setIsFromEmailLogin(aBoolLoginType: true)
                    }
                    else {
                        SESSION.setIsFromEmailLogin(aBoolLoginType: false)
                    }
                    
                    
                }
                
                else {
                    HELPER.hideLoadingAnimation()
                    HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse as! String)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: ALERT_TYPE_SERVER_ERROR)
        })
    }
}
