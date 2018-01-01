//
//  OTPController.swift
//  RPA
//
//  Created by Amit Singh on 09/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import GradientLoadingBar


class OTPController: UIViewController,connectionDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var otpView: VPMOTPView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFromResetPassword = Bool()
    var emailID : String?
    var hasEnterOTP : Bool?
    var OTPString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasEnterOTP=false
        
        
        otpView.otpFieldsCount = 4
        otpView.otpFieldDefaultBorderColor = UIColor.gray
        otpView.otpFieldEnteredBorderColor = UIColor.green
        otpView.otpFieldBorderWidth = 2
        otpView.otpFieldDisplayType=VPMOTPView.DisplayType.underlinedBottom;
        otpView.delegate = self
        // Create the UI
        otpView.initalizeUI()
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    @IBAction func submitOTP(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if hasEnterOTP!{
            GradientLoadingBar.sharedInstance().show()
            
            let connectionClass = Connection()
            connectionClass.delegate=self
            Utils.addLoaderToController(controllerView: self.view)
            let params = ["otp": OTPString,"email" : emailID]
            
            connectionClass.connenctToValidateOTP(parameters: params as! [String : String])
        }
        else{
            Utils.showAlerttoView(controller: self, message: "Please enter OTP", messageType: .error)
        }
        
        
    }
    
    
    @IBAction func Back(_ sender: UIButton) {
        self.view.endEditing(true)
         _ = navigationController?.popViewController(animated: true)
    }
    
    func finishedByGettingResponse(_ result: AnyObject) {
        GradientLoadingBar.sharedInstance().hide()
        Utils.removeLoaderFromController(controllerView: self.view)
        
        if isFromResetPassword {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "toChangePassword", sender: nil)
              
            }
        }
        else{
            UserDefaults.standard.set(false, forKey: "login")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//               self.performSegue(withIdentifier: "CustomSegue", sender: nil)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                
                let navigationController = UINavigationController(rootViewController: viewController)
                self.appDelegate.window?.rootViewController = navigationController
            }
        }
        
        
    }
    
    func failedByGettingResponse(_ result: Any) {
        GradientLoadingBar.sharedInstance().hide()
        Utils.removeLoaderFromController(controllerView: self.view)
        
        
        if(result is Dictionary<String, Any>){
            let jsonResponse = result as! Dictionary<String,Any>
            if(jsonResponse["errorDescription"] != nil){
                Utils.showAlerttoView(controller: self, message: jsonResponse["errorDescription"] as! String, messageType: .error)
            }
            else{
                Utils.showAlerttoView(controller: self, message: "Some thing went wrong. Please try again later.", messageType: .error)
            }
            
        }
        else{
                Utils.showAlerttoView(controller: self, message: "Some thing went wrong. Please try again later.", messageType: .error)
        }
    }
    
    func failedToConnect() {
        Utils.showAlerttoView(controller: self, message: "No Internet connection available.", messageType:.error)
    }

    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    
    
}

extension OTPController: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) {
        print("Has entered all OTP? \(hasEntered)")
        hasEnterOTP=hasEntered
    }
    
    func enteredOTP(otpString: String) {
        print("OTPString: \(otpString)")
        OTPString = otpString
    }
}
