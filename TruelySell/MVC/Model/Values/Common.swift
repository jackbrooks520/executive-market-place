//
//  Common.swift
//  Gigs
//
//  Created by dreams on 03/01/18.
//  Copyright © 2018 dreams. All rights reserved.
//

import Foundation
import UIKit

class alertNetwork {
    
    var aDictGetLangInfo = SESSION.getLangInfo()
    var aDictNetwork = [String:Any]()
    var ALERT_NO_INTERNET = ""
    var ALERT_TYPE_NO_DATA = ""
    var ALERT_TYPE_SERVER_ERROR = ""
    var ALERT_NO_INTERNET_DESC = ""
    var ALERT_NO_RECORDS_FOUND = ""
    var ALERT_LOADING_CONTENT = ""
    
    
    init() {
        
        if let dict = aDictGetLangInfo["common_used_texts"] as? [String : Any] {
            aDictNetwork = dict
        }
        if let alert = aDictNetwork["lg7_please_enable_i"]as? String {
            ALERT_NO_INTERNET = alert
        }
        //         = aDictNetwork["lg7_please_enable_i"] as! String
        ALERT_TYPE_NO_DATA = aDictNetwork["lg7_no_data_were_fo"] as? String ?? ""
        ALERT_TYPE_SERVER_ERROR = aDictNetwork["lg7_oops__problem_o"] as? String ?? ""
        ALERT_NO_INTERNET_DESC = aDictNetwork["lg7_oops_itseems_li"] as? String ?? ""
        ALERT_NO_RECORDS_FOUND = aDictNetwork["lg7_no_records_foun"] as? String ?? ""
        ALERT_LOADING_CONTENT = aDictNetwork["lg7_loading"] as? String ?? ""
        
    }
}

//Color


let APP_PRIMARY_COLOR = ["ff0080", "0090ff", "d9c505", "ff6000", "db0000"]
let APP_SECONDARY_COLOR = ["db0000","d9c505","ff6000","0090ff","ff0080"]
let APP_DEFAULT_GRADIENT_COLOR_1 : UIColor = UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1)
let APP_DEFAULT_GRADIENT_COLOR_2 : UIColor = UIColor(red: 217/255, green: 197/255, blue: 5/255, alpha: 1)
let APP_DEFAULT_PRIMARY_COLOR = "ff0080"
let APP_DEFAULT_SECONDARY_COLOR = "d9c505"

let APP_NAME = "TruelySell"
let HOME_PAGE_APP_FIRST_NAME = CommonTitle.TRUELY.titlecontent()  // Home page App firstname
let HOME_PAGE_APP_LAST_NAME = CommonTitle.SELL.titlecontent()       // Home page App lastname


let APP_DEFAULT_COUNTRY_PICKER = "US"
let CREDIT_COLOR = "35CC2E"
let DEBIT_COLOR = "FF0000"
let IN_ACTIVE_COLOR = "DE3434"
let ACTIVE_COLOR = "35CC2E"

var WEB_DATE_FORMAT = String() //:String = "yyyy-MM-dd"
let WEB_TIME_FORMAT :String = "hh:mm a"
let WEB_TIME_CHAT_FORMAT :String = "h:mm a"
let PAYPALL_BUNDLE_ID = "com.dreamguystech.TruelySell.payments"   // User bundle id & ".payments"
let GOOGLE_API_KEY = "AIzaSyCb_938UbaYoO1m7u03P6WBNy8BAB3B2XE"   // Use  google Map console key here
let strStaticDateFormat = "dd-MM-yyyy"

let LOGIN_THROUGH_NORMAL = 1
let LOGIN_THROUGH_FB = 2
let LOGIN_THROUGH_GOOGLE = 3

class Gradient {
    var APP_GRADIENT_COLOR_1 = UIColor()
    var APP_GRADIENT_COLOR_2 = UIColor()
    
    init() {
        if SESSION.getAlphaColor1() == 0 {
            APP_GRADIENT_COLOR_1 = APP_DEFAULT_GRADIENT_COLOR_1
        }
        else if SESSION.getAlphaColor1() != 0{
            APP_GRADIENT_COLOR_1 = UIColor(red: CGFloat(SESSION.getRedColor1()), green: CGFloat(SESSION.getGreenColor1()), blue: CGFloat(SESSION.getBlueColor1()), alpha: CGFloat(SESSION.getAlphaColor1()))
        }
        if SESSION.getAlphaColor2() == 0 {
            
            APP_GRADIENT_COLOR_2 = APP_DEFAULT_GRADIENT_COLOR_2
            
        }
        else if SESSION.getAlphaColor2() != 0{
            APP_GRADIENT_COLOR_2 = UIColor(red: CGFloat(SESSION.getRedColor2()), green: CGFloat(SESSION.getGreenColor2()), blue: CGFloat(SESSION.getBlueColor2()), alpha: CGFloat(SESSION.getAlphaColor2()))
        }
    }
}


let APP_GRADIENT_BLACK_COLOR_1 : UIColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
let APP_GRADIENT_BLACK_COLOR_2 : UIColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
let APP_GRADIENT_BLACK_COLOR_3 : UIColor = UIColor(red: 2/255, green: 2/255, blue: 2/255, alpha: 1)



// Stripe Content Title

enum StripeScrenTitle {
   case SCREEN_TITLE_STRIPE_SETTINGS
    case SCREEN_TITLE_PAYPAL_SETTINGS
    case CONTENT_TITLE_REASON
    case CONTENT_TITLE_ACC_HOLDER_NAME
    case CONTENT_TITLE_ACC_NO
    case CONTENT_TITLE_IBAN
    case CONTENT_TITLE_BANK_NAME
    case CONTENT_TITLE_BANK_ADDRESS
    case CONTENT_TITLE_SORT_CODE
    case CONTENT_TITLE_ROUTING_NUMBER
    case CONTENT_TITLE_IFSC_CODE
    
    
    func titlecontent() -> String {
        switch self {
        case .SCREEN_TITLE_STRIPE_SETTINGS:
            return HELPER.getTranslateForKey(key: "lbl_header_title", inPage: "stripe_payment_screen", existingString: "Stripe settings")
        case .SCREEN_TITLE_PAYPAL_SETTINGS:
            return HELPER.getTranslateForKey(key: "lbl_paypal_settings", inPage: "settings_screen", existingString: "PayPal settings")
        case .CONTENT_TITLE_REASON:
            return HELPER.getTranslateForKey(key: "lbl_reason", inPage: "common_strings", existingString: "REASON")
        case .CONTENT_TITLE_ACC_HOLDER_NAME:
            return HELPER.getTranslateForKey(key: "txt_fld_acc_name", inPage: "stripe_payment_screen", existingString: "THE ACCOUNT HOLDERS NAME")
        case .CONTENT_TITLE_ACC_NO:
            return HELPER.getTranslateForKey(key: "txt_fld_acc_num", inPage: "stripe_payment_screen", existingString: "ACCOUNT NUMBER")
        case .CONTENT_TITLE_IBAN:
            return HELPER.getTranslateForKey(key: "txt_fld_IBan", inPage: "stripe_payment_screen", existingString: "IBAN")
        case .CONTENT_TITLE_BANK_NAME:
            return  HELPER.getTranslateForKey(key: "txt_fld_bank_name", inPage: "stripe_payment_screen", existingString: "BANK NAME")
        case .CONTENT_TITLE_BANK_ADDRESS:
            return HELPER.getTranslateForKey(key: "txt_fld_bank_addr", inPage: "stripe_payment_screen", existingString: "BANK ADDRESS")
        case .CONTENT_TITLE_SORT_CODE:
            return HELPER.getTranslateForKey(key: "txt_fld_sort_code", inPage: "stripe_payment_screen", existingString: "SORT CODE(UK)")
        case .CONTENT_TITLE_ROUTING_NUMBER:
            return HELPER.getTranslateForKey(key: "txt_fld_swift_num", inPage: "stripe_payment_screen", existingString: "SWIFT CODE(US)")
        case .CONTENT_TITLE_IFSC_CODE:
            return HELPER.getTranslateForKey(key: "txt_fld_ifsc_code", inPage: "stripe_payment_screen", existingString: "IFSC CODE(INDIAN)")
        }
}
}


enum CommonTitle {
    case YES_BTN
    case NO_BTN
    case BTN_UPDATE
    case CHOOSE_TITLE
    case CANCEL_BUTTON
    case CAMERA_BTN
    case GALLERY_BTN
    case ENABLE_CAMERA_IN_SETTING
    case UPDATING
    case APPLY_BTN
    case DONE_BTN
    case VIEW_ALL
    case POPULAR_SERVICES
    case NEWLY_ADDED_SERVICES
    case VIEW_MORE
    case TRUELY
    case SELL
    case WORLDSLARGEST
    case MARKETPLACE
    case CATEGORIES_TITLE
    case SUB_CATEGORIES_TITLE
    case NO_SUB_CATEGORIES_FOUND
    case NO_SERVICES_FOUND
    case REPLY
    case CONFIRM_BTN
    case BTN_OK
    case WARNING_MSG
    case NOACCESS_CAMERA
    case CHOOSE_PICTURE
    case TEST
    case FILTER
    case BUY_NOW
    case SUCCESS
    case RATE_NOW
    case HISTORY
    case LOCATION_ACCESS
    case LOCATION_ACCESS_CONTENT
    case ACCEPTOR
    case REQUESTOR
    case ENABLE_LOCATION
    case ENABLE_LOCATION_VALIDATION
    case NOT_NOW
    case NO_FAVOURITES
    case VERIFICATON_PENDING
    case FAVOURITES
    case FAVOURITE_LIST
    case PAY_NOW
    func titlecontent() -> String {
        
        switch self {
        case .PAY_NOW:
            return HELPER.getTranslateForKey(key: "btn_pay_now", inPage: "common_strings", existingString: "Pay Now")
        case .FAVOURITES:
            return HELPER.getTranslateForKey(key: "btn_favourites", inPage: "common_strings", existingString: "Favourites")
        
        case .YES_BTN:
            return HELPER.getTranslateForKey(key: "btn_yes", inPage: "common_strings", existingString: "Yes")
        case .NO_BTN:
            return HELPER.getTranslateForKey(key: "btn_no", inPage: "common_strings", existingString: "No")
        case .BTN_UPDATE:
            return HELPER.getTranslateForKey(key: "btn_update", inPage: "common_strings", existingString: "Update")
        case .CHOOSE_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_choose", inPage: "common_strings", existingString: "Choose")
        case .CANCEL_BUTTON:
            return HELPER.getTranslateForKey(key: "btn_cancel", inPage: "common_strings", existingString: "Cancel")
        case .CAMERA_BTN:
            return HELPER.getTranslateForKey(key: "btn_camera", inPage: "common_strings", existingString: "Camera")
        case .GALLERY_BTN:
            return HELPER.getTranslateForKey(key: "btn_gallery", inPage: "common_strings", existingString: "Gallery")
        case .UPDATING:
            return HELPER.getTranslateForKey(key: "txt_updating", inPage: "common_strings", existingString: "Updating..")
        case .APPLY_BTN:
            return HELPER.getTranslateForKey(key: "btn_apply", inPage: "common_strings", existingString: "APPLY")
        case .DONE_BTN:
            return HELPER.getTranslateForKey(key: "btn_done", inPage: "common_strings", existingString: "Done")
        case .ACCEPTOR:
            return HELPER.getTranslateForKey(key: "lbl_acceptor", inPage: "common_strings", existingString: "Acceptor")
        case .REQUESTOR:
            return HELPER.getTranslateForKey(key: "lbl_requestor", inPage: "common_strings", existingString: "Requestor")
            
        case .VIEW_ALL:
            return HELPER.getTranslateForKey(key: "lbl_view_all", inPage: "common_strings", existingString: "View All")
        case .POPULAR_SERVICES:
            return HELPER.getTranslateForKey(key: "lbl_popular_service", inPage: "common_strings", existingString: "Popular Services")
            
        case .NEWLY_ADDED_SERVICES:
            return HELPER.getTranslateForKey(key: "lbl_newly_added_service", inPage: "common_strings", existingString: "Newly Added Services")
            
        case .FILTER:
            return HELPER.getTranslateForKey(key: "btn_filter", inPage: "common_strings", existingString: "Filter")
            
        case .VIEW_MORE:
            return HELPER.getTranslateForKey(key: "lbl_view_more", inPage: "common_strings", existingString: "View more")
            
        case .TRUELY:
            return HELPER.getTranslateForKey(key: "lbl_truely", inPage: "common_strings", existingString: "Truely")
        case .SELL:
            return HELPER.getTranslateForKey(key: "lbl_sell", inPage: "common_strings", existingString: "Sell")
        case .WORLDSLARGEST:
            return HELPER.getTranslateForKey(key: "lbl_worlds_largest", inPage: "common_strings", existingString: "World's Largest ")
        case .MARKETPLACE:
            return HELPER.getTranslateForKey(key: "lbl_market_place", inPage: "common_strings", existingString: "Marketplace")
        case .CATEGORIES_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_categories", inPage: "common_strings", existingString: "Categories")
        case .SUB_CATEGORIES_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_sub_categories", inPage: "common_strings", existingString: "SubCategories")
            
        case .NO_SERVICES_FOUND:
            return HELPER.getTranslateForKey(key: "lbl_no_services_found", inPage: "common_strings", existingString: "No service list found")
        case .REPLY:
            return HELPER.getTranslateForKey(key: "btn_reply", inPage: "common_strings", existingString: "Reply")
            
        case .CONFIRM_BTN:
            return HELPER.getTranslateForKey(key: "btn_confirm", inPage: "common_strings", existingString: "Confirm")
        case .HISTORY:
            return HELPER.getTranslateForKey(key: "lbl_history", inPage: "common_strings", existingString: "History")
        case .BTN_OK:
            return "OK"
//            return HELPER.getTranslateForKey(key: "btn_ok", inPage: "common_strings", existingString: "OK")
        case .WARNING_MSG:
            
            return HELPER.getTranslateForKey(key: "alrt_warning", inPage: "common_strings", existingString: "Warning")
        case .NOACCESS_CAMERA:
            return HELPER.getTranslateForKey(key: "alrt_warning", inPage: "common_strings", existingString: "You don't have camera")
        case .RATE_NOW:
            return HELPER.getTranslateForKey(key: "lbl_rate_now", inPage: "common_strings", existingString: "Rate now")
            
        case .ENABLE_CAMERA_IN_SETTING:
            
            return HELPER.getTranslateForValidation1Key(key: "btn_camera", inPage: "common_strings", existingString: "Enable camera option in settings")
        case .CHOOSE_PICTURE:
            
            return HELPER.getTranslateForValidation1Key(key: "btn_gallery", inPage: "common_strings", existingString: "Choose picture")
            
            
        case .NO_SUB_CATEGORIES_FOUND:
            return HELPER.getTranslateForValidation1Key(key: "lbl_sub_categories", inPage: "common_strings", existingString: "No sub categories found")
        case .TEST:
            return HELPER.getTranslateForKey(key: "lbl_test", inPage: "common_strings", existingString: "Add Service")
        case .BUY_NOW:
            return HELPER.getTranslateForKey(key: "btn_buy_now", inPage: "common_strings", existingString: "BUY Now")
        case .SUCCESS:
            return HELPER.getTranslateForKey(key: "btn_success", inPage: "common_strings", existingString: "Success")
            
        case .LOCATION_ACCESS:
            return HELPER.getTranslateForKey(key: "lbl_location_access", inPage: "common_strings", existingString: "LOCATION ACCESS")
        case .LOCATION_ACCESS_CONTENT:
            return HELPER.getTranslateForKey(key: "lbl_location_access_content", inPage: "common_strings", existingString: "Let us know where are you so we can recommend nearby services. Application would like to use your current location.")
        case .ENABLE_LOCATION:
            return HELPER.getTranslateForKey(key: "lbl_enable_location", inPage: "common_strings", existingString: "Enable location")
        case .ENABLE_LOCATION_VALIDATION:
            return HELPER.getTranslateForValidation1Key(key: "lbl_enable_location", inPage: "common_strings", existingString: "Enable Location to display nearby services")
        
        case .NOT_NOW:
            return HELPER.getTranslateForKey(key: "lbl_not_now", inPage: "common_strings", existingString: "Not now")
        case .NO_FAVOURITES:
            return HELPER.getTranslateForKey(key: "lbl_no_favourites", inPage: "common_strings", existingString: "No Favourite Services found")
        case .VERIFICATON_PENDING:
            return HELPER.getTranslateForKey(key: "lbl_verification_pending", inPage: "common_strings", existingString: "Verification Pending")
        case .FAVOURITE_LIST:
            return HELPER.getTranslateForKey(key: "btn_favourites", inPage: "common_strings", existingString: "Favourite List")
        }
    }
}
enum TabBarScreen {
    case TAB_HOME
    case TAB_CHAT
    case TAB_BOOKINGS
    case TAB_SETTINGS
    
    func titlecontent() -> String {
        switch self {
        case .TAB_HOME:
            return HELPER.getTranslateForKey(key: "tab_home", inPage: "tab_bar_title", existingString: "Home")
        case .TAB_BOOKINGS:
            return HELPER.getTranslateForKey(key: "tab_bookings", inPage: "tab_bar_title", existingString: "Bookings")
        case .TAB_CHAT:
            return HELPER.getTranslateForKey(key: "tab_chat", inPage: "tab_bar_title", existingString: "Chat")
        case .TAB_SETTINGS:
            return HELPER.getTranslateForKey(key: "tab_settings", inPage: "tab_bar_title", existingString: "Settings")
        }
    }
}
enum ChangePasswordScreenTitle {
    case CHANGE_PASSWORD
    case CURRENT_PASSWORD
    case CONFIRM_PASSWORD
    case NEW_PASSWORD
    case EMPTY_PASSWORD
    case ENTER_CURRENT_PASSWORD
    case ENTER_NEW_PASSWORD
    case ENTER_CONFIRM_PASSWORD
    case NEW_AND_CONFIRM_PASSWORD_NOT_MATCH
    func titlecontent() -> String {
        switch self {
        case .CHANGE_PASSWORD:
            return HELPER.getTranslateForKey(key: "lbl_change_password", inPage: "change_password", existingString: "Change Password")
        case .CURRENT_PASSWORD:
            return HELPER.getTranslateForKey(key: "txt_current_password", inPage: "change_password", existingString: "Current Password")
            
        case .CONFIRM_PASSWORD:
            return HELPER.getTranslateForKey(key: "txt_confirm_password", inPage: "change_password", existingString: "Confirm Password")
            
        case .NEW_PASSWORD:
            return HELPER.getTranslateForKey(key: "txt_new_password", inPage: "change_password", existingString: "New Password")
            
        case .EMPTY_PASSWORD:
            return HELPER.getTranslateForValidation1Key(key: "lbl_change_password", inPage: "change_password", existingString: "Password Cannot be empty")
        case .ENTER_CURRENT_PASSWORD:
            return HELPER.getTranslateForValidation1Key(key: "txt_current_password", inPage: "change_password", existingString: "Current password cannot be empty")
        case .ENTER_NEW_PASSWORD:
            return HELPER.getTranslateForValidation1Key(key: "txt_new_password", inPage: "change_password", existingString: "New password cannot be empty")
        case .ENTER_CONFIRM_PASSWORD:
            return HELPER.getTranslateForValidation1Key(key: "txt_confirm_password", inPage: "change_password", existingString: "Confirm password cannot be empty")
        case .NEW_AND_CONFIRM_PASSWORD_NOT_MATCH:
            return HELPER.getTranslateForValidation2Key(key: "txt_new_password", inPage: "change_password", existingString: "New password and confirm password doesn't match")
            
            
        }
    }
}
enum EmailLoginScreenTitle {
case FORGOT_PASSWORD
case PASSWORD
    func titlecontent() -> String {
    switch self {
    case .FORGOT_PASSWORD:
        return HELPER.getTranslateForKey(key: "btn_forgot_password", inPage: "email_login", existingString: "Forgot Password")
    case .PASSWORD:
        return HELPER.getTranslateForKey(key: "lbl_password", inPage: "email_login", existingString: "Password")
    }
    }
}



enum ProviderAndUserScreenTitle {
    case SELECT_SERVICE
    case GET_STARTED
    case LOGIN_TITLE
    case SELECT_SUB_CATEGORY
    case CHOOSE_SUB_CATEGORY
    case SERVICE_YOU_PROVIDE
    case NEXT_TITLE
    case PREVIOUS_TITLE
    case CODE_TITLE
    case ALREADY_PROFESSIONAL
    case REGISTER_TITLE
    case ACCESS_CODE
    case OTP_SENT_CONTENT
    case ENTER_VALID_OTP
    case CHOOSE_CATEGORY
    case LOGIN_AS_PROFESSIONAL
    case PLEASE_SELECT_CATEGORY
    case JOIN_AS_PROFESSIONAL
    case ENTER_NAME
    case ENTER_EMAIL
    case ENTER_VALID_EMAIL
    case SELECT_MOBILE_CODE
    case ENTER_MOBILE_NUM
    case SELECT_COUNTRY
    case BTN_DONE
    case BTN_CANCEL
    case ENTER_VALID_MOBILE_NO
    case JOIN_AS_USER
    case ALREADY_USER
    case LOGIN_AS_USER
    case RESEND_OTP
    case BTN_SUBMIT
    case MYPROFILE_TITLE
    case AVAILABILTY_TITLE
    case SUBSCRIPTION_TITLE
    case VALID_TILL_TITLE
    case NAME_TITLE
    case EMAIL_TITLE
    case MOBILENUMBER_TITLE
    case CATEGORY_TITLE
    case SUBCATEGORY_TITLE
    case CURRENCY_TITLE
    case CHOOSE_CURRENCY
    case EMPTY_PROVIDER_NAME
    case EMPTY_CATEGORY
    case EMPTY_SUB_CATEGORY
    case EMPTY_USER_NAME
    
    
    
    func titlecontent() -> String {
        switch self {
        case .SELECT_SERVICE:
            return HELPER.getTranslateForKey(key: "lbl_select_service_here", inPage: "register_screen", existingString: "Select your service here")
        case .GET_STARTED:
            return HELPER.getTranslateForKey(key: "lbl_get_started", inPage: "register_screen", existingString: "Get Started")
        case .LOGIN_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_login", inPage: "register_screen", existingString: "Login")
        case .SELECT_SUB_CATEGORY:
            return HELPER.getTranslateForKey(key: "lbl_select_subcategory", inPage: "register_screen", existingString: "Select your sub category")
        case .CHOOSE_SUB_CATEGORY:
            return HELPER.getTranslateForKey(key: "lbl_choose_subcategory", inPage: "register_screen", existingString: "Choose the Sub Category")
        case .SERVICE_YOU_PROVIDE:
            return HELPER.getTranslateForKey(key: "lbl_service_you_provide", inPage: "register_screen", existingString: "What service do you provide?")
        case .NEXT_TITLE:
            return HELPER.getTranslateForKey(key: "btn_next", inPage: "register_screen", existingString: "Next")
        case .PREVIOUS_TITLE:
            return HELPER.getTranslateForKey(key: "btn_previous", inPage: "register_screen", existingString: "Previous")
        case .CODE_TITLE:
            return HELPER.getTranslateForKey(key: "btn_code", inPage: "register_screen", existingString: "Code")
        case .ALREADY_PROFESSIONAL:
            return HELPER.getTranslateForKey(key: "lbl_already_professional", inPage: "register_screen", existingString: "Already a professional?")
        case .REGISTER_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_register", inPage: "register_screen", existingString: "Register")
        case .ACCESS_CODE:
            return HELPER.getTranslateForKey(key: "lbl_access_code", inPage: "register_screen", existingString: "We have sent you access code via SMS for mobile number verification.")
        case .OTP_SENT_CONTENT:
            return HELPER.getTranslateForKey(key: "lbl_otp_content", inPage: "register_screen", existingString: "Otp has been sent to ")
        case .CHOOSE_CATEGORY:
            return HELPER.getTranslateForKey(key: "btn_select_category", inPage: "register_screen", existingString: "Choose category")
        case .LOGIN_AS_PROFESSIONAL:
            return HELPER.getTranslateForKey(key: "lbl_login_as_professional", inPage: "register_screen", existingString: "Login as Professional")
        case .JOIN_AS_PROFESSIONAL:
            return HELPER.getTranslateForKey(key: "lbl_join_as_professional", inPage: "register_screen", existingString: "Join as Professional")
        case .SELECT_COUNTRY:
            return HELPER.getTranslateForKey(key: "lbl_select_country", inPage: "register_screen", existingString: "Select Country")
        case .BTN_DONE:
            return HELPER.getTranslateForKey(key: "btn_done", inPage: "register_screen", existingString: "Done")
        case .BTN_CANCEL:
            return HELPER.getTranslateForKey(key: "btn_cancel", inPage: "register_screen", existingString: "Cancel")
            
        case .JOIN_AS_USER:
            return HELPER.getTranslateForKey(key: "join_as_user", inPage: "register_screen", existingString: "Join as User")
        case .ALREADY_USER:
            return HELPER.getTranslateForKey(key: "lbl_already_user", inPage: "register_screen", existingString: "Already a user?")
        case .LOGIN_AS_USER:
            return HELPER.getTranslateForKey(key: "lbl_login_as_user", inPage: "register_screen", existingString: "Login as User")
        case .RESEND_OTP:
            return HELPER.getTranslateForKey(key: "btn_resend_otp", inPage: "register_screen", existingString: "Resend OTP")
        case .BTN_SUBMIT:
            return HELPER.getTranslateForKey(key: "btn_submit", inPage: "register_screen", existingString: "Submit")
        case .MYPROFILE_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_my_profile", inPage: "register_screen", existingString: "My Profile")
        case .AVAILABILTY_TITLE:
            return HELPER.getTranslateForKey(key: "btn_availability", inPage: "register_screen", existingString: "Availability")
        case .SUBSCRIPTION_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_subscription", inPage: "register_screen", existingString: "Subscription")
        case .VALID_TILL_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_valid_till", inPage: "register_screen", existingString: "Valid till")
        case .NAME_TITLE:
            return HELPER.getTranslateForKey(key: "txt_fld_name", inPage: "register_screen", existingString: "Name")
        case .EMAIL_TITLE:
            return HELPER.getTranslateForKey(key: "txt_fld_email", inPage: "register_screen", existingString: "Email")
        case .MOBILENUMBER_TITLE:
            return HELPER.getTranslateForKey(key: "txt_fld_mobile_num", inPage: "register_screen", existingString: "Mobile Number")
        case .CATEGORY_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_category", inPage: "register_screen", existingString: "Category")
        case .SUBCATEGORY_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_sub_category", inPage: "register_screen", existingString: "Sub Category")
        case .CURRENCY_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_currency", inPage: "register_screen", existingString: "Currency")
        case .CHOOSE_CURRENCY:
            return HELPER.getTranslateForKey(key: "btn_choose_currency", inPage: "register_screen", existingString: "Choose Currency")
            
            
            
            
            
        case .ENTER_VALID_OTP:
            return HELPER.getTranslateForValidation1Key(key: "lbl_otp_content", inPage: "register_screen", existingString: "Please enter the correct OTP code")
        case .ENTER_NAME:
            return HELPER.getTranslateForValidation1Key(key: "txt_fld_name", inPage: "register_screen", existingString: "Please enter name")
        case .ENTER_EMAIL:
            return HELPER.getTranslateForValidation1Key(key: "txt_fld_email", inPage: "register_screen", existingString: "Please enter email")
        case .PLEASE_SELECT_CATEGORY:
            return HELPER.getTranslateForValidation1Key(key: "btn_select_category", inPage: "register_screen", existingString: "Please select one category")
        case .SELECT_MOBILE_CODE:
            return HELPER.getTranslateForValidation1Key(key: "btn_code", inPage: "register_screen", existingString: "Please select country code")
        case .ENTER_MOBILE_NUM:
            return HELPER.getTranslateForValidation1Key(key: "txt_fld_mobile_num", inPage: "register_screen", existingString: "Please enter mobile number")
        case .EMPTY_CATEGORY:
            return HELPER.getTranslateForValidation1Key(key: "lbl_category", inPage: "register_screen", existingString: "Category cannot be empty")
        case .EMPTY_SUB_CATEGORY:
            return HELPER.getTranslateForValidation1Key(key: "lbl_sub_category", inPage: "register_screen", existingString: "Sub Category cannot be empty")
            
            
            
            
            
            
        case .ENTER_VALID_EMAIL:
            return HELPER.getTranslateForValidation2Key(key: "txt_fld_email", inPage: "register_screen", existingString: "Please enter the valid email address")
        case .ENTER_VALID_MOBILE_NO:
            return HELPER.getTranslateForValidation2Key(key: "txt_fld_mobile_num", inPage: "register_screen", existingString: "Mobile number must be minimum 9 digit length")
        case .EMPTY_PROVIDER_NAME:
            return HELPER.getTranslateForValidation2Key(key: "txt_fld_name", inPage: "register_screen", existingString: "Provider name cannot be empty")
            
            
            
        case .EMPTY_USER_NAME:
            return HELPER.getTranslateForValidation3Key(key: "txt_fld_name", inPage: "register_screen", existingString: "User name cannot be empty")
            
            
            
            
            
        }
    }
}

enum SettingsLangContents {
    
    case SETTINGS_TITLE
    case REGIONAL_TITLE
    case OTHERS_TITLE
    case EDIT_PROFILE_TITLE
    case NOTIFICATIONS_TITLE
    case WALLET_TITLE
    case LANGUAGE_TITLE
    case CHANGE_COLOR_TITLE
    case CHANGE_LOCATION_TITLE
    case MAKE_SUGGESSION_TITLE
    case TEARMS_AND_CONDITION_TITLE
    case SHARE_APP_TITLE
    case RATE_APP_TITLE
    case LOGOUT_TITLE
    case SURE_WANT_TO_LOGOUT
    case CHOOSE_LANGUAGE
    case REFERENCE_CODE
    case REFERENCE_Text
    case NOTIFICATION_LIST
    case NO_NOTIFICATION_FOUND
    case PRIMARY_COLOR
    case SECONDARYCOLOR
    case SET_LOCATION_TITLE
    case ACCOUNT_SETTINGS
    
    func titlecontent() -> String {
        
        switch self {
            
        case .SETTINGS_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_settings_title", inPage: "settings_screen", existingString: "Settings")
        case .REGIONAL_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_regional", inPage: "settings_screen", existingString: "Regional")
            
        case .OTHERS_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_others", inPage: "settings_screen", existingString: "Others")
            
        case .EDIT_PROFILE_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_edit_profile", inPage: "settings_screen", existingString: "EDIT PROFILE")
        case .NOTIFICATIONS_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_notifications", inPage: "settings_screen", existingString: "Notifications")
        case .WALLET_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_wallet", inPage: "settings_screen", existingString: "Wallet")
        case .LANGUAGE_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_language", inPage: "settings_screen", existingString: "Language")
            
        case .CHANGE_COLOR_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_change_color", inPage: "settings_screen", existingString: "Change App Theme")
        case .CHANGE_LOCATION_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_change_location", inPage: "settings_screen", existingString: "Change location")
        case .MAKE_SUGGESSION_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_suggession", inPage: "settings_screen", existingString: "Make a suggestion")
        case .TEARMS_AND_CONDITION_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_tearms_and_condition", inPage: "settings_screen", existingString: "Terms and Conditions")
            case .ACCOUNT_SETTINGS:
            return HELPER.getTranslateForKey(key: "lbl_account_settings", inPage: "settings_screen", existingString: "Account Settings")
            
        case .SHARE_APP_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_share_app", inPage: "settings_screen", existingString: "Share App")
        case .RATE_APP_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_rate_app", inPage: "settings_screen", existingString: "Rate Our App")
        case .LOGOUT_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_logout", inPage: "settings_screen", existingString: "Logout")
            
        case .SURE_WANT_TO_LOGOUT:
            return HELPER.getTranslateForKey(key: "alrt_want_to_logout", inPage: "settings_screen", existingString: "Are you sure want to logout?")
            
        case .CHOOSE_LANGUAGE:
            return HELPER.getTranslateForKey(key: "lbl_choose_lang", inPage: "settings_screen", existingString: "Choose a language")
        case .REFERENCE_CODE:
            return HELPER.getTranslateForKey(key: "lbl_reference_code", inPage: "settings_screen", existingString: "Referral Code: ")
            
        case .REFERENCE_Text:
            return HELPER.getTranslateForKey(key: "lbl_reference_text", inPage: "settings_screen", existingString: "Let me recommend you this application")
        case .NOTIFICATION_LIST:
            return HELPER.getTranslateForKey(key: "lbl_notification_list", inPage: "settings_screen", existingString: "Notification List")
        case .PRIMARY_COLOR:
            return HELPER.getTranslateForKey(key: "lbl_primary_color", inPage: "settings_screen", existingString: "Primary Color")
        case .SECONDARYCOLOR:
            return HELPER.getTranslateForKey(key: "lbl_secondary_color", inPage: "settings_screen", existingString: "Secondary Color")
        case .SET_LOCATION_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_location", inPage: "settings_screen", existingString: "Set Location")
            
            
            
            
            
            
        case .NO_NOTIFICATION_FOUND:
            return HELPER.getTranslateForValidation1Key(key: "lbl_notification_list", inPage: "settings_screen", existingString: "No Notifications found")
            
            
            
            
        }
    }
}
enum ProviderAvailability {
    
    case PROVIDER_BUSINESS_HRS
    case ALL_DAYS
    case MONDAY
    case TUESDAY
    case WEDNESDAY
    case THURSDAY
    case FRIDAY
    case SATURDAY
    case SUNDAY
    case SELECT_FROM_TO_TIME
    case SELECT_FROM_TIME
    case SELECT_TO_TIME
    case SELECT_DATES
    case SELECT_PROVIDERS_BUSINESS_HRS
    case UPDATE_HOURS
    
    
    
    
    func titlecontent() -> String {
        
        switch self {
        case .PROVIDER_BUSINESS_HRS:
            return HELPER.getTranslateForKey(key: "lbl_provider_business_hrs", inPage: "provider_availability_screen", existingString: "Provider Business Hours")
            case .UPDATE_HOURS:
                     return HELPER.getTranslateForKey(key: "lbl_update_hours", inPage: "provider_availability_screen", existingString: "Update Hours")
                     
            
        case .ALL_DAYS:
            return HELPER.getTranslateForKey(key: "lbl_all_days", inPage: "provider_availability_screen", existingString: "All days")
        case .MONDAY:
            return HELPER.getTranslateForKey(key: "lbl_monday", inPage: "provider_availability_screen", existingString: "Monday")
        case .TUESDAY:
            return HELPER.getTranslateForKey(key: "lbl_tuesday", inPage: "provider_availability_screen", existingString: "Tuesday")
        case .WEDNESDAY:
            return HELPER.getTranslateForKey(key: "lbl_wednesday", inPage: "provider_availability_screen", existingString: "Wednesday")
        case .THURSDAY:
            return HELPER.getTranslateForKey(key: "lbl_thursday", inPage: "provider_availability_screen", existingString: "Thursday")
        case .FRIDAY:
            return HELPER.getTranslateForKey(key: "lbl_friday", inPage: "provider_availability_screen", existingString: "Friday")
        case .SATURDAY:
            return HELPER.getTranslateForKey(key: "lbl_saturday", inPage: "provider_availability_screen", existingString: "Saturday")
        case .SUNDAY:
            return HELPER.getTranslateForKey(key: "lbl_sunday", inPage: "provider_availability_screen", existingString: "Sunday")
            
        case .SELECT_FROM_TO_TIME:
            return HELPER.getTranslateForKey(key: "alrt_select_from_and_to_time", inPage: "provider_availability_screen", existingString: "Please select From and To time for the selected days")
            
        case .SELECT_FROM_TIME:
            return HELPER.getTranslateForKey(key: "alrt_select_from_time", inPage: "provider_availability_screen", existingString: "Please select From time for the selected days")
            
        case .SELECT_TO_TIME:
            return HELPER.getTranslateForKey(key: "alrt_select_to_time", inPage: "provider_availability_screen", existingString: "Please select To time for the selected days")
            
        case .SELECT_DATES:
            return HELPER.getTranslateForKey(key: "alrt_select_dates", inPage: "provider_availability_screen", existingString: "Please select the dates..")
            
        case .SELECT_PROVIDERS_BUSINESS_HRS:
            return HELPER.getTranslateForValidation1Key(key: "lbl_provider_business_hrs", inPage: "provider_availability_screen", existingString: "Please select provider's business working hours.")
            
        }
    }
}

enum WalletContent {
    
    case WALLET_TITLE
    case TRANS_HISTORY
    case WITHDRAW_FUND
    case TOT_WALLET_BAL
    case TOT_AMT
    case TAX_AMT
    case NO_TRANS_FOUND
    case CONTACT_FOR_STRIPE_ACCESS
    case WITHDRAW_WALLET_TITLE
    case TOPUP_WALLET_TITLE
    case ADD_CASH
    case ADD_CARD
    case SELECT_PAYMENT_METHOD
    case CURRENT_BAL
    case CARD_EXP
    case CARD_CVV
    case PRIVACY_MSG
    case DEBIT_CREDIT_CARD
    case WITHDRAW_CASH
    case ADD_CASH_SECURE
    case ALERT_CASH_EMPTY_FIELD
    case ALERT_ENTER_AMOUNT_GREATER_THAN_ONE
    case ALERT_ENTER_AMOUNT_LESS_THAN_WALLET_AMOUNT
    case ALERT_CARD_NUMBER
    case ALERT_CARD_EXPIRY
    case ALERT_CVV
    case NOT_VALID_CARD
    case ENTER_CARD_DETAILS
    case EXPIRATION_MNTH
    case STRIPE
    case PAYPAL
    case WALLET_PAYMENT_HISTORY
    case CARD_NUMBER
    func titlecontent() -> String {
        
        switch self {
            
        case .WALLET_PAYMENT_HISTORY:
            return HELPER.getTranslateForKey(key: "lbl_wallet_payment_history", inPage: "wallet_screen", existingString: "Wallet Payment History")
        case .WALLET_TITLE:
            return HELPER.getTranslateForKey(key: "wallet_title", inPage: "wallet_screen", existingString: "Wallet")
        case .TRANS_HISTORY:
            return HELPER.getTranslateForKey(key: "lbl_transaction_history", inPage: "wallet_screen", existingString: "Transaction History")
        case .WITHDRAW_FUND:
            return HELPER.getTranslateForKey(key: "lbl_withdraw_fund", inPage: "wallet_screen", existingString: "WITHDRAW  FUND")
        case .TOT_WALLET_BAL:
            return HELPER.getTranslateForKey(key: "lbl_total_wallet_balance", inPage: "wallet_screen", existingString: "Total Wallet Balance")
        case .TOT_AMT:
            return HELPER.getTranslateForKey(key: "lbl_tot_amt", inPage: "wallet_screen", existingString: "Total Amount : ")
        case .TAX_AMT:
            return HELPER.getTranslateForKey(key: "lbl_tax_amt", inPage: "wallet_screen", existingString: "Tax Amount   : ")
        case .NO_TRANS_FOUND:
            return HELPER.getTranslateForKey(key: "lbl_no_trans_found", inPage: "wallet_screen", existingString: "No Transactions Found")
        case .CONTACT_FOR_STRIPE_ACCESS:
            return HELPER.getTranslateForKey(key: "lbl_contact_stripe_admin", inPage: "wallet_screen", existingString: "Contact admin for stripe payment access")
        case .WITHDRAW_WALLET_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_withdraw_wallet", inPage: "wallet_screen", existingString: "Withdraw Wallet")
        case .TOPUP_WALLET_TITLE:
            
            return HELPER.getTranslateForKey(key: "lbl_topup_wallet", inPage: "wallet_screen", existingString: "Topup Wallet")
            
        case .ADD_CASH:
            
            return HELPER.getTranslateForKey(key: "lbl_add_cash", inPage: "wallet_screen", existingString: "Add Cash")
        case .ADD_CARD:
            
            return HELPER.getTranslateForKey(key: "lbl_add_card", inPage: "wallet_screen", existingString: "Add a card")
        case .SELECT_PAYMENT_METHOD:
            return HELPER.getTranslateForKey(key: "lbl_select_payment_method", inPage: "wallet_screen", existingString: "Select your payment method")
        case .CURRENT_BAL:
            return HELPER.getTranslateForKey(key: "lbl_current_bal", inPage: "wallet_screen", existingString: "Current Balance")
            
        case .CARD_EXP:
            return HELPER.getTranslateForKey(key: "lbl_card_expiry", inPage: "wallet_screen", existingString: "Card Expiry")
        case .CARD_CVV:
            return HELPER.getTranslateForKey(key: "lbl_cvv", inPage: "wallet_screen", existingString: "CVV")
        case .PRIVACY_MSG:
            return HELPER.getTranslateForKey(key: "lbl_privacy_msg", inPage: "wallet_screen", existingString: "Your card details would be secureley for faster payments. Your CVV will not be stored.")
        case .DEBIT_CREDIT_CARD:
            return HELPER.getTranslateForKey(key: "lbl_debit_credit_card", inPage: "wallet_screen", existingString: "Debit / Credit Card")
            
        case .ADD_CASH_SECURE:
            return HELPER.getTranslateForKey(key: "btn_add_cash", inPage: "wallet_screen", existingString: "Add Cash Securely")
        case .WITHDRAW_CASH:
            return HELPER.getTranslateForKey(key: "btn_withdraw_cash", inPage: "wallet_screen", existingString: "Withdraw Cash Securely")
        case .ALERT_CASH_EMPTY_FIELD:
            return HELPER.getTranslateForKey(key: "lbl_enter_amt_to_proceed", inPage: "wallet_screen", existingString: "Please enter the amount to proceed...")
        case .STRIPE:
            return HELPER.getTranslateForKey(key: "lbl_stripe", inPage: "wallet_screen", existingString: "Stripe")
        case .PAYPAL:
            return HELPER.getTranslateForKey(key: "lbl_paypal", inPage: "wallet_screen", existingString: "PayPal")
            
        case .ALERT_ENTER_AMOUNT_GREATER_THAN_ONE:
            return HELPER.getTranslateForKey(key: "lbl_enter_less_than_one", inPage: "wallet_screen", existingString: "Please enter the amount greater than 1")
            
        case .ALERT_ENTER_AMOUNT_LESS_THAN_WALLET_AMOUNT:
            return HELPER.getTranslateForKey(key: "lbl_enter_amt_less_than_wallet", inPage: "wallet_screen", existingString: "Please enter amount less than your wallet amount")
            
        case .ALERT_CARD_NUMBER:
            return HELPER.getTranslateForValidation2Key(key: "txt_fld_card_num", inPage: "wallet_screen", existingString: "Card number cannot be empty")
            
        case .ALERT_CARD_EXPIRY:
            return HELPER.getTranslateForValidation1Key(key: "txt_fld_exp_mnth", inPage: "wallet_screen", existingString: "Card expiry number cannot be empty")
            
        case .ALERT_CVV:
            return HELPER.getTranslateForValidation1Key(key: "txt_fld_cvv", inPage: "wallet_screen", existingString: "Card cvv cannot be empty")
        case .NOT_VALID_CARD:
            return HELPER.getTranslateForValidation2Key(key: "txt_fld_exp_mnth", inPage: "wallet_screen", existingString: "Card Details is not Valid")
        case .ENTER_CARD_DETAILS:
            return HELPER.getTranslateForValidation1Key(key: "txt_fld_card_num", inPage: "wallet_screen", existingString: "Enter card details")
        case .EXPIRATION_MNTH:
            return HELPER.getTranslateForKey(key: "lbl_expiration_month", inPage: "wallet_screen", existingString: "Expiration Date (MM/YY)")
        case .CARD_NUMBER:
            return HELPER.getTranslateForKey(key: "txt_fld_card_num", inPage: "wallet_screen", existingString: "Card Number")
        }
    }
}


enum ChatContent {
    
    case NO_CHAT_AVAILABLE
    case ENTER_MESSAGE
    
    func titlecontent() -> String {
        switch self {
        case .NO_CHAT_AVAILABLE:
            return HELPER.getTranslateForKey(key: "lbl_no_chat", inPage: "chat_screen", existingString: "No chat list available")
        case .ENTER_MESSAGE:
            return HELPER.getTranslateForKey(key: "txt_enter_message", inPage: "chat_screen", existingString: "Enter your message..")
            
            
            
            
        }
    }
}
enum HomeScreenContents{
    
    case NO_POPULAR_SERVICE
    case NO_NEWLY_ADDED_SERVICE
    case NO_CATEGORIES_FOUND
    case BUYER_REQUEST
    case IN_PROGRESS_SERVICES
    case MY_SERVICE
    case COMPLETED_SERVICES
    case ACTIVE
    case INACTIVE
    case ALL_TITLE
    case SERVICE
    
    func titlecontent() -> String {
        switch self {
        case .NO_POPULAR_SERVICE:
            return HELPER.getTranslateForKey(key: "lbl_no_popular_service", inPage: "home_screen", existingString: "No Popular Services found")
        case .NO_NEWLY_ADDED_SERVICE:
            return HELPER.getTranslateForKey(key: "lbl_no_newly_added_service", inPage: "home_screen", existingString: "No Newly Added Services found")
        case .NO_CATEGORIES_FOUND:
            return HELPER.getTranslateForKey(key: "lbl_no_categories_found", inPage: "home_screen", existingString: "No categories found")
        case .BUYER_REQUEST:
            return HELPER.getTranslateForKey(key: "lbl_buyer_request", inPage: "home_screen", existingString: "Buyer Request")
        case .IN_PROGRESS_SERVICES:
            return HELPER.getTranslateForKey(key: "lbl_inprogress_services", inPage: "home_screen", existingString: "In-Progress Services")
        case .MY_SERVICE:
            return HELPER.getTranslateForKey(key: "lbl_my_services", inPage: "home_screen", existingString: "My Services")
        case .COMPLETED_SERVICES:
            return HELPER.getTranslateForKey(key: "lbl_completed_services", inPage: "home_screen", existingString: "Completed Service")
            
        case .ACTIVE:
            return HELPER.getTranslateForKey(key: "lbl_filter_active", inPage: "home_screen", existingString: "Active")
        case .INACTIVE:
            return HELPER.getTranslateForKey(key: "lbl_filter_inactive", inPage: "home_screen", existingString: "Inactive")
        case .ALL_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_filter_all", inPage: "home_screen", existingString: "All")
        case .SERVICE:
            return HELPER.getTranslateForValidation1Key(key: "lbl_my_services", inPage: "home_screen", existingString: "Services")
        }
    }
}


enum ViewAllServices{
    
    case BOOK
    case VIEW_ON_MAP
    case POPULAR
    case NEWEST
    case FEATURED
    case POPULAR_SERVICES
    case FEATURED_SERVICES
    
    case NEW_SERVICES
    case RELATED_SERVICES
    
    
    func titlecontent() -> String {
        switch self {
        case .BOOK:
            return HELPER.getTranslateForKey(key: "lbl_book", inPage: "view_all_services", existingString: "Book")
        case .VIEW_ON_MAP:
            return HELPER.getTranslateForKey(key: "lbl_view_on_map", inPage: "view_all_services", existingString: "View on map")
            
            
        case .POPULAR:
            return HELPER.getTranslateForKey(key: "lbl_popular", inPage: "view_all_services", existingString: "POPULAR")
        case .NEWEST:
            return HELPER.getTranslateForKey(key: "lbl_newest", inPage: "view_all_services", existingString: "NEWEST")
        case .FEATURED:
            return HELPER.getTranslateForKey(key: "FEATURED", inPage: "view_all_services", existingString: "FEATURED")
        case .POPULAR_SERVICES:
            return HELPER.getTranslateForKey(key: "lbl_popular_services", inPage: "view_all_services", existingString: "Popular Services")
        case .FEATURED_SERVICES:
            return HELPER.getTranslateForKey(key: "lbl_featured_services", inPage: "view_all_services", existingString: "Featured Services")
        case .NEW_SERVICES:
            return HELPER.getTranslateForKey(key: "lbl_new_service", inPage: "view_all_services", existingString: "New Services")
        case .RELATED_SERVICES:
            return HELPER.getTranslateForKey(key: "lbl_related_services", inPage: "view_all_services", existingString: "Related Services")
            
            
        }
    }
}

enum Booking_service{
    case COD_PENDING
    case PENDING_TITLE
    case INPROGRESS_TITLE
    case COMPLETED_TITLE
    case CANCELLED_TITLE
    case CHOOSE_SERVICE_TYPE
    case CHOOSE_TYPE
    case ACTIVATE_SERVICE
    case INACTIVATE_SERVICE
    case SERVICE_DETAIL
    case MARK_AS_COMPLETE
    case BOOKING_SERVICE
    case TIME_DATE
    case SELECT_TIME_SLOT
    case SELECT_LOCATION
    case LOCATION
    case DESCRIPTION
    case CALENDER
    case MESSAGE_TO_PROVIDER
    case PAYMENT_DETAILS
    case FROM
    case TO
    case TIMINGS
    case LEAVE_DESCRIPTION
    case ENTER_DESC_FOR_BOOKING
    case INSUFFICIENT_BALANCE
    case BOOK_NOW
    case LEAVE_COMMENTS
    case ENTER_REJECTED_REASON
    case REVIEWS
    case OTHER_RELATED_SERVICE
    case CHOOSE_LOCATION
    case ACCEPTED_TITLE
    case ENTER_COMMENTS
    case SELECT_REVIEW_TYPE
    case REJECTED_TITLE
    case REJECT_SERVICE
    case TXT_SELECT_LOCATION
    case NO_TIME_SLOT_AVAILABLE
    case BLOCK
    case COD_RECEIVED
    case COD
    case WALLET
    
    
    
    
    
    func titlecontent() -> String {
        switch self {
        case .COD:
            return HELPER.getTranslateForKey(key: "lbl_cod", inPage: "booking_service", existingString: "Cash on Delivery")
        case .WALLET:
            return HELPER.getTranslateForKey(key: "lbl_wallet", inPage: "booking_service", existingString: "Wallet")
        case .COD_PENDING:
            return HELPER.getTranslateForKey(key: "lbl_cod_pending", inPage: "booking_service", existingString: "COD Pending")
        case .COD_RECEIVED:
            return HELPER.getTranslateForKey(key: "lbl_cod_completed", inPage: "booking_service", existingString: "COD Payment Received")
        case .PENDING_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_pending", inPage: "booking_service", existingString: "Pending")
        case .INPROGRESS_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_inprogress", inPage: "booking_service", existingString: "Inprogress")
        case .COMPLETED_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_completed", inPage: "booking_service", existingString: "Completed")
        case .CANCELLED_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_cancelled", inPage: "booking_service", existingString: "Cancelled")
        case .REJECTED_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_rejected", inPage: "booking_service", existingString: "Rejected")
        case .CHOOSE_SERVICE_TYPE:
            return HELPER.getTranslateForKey(key: "lbl_choose_service_type", inPage: "booking_service", existingString: "Choose Service Type")
        case .CHOOSE_TYPE:
            return HELPER.getTranslateForKey(key: "lbl_choose_type", inPage: "booking_service", existingString: "Choose Type")
        case .ACTIVATE_SERVICE:
            return HELPER.getTranslateForKey(key: "lbl_active_your_service", inPage: "booking_service", existingString: "Are you sure want Active your service?")
        case .INACTIVATE_SERVICE:
            return HELPER.getTranslateForKey(key: "lbl_inactive_your_service", inPage: "booking_service", existingString: "Are you sure want In-Active your service?")
        case .SERVICE_DETAIL:
            return HELPER.getTranslateForKey(key: "lbl_service_detail", inPage: "booking_service", existingString: "Service Detail")
        case .MARK_AS_COMPLETE:
            return HELPER.getTranslateForKey(key: "lbl_mark_as_complete", inPage: "booking_service", existingString: "Mark as complete")
        case .ACCEPTED_TITLE:
            return HELPER.getTranslateForKey(key: "lbl_accepted", inPage: "booking_service", existingString: "Accepted")
        case .BOOKING_SERVICE:
            return HELPER.getTranslateForKey(key: "lbl_book_services", inPage: "booking_service", existingString: "Book Services")
        case .TIME_DATE:
            return HELPER.getTranslateForKey(key: "lbl_time_date", inPage: "booking_service", existingString: "Time & Date")
        case .SELECT_TIME_SLOT:
            return HELPER.getTranslateForValidation1Key(key: "lbl_time_date", inPage: "booking_service", existingString: "Please select time slot for booking")
        case .SELECT_LOCATION:
            return HELPER.getTranslateForValidation1Key(key: "lbl_location", inPage: "booking_service", existingString: "Please select location for booking")
        case .LOCATION:
            return HELPER.getTranslateForKey(key: "lbl_location", inPage: "booking_service", existingString: "Location")
        case .DESCRIPTION:
            return HELPER.getTranslateForKey(key: "lbl_description", inPage: "booking_service", existingString: "Description")
        case .CALENDER:
            return HELPER.getTranslateForKey(key: "lbl_calendar", inPage: "booking_service", existingString: "calendar")
        case .MESSAGE_TO_PROVIDER:
            return HELPER.getTranslateForKey(key: "lbl_message_to_provider", inPage: "booking_service", existingString: "Message to Provider")
        case .PAYMENT_DETAILS:
            return HELPER.getTranslateForKey(key: "lbl_payment_details", inPage: "booking_service", existingString: "Payment Details")
        case .FROM:
            return HELPER.getTranslateForKey(key: "lbl_from", inPage: "booking_service", existingString: "From")
        case .TO:
            return HELPER.getTranslateForKey(key: "lbl_to", inPage: "booking_service", existingString: "To")
        case .TIMINGS:
            return HELPER.getTranslateForKey(key: "lbl_timings", inPage: "booking_service", existingString: "Timings")
        case .LEAVE_DESCRIPTION:
            return HELPER.getTranslateForKey(key: "lbl_leave_description", inPage: "booking_service", existingString: "Leave your description here..")
            
        case .ENTER_DESC_FOR_BOOKING:
            return HELPER.getTranslateForValidation1Key(key: "lbl_leave_description", inPage: "booking_service", existingString: "Please enter your description for booking")
            
        case .INSUFFICIENT_BALANCE:
            return HELPER.getTranslateForKey(key: "lbl_insufficient_balance", inPage: "booking_service", existingString: "You do not have sufficient balance in your wallet account. Please Topup to book the service")
        case .NO_TIME_SLOT_AVAILABLE:
            return HELPER.getTranslateForKey(key: "lbl_no_time_slot_available", inPage: "booking_service", existingString: "No time slots available for the selected date!")
            
        case .BOOK_NOW:
            return HELPER.getTranslateForKey(key: "lbl_book_now", inPage: "booking_service", existingString: "Book now")
        case .LEAVE_COMMENTS:
            return HELPER.getTranslateForKey(key: "txt_view_leave_comments", inPage: "booking_service", existingString: "Leave your comments here...")
        case .OTHER_RELATED_SERVICE:
            return HELPER.getTranslateForKey(key: "lbl_other_related_service", inPage: "booking_service", existingString: "Other Related Services")
        case .REVIEWS:
            return HELPER.getTranslateForKey(key: "lbl_reviews", inPage: "booking_service", existingString: "Reviews")
            
        case .ENTER_COMMENTS:
            return HELPER.getTranslateForKey(key: "txt_view_leave_comments", inPage: "booking_service", existingString: "Please enter the comments for the service")
        case .SELECT_REVIEW_TYPE:
            return HELPER.getTranslateForKey(key: "lbl_select_review_type", inPage: "booking_service", existingString: "Please select review type")
            
            
            
        case .ENTER_REJECTED_REASON:
            return HELPER.getTranslateForValidation1Key(key: "txt_view_leave_comments", inPage: "booking_service", existingString: "Please enter the rejection reason")
        case .REJECT_SERVICE:
            return HELPER.getTranslateForValidation1Key(key: "lbl_rejected", inPage: "booking_service", existingString: "Reject Service")
            
            
            
        case .CHOOSE_LOCATION:
            return HELPER.getTranslateForValidation2Key(key: "lbl_location", inPage: "booking_service", existingString: "Choose location")
            
            
        case .TXT_SELECT_LOCATION:
            return HELPER.getTranslateForValidation3Key(key: "lbl_location", inPage: "booking_service", existingString: "*Please select the location")
        case .BLOCK:
            return HELPER.getTranslateForKey(key: "btn_block", inPage: "booking_service", existingString: "Block")
            
            
        }
    }
}


enum BookingDetailService{
    
    case OVERVIEW
    case ABOUTBUYER
    case BOOKINGINFO
    case ACCEPTREQUEST
    case REJECTREQUEST
    case LOCATION
    case APPOINMENT_SLOT
    case MESSAGE_FROM_BUYER
    case ADMIN_COMMENTS
    case REJECTED_REASON
    case VIEWS
    case DESCRIPTION
    case TO_TIME
    case FROM_TIME
    case RATE_NOW
    case SERVICE_OFFERED
    case ABOUT_SELLER
    case NO_OTHER_SERVICE_FOUND
    case NO_REVIEWS_FOUND
    case YOUR_LOCATION
    case SERVICE_EXPERIENCE
    case RATE_SERVICE
    case RESCHEDULE
  case BTN_RESCHEDULE
    func titlecontent() -> String {
        switch self {
        case .OVERVIEW:
            return HELPER.getTranslateForKey(key: "lbl_overview", inPage: "booking_detail_service", existingString: "OverView")
        case .RESCHEDULE:
            return HELPER.getTranslateForKey(key: "btn_reschedule", inPage: "booking_detail_service", existingString: "Reschedule Timing")
        case .ABOUTBUYER:
            return HELPER.getTranslateForKey(key: "lbl_about_buyer", inPage: "booking_detail_service", existingString: "About the Buyer")
        case .BOOKINGINFO:
            return HELPER.getTranslateForKey(key: "lbl_booking_info", inPage: "booking_detail_service", existingString: "Booking Info")
        case .ACCEPTREQUEST:
            return HELPER.getTranslateForKey(key: "btn_accept_request", inPage: "booking_detail_service", existingString: "Accept Request")
        case .REJECTREQUEST:
            return HELPER.getTranslateForKey(key: "btn_reject_request", inPage: "booking_detail_service", existingString: "Reject Request")
        case .LOCATION:
            return HELPER.getTranslateForKey(key: "lbl_location", inPage: "booking_detail_service", existingString: "Location")
        case .APPOINMENT_SLOT:
            return HELPER.getTranslateForKey(key: "lbl_appoinment_slot", inPage: "booking_detail_service", existingString: "Appointment Slot")
        case .MESSAGE_FROM_BUYER:
            return HELPER.getTranslateForKey(key: "lbl_message_from_buyer", inPage: "booking_detail_service", existingString: "Message from Buyer")
        case .ADMIN_COMMENTS:
            return HELPER.getTranslateForKey(key: "lbl_admin_comments", inPage: "booking_detail_service", existingString: "Admin Comments")
        case .REJECTED_REASON:
            return HELPER.getTranslateForKey(key: "lbl_rejected_reason", inPage: "booking_detail_service", existingString: "Rejected Reason")
        case .VIEWS:
            return HELPER.getTranslateForKey(key: "lbl_views", inPage: "booking_detail_service", existingString: " Views")
        case .YOUR_LOCATION:
            return HELPER.getTranslateForKey(key: "lbl_your_location", inPage: "booking_detail_service", existingString: "Your Location")
            
        case .SERVICE_EXPERIENCE:
            return HELPER.getTranslateForKey(key: "lbl_service_experience", inPage: "booking_detail_service", existingString: "how was your experience about this service")
            
        case .DESCRIPTION:
            return HELPER.getTranslateForKey(key: "lbl_description", inPage: "booking_detail_service", existingString: "Description:")
        case .FROM_TIME:
            return HELPER.getTranslateForKey(key: "lbl_from_time", inPage: "booking_detail_service", existingString: "From Time")
        case .TO_TIME:
            return HELPER.getTranslateForKey(key: "lbl_to_time", inPage: "booking_detail_service", existingString: "To Time")
        case .RATE_NOW:
            return HELPER.getTranslateForKey(key: "lbl_rate_now", inPage: "booking_detail_service", existingString: "Rate Now")
        case .SERVICE_OFFERED:
            return HELPER.getTranslateForKey(key: "lbl_service_offered", inPage: "booking_detail_service", existingString: "Service Offered:")
            
        case .ABOUT_SELLER:
            return HELPER.getTranslateForKey(key: "lbl_about_seller", inPage: "booking_detail_service", existingString: "About the Seller")
        case .NO_OTHER_SERVICE_FOUND:
            return HELPER.getTranslateForKey(key: "lbl_no-services_found", inPage: "booking_detail_service", existingString: "No other services found")
        case .NO_REVIEWS_FOUND:
            return HELPER.getTranslateForKey(key: "lbl_no_reviews_found", inPage: "booking_detail_service", existingString: "No reviews found")
            
        case .RATE_SERVICE:
            return HELPER.getTranslateForValidation1Key(key: "lbl_hint_Description", inPage: "booking_detail_service", existingString: "Please rate the service")
        case .BTN_RESCHEDULE:
            return HELPER.getTranslateForValidation1Key(key: "btn_reschedule", inPage: "booking_detail_service", existingString: "Reschedule")
        }
    }
}

enum SubscriptionScreen {
    case INFO_LABEL
    case THANKS_FOR_UPGRADE
    case THANK_YOU
    case BUY_SUBSCRIPTION
    case GO_TO_SUBSCRIPTION
    case SUBSCRIBE_NOW
    case SKIP_NOW
    func titlecontent() -> String {
        switch self {
        case .INFO_LABEL:
            return HELPER.getTranslateForKey(key: "lbl_thankyou_desc", inPage: "subscriptionscreen", existingString: "You're going to do great things with TruelySell")
        case .THANKS_FOR_UPGRADE:
            return HELPER.getTranslateForKey(key: "lbl_thank_you_upgrade", inPage: "subscriptionscreen", existingString: "Thank you for upgrading your account!")
        case .BUY_SUBSCRIPTION:
            return HELPER.getTranslateForKey(key: "lbl_buy_subscription", inPage: "subscriptionscreen", existingString: "BUY SUBSCRIPTION")
        case .THANK_YOU:
            return HELPER.getTranslateForKey(key: "lbl_thank_you", inPage: "subscriptionscreen", existingString: "Thank You!")
        case .GO_TO_SUBSCRIPTION:
            return HELPER.getTranslateForKey(key: "btn_go_subscription", inPage: "subscriptionscreen", existingString: "GO TO SUBSCRIPTION")
        case .SUBSCRIBE_NOW:
            return HELPER.getTranslateForKey(key: "lbl_subscripe_now", inPage: "subscriptionscreen", existingString: "Subscribe Now")
        case .SKIP_NOW:
            return HELPER.getTranslateForKey(key: "lbl_skip_now", inPage: "subscriptionscreen", existingString: "Skip Now")
      
        }
    }
}

enum CreateService{
    
    case GALLERY
    case INFORMATION
    case TITLE
    case TXT_SERVICE_OFFER
    case SERVICE_AMT
    case DESCRIPTION
    case DELETE_IMG
    case TITLE_CANNOT_BE_EMPTY
    case ENTER_DESCRIPTION
    case ENTER_LOCATION
    case ENTER_CATEGORY
    case ENTER_SUB_CATEGORY
    case EMPTY_AMNT
    case EMPTY_ABOUT
    case UPLOAD_MINIMUM_IMAGE
    case UPDATE_AVAILABILITY
    case BROWSE_FROM_GALLERY
    
    func titlecontent() -> String {
        switch self {
        case .GALLERY:
            return HELPER.getTranslateForKey(key: "lbl_gallery", inPage: "create_service", existingString: "Gallery")
            case .BROWSE_FROM_GALLERY:
                      return HELPER.getTranslateForKey(key: "lbl_browse_from_gallery", inPage: "create_service", existingString: "Browse from gallery")
        case .INFORMATION:
            return HELPER.getTranslateForKey(key: "lbl_information", inPage: "create_service", existingString: "Information")
        case .TITLE:
            return HELPER.getTranslateForKey(key: "lbl_title", inPage: "create_service", existingString: "Title")
        case .TXT_SERVICE_OFFER:
            return HELPER.getTranslateForKey(key: "txt_service_offer", inPage: "create_service", existingString: "Service offer..")
        case .SERVICE_AMT:
            return HELPER.getTranslateForKey(key: "lbl_service_amount", inPage: "create_service", existingString: "Service Amount")
        case .DESCRIPTION:
            return HELPER.getTranslateForKey(key: "lbl_hint_Description", inPage: "create_service", existingString: "Description")
        case .DELETE_IMG:
            return HELPER.getTranslateForValidation1Key(key: "lbl_err_minimun_image", inPage: "create_service", existingString: "Are you sure want to delete the service image?")
        case .TITLE_CANNOT_BE_EMPTY:
            return HELPER.getTranslateForValidation1Key(key: "lbl_title", inPage: "create_service", existingString: "Title cannot be empty")
        case .ENTER_DESCRIPTION:
            return HELPER.getTranslateForValidation1Key(key: "lbl_hint_Description", inPage: "create_service", existingString: "Please enter description")
        case .ENTER_LOCATION:
            return HELPER.getTranslateForValidation1Key(key: "lbl_service_location", inPage: "create_service", existingString: "Location address cannot be empty")
        case .ENTER_CATEGORY:
            return HELPER.getTranslateForValidation1Key(key: "lbl_hint_category", inPage: "create_service", existingString: "Please choose category")
        case .ENTER_SUB_CATEGORY:
            return HELPER.getTranslateForValidation1Key(key: "lbl_hint_subcategory", inPage: "create_service", existingString: "Please choose sub category")
        case .EMPTY_AMNT:
            return HELPER.getTranslateForValidation1Key(key: "lbl_service_amount", inPage: "create_service", existingString: "Please Enter Price")
        case .EMPTY_ABOUT:
            return HELPER.getTranslateForValidation1Key(key: "lbl_about", inPage: "create_service", existingString: "Please enter about service")
        case .UPLOAD_MINIMUM_IMAGE:
            return HELPER.getTranslateForValidation1Key(key: "lbl_err_minimun_image", inPage: "create_service", existingString: "Please upload minimum of three images..")
        case .UPDATE_AVAILABILITY:
            return HELPER.getTranslateForValidation1Key(key: "update_availability", inPage: "create_service", existingString: "Update Availability in Profile to Create a Service")
        
        }
        
    }
    
}

