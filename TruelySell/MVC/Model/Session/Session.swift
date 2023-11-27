//
//  Session.swift
//  DriverUtilites
//
//  Created by Guru Prasad chelliah on 10/24/17.
//  Copyright © 2017 project. All rights reserved.
//

import UIKit

class Session: NSObject {
    
    static let sharedInstance: Session = {
        
        let instance = Session()
        
        // setup code
        
        return instance
    }()
    
    
    // MARK: - Shared Methods
    
    func setAppLaunchIsFirstTime(isLogin : Bool) {
        
        
        UserDefaults.standard.set(isLogin, forKey: "app_launch_first_time")
        userdefaultsSynchronize()
    }
    
    func IsAppLaunchFirstTime() -> Bool {
        
        if  UserDefaults.standard.object(forKey: "app_launch_first_time") == nil {
            
            return true
        }
        
        return UserDefaults.standard.bool(forKey: "app_launch_first_time")
    }
    
    
    // Set and get user id
    
    func setIsUserLogIN(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "user_log_in")
        userdefaultsSynchronize()
    }
    
    func isUserLogIn() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "user_log_in")
    }
    
    func setIsUserLogINFirstTime(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "user_log_in_FirstTime")
        userdefaultsSynchronize()
    }
    
    func isUserLogInFirstTime() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "user_log_in_FirstTime")
    }
    
    // Set and get App Language Name
    func setAppLanguage(aStrAppLang : String) {
        
        UserDefaults.standard.set(aStrAppLang, forKey: "app_lang")
        userdefaultsSynchronize()
    }
    
    func getAppLanguage() -> String {
        
        if let appLang = UserDefaults.standard.string(forKey: "app_lang") {
            return appLang
        }
        return ""
        
    }
    
    // Set and get App Language Type
    func setAppLangType(aStrAppLangType : String) {
        
        UserDefaults.standard.set(aStrAppLangType, forKey: "app_lang_type")
        userdefaultsSynchronize()
    }
    
    func getAppLangType() -> String {
        
        if let appLang = UserDefaults.standard.string(forKey: "app_lang_type") {
            return appLang
        }
        return ""
        
    }
    
    // Set and get App Language contents
  
       func setLangInfo(dictInfo: [String:Any]) {
           
           UserDefaults.standard.set(dictInfo, forKey: "lang_info")
           userdefaultsSynchronize()
       }
       func getLangInfo() -> [String:Any] {
           
           if let info = UserDefaults.standard.dictionary(forKey: "lang_info") {
               return info
           }
           return [:]
       }
    
    // set and get location name
    func setLocationName(aStrLocName : String) {
        
        UserDefaults.standard.set(aStrLocName, forKey: "loc_name")
        userdefaultsSynchronize()
    }
    
    func getLocationName() -> String {
        
        if let appLang = UserDefaults.standard.string(forKey: "loc_name") {
            return appLang
        }
        return ""
        
    } //
    
    // Set and get App Language Image
    func setAppLanguageImage(aStrAppLang : String) {
        
        UserDefaults.standard.set(aStrAppLang, forKey: "app_lang_image")
        userdefaultsSynchronize()
    }
    
    func getAppLanguageImage() -> String {
        
        if let appLang = UserDefaults.standard.string(forKey: "app_lang_image") {
            return appLang
        }
        return ""
        
    } //
    
    
    // Set and get user id
    func setUserId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "user_id")
        userdefaultsSynchronize()
    }
    
    func getUserId() -> String {
        
        if let userid = UserDefaults.standard.string(forKey: "user_id") {
            return userid
        }
        return ""
        
    } //let K_USER_id = "userid"
    
    
    // facebook id
    
    func setUserFacebookId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "user_fbid")
        userdefaultsSynchronize()
    }
    
    func getUserFacebookId() -> String {
        
        if let userid = UserDefaults.standard.string(forKey: "user_fbid") {
            return userid
        }
        return ""
        
    }
    
    func setUserSignupdetailsForFB(fbId : String, uname:String, token:String) {
        
        UserDefaults.standard.set(fbId, forKey: "user_fbid")
        UserDefaults.standard.set(uname, forKey: "user_fbname")
        UserDefaults.standard.set(token, forKey: "user_fbtoken")
        //        UserDefaults.standard.set(profilepicurl, forKey: "user_fbprofilepic")
        
        
        userdefaultsSynchronize()
    }
    
    func getUserSignupdetailsForFB() -> (String,String,String) {
        
        var userid = ""
        var username = ""
        var usertoken = ""
        
        if let user = UserDefaults.standard.string(forKey: "user_fbid") {
            userid = user
        }
        if let usern = UserDefaults.standard.string(forKey: "user_fbname") {
            username = usern
        }
        if let usert = UserDefaults.standard.string(forKey: "user_fbtoken") {
            usertoken = usert
        }
        return (userid,username,usertoken )
        
    }
    
    // Set and get user location name
    func setUserLocName(aStrUserLocName : String) {
        
        UserDefaults.standard.set(aStrUserLocName, forKey: "user_loc_name")
        userdefaultsSynchronize()
    }
    
    func getUserLocName() -> String {
        
        if let userLocName = UserDefaults.standard.string(forKey: "user_loc_name") {
            return userLocName
        }
        return ""
        
    }
    
    // Lat Long
    
    func setUserLatLong(lat: String,long:String) {
        
        UserDefaults.standard.set(lat, forKey: "user_Lat")
        UserDefaults.standard.set(long, forKey: "user_Long")
        userdefaultsSynchronize()
    }
    
    func getUserLatLong() -> (String,String) {
        
        var userlat = ""
        var userlong = ""
        
        if let usern = UserDefaults.standard.string(forKey: "user_Lat") {
            userlat = usern
        }
        if let usert = UserDefaults.standard.string(forKey: "user_Long") {
            userlong = usert
        }
        return (userlat,userlong )
    }
    
    func setUserUpdatedLatLonginGoogleSearch(lat: String,long:String) {
        
        UserDefaults.standard.set(lat, forKey: "user_Lat_Updated")
        UserDefaults.standard.set(long, forKey: "user_Long_Updated")
        userdefaultsSynchronize()
    }
    
    func getUserUpdatedLatLonginGoogleSearch() -> (String,String) {
        
        var userlat = ""
        var userlong = ""
        
        if let usern = UserDefaults.standard.string(forKey: "user_Lat_Updated") {
            userlat = usern
        }
        if let usert = UserDefaults.standard.string(forKey: "user_Long_Updated") {
            userlong = usert
        }
        return (userlat,userlong )
    }
    
    func setUserUpdatedLatLonginGoogleSearchBook(lat: String,long:String) {
        
        UserDefaults.standard.set(lat, forKey: "user_Lat_Updated_book")
        UserDefaults.standard.set(long, forKey: "user_Long_Updated_book")
        userdefaultsSynchronize()
    }
    
    func getUserUpdatedLatLonginGoogleSearchBook() -> (String,String) {
        
        var userlat = ""
        var userlong = ""
        
        if let usern = UserDefaults.standard.string(forKey: "user_Lat_Updated_book") {
            userlat = usern
        }
        if let usert = UserDefaults.standard.string(forKey: "user_Long_Updated_book") {
            userlong = usert
        }
        return (userlat,userlong )
    }
    func setLocationZoom(zoom : Float) {
        UserDefaults.standard.set(zoom, forKey: "loc_Zoom")
        userdefaultsSynchronize()
    }
    func getLocationZoom() -> Float {
        UserDefaults.standard.float(forKey: "loc_Zoom")
        
    }
    
    // Set and get location name
    
    func setUsesetLocationNameUpdate(name : String) {
        
        UserDefaults.standard.set(name, forKey: "loc_name")
        userdefaultsSynchronize()
    }
    
    func getLocationNameUpdate() -> String {
        
        if let locname = UserDefaults.standard.string(forKey: "loc_name") {
            return locname
        }
        return ""
        
    }
    
    // Google
    
    func setUserSignupdetailsForGoogle(Id : String, uname:String, email:String?) {
        
        UserDefaults.standard.set(Id, forKey: "user_Goid")
        UserDefaults.standard.set(uname, forKey: "user_Goname")
        UserDefaults.standard.set(email, forKey: "user_Goemail")
        UserDefaults.standard.set(email, forKey: "user_email")
        
        //        UserDefaults.standard.set(profilepicurl, forKey: "user_fbprofilepic")
        
        
        userdefaultsSynchronize()
    }
    
    func getUserSignupdetailsForGoogle() -> (String,String,String) {
        
        var userid = ""
        var username = ""
        var useremail = ""
        
        if let user = UserDefaults.standard.string(forKey: "user_Goid") {
            userid = user
        }
        if let usern = UserDefaults.standard.string(forKey: "user_Goname") {
            username = usern
        }
        if let usermail = UserDefaults.standard.string(forKey: "user_Goemail") {
            useremail = usermail
        }
        return (userid,username,useremail )
        
    }
    func setUserFbSigninStatus(status : Bool) {
        
        UserDefaults.standard.set(status, forKey: "Fb_status")
        userdefaultsSynchronize()
    }
    
    func getUserFbsigninStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "Fb_status")
    }
    func setUserGoogleSigninStatus(status : Bool) {
        
        UserDefaults.standard.set(status, forKey: "Google_status")
        userdefaultsSynchronize()
    }
    
    func getUserGoogleStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "Google_status")
    }
    
    func setUserGoogleId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "user_Gooid")
        userdefaultsSynchronize()
    }
    
    func getUserGoogleId() -> String {
        
        if let userid = UserDefaults.standard.string(forKey: "user_Gooid") {
            return userid
        }
        return ""
        
    }
   
    //Splash screen
    func setSplashScreenStatus(status : Bool) {
        
        UserDefaults.standard.set(status, forKey: "Splash_status")
        userdefaultsSynchronize()
    }
    
    func getSplashScreenStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "Splash_status")
    }
    
    // Set and get password
    func setCurrentPassword(password : String) {
        
        UserDefaults.standard.set(password, forKey: "current_pwd")
        userdefaultsSynchronize()
    }
    
    func getCurrentPassword() -> String {
        
        return UserDefaults.standard.string(forKey: "current_pwd")!
    }
    
    // SET and get user role
    
    func setUserRole(aStrUserRole : String) {
        
        UserDefaults.standard.set(aStrUserRole, forKey: "user_role")
        userdefaultsSynchronize()
    }
    
    func getUserRole() -> String {
        
        if let role = UserDefaults.standard.string(forKey: "user_role") {
            return role
        }
        return ""
        
    }
    
    // Set and get Base iIage URL
    func setBaseImageUrl(aStrImageUrl : String) {
        
        UserDefaults.standard.set(aStrImageUrl, forKey: "base_image_url")
        userdefaultsSynchronize()
    }
    
    func getBaseImageUrl() -> String {
        
        return UserDefaults.standard.string(forKey: "base_image_url")!
    }
    
    // Set and get student id
    func setStudentId(aStrUserId : String) {
        
        UserDefaults.standard.set(aStrUserId, forKey: "student_id")
        userdefaultsSynchronize()
    }
    
    func getStudentId() -> String {
        
        return UserDefaults.standard.string(forKey: "student_id")!
    }
    
    // Set and get user name
    
    func setUserName(aStrUserName : String) {
        
        UserDefaults.standard.set(aStrUserName, forKey: "user_name")
        userdefaultsSynchronize()
    }
    
    func getUserName() -> String {
        if let name = UserDefaults.standard.string(forKey: "user_name") {
            return name
        }
        return ""
    }
    func setCurrentChatUserName(aStrUserName : String) {
        
        UserDefaults.standard.set(aStrUserName, forKey: "chatuser_name")
        userdefaultsSynchronize()
    }
    
    func getCurrentChatUserName() -> String {
        if let name = UserDefaults.standard.string(forKey: "chatuser_name") {
            return name
        }
        return ""
    }
    func setUserEmail(aStrUserName : String) {
        
        UserDefaults.standard.set(aStrUserName, forKey: "user_email")
        userdefaultsSynchronize()
    }
    
    func getUserEmail() -> String {
        if let name = UserDefaults.standard.string(forKey: "user_email") {
            return name
        }
        return ""
    }
    
    func setUserSubscriptionStatus(status : Bool) {
        
        UserDefaults.standard.set(status, forKey: "UserSubscription_status")
        userdefaultsSynchronize()
    }
    
    func getUserSubscriptionStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "UserSubscription_status")
    }
    func setUserSubscriptionType(type : String) {
        
        UserDefaults.standard.set(type, forKey: "UserSubscription_Type")
        userdefaultsSynchronize()
    }
    
    func getUserSubscriptionType() -> String {
        
        if let type = UserDefaults.standard.string(forKey: "UserSubscription_Type") {
            return type
        }
        return ""
    }
    func setUserIDcardStatus(status : Bool) {
        
        UserDefaults.standard.set(status, forKey: "UserIDcard_status")
        userdefaultsSynchronize()
    }
    
    func getUserIDcardStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "UserIDcard_status")
    }
    //Stripe Account details
    func setUserStripeInfo(dictInfo: [String:String]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "user_stripe_info")
        userdefaultsSynchronize()
    }
    
    func getUserStripeInfo() -> [String:String] {
        if let info =  UserDefaults.standard.dictionary(forKey: "user_stripe_info") as? [String : String] {
            return info
        }
        return [:]
      
    }
    
    // Set and get paypal id
    
    func setPaypalId(aStrPaypalId : String) {
        
        UserDefaults.standard.set(aStrPaypalId, forKey: "paypal_email")
        userdefaultsSynchronize()
    }
    
    func getPaypalId() -> String {
        if let name = UserDefaults.standard.string(forKey: "paypal_email") {
            return name
        }
        return ""
    }
    
    // Set and get user image
    func setUserImage(aStrUserImage : String) {
        
        UserDefaults.standard.set(aStrUserImage, forKey: "user_image")
        userdefaultsSynchronize()
    }
    
    func getUserImage() -> String {
        
        if let image = UserDefaults.standard.string(forKey: "user_image") {
            return image
        }
        return ""
    }
    //ID card
    func setUserIDcardImage(aStrUserImage : String) {
        
        UserDefaults.standard.set(aStrUserImage, forKey: "user_IDcardimage")
        userdefaultsSynchronize()
    }
    
    func getUserIDCardImage() -> String {
        
        if let image = UserDefaults.standard.string(forKey: "user_IDcardimage") {
            return image
        }
        return ""
    }
    func setSessionId(strSessionId: String) {
        
        UserDefaults.standard.set(strSessionId, forKey: "session_id")
        userdefaultsSynchronize()
    }
    
    func getSessionId() -> String {
        
        return UserDefaults.standard.string(forKey: "session_id")!
    }
    
    
    // Set and get device token
    func setDeviceToken(deviceToken : String) {
        
        UserDefaults.standard.set(deviceToken, forKey: "device_token")
        userdefaultsSynchronize()
    }
    
    func getDeviceToken() -> String {
        
        if UserDefaults.standard.string(forKey: "device_token") != nil {
            return UserDefaults.standard.string(forKey: "device_token")! as String
        }
        
        return ""
    }
    
    func setUserInfo(dictInfo: [String:String]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "user_info")
        userdefaultsSynchronize()
    }
    
    func getUserInfo() -> [String:String] {
        
        return UserDefaults.standard.dictionary(forKey: "user_info") as! [String : String]
    }
    
    
    func setBannerInfo(dictInfo: [[String:String]]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "banner_info")
        userdefaultsSynchronize()
    }
    
    func getBannerInfo() -> [[String:String]] {
        
        if UserDefaults.standard.array(forKey: "banner_info") != nil {
            return UserDefaults.standard.array(forKey: "banner_info") as! [[String : String]]
        }
        
        let aAryInfo = [[String : String]]()
        return aAryInfo
    }
    
    func setIsUPushNotificationStatus(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "push_notification_status")
        userdefaultsSynchronize()
    }
    
    func getPushNotificationStatus() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "push_notification_status")
    }
    
    func setPassword(strSessionId: String) {
        
        UserDefaults.standard.set(strSessionId, forKey: "password")
        userdefaultsSynchronize()
    }
    
    func getPassword() -> String {
        
        return UserDefaults.standard.string(forKey: "password")!
    }
    
    // Set and get user id
    
    func setIsUploadAnswer(isAnswer : Bool) {
        
        UserDefaults.standard.set(isAnswer, forKey: "is_upload")
        userdefaultsSynchronize()
    }
    
    func isUploadAnswer() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "is_upload")
    }
    
    //Set and Get Upload Document Photos
    
    func setUploadDocument(dictInfo: [[String:AnyObject]]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "imageupload")
        userdefaultsSynchronize()
    }
    
    func getUploadDocument() -> [[String:Any]] {
        
        if UserDefaults.standard.array(forKey: "imageupload") != nil {
            return UserDefaults.standard.array(forKey: "imageupload") as! [[String : Any]]
        }
        
        let aAryInfo = [[String : Any]]()
        return aAryInfo
    }
    
    // Set and get video recoreder permission
    
    func setIsPhotoLibraryPermisson(isAnswer : Bool) {
        
        UserDefaults.standard.set(isAnswer, forKey: "photo_permission")
        userdefaultsSynchronize()
    }
    
    func isPhotoLibraryPermisson() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "photo_permission")
    }
    
    // MARK: - Private Methods
    
    private func userdefaultsSynchronize() {
        
        UserDefaults.standard.synchronize()
    }
    
    // MARk:- Set and Get user price option
    
    func setUserPriceOption(option:String,price:String,extraprice:String) {
        
        UserDefaults.standard.set(option, forKey: "user_price_option")
        UserDefaults.standard.set(price, forKey: "gigs_price")
        UserDefaults.standard.set(extraprice, forKey: "extra_gig_price")
        userdefaultsSynchronize()
    }
    
    func getUserPriceOption() -> (String,String,String) {
        
        var priceoption = ""
        var gigsprice = ""
        var gigsextraprice = ""
        
        if let option = UserDefaults.standard.string(forKey: "user_price_option") {
            priceoption = option
        }
        if let price = UserDefaults.standard.string(forKey: "gigs_price") {
            gigsprice = price
        }
        if let extraprice = UserDefaults.standard.string(forKey: "extra_gig_price") {
            gigsextraprice = extraprice
        }
        return (priceoption, gigsprice, gigsextraprice)
        
    }
    
    func setColorCode(dictInfo: [String:Any]) {
        
        UserDefaults.standard.set(dictInfo, forKey: "color_code")
        userdefaultsSynchronize()
    }
    
    func getColorCode() -> [String:Any] {
        
        return UserDefaults.standard.dictionary(forKey: "color_code") as! [String : String]
    }
    
    func setPrimaryColorCode(colorCode: String) {
        
        var aStr = colorCode
        
        aStr = aStr.replacingOccurrences(of: "#", with: "", options: .literal, range: nil)
        UserDefaults.standard.set(aStr, forKey: "primary_color_code")
        userdefaultsSynchronize()
    }
    
    func getPrimaryColorCode() -> String  {
        
        if UserDefaults.standard.string(forKey: "primary_color_code") == nil {
            
            return "d42129"
        }
        
        return UserDefaults.standard.string(forKey: "primary_color_code")!
    }
    
    func setRTLEnabled(flag : Bool) {
        UserDefaults.standard.set(flag, forKey: "rtl_enabled")
        userdefaultsSynchronize()
    }
    
    func isRTLEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: "rtl_enabled")
    }
    
    func resetRTLEnabled() {
        UserDefaults.standard.removeObject(forKey: "rtl_enabled")
    }
    
    // MARK: - New Design sessions
    
    // Set and get user type
    func setUserLogInType(aStrUserLogInType : String) {
        
        UserDefaults.standard.set(aStrUserLogInType, forKey: "user_login_type")
        userdefaultsSynchronize()
    }
    
    func getUserLogInType() -> String {
        
        if let userlogintype = UserDefaults.standard.string(forKey: "user_login_type") {
            return userlogintype
        }
        return ""
        
    }
    func setUserProviderID(aStrUserId : String) {
           
           UserDefaults.standard.set(aStrUserId, forKey: "user_provider_id")
           userdefaultsSynchronize()
       }
       
       func getUserProviderID() -> String {
           
           if let userlogintype = UserDefaults.standard.string(forKey: "user_provider_id") {
               return userlogintype
           }
           return ""
           
       }
    
    func setIsFromEmailLogin(aBoolLoginType : Bool) {
          
          UserDefaults.standard.set(aBoolLoginType, forKey: "login_type")
          userdefaultsSynchronize()
      }
      
    func getIsFromEmailLoginType() -> Bool {
          
      
          return UserDefaults.standard.bool(forKey: "login_type")
          
      }
    
    
    // SET and get user Token
    func setUserToken(aStrUserToken : String) {
        
        UserDefaults.standard.set(aStrUserToken, forKey: "user_Token")
        userdefaultsSynchronize()
    }
    
    func getUserToken() -> String {
        
        if let token = UserDefaults.standard.string(forKey: "user_Token") {
            return token
        }
        return ""
        
    }
    
    //User info
    func setUserInfoNew(name:String,email:String,mobilenumber:String) {
        
        UserDefaults.standard.set(name, forKey: "user_name")
        UserDefaults.standard.set(email, forKey: "user_email")
        UserDefaults.standard.set(mobilenumber, forKey: "user_mobile")
        userdefaultsSynchronize()
    }
    
    func getUserInfoNew() -> (String,String,String) {
        
        var name = ""
        var email = ""
        var mobilenumber = ""
        
        if let option = UserDefaults.standard.string(forKey: "user_name") {
            name = option
        }
        if let price = UserDefaults.standard.string(forKey: "user_email") {
            email = price
        }
        if let extraprice = UserDefaults.standard.string(forKey: "user_mobile") {
            mobilenumber = extraprice
        }
        return (name, email, mobilenumber)
    }
    
    // Set is user log in
    func setIsUserLogin(isLoginUser : Bool) {
        
        UserDefaults.standard.set(isLoginUser, forKey: "is_user_login")
        userdefaultsSynchronize()
    }
    
    func IsUserLogin() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "is_user_login")
    }
    // app launches first time
    func setIsAppLaunchFirstTime(isLogin : Bool) {
        
        UserDefaults.standard.set(isLogin, forKey: "user_log_in_FirstTime")
        userdefaultsSynchronize()
    }
    
    func isAppLaunchFirstTime() -> Bool {
        
        let aBoolCheck = UserDefaults.standard.bool(forKey: "user_log_in_FirstTime") as Bool
        
        if aBoolCheck {
            
            return false
        }
            
        else {
            
            return true
        }
    }
    //set and get Reference code
      func setReferenceCode(aStrReferenceCode : String) {
             
             UserDefaults.standard.set(aStrReferenceCode, forKey: "reference_code")
             userdefaultsSynchronize()
         }
         
         func getReferenceCode() -> String {
             if let name = UserDefaults.standard.string(forKey: "reference_code") {
                 return name
             }
             return ""
         }
    
    //Check RTL
    
    func setIsRtl(isRightToLeft : Bool) {
        
        UserDefaults.standard.set(isRightToLeft, forKey: "boolLangViewRTL")
        userdefaultsSynchronize()
    }
    
    func IsLangRtl() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "boolLangViewRTL")
    }
    
    
    
    
    // set and get AppColor
    func setAppColor(AppColor : String) {
        UserDefaults.standard.set(AppColor, forKey: "app_color")
    }
    func getAppColor() -> String {
        
        if let appcolor = UserDefaults.standard.string(forKey: "app_color") {
            return appcolor
        }
        return APP_DEFAULT_PRIMARY_COLOR
        
    }
    
    func setSecondaryAppColor(AppColor : String) {
        UserDefaults.standard.set(AppColor, forKey: "secondary_app_color")
    }
    func getSecondaryAppColor() -> String {
        
        if let appcolor = UserDefaults.standard.string(forKey: "secondary_app_color") {
            return appcolor
        }
        return APP_DEFAULT_SECONDARY_COLOR
        
    }
    // set and get FirstGradientColor
    func setFirstGradientColor(red : Float, green : Float , blue : Float , alpha : Float) {
        UserDefaults.standard.set(red, forKey: "red_gradient_color1")
        UserDefaults.standard.set(green, forKey: "green_gradient_color1")
        UserDefaults.standard.set(blue, forKey: "blue_gradient_color1")
        UserDefaults.standard.set(alpha, forKey: "alpha_gradient_color1")
    }
    func getRedColor1() -> Float {
        UserDefaults.standard.float(forKey: "red_gradient_color1")
    }
    func getGreenColor1() -> Float {
        UserDefaults.standard.float(forKey: "green_gradient_color1")
        
    }
    func getBlueColor1() -> Float {
        UserDefaults.standard.float(forKey: "blue_gradient_color1")
    }
    func getAlphaColor1() -> Float {
        UserDefaults.standard.float(forKey: "alpha_gradient_color1")
    }
    
    
    
    
    // set and get SecondGradientColor
    func setSecondGradientColor(red : Float, green : Float , blue : Float , alpha : Float) {
        UserDefaults.standard.set(red, forKey: "red_gradient_color2")
        UserDefaults.standard.set(green, forKey: "green_gradient_color2")
        UserDefaults.standard.set(blue, forKey: "blue_gradient_color2")
        UserDefaults.standard.set(alpha, forKey: "alpha_gradient_color2")
    }
    
    func getRedColor2() -> Float {
        UserDefaults.standard.float(forKey: "red_gradient_color2")
    }
    func getGreenColor2() -> Float {
        UserDefaults.standard.float(forKey: "green_gradient_color2")
        
    }
    func getBlueColor2() -> Float {
        UserDefaults.standard.float(forKey: "blue_gradient_color2")
    }
    func getAlphaColor2() -> Float {
        UserDefaults.standard.float(forKey: "alpha_gradient_color2")
    }
    
}
