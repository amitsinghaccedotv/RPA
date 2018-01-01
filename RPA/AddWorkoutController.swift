//
//  AddWorkoutController.swift
//  RPA
//
//  Created by Amit Singh on 01/10/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import TextFieldEffects
import HealthKit
import DateTimePicker


class AddWorkoutController: UIViewController,CustomPopOverDelegate,UITextFieldDelegate{
    var popover = CustomPopOver()
    var isPopoverAvailable = Bool()
    var isActivityTypeSelected = Bool()
    var isAnyError = Bool()
    
    
    @IBOutlet weak var activityTextField: HoshiTextField!
    @IBOutlet weak var intensityTextField: HoshiTextField!
    @IBOutlet weak var startDateTxtField: HoshiTextField!
    @IBOutlet weak var endDateTxtField: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: Add Workout Date button Action
    @IBAction func dateButtonClicked(_ sender: UIButton){
        
        let calendar = Calendar.current
        let backDate = calendar.date(byAdding: .month, value: -30, to: Date())
        let currentDate = NSDate()
        let picker = DateTimePicker.show(selected: currentDate as Date, minimumDate: backDate, maximumDate: nil)
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        
        picker.completionHandler = { date in
            
            let enteredDate = date as Date
            
            
            let formatter = Utils.getDateFormatter()
            if sender.tag == 0{
                if enteredDate > currentDate as Date{
                    self.isAnyError = true
                    self.startDateTxtField.placeholderColor=UIColor.red
                    Utils.showAlerttoView(controller: self, message: "Entered date is not a valid date", messageType: .error)
                }
                else{
                    self.isAnyError  = false
                    self.startDateTxtField.text=formatter.string(from: enteredDate)
                    self.startDateTxtField.placeholderColor=UIColor.gray
                }
                
            }
            else{
                if enteredDate > currentDate as Date{
                    self.isAnyError = true
                    self.endDateTxtField.placeholderColor=UIColor.red
                    Utils.showAlerttoView(controller: self, message: "Entered date is not a valid date", messageType: .error)
                }
                else{
                    self.isAnyError  = false
                    self.endDateTxtField.text = formatter.string(from: enteredDate)
                    self.endDateTxtField.placeholderColor=UIColor.gray
                }
            }
        }
//        let currentDate = NSDate()
//        DatePickerDialog().show("Workout Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: currentDate as Date, minimumDate: nil, maximumDate: currentDate as Date, datePickerMode: .date) { (date) in
//
//            if let dt = date {
//                let formatter = Utils.getDateFormatter()
//                self.workoutDateTxtField.text = formatter.string(from: dt)
//            }
//        }
    }
    
    // MARK: Add Activity  button Action
    
    @IBAction func popOverBtnClicked(_ sender: UIButton) {
        self.resetView()
        self.view.endEditing(true)
        if !self.isPopoverAvailable {
            var popoverheight = 0
            
            switch sender.tag{
            case 1000:
                    isActivityTypeSelected = true
                    popoverheight = 400
                break
            case 1001:
                    isActivityTypeSelected = false
                    popoverheight = 200
                break
            default:
                break
            }
            popover = CustomPopOver.init(frame: CGRect(x:sender.frame.origin.x + 5, y: sender.frame.origin.y+sender.frame.size.height,width:self.view.frame.size.width-20,height: CGFloat(popoverheight)))
            popover.alpha=0.0;
            popover.custompopoverDelegate=self
            self.view.addSubview(self.popover)
            popover.createContentList(activity: isActivityTypeSelected)
            UIView.animate(withDuration: 0.25) { () -> Void in
                self.popover.alpha=1;
                self.isPopoverAvailable = true
            }
        }
    }
    
   
    @IBAction func createActivity(_ sender: Any) {
        if checkError() {
            Utils.showAlerttoView(controller: self, message: "Please check entered data", messageType: .error)
        }
        else{
            let date = NSDate()
            self.saveWorkout(date: date ,activity: ActivityIdentifier(rawValue: activityTextField.text!)!)
        }
    }
    
    func saveWorkout(date:NSDate , activity:ActivityIdentifier){
        let healthManager = HealthManager()
        let df = Utils.getDateFormatter()
        let sdString = startDateTxtField.text
        let edString = endDateTxtField.text
        
        let stDate = df.date(from: sdString!)
        let enDate = df.date(from: edString!)
        switch activity {
        case .Running:
            
            healthManager.saveWorkout(workoutDuration: (TimeInterval(Utils.getMinutesInIntegerFrom(startdate: stDate! as NSDate, endDate: enDate! as NSDate))), StartDate:stDate!, EndDate: enDate!, activityType: .running,intencityType:self.getInencity(), completion: { (error, success) in
                if ((error) != nil){
                    UserDefaults.standard.set(false, forKey: "dataChanged")
                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
                }
                else{
                    UserDefaults.standard.set(true, forKey: "dataChanged")
                    self.backToPreviousStack(self)
                }
            })
            break
        case .Cycling:
            
            healthManager.saveWorkout(workoutDuration: (TimeInterval(Utils.getMinutesInIntegerFrom(startdate: stDate! as NSDate, endDate: enDate! as NSDate))), StartDate:stDate!, EndDate: enDate!, activityType: .cycling,intencityType:self.getInencity(), completion: { (error, success) in
                    if ((error) != nil){
                        UserDefaults.standard.set(false, forKey: "dataChanged")
                        Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
                    }
                    else{
                        UserDefaults.standard.set(true, forKey: "dataChanged")
                        self.backToPreviousStack(self)
                    }
                })
                
            break
        case .Swimming:
            
            healthManager.saveWorkout(workoutDuration: (TimeInterval(Utils.getMinutesInIntegerFrom(startdate: stDate! as NSDate, endDate: enDate! as NSDate))), StartDate:stDate!, EndDate: enDate!, activityType: .swimming,intencityType:self.getInencity(), completion: { (error, success) in
                    if ((error) != nil){
                        UserDefaults.standard.set(false, forKey: "dataChanged")
                       Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
                    }
                    else{
                        UserDefaults.standard.set(true, forKey: "dataChanged")
                        self.backToPreviousStack(self)
                    }
                })
            break
        case .Hiking:
            
            healthManager.saveWorkout(workoutDuration: (TimeInterval(Utils.getMinutesInIntegerFrom(startdate: stDate! as NSDate, endDate: enDate! as NSDate))), StartDate:stDate!, EndDate: enDate!, activityType: .hiking,intencityType:self.getInencity(), completion: { (error, success) in
                if ((error) != nil){
                    UserDefaults.standard.set(false, forKey: "dataChanged")
                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
                }
                else{
                    UserDefaults.standard.set(true, forKey: "dataChanged")
                    self.backToPreviousStack(self)
                }
             })
            break;
        case .HealthOut_Mobilize:
            
//            healthManager.saveWorkout(workoutDuration: self.timeInterval(Duration.text!), StartDate: date, EndDate: date, activityType: .other,otherActivityType:.HealthOut_Mobilize, completion: { (error, success) in
//                if ((error) != nil){
//                    UserDefaults.standard.set(false, forKey: "dataChanged")
//                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
//                }
//                else{
//                    UserDefaults.standard.set(true, forKey: "dataChanged")
//                    self.backToPreviousStack(self)
//                }
//            })
            
                Utils.showAlerttoView(controller: self, message: "Working", messageType: .error)
            break
        case .HealthOut_Stabilize:
            
//             healthManager.saveWorkout(workoutDuration: self.timeInterval(Duration.text!), StartDate: date, EndDate: date, activityType: .other,otherActivityType:.HealthOut_Stabilize, completion: { (error, success) in
//                if ((error) != nil){
//                    UserDefaults.standard.set(false, forKey: "dataChanged")
//                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
//                }
//                else{
//                    UserDefaults.standard.set(true, forKey: "dataChanged")
//                    self.backToPreviousStack(self)
//                }
//             })
            Utils.showAlerttoView(controller: self, message: "Working", messageType: .error)
            break
        case .HealthOut_Energize:
            
//             healthManager.saveWorkout(workoutDuration: self.timeInterval(Duration.text!), StartDate: date, EndDate: date, activityType: .other,otherActivityType:.HealthOut_Energize, completion: { (error, success) in
//                if ((error) != nil){
//                    UserDefaults.standard.set(false, forKey: "dataChanged")
//                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
//                }
//                else{
//                    UserDefaults.standard.set(true, forKey: "dataChanged")
//                    self.backToPreviousStack(self)
//                }
//             })
            Utils.showAlerttoView(controller: self, message: "Working", messageType: .error)
            
            break
        case .Crossfit:
            
             healthManager.saveWorkout(workoutDuration: (TimeInterval(Utils.getMinutesInIntegerFrom(startdate: stDate! as NSDate, endDate: enDate! as NSDate))), StartDate:stDate!, EndDate: enDate!, activityType: .crossTraining,intencityType:self.getInencity(), completion: { (error, success) in
                if ((error) != nil){
                    UserDefaults.standard.set(false, forKey: "dataChanged")
                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
                }
                else{
                    UserDefaults.standard.set(true, forKey: "dataChanged")
                    self.backToPreviousStack(self)
                }
             })
            break
        case .Pilates:
            
             
            healthManager.saveWorkout(workoutDuration: (TimeInterval(Utils.getMinutesInIntegerFrom(startdate: stDate! as NSDate, endDate: enDate! as NSDate))), StartDate:stDate!, EndDate: enDate!, activityType: .pilates,intencityType:self.getInencity(), completion: { (error, success) in
                if ((error) != nil) {
                    UserDefaults.standard.set(false, forKey: "dataChanged")
                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
                }
                else{
                    UserDefaults.standard.set(true, forKey: "dataChanged")
                    self.backToPreviousStack(self)
                }
             })
            break
        case .Strength_Training:
            
             
            healthManager.saveWorkout(workoutDuration: (TimeInterval(Utils.getMinutesInIntegerFrom(startdate: stDate! as NSDate, endDate: enDate! as NSDate))), StartDate:stDate!, EndDate: enDate!, activityType: .other,intencityType:self.getInencity(), completion: { (error, success) in
                if ((error) != nil){
                    UserDefaults.standard.set(false, forKey: "dataChanged")
                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
                }
                else{
                    UserDefaults.standard.set(true, forKey: "dataChanged")
                        self.backToPreviousStack(self)
                }
             })
             
            break
        case .Walking:
            
            healthManager.saveWorkout(workoutDuration: (TimeInterval(Utils.getMinutesInIntegerFrom(startdate: stDate! as NSDate, endDate: enDate! as NSDate))), StartDate:stDate!, EndDate: enDate!, activityType: .walking,intencityType:self.getInencity(), completion: { (error, success) in
                if ((error) != nil){
                    UserDefaults.standard.set(false, forKey: "dataChanged")
                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
                }
                else{
                    UserDefaults.standard.set(true, forKey: "dataChanged")
                    self.backToPreviousStack(self)
                }
             })
            break
        case .Yoga:
            
            healthManager.saveWorkout(workoutDuration: (TimeInterval(Utils.getMinutesInIntegerFrom(startdate: stDate! as NSDate, endDate: enDate! as NSDate))), StartDate:stDate!, EndDate: enDate!, activityType: .yoga,intencityType:self.getInencity(), completion: { (error, success) in
                if ((error) != nil){
                      UserDefaults.standard.set(false, forKey: "dataChanged")
                    Utils.showAlerttoView(controller: self, message: "Some thing went wrong", messageType: .error)
                }
                else{
                    UserDefaults.standard.set(true, forKey: "dataChanged")
                    self.backToPreviousStack(self)
                }
             })
            break
        
        default:
            break
        }
        
    }
    
    func getInencity()->IntensityIdentifire{
        if (intensityTextField.text == IntensityIdentifire.Mild.rawValue) {
            return .Mild
        }
        else if (intensityTextField.text == IntensityIdentifire.Intense.rawValue){
            return .Intense
        }
        return .Moderate
    }
    
    
    // MARK: convert string to time interval
    func timeInterval(_ timeString:String)->TimeInterval!{
        let enteredTime = timeString.replacingOccurrences(of: " mins", with: "", options: .literal, range: nil)

        let timeMultipilers = [1.0,60.0,3600.0] //seconds for unit
        var time = 0.0
        var timeComponents = enteredTime.components(separatedBy: ":")
        timeComponents.reverse()
        if timeComponents.count > timeMultipilers.count{return nil}
        for index in 0..<timeComponents.count{
            guard let timeComponent = Double(timeComponents[index]) else { return nil}
            time += timeComponent * timeMultipilers[index]
        }
        return time
    }
    
    // MARK: view delegate
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if isPopoverAvailable {
            self.popover.removeFromSuperview()
            isPopoverAvailable = false
        }
    }
    
    // MARK: popover delegate
    func selelctedActivity(activityName: String) {
        isPopoverAvailable = false
        self.popover.removeFromSuperview()
        if isActivityTypeSelected {
            activityTextField.text=activityName
        }
        else{
            intensityTextField.text=activityName
        }
    }
    
    
    // MARK: TextField Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.resetView()
    }
    
    
    func resetView(){
        activityTextField.placeholderColor=UIColor.gray
        intensityTextField.placeholderColor=UIColor.gray
        endDateTxtField.placeholderColor=UIColor.gray
        startDateTxtField.placeholderColor=UIColor.gray
    }
    
    // MARK: Show error of invalid fields
    func checkError() -> Bool{
        isAnyError = false
        
        if activityTextField.text?.characters.count == 0 {
            isAnyError = true
            activityTextField.placeholderColor=UIColor.red
        }
        if intensityTextField.text?.characters.count == 0 {
            isAnyError = true
            intensityTextField.placeholderColor=UIColor.red
        }
        if startDateTxtField.text?.characters.count == 0 {
            isAnyError = true
            startDateTxtField.placeholderColor=UIColor.red
        }
        if endDateTxtField.text?.characters.count == 0 {
            isAnyError = true
            endDateTxtField.placeholderColor=UIColor.red
        }
        return isAnyError
    }
    @IBAction func backToPreviousStack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
