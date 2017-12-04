//
//  LoginController.swift
//  RPA
//
//  Created by Amit Singh on 08/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import GradientLoadingBar
import TextFieldEffects
import TSMessages
import FacebookLogin
import FBSDKCoreKit

class LoginController: UIViewController ,connectionDelegate,UITextFieldDelegate{

    
    
    @IBOutlet weak var usrTextFeild: HoshiTextField!
    @IBOutlet weak var pswrdTextField: HoshiTextField!
    var isFromModel = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func facebook_login_clicked(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "isSocial")
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile,.email], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                print("Logged in access token",accessToken)
                print("Logged in grantedPermission token",grantedPermissions)
                print("Logged in declinePermissions",declinedPermissions)
                 
                GradientLoadingBar.sharedInstance().show()
                let connectionClass = Connection()
                connectionClass.delegate=self
                Utils.addLoaderToController(controllerView: self.view)
                
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"]).start {
                    (connection, result, err) in
                    if(err == nil)
                    {
                        print("result \(String(describing: result))")
                        
                        UserDefaults.standard.setValue(result, forKey: "social_profile")
                        let params = ["": ""]
                        let facebookDict = result as! Dictionary<String, Any>
                        
                        connectionClass.connectAuthenticateSocialLogin(parameters: params, userName: facebookDict["email"] as! String, facebookToken: accessToken.authenticationToken)
                    }
                    else
                    {
                        Utils.showAlerttoView(controller: self, message:"Facebook Login Failed", messageType: .error)
                    }
                }

            }
            
        }
    }
    @IBAction func reset_password_clicked(_ sender: Any) {
        self.view.endEditing(true)
        
        self.performSegue(withIdentifier: "toResetPassword", sender: nil)
    }

    @IBAction func loginClicked(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isSocial")
        if((usrTextFeild.text?.characters.count)! > 0 && (pswrdTextField.text?.characters.count)! > 0){

            if(Utils.validateEmail(candidate: usrTextFeild.text!)){
                GradientLoadingBar.sharedInstance().show()
                let connectionClass = Connection()
                connectionClass.delegate=self
                Utils.addLoaderToController(controllerView: self.view)
                let params = ["": ""]
                connectionClass.connectToLogin(parameters: params, userName: usrTextFeild.text!, password: pswrdTextField.text!)
            }
            else{
                    Utils.showAlerttoView(controller: self, message: "Please enter valid email", messageType: .error)
                    usrTextFeild.placeholderColor=UIColor.red
                    usrTextFeild.borderInactiveColor=UIColor.red
            }
        }
        else{
            if(usrTextFeild.text?.characters.count)!>0{
                Utils.showAlerttoView(controller: self, message: "Please enter password.", messageType: .error)
                pswrdTextField.placeholderColor=UIColor.red
                pswrdTextField.borderInactiveColor=UIColor.red
            }
            else{
                Utils.showAlerttoView(controller: self, message: "Please enter username.", messageType: .error)
                usrTextFeild.placeholderColor=UIColor.red
                usrTextFeild.borderInactiveColor=UIColor.red
            }
        }
        
//        Utils.removeLoaderFromController(controllerView: self.view)
//        GradientLoadingBar.sharedInstance().hide()
//        self.performSegue(withIdentifier: "CustomSegue", sender: nil)
        
    }
    
    
   
    @IBAction func createAccount_Clicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toRegistration", sender: self)
    }
    
    
    func finishedByGettingResponse(_ result: Any) {
        print(result)
        UserDefaults.standard.set(true, forKey: "login")
        UserDefaults.standard.set(result, forKey: "profileData")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.isFromModel {
                self.dismiss(animated: true, completion: nil)
                self.isFromModel = false
            }
            else{
                Utils.removeLoaderFromController(controllerView: self.view)
                GradientLoadingBar.sharedInstance().hide()
                self.performSegue(withIdentifier: "CustomSegue", sender: nil)

            }
            

        }
        
    }
    func failedByGettingResponse(_ result: Any) {
        
        Utils.removeLoaderFromController(controllerView: self.view)
        GradientLoadingBar.sharedInstance().hide()
        
        
        if (result is Dictionary<String, Any>){
             var jsonResponse = result as! Dictionary<String,Any>
            if (jsonResponse["errorDescription"] != nil) {
                Utils.showAlerttoView(controller: self, message: jsonResponse["errorDescription"] as! String, messageType: .error)
                
            }
            else if (jsonResponse["error_description"] != nil){
                Utils.showAlerttoView(controller: self, message: jsonResponse["error_description"] as! String, messageType: .error)
            }
            else{
                
                if (jsonResponse["message"] != nil){
                    Utils.showAlerttoView(controller: self, message: jsonResponse["message"] as! String, messageType:.error)
                }
                else{
                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong. Try again.", messageType:.error)
                }
                
            }
        }
        else{
            Utils.showAlerttoView(controller: self, message: "Some thing went wrong. Try again later.", messageType:.error)
            
        }
        
    }

    
    func failedToConnect() {
        Utils.showAlerttoView(controller: self, message: "No Internet connection available.", messageType:.error)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.resetView()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.resetView()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.resetView()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resetView()
        self.view.endEditing(true)
    }
    
    func resetView(){
        usrTextFeild.placeholderColor=UIColor.black
        usrTextFeild.borderInactiveColor=UIColor.black
        pswrdTextField.placeholderColor=UIColor.black
        pswrdTextField.borderInactiveColor=UIColor.black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OTPController" {
            let otpView = segue.destination as? OTPController
            otpView?.emailID=usrTextFeild.text
            self.navigationController?.navigationBar.isHidden=false
        }
    }
    
    
}
