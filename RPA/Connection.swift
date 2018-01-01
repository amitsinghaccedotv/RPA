//
//  Connection.swift
//  RPA
//
//  Created by Amit Singh on 08/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON



class Connection: NSObject,connectionDelegate {
    static let kBaseURL = "http://13.59.169.206"
    static let kAuthenticateEndPoint =  "/healthout-service/oauth/token?grant_type=password"
    static let kValidateOTPEndPoint = "/healthout-service/v1/otp/validate"
    static let kRegisterationEndPoint = "/healthout-service/v1/user/register"
    static let kGetResetOTPEndPoint = "/healthout-service/v1/otp?"
    static let kAuthSocialLoginEndPoint = "/healthout-service/oauth/token?grant_type=social&socialtype=facebook"
    static let kGetUserProfile = "/healthout-service/v1/user/"
    static let kUpdateProfile = "/healthout-service/v1/user-health-info/"
    var delegate : connectionDelegate?
    
    
    func connectToGetOTP(parameters: [String:String]){
        let UrlString = "\(Connection.kBaseURL)\(Connection.kRegisterationEndPoint)"
        let headers = ["Content-Type": "application/json"]
        
        self.callConnectionAPI(URL: UrlString, header: headers, parameters: parameters , methodType: .post)
    }
    
    func connenctToValidateOTP(parameters: [String:String]){
       
        let UrlString = "\(Connection.kBaseURL)\(Connection.kValidateOTPEndPoint)"
        let headers = ["Content-Type": "application/json"]
        
        self.callConnectionAPI(URL: UrlString, header: headers, parameters: parameters , methodType: .post)
    }
    
    func connectToLogin(parameters: [String : String] , userName : String , password : String){
        
        let Url = "\(Connection.kBaseURL)\(Connection.kAuthenticateEndPoint)"+"&username="+"\(userName)"+"&password="+"\(password)"
        let headers = ["Content-Type": "application/x-www-form-urlencoded" , "Authorization": "Basic aGVhbHRob3V0LWlvcy1hcHA6aGVhbHRob3V0LXNlcnZpY2U="]
         self.callConnectionAPI(URL: Url, header: headers, parameters: parameters , methodType: .post)
    }
    func connectToSaveWorkout(parameters : [String : String],token : String){
        let Url = "\(Connection.kBaseURL)\(Connection.kUpdateProfile)"
        let header = [
            "Authorization": "Bearer "+"\(token)",
            "Content-Type": "application/json"
        ]
        self.callConnectionAPI(URL: Url, header: header, parameters: parameters , methodType: .post)
    }
    func connectToUpdateWorkout(parameters : [String : String],token : String ,userID: String){
        let Url = "\(Connection.kBaseURL)\(Connection.kUpdateProfile)\(userID)"
        let header = [
            "Authorization": "Bearer "+"\(token)",
            "Content-Type": "application/json"
        ]
        self.callConnectionAPI(URL: Url, header: header, parameters: parameters , methodType: .put)
        
    }
    
    func connectToGetProfile(userID : Int,parameters: [String : String],token : String){
        
        let Url = "\(Connection.kBaseURL)\(Connection.kGetUserProfile)"+"\(userID)"
        let header = [
            "Authorization": "Bearer "+"\(token)",
            "Content-Type": "application/json"
        ]
        self.connectToServerForGetRequest(url: Url, requestName: "getProfile",headers: header)
    }
    
    func connectToGetHealthProfile(userID : Int,parameters: [String : String],token : String){
        
        let Url = "\(Connection.kBaseURL)\(Connection.kUpdateProfile)"+"\(userID)"
        let header = [
            "Authorization": "Bearer "+"\(token)",
            "Content-Type": "application/json"
        ]
        self.connectToServerForGetRequest(url: Url, requestName: "getHealthProfile",headers: header)
    }
    
    func connectToResetOTP(parameters: [String : String] , userName : String){
      
        let Url = "\(Connection.kBaseURL)\(Connection.kGetResetOTPEndPoint)"+"email="+"\(userName)"+"&otpType=REGISTRATION"
        self.connectToServerForGetRequest(url: Url, requestName: "OTP", headers: ["":""] )
    }
    
    func connectAuthenticateSocialLogin(parameters: [String : String] , userName : String , facebookToken : String){
        
        let Url = "\(Connection.kBaseURL)\(Connection.kAuthSocialLoginEndPoint)"+"&username="+"\(userName)"+"&socialtoken="+"\(facebookToken)"
        let headers = ["Content-Type": "application/x-www-form-urlencoded" , "Authorization": "Basic aGVhbHRob3V0LWlvcy1hcHA6aGVhbHRob3V0LXNlcnZpY2U="]
        self.callConnectionAPI(URL: Url, header: headers, parameters: parameters , methodType: .post)

    }
    
    func callConnectionAPI(URL:String , header: [String : String] , parameters : [String : String],methodType : HTTPMethod){
     
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")

        if(reachabilityManager?.isReachable)!{
            
        
            
            
            Alamofire.request(URL, method: methodType, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
                print(parameters)
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        
                        if let id = response.result.value as? NSNull {
                            print(id);
                            self.delegate?.finishedByGettingResponse!("success" as AnyObject)
                            return
                        }
                        let jsonResponse = response.result.value as! Dictionary<String,Any>
                        if((jsonResponse["errorCode"]) == nil && (jsonResponse["error"]) == nil){
                            self.delegate?.finishedByGettingResponse!(response.result.value as AnyObject)
                        }
                        else{
                            self.delegate?.failedByGettingResponse!(response.result.value as AnyObject)
                        }
                        
                        
                        
                    }
                    break
                case .failure(_):
                    print(response.result.error as AnyObject)
                    self.delegate?.failedByGettingResponse!(response.result.error as AnyObject)
                    break
                }
            }
        }
        else{
            self.delegate?.failedToConnect!()
        }
        
    }
    
    func connectToServerForGetRequest(url : String , requestName : String , headers: [String : String]){
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
        if(reachabilityManager?.isReachable)!{
            if(requestName == "getProfile" || requestName == "getHealthProfile"){
                Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                    .responseJSON { response in
                        if(response.result.isSuccess){
                            self.delegate?.finishedByGettingResponse!(response.result.value as AnyObject)
                        }
                        else{
                            self.delegate?.failedByGettingResponse!(response.result.value as AnyObject)
                        }
                }
            }else{
                Alamofire.request(url).responseJSON(completionHandler: {
                    response in
                    if(response.result.isSuccess){
                        print("success",response.result.value as AnyObject);
                        if(requestName == "GetProfile"){
                            self.delegate?.finishedByGettingResponse!(response.result as AnyObject)
                        }
                        else{
                            self.delegate?.finishedByGettingResponse!(response.response?.statusCode as AnyObject)
                        }
                        
                    }
                    else{
                        print("failed");
                        self.delegate?.failedByGettingResponse!(response.result.error as AnyObject)
                    }
                })
            }
            
        }
        else{
            self.delegate?.failedToConnect!()
        }
        
    }
    
}


@objc protocol connectionDelegate {
    @objc optional func finishedByGettingResponse(_ result:AnyObject)
    @objc optional func failedByGettingResponse(_ result:AnyObject)
    @objc optional func failedToConnect()
}

