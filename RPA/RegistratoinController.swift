//
//  RegistratoinController.swift
//  RPA
//
//  Created by Amit Singh on 08/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import GradientLoadingBar
import TextFieldEffects

class RegistratoinController: UIViewController,connectionDelegate, UITextFieldDelegate {
   
    @IBOutlet weak var nameTxtField: HoshiTextField!
    @IBOutlet weak var emailTxtField: HoshiTextField!
    @IBOutlet weak var passwordTxtField: HoshiTextField!
    @IBOutlet weak var confirmTxtField: HoshiTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    }

    
    @IBAction func sign_in_clicked(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func signUpClicked(_ sender: UIButton) {
        
        self.view.endEditing(true)

        if ((nameTxtField.text?.characters.count)! > 0 &&
            (emailTxtField.text?.characters.count)! > 0 &&
                (passwordTxtField.text?.characters.count)! > 0
                    && (confirmTxtField.text?.characters.count)! > 0) {
           
            if (Utils.validateEmail(candidate: emailTxtField.text!) && passwordTxtField.text==confirmTxtField.text){
                    GradientLoadingBar.sharedInstance().show()
                    self.navigationItem.setHidesBackButton(true, animated: false)
                    let connectionClass = Connection()
                    connectionClass.delegate=self
                    Utils.addLoaderToController(controllerView: self.view)
                    let params = ["fullName": nameTxtField.text,"email" : emailTxtField.text,"password":passwordTxtField.text]
                    connectionClass.connectToGetOTP(parameters: params as! [String : String])
            }
            else{
                
                
                if(Utils.validateEmail(candidate: emailTxtField.text!)){
                    
                    Utils.showAlerttoView(controller: self, message: "Password does not match the confirm password", messageType: .error)
                    passwordTxtField.placeholderColor=UIColor.red
                    passwordTxtField.borderInactiveColor=UIColor.red
                    confirmTxtField.placeholderColor=UIColor.red
                    confirmTxtField.borderInactiveColor=UIColor.red
                }
                else{
                    Utils.showAlerttoView(controller: self, message: "Please enter a valid email", messageType: .error)
                    emailTxtField.placeholderColor=UIColor.red
                    emailTxtField.borderInactiveColor=UIColor.red
                }
            }
            
        }
        else if ((nameTxtField.text?.characters.count)! == 0 &&
            (emailTxtField.text?.characters.count)! == 0 &&
            (passwordTxtField.text?.characters.count)! == 0
            && (confirmTxtField.text?.characters.count)! == 0){
                self.showErrorforAllBlankFields()
            Utils.showAlerttoView(controller: self, message: "All fields are mandatory", messageType: .error)
            
        }
        else{
            if(nameTxtField.text?.characters.count==0){
                Utils.showAlerttoView(controller: self, message: "Please enter name", messageType: .error)
                
            }
            else if ((emailTxtField.text?.characters.count)! == 0 && Utils.validateEmail(candidate: emailTxtField.text!)){
                Utils.showAlerttoView(controller: self, message: "Please enter a valid email", messageType: .error)
                
            }
            else if (passwordTxtField.text?.characters.count == 0){
                Utils.showAlerttoView(controller: self, message: "Please enter password", messageType: .error)
                
            }
            else{
                Utils.showAlerttoView(controller: self, message: "Please enter confirm password", messageType: .error)
                
            }
        }
     
        self.showErrorforAllBlankFields()
    }
    
    func showErrorforAllBlankFields(){
        if nameTxtField.text?.characters.count==0 {
            self.showErrorColor(textfield: nameTxtField)
        }
        if emailTxtField.text?.characters.count==0 {
            self.showErrorColor(textfield: emailTxtField)
        }
        if passwordTxtField.text?.characters.count==0 {
            self.showErrorColor(textfield: passwordTxtField)
        }
        if confirmTxtField.text?.characters.count==0 {
            self.showErrorColor(textfield: confirmTxtField)
        }
    }
    
    
    func showErrorColor(textfield : HoshiTextField){
        textfield.placeholderColor=UIColor.red
        textfield.borderInactiveColor=UIColor.red
    }
   
    
    func finishedByGettingResponse(_ result: Any) {
        GradientLoadingBar.sharedInstance().hide()
        self.navigationItem.setHidesBackButton(false, animated: false)
        Utils.removeLoaderFromController(controllerView: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.performSegue(withIdentifier: "OTPController", sender: nil)
        }
    }
    
    func failedToConnect() {
        Utils.showAlerttoView(controller: self, message: "No Internet connection available.", messageType:.error)
    }
    
    func failedByGettingResponse(_ result: Any) {
        
        self.navigationItem.setHidesBackButton(false, animated: false)
        Utils.removeLoaderFromController(controllerView: self.view)
        GradientLoadingBar.sharedInstance().hide()
        
        if(result is Dictionary<String, Any>){
            
            let jsonResponse = result as! Dictionary<String,Any>
            
            if(jsonResponse["errorDescription"]  != nil){
                Utils.showAlerttoView(controller: self, message: jsonResponse["errorDescription"] as! String, messageType: .error)
            }
            else{
                Utils.showAlerttoView(controller: self, message: "Some thing went wrong, Please try again", messageType: .error)
            }
            
        }
        else{
            Utils.showAlerttoView(controller: self, message: "Some thing went wrong, Please try again", messageType: .error)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OTPController" {
            let otpView = segue.destination as? OTPController
            otpView?.emailID=emailTxtField.text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.resetView()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resetView()
        textField.resignFirstResponder()
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
        
        nameTxtField.placeholderColor=UIColor.black
        nameTxtField.borderInactiveColor=UIColor.black
        
        emailTxtField.placeholderColor=UIColor.black
        emailTxtField.borderInactiveColor=UIColor.black
        
        passwordTxtField.placeholderColor=UIColor.black
        passwordTxtField.borderInactiveColor=UIColor.black
        
        confirmTxtField.placeholderColor=UIColor.black
        confirmTxtField.borderInactiveColor=UIColor.black
    }
}
