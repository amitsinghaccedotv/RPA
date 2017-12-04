//
//  ResetPasswordController.swift
//  RPA
//
//  Created by Amit Singh on 10/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import TextFieldEffects
import GradientLoadingBar


class ResetPasswordController: UIViewController,connectionDelegate {

    @IBOutlet weak var email_txt_field: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitOTP(_ sender: UIButton) {
        self.view.endEditing(true)
        if((email_txt_field.text?.characters.count)! > 0){
            GradientLoadingBar.sharedInstance().show()
            
            let connectionClass = Connection()
            connectionClass.delegate=self
            Utils.addLoaderToController(controllerView: self.view)
            let params = ["" : ""]
            
            connectionClass.connectToResetOTP(parameters: params, userName: email_txt_field.text!)
        }
        else{
            Utils.showAlerttoView(controller: self, message: "Please enter OTP", messageType: .error)
            email_txt_field.placeholderColor=UIColor.red
            email_txt_field.borderInactiveColor=UIColor.red
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OTPController" {
            let otpView = segue.destination as? OTPController
            otpView?.emailID=email_txt_field.text
            otpView?.isFromResetPassword=true
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resetView()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
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
        email_txt_field.placeholderColor=UIColor.black
        email_txt_field.borderInactiveColor=UIColor.black
    }
    
    
    func finishedByGettingResponse(_ result: Any) {
        GradientLoadingBar.sharedInstance().hide()
        Utils.removeLoaderFromController(controllerView: self.view)
        
        let status  = result as! Int
        if status == 200 || status == 201 || status == 202 || status == 203 || status == 204{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "OTPController", sender: nil)
            }
        }
        else{
            Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
        }
        
    }
    func failedToConnect() {
        self.showDefaultErrorMessage()
    }
    func failedByGettingResponse(_ result: Any) {
        print(result);
        self.showDefaultErrorMessage()
    }
    
    func showDefaultErrorMessage(){
        GradientLoadingBar.sharedInstance().hide()
        Utils.removeLoaderFromController(controllerView: self.view)
        Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
    }
}
