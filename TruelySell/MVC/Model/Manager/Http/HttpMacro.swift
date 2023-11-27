//
//  HttpMacro.swift
//  VRS
//
//  Created by Guru Prasad chelliah on 6/8/17.
//  Copyright © 2017 project. All rights reserved.
//

import Foundation


let WEB_SERVICE_URL = "https://truelysell.com/api/" //Write the Base Live URL.
let WEB_BASE_URL = "https://truelysell.com/" //Write the Base Live URL.


let CONTACT_URL = "https://truelysell.com/contact" //Write the Contact URL.
let TERMS_CONDITION_URL = "https://truelysell.com/terms-conditions-app" //Write the liveterms and condition URL.
let PRIVACY_POLICY_URL = "https://truelysell.com/privacy-app"
let APP_STORE_URL = "https://apps.apple.com/us/app/truelysell/id1507533178"      //Write the live app store url.

let WEB_SOCKET_URL = "wss://truelysell.com:8443"
// Request
let kCASE = "Case"

let CASE_DATE_TIME_FORMAT = "date_time_format"
let CASE_TRANSACTION_DETAIL = "api/view_wallet_history"
let CASE_RESCHEDULE_TIME = "api/booking_reschedule_provider"
let kLAST_UPDATED_TIME = "last_updated_time"
let CASE_CHANGE_PASSWORD = "userchangepassword"
// Case Name New
let CASE_CURRENCY_CONVERT = "currency-conversion"
let CASE_BLOCK_USERS = "api/block_users"
let CASE_BLOCK_PROVIDER = "api/block_providers"
let CASE_FAVOURITE_LIST = "api/userfavorites"
let CASE_ADD_REMOVE_FAVOURITES = "api/service_favorite_status"
let CASE_WALLET_WITHDRAW = "api/wallet_withdraw"
let CASE_STRIPE_PAYMENT_SETTINGS = "stripe_account_details" 
let CASE_BRAINTEE_CLIENT_ID = "api/braintreeKey"
let CASE_BRAINTEE_PAYPAL = "api/BraintreePaypal"

let CASE_LOGIN_TYPE = "api/getlogin_type"
let CASE_FORGOT_PASSWORD = "forget_password"

let CASE_PROFESSIONAL_CATEGOY = "category"
let CASE_PROFESSIONAL_SUB_CATEGOY = "subcategory"
let CASE_MY_SERVICE_LISTS_ACTIVE_API = "update-myservice-status"
let CASE_MY_SERVICE_ADD = "add_service"
let CASE_MY_SERVICE_DETAIL = "edit_service"
let CASE_MY_SERVICE_EDIT = "update_service"
let CASE_MY_SERVICE_DELETE = "delete_service"
let CASE_MY_SERVICE_IMAGE_DELETE = "delete_serviceimage"
let CASE_UPDATE_PROFILE_PROVIDER = "update_provider"
let CASE_UPDATE_PROFILE_USER = "update_user"
let CASE_PROVIDER_AVAILABILITY = "update_availability"
let CASE_PROVIDER_AVAILABILITY_DETAIL = "availability"
let CASE_VIEW_SUB_CATEGORY = "get_services_from_subid"
let CASE_BOOKING_TIME = "service_availability"
let CASE_BOOKING_SERVICE = "book_service"
let CASE_NEW_LOGOUT = "logout"
let CASE_NEW_DELETE_ACCOUNT = "delete_account"
let CASE_BOOKING_STATUS_UPDATE = "update_booking"
let CASE_SERVICE_DETAIL_VIEWS = "views"
let CASE_PROVIDER_DASHBOARD_COUNT = "get_provider_dashboard_infos"
let CASE_SEND_STRIPE_DETAILS = "stripe_account_details"
let CASE_STRIPE_DETAILS = "account_details"
let CASE_CHECK_STATUS = "details"
let CASE_CHAT_HISTORY = "get-chat-list"
let CASE_CHAT_DETAIL = "get-chat-history"
let CASE_NEW_NOTIFICATION_LIST = "get-notification-list"
let CASE_NEW_NOTIFICATION_DEVICE_TOKEN = "flash-device-token"

let CASE_WALLET_TRANSACTION_HISTORY = "wallet-history"
let CASE_ADD_USER_WALLET = "add-user-wallet"
let CASE_WITHDRAW_PROVIDER = "withdraw-provider"
let CASE_WALLET_AMOUNT = "get-wallet"

let CASE_VIEW_ALL = "all-services"
let CASE_SERVICE_DETAIL = "service-details"

let CASE_HOME = "api/home"
let CASE_DEMO_HOME = "demo-home"
let CASE_NEW_SEARCH = "api/search_services"
let CASE_PROVIDER_BUYER_REQUEST = "api/requestlist_provider"
let CASE_MY_SERVICE_LISTS = "api/my_service"
let CASE_BOOKING_LIST = "api/bookinglist"
let CASE_BOOKING_DETAIL = "api/bookingdetail"
let CASE_PROVIDER_SIGNIN = "api/provider_signin"
let CASE_USER_SIGNIN = "api/user_signin"
let CASE_GENERATE_OTP_PROVIDER = "api/generate_otp_provider"
let CASE_GENERATE_OTP_USER = "api/generate_otp_user"
let CASE_LANGUAGE_LIST = "api/language_list"
let CASE_CURRENCY_LIST = "api/currency_list"
let CASE_LANGUAGE_TYPE = "api/language"
let CASE_SUBSCRIPTION_DETAILS = "api/subscription"




// Case Name Old

let CASE_SUB_CATEGORY = "sub_category"
let CASE_PROVIDER_DETAIL_BOOK = "provider_details"
let CASE_PROVIDER_DETAIL_VIEWS = "views"
let CASE_PROVIDER_BOOK_SERVICE = "book_service"
let CASE_NOTIFICATION_COUNT = "chat_history_count"
let CASE_MY_PROVIDER_COMPLETE = "complete_provider"

let CASE_DEVICE_TOKEN = "gigs/save_device_id"
let CASE_LOGIN = "login"
let CASE_SIGNUP = "user/signup"
//let CASE_FORGOT_PASSWORD = "forgot_password"

let CASE_REGISTER = "signup"
let CASE_IMAGE_UPLOAD = "profile_image_upload"
let CASE_VIEW_USER_PROFILE = "user_profile"
let CASE_VIEW_PROVIDER_PROFILE = "profile"
let CASE_REQUESTS_LIST = "request_list"
let CASE_SERVICE_LIST = "provider_list"
let CASE_ADD_REQUEST = "request"
let CASE_UPDATE_REQUEST = "request_update"
let CASE_UPDATE_SERVICE = "provide_update"
let CASE_SEARCH_LIST = "search_request_list"
let CASE_SUBSCRIPTION_SUCCESS = "subscription_success"

let CASE_STRIPE_KEY = "stripe_details"
let CASE_LOGOUT = "logout"

let CASE_USER_COMMENTS_LIST = "comments_list"
let CASE_ADD_USER_COMMENTS = "comments"
let CASE_ADD_USER_COMMENTS_REPLIES = "replies"
let CASE_USER_COMMENTS_REPLY_LIST = "replies_list"

let CASE_MY_REQUEST_REMOVE_LIST = "request_remove"
let CASE_MY_SERVICE_REMOVE_LIST = "service_remove"

let CASE_MY_REQUEST_LIST = "my_request_list"
let CASE_MY_SERVICE_LIST = "my_provider_list"
let CASE_MY_SERVICE_SEARCH_LIST = "provider_search_list"

let CASE_MY_REQUEST_ACCEPT = "request_accept"

let CASE_MY_REQUEST_COMPLETE = "request_complete"
let CASE_COLOR = "colour_settings"
let CASE_SUBSCRIPTION = "api/subscription_payment"

let CASE_COUNTRY = "user/country"
let CASE_STATE = "user/state"
let CASE_HOME_GIGS = "/gigs/"
let CASE_HOME_VIEWALL_GIGS = "gigs/categories"
let CASE_GIGS_DETAILS = "gigs/gigs_details"
let CASE_HOME_FAVOURTIES_GIGS = "gigs/favourites_gigs"
let CASE_HOME_ADD_FAVOURTIES_GIGS = "gigs/add_favourites"
let CASE_HOME_REMOVE_FAVOURTIES_GIGS = "gigs/remove_favourites"
let CASE_HOME_LAST_VISITED_GIGS = "gigs/last_visited_gigs"
let CASE_HOME_MY_GIGS = "gigs/my_gigs/"
let CASE_HOME_SEARCH = "gigs/search_gig"
let CASE_CREATE_GIGS = "gigs/create_gigs"
let CASE_UPDATE_GIGS = "gigs/update_gigs"
let CASE_PAYPAL = "user/paypal_setting"
let CASE_SETTINGS = "gigs/footer_menu"
let CASE_LANGUAGE = "user/speaking_language/ios"
let CASE_PROFESSION = "user/profession/iOS"
let CASE_VIEWALL_USERREVIEWS = "gigs/seller_reviews"
let CASE_CONTACT_MESSAGE = "gigs/buyer_chat"
let CASE_ADD_FAVOURITES = "/gigs/add_favourites"
let CASE_REMOVE_FAVOURITES = "/gigs/remove_favourites"
let CASE_TERMS_AND_CONDITION = "/gigs/terms"
let CASE_BUY_SERVICE = "gigs/buy_now"
let CASE_PAYPAL_SUCCESS_SERVICE = "gigs/paypal_success"
let CASE_STRIPE_CHARGE = "charge"
let CASE_MY_ACTIVITY = "gigs/my_gig_activity"
let CASE_PAYPAL_PAYMENT_CANCEL = "gigs/buyer_cancel"
let CASE_AMOUNT_WITHDRAW = "gigs/withdram_payment_request"
let CASE_ORDER_STATUS = "gigs/sale_order_status"
let CASE_COMPLETE_REQUEST = "gigs/change_gigs_status"



let CASE_CHAT_SEND = "chat"
let CASE_CHAT_HISTORY_REQUEST = "chat_history_requester"
let CASE_CHAT_DETAIL_REQUEST = "chat_details_requester"
let CASE_CHAT_SEND_REQUEST = "chat_requester"

let CASE_LAST_VISITED_GIGS = "gigs/last_visit" //Background run



//let CASE_PROFILE = "dashboard.php"
//let CASE_EDIT_PROFILE = "profile.php"

// Response
let kRESPONSE = "response"
let kRESPONSE_MESSAGE = "response_message"
let kRESPONSE_CODE = "response_code"

let kRESPONSE_CODE_DATA = 200
let kRESPONSE_CODE_DATA_NOT_AVAILABLE = 201
let kRESPONSE_CODE_NO_DATA_500 = 500
let kRESPONSE_CODE_NO_DATA = 0
let kRESPONSE_CODE_VALIDATION = -1
let kRESPONSE_CODE_NOT_VALIDATION = -2

let kRESPONSE_SUCCESS = "success"
let kRESPONSE_FAILURE = "failure"

let kDEVICE_TYPE = "device_type"
let kDEVICE_TYPE_IOS = "iOS"
let kDEVICE_CATEGORY_ID = "category_Id"
let kDEVICE_CATEGORY_iD = "category_id"
let kDEVICE_TITLE = "title"
let kDEVICE_STATE = "state"
let kDEVICE_COUNTRY = "country"
let kUSER_ID = "user_id"

let kDEVICE_VIEWALL = "services"
let kDEVICE_VIEWALL_SERVICES = "ALL"

// Alert Title
// Alert Title

let ALERT_NO_INTERNET = "Oops!! Itseems like you are not connected to internet"
let ALERT_UNABLE_TO_REACH_DESC = "Unable to reach server at the moment"
let ALERT_REQUIRED_FIELDS = "Please provide the required information"
//let ALERT_EMPTY_FIELD = "Email field cannot be blank"
//let ALERT_EMPTY_PHONENO = "Phone number field cannot be blank"
let ALERT_PAYPAL_EMPTY_FIELD = "Paypal Email field cannot be blank"
//let ALERT_PASSWORD_FIELD = "Password field cannot be blank"
//let ALERT_REPEAT_PASSWORD_FIELD = "Repeat Password field cannot be blank"
//let ALERT_PHONENO = "Phone number must be 10 digits"
//let ALERT_EMAIL_ID = "Email address is valid"
let ALERT_EMAIL_ID_NOTVALID = "Email address is not valid"
//let ALERT_PASSWORD = "Password must be atleast 8 characters long. To make it stronger,use upper and lower case letters,numbers and symbols"
//let ALERT_PASSWORD_MATCH = "Passwords do not match"
//let ALERT_NOT_VALID = "Username or Password is not valid"
//let ALERT_USER_NAME = "User name cannot blank"
//let ALERT_REASON_FIELD = "Reason field cannot be blank"
//let ALERT_ACCOUNT_HOLDER_NAME_FIELD = "Account Holder Name field cannot be blank"
//let ALERT_ACCOUNT_NO_FIELD = "Account Number field cannot be blank"
//let ALERT_BANK_NAME_FIELD = "Bank Name field cannot be blank"
//let ALERT_BANK_ADDRESS_FIELD = "Bank Address field cannot be blank"
//let ALERT_SORT_CODE_FIELD = "Sort Code field cannot be blank"
//let ALERT_ROUTING_NUMBER_FIELD = "Routing Number field cannot be blank"
//let ALERT_IFSC_CODE_FIELD = "IFSC Code field cannot be blank"
//let ALERT_PROFILE_PIC = "Profile pic cannot be blank"
//let ALERT_ICCARD_PIC = "IC card cannot be blank"


let ALERT_ACCOUNT_HOLDER_NAME_FIELD = HELPER.getTranslateForKey(key: "lbl_account_holder_name_field_cannot_be_blank", inPage: "stripe_payment_screen", existingString: "Account Holder Name field cannot be blank")
let ALERT_ACCOUNT_NO_FIELD = HELPER.getTranslateForKey(key: "txt_fld_acc_num", inPage: "stripe_payment_screen", existingString: "Account Holder Number")
let ALERT_BANK_NAME_FIELD = HELPER.getTranslateForKey(key: "txt_fld_bank_name", inPage: "stripe_payment_screen", existingString: "Bank Name")
let ALERT_BANK_ADDRESS_FIELD = HELPER.getTranslateForKey(key: "txt_fld_bank_addr", inPage: "stripe_payment_screen", existingString: "BANK ADDRESS")

let ALERT_ANYONE_FIELDS = HELPER.getTranslateForKey(key: "btn_update", inPage: "stripe_payment_screen", existingString: "Please enter anyone field - SortCode or IFSC code or Swift number")
let ALERT_EMPTY_FIELD = HELPER.getTranslateForKey(key: "lbl_empty", inPage: "stripe_payment_screen", existingString: "Cannot be blank")



// Response Code
let RESPONSE_CODE_200 = 200
let RESPONSE_CODE_404 = 404
let RESPONSE_CODE_498 = 498
let CASE_HISTORY_LIST = "history_list"
let CASE_MY_BOOKING_PROVIDER = "api/my_booking_list"
let CASE_HISTORY_PROVIDER = "api/booking_request_list"
let CASE_RATE_LIST = "review_type"
let CASE_RATE_SUBMIT = "rate_review"
let CASE_RATE_REVIEW_LIST = "rate_review_list"

let ALERT_TYPE_NO_INTERNET = HELPER.getTranslateForKey(key: "lbl_enable_internet", inPage: "common_strings", existingString: "Please enable your internet.")
let ALERT_NO_INTERNET_DESC = HELPER.getTranslateForKey(key: "lbl_no_internet", inPage: "common_strings", existingString: "Oops!! Itseems like you are not connected to internet")

let ALERT_TYPE_NO_DATA = HELPER.getTranslateForKey(key: "lbl_no_data_found", inPage: "common_strings", existingString: "No data found")
let ALERT_TYPE_SERVER_ERROR = HELPER.getTranslateForKey(key: "lbl_unable_to_reach_server", inPage: "common_strings", existingString: "Unable to reach server at the moment")
let ALERT_NO_RECORDS_FOUND = HELPER.getTranslateForKey(key: "lg_no_records_were_found", inPage: "common_strings", existingString: "No records were found")
let ALERT_LOADING_CONTENT = ""


// Parameters
let K_USER_ID = "user_id"
let K_SUB_CATEGORY_ID = "sub_category_id"
let K_GIG_ID = "gig_id"
let K_USER_id = "userid"
let K_USER_NAME = "email"
let K_PASSWORD = "password"
let K_DEVICE_ID = "device_id"
let K_DEVICE_TYPE = "device_type"
let K_FIRST_NAME = "first_name"
let K_LAST_NAME = "last_name"
let K_PHONE = "phone"
let K_ADDRESS = "address"
let K_CITY = "city"
let K_STATE = "state"
let K_ORDER_ID = "order_id"

let K_SESSION_ID = "session_id"
let K_USER_PASSWORD = "new_password"
let K_CONFIRM_PASSWORD = "conform_password"
let K_ITEM_NUMBER = "item_number"
let K_PAYPAL_ID = "paypal_uid"



