//
//  HttpManager.swift
//  VRS
//
//  Created by admin on 27/05/2017.
//  Copyright © 2017 project. All rights reserved.
//

import UIKit
import Alamofire

class HttpManager: NSObject {

    static let sharedInstance: HttpManager = {
       let instance = HttpManager()
        
        return instance
    }()

    func callGetApi(strUrl:String, sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
        
        var headers = [String : String] ()
        
        if SESSION.getUserToken().count != 0 {
        
            headers = ["token": SESSION.getUserToken(),"language":SESSION.getAppLangType()]
        }
        else{
          
            headers = ["token": "8338d6ff4f0878b222f312494c1621a9","language":SESSION.getAppLangType()]
        }
        
        let dict = [String : String] ()
        
        Alamofire.request(strUrl, method: .get, parameters: dict, encoding: Alamofire.URLEncoding.default, headers: headers).responseJSON
            {(response) in
                
                let jsonDict = response.result.value as? [String:Any]
                
                if response.result.isSuccess {
                    
                    sucessBlock(jsonDict! as NSDictionary)
                    print(jsonDict!)
                }
                    
                else if response.result.isFailure {
                    
                    if SESSION.isAppLaunchFirstTime() {
                                      failureBlock(ALERT_UNABLE_TO_REACH_DESC)
                                  }
                                       else {
                                           failureBlock(ALERT_TYPE_SERVER_ERROR)
                                      }
                }
        }
    }
    
    func callGetApiDefaultToken(strUrl:String, sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
        
        var headers = [String : String] ()
        headers = ["token": "8338d6ff4f0878b222f312494c1621a9","language":SESSION.getAppLangType()]
        
        let dict = [String : String] ()
        
        Alamofire.request(strUrl, method: .get, parameters: dict, encoding: Alamofire.URLEncoding.default, headers: headers).responseJSON
            {(response) in
                
                let jsonDict = response.result.value as? [String:Any]
                
                if response.result.isSuccess {
                    
                    sucessBlock(jsonDict! as NSDictionary)
                }
                    
                else if response.result.isFailure {
                 if SESSION.isAppLaunchFirstTime() {
                                      failureBlock(ALERT_UNABLE_TO_REACH_DESC)
                                  }
                                       else {
                                           failureBlock(ALERT_TYPE_SERVER_ERROR)
                                      }
                }
        }
    }
    
    func callGetApiParams(strUrl:String, dictParameters:[String : String],sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
        
        var headers = [String : String] ()
        
        if SESSION.getUserToken().count != 0 {
            
            headers = ["token": SESSION.getUserToken(),"language":SESSION.getAppLangType()]
        }
        else{
            
            headers = ["token": "8338d6ff4f0878b222f312494c1621a9","language":SESSION.getAppLangType()]
        }
        
        Alamofire.request(strUrl, method: .get, parameters: dictParameters, encoding: Alamofire.URLEncoding.default, headers: headers).responseJSON
            {(response) in
                
                let jsonDict = response.result.value as? [String:Any]
                
                if response.result.isSuccess {
                    
                    sucessBlock(jsonDict! as NSDictionary)
                }
                    
                else if response.result.isFailure {
                     if SESSION.isAppLaunchFirstTime() {
                    failureBlock(ALERT_UNABLE_TO_REACH_DESC)
                }
                     else {
                         failureBlock(ALERT_TYPE_SERVER_ERROR)
                    }
                }
        }
    }
    
    func callPostApi(strUrl:String, dictParameters:[String : String], sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
        
        var headers:HTTPHeaders? = nil
        if SESSION.getUserToken().count > 0 {
            
            headers = ["token": SESSION.getUserToken(),"language":SESSION.getAppLangType(),"Content-Type":"application/json"]
        }
        else {
            
            headers = ["Content-Type" : "application/json","token": "8338d6ff4f0878b222f312494c1621a9","language":SESSION.getAppLangType()] //default token
        }
        
        print(strUrl)
        print(dictParameters)
        print(headers)

        Alamofire.request(strUrl, method : .post, parameters : dictParameters, encoding : JSONEncoding.default , headers : headers).responseData {
            (dataResponse) in
            
            print(dataResponse.request as Any) // your request
            print(dataResponse.response as Any) // your response
            print(dataResponse.result.value as Any) // your response
            
            if dataResponse.result.isSuccess {
                
                var jsonResponse  = [String :Any]()
                
                 let encryptedData:NSData = dataResponse.result.value! as NSData
                    
                    print(NSString(data: (encryptedData as Data) as Data, encoding: String.Encoding.utf8.rawValue)! as String)
                    
                    do {
                        jsonResponse = try JSONSerialization.jsonObject(with: encryptedData as Data, options: .mutableContainers) as! [String : Any]
                        print(jsonResponse as NSDictionary)
                    }
                        
                    catch let error
                    {
                        print(error)
                    }
//                }
                
                sucessBlock(jsonResponse as NSDictionary)
                
            }
                
            else if dataResponse.result.isFailure {
                
                if SESSION.isAppLaunchFirstTime() {
                                  failureBlock(ALERT_UNABLE_TO_REACH_DESC)
                              }
                                   else {
                                       failureBlock(ALERT_TYPE_SERVER_ERROR)
                                  }
            }
        }
        
    }
    
    //contrycode REQUEST
    func contryCode(contryCodeBlock: @escaping (NSArray)->(), failureBlock:@escaping (String) ->()) {
        
        Alamofire.request("https://restcountries.eu/rest/v2/all", method: .get).responseJSON
            {(response) in
                
                if response.result.isSuccess {
                    
                    if let result = response.result.value {
                        
                        let json = result as! Array<Any>
                        
                        print(json)
                        
                        contryCodeBlock(result as! Array<Any> as NSArray)
                    }
                }
                    
                else if response.result.isFailure {
                    
                    
                    if SESSION.isAppLaunchFirstTime() {
                                      failureBlock(ALERT_UNABLE_TO_REACH_DESC)
                                  }
                                       else {
                                           failureBlock(ALERT_TYPE_SERVER_ERROR)
                                      }                }
        }
    }
   
//    func callUploadImageApi(strUrl:String,params:[String:String], sucessBlock: @escaping (NSDictionary)->(), failureBlock:@escaping (String) ->()) {
//        
//        let dict = params
//        var myImageUrl = dict[""]
//        var myCardImgUrl = dict[""]
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            
//            if myImageUrl != nil {
//                
//                multipartFormData.append(myImageUrl!, withName: "profile_img")
//                
//            }
//            if myCardImgUrl != nil {
//                
//                multipartFormData.append(myCardImgUrl!, withName: "ic_card_image")
//                
//            }
//            
//            for (key, value) in dict {
//                
//                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//            }
//        }, to: WEB_SERVICE_URL + CASE_REGISTER) { (response) in
//            
//            let jsonDict = response.result.value as? [String:Any]
//            
//            if response.result.isSuccess {
//                
//                sucessBlock(jsonDict! as NSDictionary)
//            }
//                
//            else if response.result.isFailure {
//                
//                failureBlock(ALERT_UNABLE_TO_REACH_DESC)
//            }
//        }
//    }
}
