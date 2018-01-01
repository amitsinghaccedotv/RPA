//
//  ProfileController.swift
//  RPA
//
//  Created by Amit Singh on 16/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import GradientLoadingBar
import EasyImagePicker
import TextFieldEffects
import SDWebImage
import DateTimePicker
import THCalendarDatePicker

class ProfileController: UIViewController,UITextFieldDelegate,connectionDelegate,workoutDelegate,UIScrollViewDelegate,THDatePickerDelegate{
  
    
    
    @IBOutlet weak var fullNameTxtField    :   HoshiTextField!
    @IBOutlet weak var emailTxtField        :   HoshiTextField!
    @IBOutlet weak var birthdayTxtField     :   HoshiTextField!
    @IBOutlet weak var heightTxtField       :   HoshiTextField!
    @IBOutlet weak var weightTxtField       :   HoshiTextField!
    @IBOutlet weak var bmiTxtField          :   HoshiTextField!
    @IBOutlet weak var sMinuteTxtField      :   HoshiTextField!
    @IBOutlet weak var sRPATxtField         :   HoshiTextField!
    @IBOutlet weak var mMinuteTxtField      :   HoshiTextField!
    @IBOutlet weak var mRPATxtField         :   HoshiTextField!
    @IBOutlet weak var cMinuteTxtField      :   HoshiTextField!
    @IBOutlet weak var cCaloriesTxtField    :   HoshiTextField!
    @IBOutlet weak var cRPATxtField         :   HoshiTextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var maleButton : UIButton!
    @IBOutlet weak var femaleButton : UIButton!
    
    var ProfileDict = NSMutableDictionary()
    let workoutData  = WorkoutData()
    var imagePicker : ImagePicker?
    var isEditingON : Bool!
    var isFirstTimeUser : Bool!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        ProfileDict = workoutData.getProfileData()
        
        
        
        self.workoutData.getProfileData()
        self.workoutData.delegate=self
        imagePicker = ImagePicker()
        imagePicker?.alertMessage = "select photo from camera or library"
        imagePicker?.alertTitle = "RPA Profile"
        imagePicker?.onCancel = {
            print("picking canceled by user!")
        }
        imagePicker?.onError = {
            print("error occurred!")
        }
        self.addImagePicker()
        
        if let loggedInUserData = UserDefaults.standard.value(forKey: "profileData") as? NSMutableDictionary{
           
            let userInfo = loggedInUserData.value(forKey: "userInfo") as! Dictionary <String , Any>
            if UserDefaults.standard.bool(forKey: "isSocial"){
                print(UserDefaults.standard.value(forKey: "social_profile")!)
                let socialDict = UserDefaults.standard.value(forKey: "social_profile") as! Dictionary<String,Any>
                print(socialDict)
                let pictureDict  = socialDict["picture"] as! Dictionary<String,Any>
                let dataDict = pictureDict["data"] as! NSMutableDictionary
                
                let imageUrl = URL.init(string: dataDict["url"] as! String)
                self.profileButton.sd_setImage(with: imageUrl, for: .normal, completed: nil)
            }
            else{
                let userId = userInfo["userId"]
                self.profileButton .setImage(Utils.getImagefile(fileName: ("profile"+"\(userId)"+".png" ?? "")), for: .normal)
            }
            self.updateProfileData(response: userInfo)
        }
        
        
        
        self.profileButton.layer.cornerRadius = (profileButton.frame.size.width)/2
        self.profileButton.clipsToBounds=true
        self.isEditingON = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.title="Profile";
        
        Utils.removeNavigationItemButton(navController: (self.tabBarController?.navigationController)!)
        self.tabBarController?.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem:.edit, target: self, action: #selector(editClicked))
        self.tabBarController?.navigationController?.navigationBar.tintColor=UIColor.white
        
        // Move to a background thread to do some long running work
        DispatchQueue.global(qos: .userInitiated).async {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                self.getProfle()
                self.relaodNavigationItems()
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    //MARK : Reload Navigation Items
    func relaodNavigationItems(){
       
        if isEditingON {
            self.saveButton.setTitle("SAVE", for: UIControlState.normal)
            self.tabBarController?.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(editClicked))
        }
        else{
            self.saveButton.setTitle("Logout", for: UIControlState.normal)
            self.tabBarController?.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editClicked))
        }
        self.setProfileEditable()
    }
    
    
   
    // MARK: Edit Profile Clicked
    func editClicked(){
        if isEditingON {
            isEditingON = false;
        }
        else{
            isEditingON = true;
        }
        self.restView()
        self.relaodNavigationItems()
        self.setProfileEditable()
    }
    
    
    // MARK: Change Profile action called
    @IBAction func ProfileBtnClicked(_ sender: Any) {
        if isEditingON {
            imagePicker?.pickeImage()
        }
    }
    
    func addImagePicker(){
        imagePicker?.onPickImage = { [weak self] (pickedIamge, picker) in
            //            self?.imageView.image = picker.resize(this: pickedIamge, by: CGSize(width: 200, height: 200))
            let loggedInUserData = UserDefaults.standard.value(forKey: "profileData") as! NSMutableDictionary
            let userInfo = loggedInUserData.value(forKey: "userInfo") as! Dictionary <String , Any>
            let userId = userInfo["userId"]
            
            if Utils.saveProfileImage(profileImg: pickedIamge, UserID: "\(userId)") {
                self?.profileButton .setImage(picker.resize(this: pickedIamge, by: CGSize(width: 200, height: 200)), for: .normal)
                
                self?.profileButton.layer.cornerRadius = (self?.profileButton.frame.size.width)!/2
                self?.profileButton.clipsToBounds=true
            }
        }
    }
    
    // MARK: Get Profile Data
    func getProfle(){
        
    
        if let loggedInUserData = UserDefaults.standard.value(forKey: "profileData") as? NSMutableDictionary{
            let userInfo = loggedInUserData.value(forKey: "userInfo") as! Dictionary <String , Any>
            GradientLoadingBar.sharedInstance().show()
            Utils.addLoaderToController(controllerView:appDelegate.window!)
            let connectionClass = Connection()
            connectionClass.delegate=self
            let params = ["": ""]
            connectionClass.connectToGetHealthProfile(userID: userInfo["userId"] as! Int , parameters: params, token:loggedInUserData["access_token"] as! String)
        }
      
    }
    // MARK: Workout Delegates
    func finishedByGettingHelathData(_result: NSDictionary) {
        self.updateProfileData(response: _result as! Dictionary<String, Any>)
    }
    func failedByGettingHelathData() {
        print("unable to fetch workout data")
    }
    // MARK: Connection Delegates
    func finishedByGettingResponse(_ result: AnyObject) {
        let response = result as! Dictionary<String, Any>
        isFirstTimeUser = false
        GradientLoadingBar.sharedInstance().hide()
        Utils.removeLoaderFromController(controllerView: appDelegate.window!)
        self.relaodNavigationItems()
        if response["error"] != nil{
            if(response["error"] as! String == "invalid_token"){
//                self.performSegue(withIdentifier: "toLogin", sender: nil)
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
                
                let navigationController = UINavigationController(rootViewController: viewController)
                appDelegate.window?.rootViewController = navigationController
            }
            else{
                Utils.showAlerttoView(controller: self, message: "Something went wrong", messageType: .error)
            }
        }
        else if(response["errorCode"] != nil){
            if(response["errorCode"] as? String == "USER_HEALTH_INFO_DOES_NOT_EXIST"){
                isFirstTimeUser = true
                self.fill_profileData()
            }
        }
        else{
            
            DispatchQueue.global(qos: .userInitiated).async {
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                    self.updateProfileData(response: response)
                    self.fill_profileData()
                   
                    if(self.mMinuteTxtField.text?.count != 0 && self.sMinuteTxtField.text?.count != 0 && self.cMinuteTxtField.text?.count != 0){
                        let rpa_targetData = NSMutableDictionary()
                        rpa_targetData.setValue(self.mMinuteTxtField.text, forKey: "mobilizeMinuteRPA")
                        rpa_targetData.setValue(self.mRPATxtField.text, forKey: "mobilizeTargetRPA")
                        rpa_targetData.setValue(self.sMinuteTxtField.text, forKey: "stabilizeMinuteRPA")
                        rpa_targetData.setValue(self.sRPATxtField.text, forKey: "stabilizeTargetRPA")
                        rpa_targetData.setValue(self.cMinuteTxtField.text, forKey: "energizeMinuteRPA")
                        rpa_targetData.setValue(self.cRPATxtField.text, forKey: "energizeTargetRPA")
                        rpa_targetData.setValue(self.cCaloriesTxtField.text, forKey: "energizeTargetCalories")
                        UserDefaults.standard.set(rpa_targetData, forKey: "rpa_target")
                    }
                }
            }
        }
        
    }
    func failedByGettingResponse(_ result: Any) {
        GradientLoadingBar.sharedInstance().hide()
        Utils.removeLoaderFromController(controllerView: appDelegate.window!)
        Utils.showAlerttoView(controller: self, message: "Something went wrong", messageType: .error)
    }
    
    func failedToConnect() {
        GradientLoadingBar.sharedInstance().hide()
        Utils.removeLoaderFromController(controllerView: appDelegate.window!)
        Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
    }
    
    
    // MARK: Update profile Dictionary
    func updateProfileData(response : Dictionary<String, Any>){
        for (key, value) in response {
            print("\(key) -> \(value)")
            self.ProfileDict.setValue(value, forKey: key)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    // MARK: All Button Actions
    @IBAction func createProfileClicked(_ sender: Any) {
        if saveButton.titleLabel?.text == "Logout" {
            UserDefaults.standard.set(false, forKey: "login")
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
            
            let navigationController = UINavigationController(rootViewController: viewController)
            appDelegate.window?.rootViewController = navigationController
            
        }
        else{
            self.validateBeforeSaving()
        }
    }
    func validateBeforeSaving(){
        
        if fullNameTxtField.text?.count != 0 && emailTxtField.text?.count != 0 && mMinuteTxtField.text?.count != 0 && sMinuteTxtField.text?.count != 0 &&  cMinuteTxtField.text?.count != 0 && mRPATxtField.text?.count != 0 && sRPATxtField.text?.count != 0 && cRPATxtField.text?.count != 0 && cCaloriesTxtField.text?.count != 0 {
            self.setProfileEditable()
            let loggedInUserData = UserDefaults.standard.value(forKey: "profileData") as! NSMutableDictionary
            let userInfo = loggedInUserData.value(forKey: "userInfo") as! Dictionary <String , Any>
            let userID = "\(userInfo["userId"] ?? "")"
            let accessToken = "\(loggedInUserData["access_token"] ?? "")"
            let gender = maleButton.isSelected ? "Male" : "Female"
            
            let params = ["gender" : String(gender),"height" : heightTxtField.text , "weight" : weightTxtField.text,"bmi" : bmiTxtField.text , "mobilizeMinuteRPA" : mMinuteTxtField.text ,"mobilizeTargetRPA" : mRPATxtField.text , "stabilizeMinuteRPA" : sMinuteTxtField.text,"stabilizeTargetRPA" : sRPATxtField.text ,"energizeMinuteRPA" : cMinuteTxtField.text ,"energizeTargetRPA" : cRPATxtField.text ,"energizeTargetCalories" : cCaloriesTxtField.text , "userId" : String(userID), ]
            
            
            GradientLoadingBar.sharedInstance().show()
            Utils.addLoaderToController(controllerView: appDelegate.window!)
            let connectionClass = Connection()
            connectionClass.delegate=self
            isEditingON = false
            if(isFirstTimeUser){
                connectionClass.connectToSaveWorkout(parameters: params as! [String : String], token: accessToken)
            }
            else{
                connectionClass.connectToUpdateWorkout(parameters: params as! [String : String], token: accessToken, userID: userID)
            }
            
        }
        else{
            if(fullNameTxtField.text?.count == 0){
                fullNameTxtField.placeholderColor=UIColor.red
                fullNameTxtField.borderInactiveColor=UIColor.red
            }
            if (emailTxtField.text?.count == 0){
                emailTxtField.placeholderColor=UIColor.red
                emailTxtField.borderInactiveColor=UIColor.red
            }
            if(mRPATxtField.text?.count) == 0 {
                mRPATxtField.placeholderColor=UIColor.red
                mRPATxtField.borderInactiveColor=UIColor.red
            }
            if(mMinuteTxtField.text?.count) == 0 {
                mMinuteTxtField.placeholderColor=UIColor.red
                mMinuteTxtField.borderInactiveColor=UIColor.red
            }
            if(sRPATxtField.text?.count == 0){
                sRPATxtField.placeholderColor=UIColor.red
                sRPATxtField.borderInactiveColor=UIColor.red
            }
            if(sMinuteTxtField.text?.count == 0){
                sMinuteTxtField.placeholderColor=UIColor.red
                sMinuteTxtField.borderInactiveColor=UIColor.red
            }
            if(cRPATxtField.text?.count == 0){
                cRPATxtField.placeholderColor=UIColor.red
                cRPATxtField.borderInactiveColor=UIColor.red
            }
            if(cCaloriesTxtField.text?.count == 0){
                cCaloriesTxtField.placeholderColor=UIColor.red
                cCaloriesTxtField.borderInactiveColor=UIColor.red
            }
            if(cMinuteTxtField.text?.count == 0){
                cMinuteTxtField.placeholderColor=UIColor.red
                cMinuteTxtField.borderInactiveColor=UIColor.red
            }
            if(heightTxtField.text?.count == 0){
                heightTxtField.placeholderColor=UIColor.red
                heightTxtField.borderInactiveColor=UIColor.red
            }
            if(weightTxtField.text?.count == 0){
                weightTxtField.placeholderColor=UIColor.red
                weightTxtField.borderInactiveColor=UIColor.red
            }
            if(bmiTxtField.text?.count == 0){
                bmiTxtField.placeholderColor=UIColor.red
                bmiTxtField.borderInactiveColor=UIColor.red
            }
        }
    }
    
    func restView(){
        
            fullNameTxtField.placeholderColor=UIColor.darkGray
            fullNameTxtField.borderInactiveColor=UIColor.darkGray
        
            emailTxtField.placeholderColor=UIColor.darkGray
            emailTxtField.borderInactiveColor=UIColor.darkGray
        
            mRPATxtField.placeholderColor=UIColor.black
            mRPATxtField.borderInactiveColor=UIColor.black
        
            mMinuteTxtField.placeholderColor=UIColor.darkGray
            mMinuteTxtField.borderInactiveColor=UIColor.darkGray
        
            sRPATxtField.placeholderColor=UIColor.black
            sRPATxtField.borderInactiveColor=UIColor.black
        
            sMinuteTxtField.placeholderColor=UIColor.darkGray
            sMinuteTxtField.borderInactiveColor=UIColor.darkGray
        
            cRPATxtField.placeholderColor=UIColor.black
            cRPATxtField.borderInactiveColor=UIColor.black
        
            cMinuteTxtField.placeholderColor=UIColor.darkGray
            cMinuteTxtField.borderInactiveColor=UIColor.darkGray
        
            cCaloriesTxtField.placeholderColor=UIColor.black
            cCaloriesTxtField.borderInactiveColor=UIColor.black
       
            heightTxtField.placeholderColor=UIColor.darkGray
            heightTxtField.borderInactiveColor=UIColor.darkGray
       
            weightTxtField.placeholderColor=UIColor.darkGray
            weightTxtField.borderInactiveColor=UIColor.darkGray
       
            bmiTxtField.placeholderColor=UIColor.darkGray
            bmiTxtField.borderInactiveColor=UIColor.darkGray
        }
    
    @IBAction func genderClicked(_ sender: Any) {
        let selectedButton = sender as! UIButton
        switch selectedButton.tag {
        case gender.Male.rawValue:
                maleButton.isSelected=true
                femaleButton.isSelected=false
            break
        case gender.Female.rawValue:
                maleButton.isSelected=false
                femaleButton.isSelected=true
            break
        default:
            break
        }
    }
    func fill_profileData(){
        if ProfileDict.count>0{
            
            if((ProfileDict.value(forKey: "age")) != nil){
                let formatter = DateFormatter()
                formatter.timeZone=NSTimeZone.local
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let stringDate = ProfileDict.value(forKey: "age") as! String
                let date = formatter.date(from:stringDate )
                let newDF = Utils.getDefaultDateFormatter()
                let strDate = newDF.string(from: date!)
                birthdayTxtField.text = strDate
            }
            
            if(ProfileDict.value(forKey: "gender") as? String == "Male"){
                maleButton.isSelected=true
                femaleButton.isSelected=false
            }
            else if(ProfileDict.value(forKey: "gender") as? String == "Female"){
                maleButton.isSelected=false
                femaleButton.isSelected=true
            }
            emailTxtField.text=ProfileDict.value(forKey: "email") as? String
            fullNameTxtField.text=ProfileDict.value(forKey: "fullName") as? String
            self.heightTxtField.text=ProfileDict.value(forKey: "height") as? String
            self.weightTxtField.text=ProfileDict.value(forKey: "weight") as? String
            self.bmiTxtField.text=ProfileDict.value(forKey: "bmi") as? String
            self.mMinuteTxtField.text=ProfileDict.value(forKey: "mobilizeMinuteRPA") as? String
            self.mRPATxtField.text=ProfileDict.value(forKey: "mobilizeTargetRPA") as? String
            self.sMinuteTxtField.text=ProfileDict.value(forKey: "stabilizeMinuteRPA") as? String
            self.sRPATxtField.text=ProfileDict.value(forKey: "stabilizeTargetRPA") as? String
            self.cMinuteTxtField.text=ProfileDict.value(forKey: "energizeMinuteRPA") as? String
            self.cRPATxtField.text=ProfileDict.value(forKey: "energizeTargetRPA") as? String
            self.cCaloriesTxtField.text=ProfileDict.value(forKey: "energizeTargetCalories") as? String
            
        }
    }
    // MARK: TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.restView()
        if textField == birthdayTxtField{
            DispatchQueue.global(qos: .userInitiated).async {
                // Bounce back to the main thread to update the UI
                DispatchQueue.main.async {
                  
                    self.showDateTimePicker()
                }
            }
            
            return false
        }
        else if textField == bmiTxtField{
            return false
        }
        return true
    }
    
    @IBAction func BirthdayClicked(_ sender: Any) {
        if isEditingON {
            self.showDateTimePicker()
        }
    }
    // MARK: -  show caledar
    func showDateTimePicker(){
        let currentDate = NSDate()
        
        datePicker.date = currentDate as Date!
        datePicker.setAutoCloseOnSelectDate(true)
        datePicker.setAllowClearDate(false)
        datePicker.setDisableHistorySelection(false)
        presentSemiViewController(datePicker)
    }
    
    
    lazy var datePicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
        dp?.delegate = self
        dp?.setAllowClearDate(false)
        dp?.setClearAsToday(true)
        dp?.setAutoCloseOnSelectDate(false)
        dp?.setAllowSelectionOfSelectedDate(true)
        dp?.setDisableHistorySelection(true)
        dp?.setDisableFutureSelection(false)
        dp?.selectedBackgroundColor = UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        dp?.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp?.currentDateColorSelected = UIColor.yellow
        return dp!
    }()
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.tag)
        
        if textField == heightTxtField || textField == weightTxtField{
            if(heightTxtField.text?.count != 0 &&  weightTxtField.text?.count != 0){
                let bmi = Utils.calculateBMI(height: (heightTxtField.text! as NSString).doubleValue, weight: (weightTxtField.text! as NSString).doubleValue)
                bmiTxtField.text = String(format: "%.2f",bmi)
            }
        }
        else if(textField == emailTxtField){
            if(!Utils.validateEmail(candidate: textField.text!)){
                Utils.showAlerttoView(controller: self, message: "Not a Valid Email", messageType: .error)
                emailTxtField.placeholderColor=UIColor.red
                emailTxtField.borderInactiveColor=UIColor.red
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func setProfileEditable(){
        self.fullNameTxtField.isEnabled=isEditingON
        self.emailTxtField.isEnabled=isEditingON
        self.birthdayTxtField.isEnabled=isEditingON
        self.heightTxtField.isEnabled=isEditingON
        self.weightTxtField.isEnabled=isEditingON
        self.bmiTxtField.isEnabled=isEditingON
        self.mMinuteTxtField.isEnabled=isEditingON
        self.sMinuteTxtField.isEnabled=isEditingON
        self.cMinuteTxtField.isEnabled=isEditingON
        self.mRPATxtField.isEnabled=isEditingON
        self.cRPATxtField.isEnabled=isEditingON
        self.sRPATxtField.isEnabled=isEditingON
        self.cCaloriesTxtField.isEnabled=isEditingON
        self.maleButton.isUserInteractionEnabled=isEditingON
        self.femaleButton.isUserInteractionEnabled=isEditingON
    }
    
    func datePicker(_ datePicker: THDatePickerViewController!, selectedDate: Date!) {
        print(selectedDate)
        let df = Utils.getDefaultDateFormatter()
        let curDate = Date()
        if selectedDate < curDate {
            birthdayTxtField.text = df.string(from: selectedDate)
        }
        else{
            Utils.showAlerttoView(controller: self, message: "Date of birth is not valid.", messageType: .error)
        }
        
        
    }
    func datePickerDonePressed(_ datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func datePickerCancelPressed(_ datePicker: THDatePickerViewController!) {
        print(datePicker.selectedDates)
    }
    
}
enum gender : Int {
    case Male = 1001
    case Female = 1002
}
