 
import UIKit
import IQKeyboardManagerSwift
import DrawerController
import GoogleMaps
import GooglePlaces
import Stripe
import Firebase
import UserNotifications
import FirebaseMessaging
import Braintree
//import netfox

var currentLocation = CLLocationCoordinate2D()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {
    
    var window: UIWindow?
    var drawerController: DrawerController!
    var locationManager = CLLocationManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        BTAppSwitch.setReturnURLScheme(PAYPALL_BUNDLE_ID)
        IQKeyboardManager.shared.disabledToolbarClasses = [ChatDetailViewController.self]
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatDetailViewController.self]
        IQKeyboardManager.shared.disabledTouchResignedClasses = [ChatDetailViewController.self]
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        IQKeyboardManager.shared.enable = true
        self.window = UIWindow (frame: UIScreen.main.bounds)
        
        UITextField.appearance().tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        UITextView.appearance().tintColor = HELPER.hexStringToUIColor(hex: SESSION.getAppColor())
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else {
            // Fallback on earlier versions
        }
        
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        
        self .initLocationManager()
        locationManager.delegate = self
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        let token = Messaging.messaging().fcmToken
        
        print("FCM token: \(token ?? "")")
        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            // If granted comes true you can enabled features based on authorization.
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        if SESSION.isAppLaunchFirstTime() {
            loadLanguageSceen()
        }
        else {
            loadTabbar()
        }
        return true
        
    }
    
    func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        SESSION.setDeviceToken(deviceToken: fcmToken ?? "")
        sendDeviceTokenToApi()
    }

    private func application(application: UIApplication,
                             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .active {
        }
        print(userInfo)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //        AppEvents.activateApp()
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        isChatDetailVisible = false
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        application.applicationIconBadgeNumber = 0
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        isChatDetailVisible = false
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func changeRootViewController(aViewController: UIViewController) {
        if !(window!.rootViewController != nil) {
            window?.rootViewController = aViewController
            return
        }
        let snapShot: UIView? = window?.snapshotView(afterScreenUpdates: true)
        aViewController.view.addSubview(snapShot!)
        window?.rootViewController = aViewController
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            snapShot?.layer.opacity = 0
            snapShot?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }, completion: {(_ finished: Bool) -> Void in
            snapShot?.removeFromSuperview()
        })
    }
    
    func loadTabbar() {
        if SESSION.IsLangRtl() == true {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        let loginViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: STORYBOARD_ID_HOME_NEW_TAB_BAR_VC)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        self.changeRootViewController(aViewController: navigationController)
        
    }
    
    func loadLanguageSceen() {
        let aViewController = NEWDASHBOARDSTORYBOARD.instantiateViewController(withIdentifier: "LanguageViewController")
        let navigationController = UINavigationController(rootViewController: aViewController)
        self.changeRootViewController(aViewController: navigationController)
    }
    
    // MARK:- Api call
    func sendDeviceTokenToApi() {
        
        //        HELPER.showLoadingAnimationWithTitle(aViewController: self, aStrText: "")
        
        var aDictParams = [String:String]()
        aDictParams["device_type"] = "ios"
        aDictParams["device_token"] = SESSION.getDeviceToken()
        
        HTTPMANAGER.callPostApi(strUrl: WEB_SERVICE_URL + CASE_NEW_NOTIFICATION_DEVICE_TOKEN,dictParameters:aDictParams, sucessBlock: { response in
            
            HELPER.hideLoadingAnimation()
            
            if response.count != 0 {
                
                let aDictResponse = response[kRESPONSE] as! [String : String]
                
                if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_DATA) {
                    
                    HELPER.hideLoadingAnimation()
                }
                else if (Int(aDictResponse[kRESPONSE_CODE]!) == kRESPONSE_CODE_NO_DATA) {
                    
                }
                else {
                    
                    //            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: APP_NAME, aStrMessage: aMessageResponse!)
                }
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
          
        })
    }
    
    // Stripe Key
    func userStripeKey() {
        
        
        HTTPMANAGER.callGetApi(strUrl: WEB_SERVICE_URL+CASE_STRIPE_KEY, sucessBlock: {response in
            
            HELPER.hideLoadingAnimation()
            
            var aDictResponse = [String:Any]()
            aDictResponse = response["response"] as! [String : Any]
            
            let aIntResponseCode = aDictResponse["response_code"] as! String
            var myDictStripeKey = [String:String]()
            
            if aIntResponseCode == "200" {
                
                myDictStripeKey = response["data"] as! [String:String]
                
                if myDictStripeKey["publishable_key"]!.count > 0 {
                    StripeAPI.defaultPublishableKey = myDictStripeKey["publishable_key"]
                }
                else {
                }
            }
            else if aIntResponseCode == "404" {
                HELPER.hideLoadingAnimation()
            }
            else {
                HELPER.hideLoadingAnimation()
            }
            
        }, failureBlock: { error in
            
            HELPER.hideLoadingAnimation()
            
        })
    }
    
    // MARK:- Location manager
    
    func initLocationManager() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.requestWhenInUseAuthorization()
        if locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    
    // MARK: CLLocaitonManager Delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("locations = \(locations)")
        let userLocation = locations.last
        
        print("Latitude :- \(userLocation!.coordinate.latitude)")
        print("Longitude :-\(userLocation!.coordinate.longitude)")
        
        SESSION.setUserLatLong(lat: String(userLocation!.coordinate.latitude), long:String( userLocation!.coordinate.longitude))
        
        let location = CLLocation(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        fetchCountryAndCity(location: location) { country, city in
            print("country:", country)
            print("city:", city)
            currentlocString = city + "," + country
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                      let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("HomeView location not fetching\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldIAllow = false
        
        switch status {
        case CLAuthorizationStatus.restricted:
            // locationStatus = "Restricted Access to location"
            print("Restricted Access to location")
            
        case CLAuthorizationStatus.denied:
            // locationStatus = "User denied access to location"
            print("User denied access to location")
        case CLAuthorizationStatus.notDetermined:
            // locationStatus = "Status not determined"
            print("Status not determined")
        default:
            // locationStatus = "Allowed to location Access"
            shouldIAllow = true
        }
        //   NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
        if (shouldIAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            locationManager.startUpdatingLocation()
        } else {
        }
    }
    
    // Open url
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?,annotation: Any) -> Bool {
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if url.scheme?.localizedCaseInsensitiveCompare(PAYPALL_BUNDLE_ID) == .orderedSame {
            return BTAppSwitch.handleOpen(url, options: options)
        }
        return false
    }
    
    
    // Remote notification
    
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            
            //Notifications get posted to the function (delegate):  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)"
            
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                //                if error == nil{
                //                    UIApplication.shared.registerForRemoteNotifications()
                //                }
                guard error == nil else {
                    //Display Error.. Handle Error.. etc..
                    return
                }
                
                if granted {
                    //Do stuff here..
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
   
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator:----->\(error)")
    }
    
    func notificationCallingSetUp(userInfo: NSDictionary){
        let app = UIApplication.shared
        var notificationType = ""
        var msg = ""
        print("userInfo:----->\(userInfo)")
        if let notifyType = userInfo["gcm.notification.notification"] as? String {
            notificationType = notifyType
        }
        
        
        if let aps = userInfo["aps"] as? NSDictionary {
            
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["body"] as? NSString {
                    msg = message as String
                }
            }
        }
        switch app.applicationState {
        case .active, .inactive, .background:
            if notificationType == "chat" {
                
                if let topController = UIApplication.topViewController() {
                    let topvc:DrawerController = topController as! DrawerController
                    print(topvc.navigationController?.visibleViewController ?? "")
                    if (isChatDetailVisible == true) {
                        
                        //                        let vc:ChatListViewController = topController as! ChatListViewController
                        
                        //                        vc.viewWillAppear(true)
                        
                        //                        let vc:ChatDetailViewController = topController as! ChatDetailViewController
                        let oldName = SESSION.getCurrentChatUserName()
                        let cUname:String = (userInfo["gcm.notification.chat_from_name"] as? String) ?? ""
                        if cUname == oldName {
                            
                            let chatDetails = ["chat_from":userInfo["gcm.notification.chat_from"] ?? "","chat_to":"","chat_utc_time":userInfo["gcm.notification.utctime"] ?? "","content":msg,"fromname":userInfo["gcm.notification.chat_from_name"] ?? ""] as [String : Any]
                            NotificationCenter.default.post(name: NSNotification.Name("GetChatDetails"), object: nil, userInfo: chatDetails)
                        }
                    }
                }
            }
            
            break
        default:
            break
            
        }
    }
    
    // RTL Method
    
    func isRTLSupportEnabled(flag: Bool) {
        if UIView().responds(to: #selector(setter:UIView.semanticContentAttribute)) {
            if flag {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            } else {
                UIView.appearance().semanticContentAttribute = .unspecified
            }
        }
    }
    
    
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS10+, called when presenting notification in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) willPresentNotification: \(userInfo)")
        //TODO: Handle foreground notification
        completionHandler([.alert, .badge, .sound])
    }
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)")
        //TODO: Handle background notification
        self .notificationCallingSetUp(userInfo: userInfo as NSDictionary)
        
        completionHandler()
    }
}
extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
        //        SESSION.setDeviceToken(deviceToken: fcmToken)
        if fcmToken.count != 0 {
            SESSION.setDeviceToken(deviceToken: fcmToken)
            sendDeviceTokenToApi()
        }
    }
    
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        self .notificationCallingSetUp(userInfo: userInfo as NSDictionary)
        
    }
}
extension UIWindow {
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(_ vc:UIViewController) -> UIViewController {
        if vc.isKind(of: UINavigationController.self) {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( navigationController.visibleViewController!)
        } else if vc.isKind(of: UITabBarController.self) {
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(presentedViewController.presentedViewController!)
            } else {
                return vc;
            }
        }
    }
}
extension UIApplication {
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
