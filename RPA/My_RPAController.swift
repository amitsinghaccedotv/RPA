//
//  My_RPAController.swift
//  RPA
//
//  Created by Amit Singh on 16/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import HealthKit
import CareKit
import ResearchKit
import TEAChart

class My_RPAController: UIViewController,workoutDelegate{
    
    let workoutData  = WorkoutData()
    var workoutArray = NSMutableArray()
    
    var isloaded = Bool()
    @IBOutlet weak var moblizeView  : TEABarChart!
    @IBOutlet weak var steblizeView : TEABarChart!
    @IBOutlet weak var enerzizeView : TEABarChart!
    
    @IBOutlet weak var curWeekButton    : UIButton?
    @IBOutlet weak var threeWeekButton  : UIButton?
    @IBOutlet weak var threeMonthButton : UIButton?
    
    @IBOutlet weak var mPercentLbl : UILabel?
    @IBOutlet weak var sPercentLbl : UILabel?
    @IBOutlet weak var ePercentLbl : UILabel?
    
    @IBOutlet weak var mPercentTargetLbl : UILabel?
    @IBOutlet weak var sPercentTargetLbl : UILabel?
    @IBOutlet weak var ePercentTargetLbl : UILabel?
    
    @IBOutlet weak var mCurrentminLbl : UILabel?
    @IBOutlet weak var sCurrentminLbl : UILabel?
    @IBOutlet weak var eCurrentcalLbl : UILabel?
    
    @IBOutlet weak var mTargetminLbl : UILabel?
    @IBOutlet weak var sTargetminLbl : UILabel?
    @IBOutlet weak var eTargetcalLbl : UILabel?
    
    
    
    let curWeekArray    = NSMutableArray()
    let threeWeekArray  = NSMutableArray()
    let threeMonthArray = NSMutableArray()
    
    var energizie  = Float()
    var stablize   = Float()
    var moblize    = Float()
    
    var mDuration  = Float()
    var sDuration  = Float()
    var eCalories  = Float()
    
    var completionDataStablise = [(dateComponent: DateComponents, value: Double)]()
    var completionDataMobilise = [(dateComponent: DateComponents, value: Double)]()
    var completionDataEnergise = [(dateComponent: DateComponents, value: Double)]()
    
    fileprivate var insightsViewController: OCKInsightsViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addInsiteController()
        self.fetchWorkoutData()
        self.curWeekButton?.isSelected=true
        self.setSelectedButtonOn()
        
         self.showWorkoutDataforSelectedTopTab(selectedTab: workoutDuration.currentWeek.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.title="My RPA";
        Utils.removeNavigationItemButton(navController: (self.tabBarController?.navigationController)!)
    self.tabBarController?.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem:.refresh, target: self, action: #selector(reloadGraph))
        self.tabBarController?.navigationController?.navigationBar.tintColor=UIColor.white
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadGraph(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           
            self.workoutArray.removeAllObjects()
            self.curWeekArray.removeAllObjects()
            self.threeMonthArray.removeAllObjects()
            self.threeWeekArray.removeAllObjects()
            
            self.fetchWorkoutData()
        }
    }
    
    // MARK: add InsightsController
    func addInsiteController(){
        let viewController = OCKInsightsViewController(insightItems: [OCKInsightItem.emptyInsightsMessage()],
                                                       headerTitle: "RPA", headerSubtitle: "")
        insightsViewController = viewController
    }
    // MARK: Get all Workout Data
    func fetchWorkoutData(){
        workoutData.delegate=self
        workoutData.getWorkoutData()
    }
    func finishedByGettingWorkout(_ result: NSMutableArray, requestCount: NSInteger) {
        print("workout found",requestCount)
        for activityDict in result {
            let activityDict = activityDict as! Dictionary<String, Any>
            workoutArray.add(activityDict);
        }
        
        if requestCount == ActivityIdentifier.allValues.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showWorkoutDataforSelectedTopTab(selectedTab:(self.curWeekButton?.isSelected)! ? workoutDuration.currentWeek.rawValue: (self.threeWeekButton?.isSelected)! ? workoutDuration.threeWeek.rawValue :workoutDuration.threeMonth.rawValue)
            }
        }
        
    }
    
    func failedByGettingWorkout(_ result: NSMutableArray) {
        print("failed")
    }
    // Mark: Filter workout data
    func showWorkoutDataforSelectedTopTab(selectedTab : NSInteger){
        print(workoutArray)
        switch selectedTab {
        case workoutDuration.currentWeek.rawValue:
            if curWeekArray.count>0 {
                curWeekArray.removeAllObjects()
            }
            let weekday = NSCalendar.current.component(.weekday, from: Date())
            let endDate = Utils.getCurrentDate(currentDate: NSDate())
            
            let startDate = Calendar.current.date(byAdding: .day, value: -weekday, to: endDate)
            self.sortArrayAccordingtoDate(startDate: startDate!, endDate: endDate)
            
            break
        case workoutDuration.threeWeek.rawValue:
            if(threeWeekArray.count>0){
                threeWeekArray.removeAllObjects()
            }
            let startDate = Calendar.current.date(byAdding: .day, value: -21, to: Date())
            let endDate = Utils.getCurrentDate(currentDate: NSDate())
            self.sortArrayAccordingtoDate(startDate: startDate!, endDate: endDate)
            break
        case workoutDuration.threeMonth.rawValue:
            if threeMonthArray.count>0 {
                threeMonthArray.removeAllObjects()
            }
            
            let startDate = Calendar.current.date(byAdding:.month, value: -3, to: Date())
            let endDate = Utils.getCurrentDate(currentDate: NSDate())
            
            self.sortArrayAccordingtoDate(startDate: startDate!, endDate: endDate)
            break
        default:
            break
        }
        
    }
    
    func sortArrayAccordingtoDate(startDate: Date , endDate: Date){
        print(workoutArray)
        for dict  in self.workoutArray {
            let activityDict = dict  as! NSDictionary
            let actDate = activityDict["startDate"] as! Date
            
            if actDate <= endDate && actDate >= startDate {
                if (curWeekButton?.isSelected)! {
                    curWeekArray.add(activityDict)
                }
                else if (threeWeekButton?.isSelected)! {
                    threeWeekArray.add(activityDict)
                }
                else{
                    threeMonthArray.add(activityDict)
                }
            }
        }
        self.addGraphtoView()
    }

    func filterRPA(workoutArr : NSMutableArray , numberOfDays : Float)-> NSMutableDictionary {
        energizie = 0
        moblize = 0
        stablize=0
        
        mDuration = 0
        sDuration = 0
        eCalories = 0
        
        for dict in workoutArr {
            let workoutDict = dict as! Dictionary<String,Any>
            let rpaDict = workoutDict["rpa"] as! Dictionary<String,Any>
            
            let mobilizeDuration = (rpaDict[RpaType.Moblize.rawValue] as? Float)!
            let stablizeDuration = (rpaDict[RpaType.Stablize.rawValue]as? Float)!
            let energizeCalories = ((rpaDict[RpaType.Energize.rawValue] as? Float)!)
           
            mDuration = mDuration + mobilizeDuration
            sDuration = sDuration + stablizeDuration
            eCalories = eCalories + energizeCalories
            
            
        }
        
        if let rpa_target = UserDefaults.standard.dictionary(forKey: "rpa_target"){
            let rpa_mobilise = rpa_target["mobilizeMinuteRPA"] as! String
            let rpa_stablise = rpa_target["stabilizeMinuteRPA"] as! String
            let rpa_energise = rpa_target["energizeMinuteRPA"] as! String
            
            moblize   = (mDuration/Float(rpa_mobilise)!) * 100
            stablize  = (sDuration/Float(rpa_stablise)!) * 100
            energizie = (eCalories/Float(rpa_energise)!) * 100
            
            mTargetminLbl?.text=rpa_mobilise
            sTargetminLbl?.text=rpa_stablise
            eTargetcalLbl?.text=rpa_energise
            
             let percentString = "%"
            mPercentTargetLbl?.text = "\(rpa_target["mobilizeTargetRPA"] ?? "0")\(percentString)"
            sPercentTargetLbl?.text = "\(rpa_target["stabilizeTargetRPA"] ?? "0")\(percentString)"
            ePercentTargetLbl?.text = "\(rpa_target["energizeTargetRPA"] ?? "0")\(percentString)"
        }
        else{
            moblize   = (mDuration/100) * 100
            stablize  = (sDuration/100) * 100
            energizie = (eCalories/100) * 100
        }
     
      
        
        let filterRPADict = NSMutableDictionary()
        filterRPADict.setValue(moblize, forKey: RpaType.Moblize.rawValue)
        filterRPADict.setValue(stablize, forKey: RpaType.Stablize.rawValue)
        filterRPADict.setValue(energizie, forKey: RpaType.Energize.rawValue)

        let percentString = "%"
        
        mPercentLbl?.text = "\(String(format: "%.2f",moblize)) \(percentString)"
        sPercentLbl?.text = "\(String(format: "%.2f",stablize))  \(percentString)"
        ePercentLbl?.text = "\(String(format: "%.2f",energizie)) \(percentString)"
        
        
        mCurrentminLbl?.text = "\(mDuration)"
        sCurrentminLbl?.text = "\(sDuration)"
        eCurrentcalLbl?.text = "\(eCalories)"
        
        return filterRPADict
    }
    // MARK: Add Graph to View
    func addGraphtoView(){
        let rpaDict = self.filterRPA(workoutArr: (curWeekButton?.isSelected)! ? self.curWeekArray : (threeWeekButton?.isSelected)! ? self.threeWeekArray:self.threeMonthArray , numberOfDays: (curWeekButton?.isSelected)! ? 7:(threeWeekButton?.isSelected)! ? 21 : 90)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let mobilizeVal = rpaDict[RpaType.Moblize.rawValue] as! Float
            let stablizeVal = rpaDict[RpaType.Stablize.rawValue] as! Float
            let energizeVal = rpaDict[RpaType.Energize.rawValue] as! Float
            
//            print(mobilizeVal,stablizeVal,energizeVal)
            
            if let rpa_target = UserDefaults.standard.dictionary(forKey: "rpa_target"){
                let rpa_mobilise = rpa_target["mobilizeMinuteRPA"] as! String
                let rpa_stablise = rpa_target["stabilizeMinuteRPA"] as! String
                let rpa_energise = rpa_target["energizeMinuteRPA"] as! String
                
                if(rpa_target.count != 0){
                    self.moblizeView.data       = [mobilizeVal,Float(rpa_mobilise)!];
                    self.steblizeView.data      = [stablizeVal,Float(rpa_stablise)!];
                    self.enerzizeView.data      = [energizeVal,Float(rpa_energise)!];
                    
                    
                }
                else{
                    self.moblizeView.data       = [mobilizeVal,100];
                    self.steblizeView.data      = [stablizeVal,100];
                    self.enerzizeView.data      = [energizeVal,100];
                }
            }
            else{
                self.moblizeView.data       = [mobilizeVal,0];
                self.steblizeView.data      = [stablizeVal,0];
                self.enerzizeView.data      = [energizeVal,0];
            }
            
            
           
           
            self.moblizeView.barSpacing = 35;
            self.moblizeView.barColors  = [UIColor.mobilizeColor()]
            
            self.steblizeView.barColors = [UIColor.stablizeColor()]
            self.steblizeView.barSpacing = 35;
            
            self.enerzizeView.barColors = [UIColor.energizeColor()]
            self.enerzizeView.barSpacing = 35;
        }
    }
    // MARK: top button activities
    @IBAction func topActivityClicked(_ sender: UIButton) {
        let button = sender
        switch button.tag {
        case 0:
            if curWeekArray.count>0 {
                curWeekArray.removeAllObjects()
            }
            curWeekButton?.isSelected=true
            threeWeekButton?.isSelected=false
            threeMonthButton?.isSelected=false
            self.showWorkoutDataforSelectedTopTab(selectedTab: workoutDuration.currentWeek.rawValue)
            
            break
        case 1:
            if threeWeekArray.count>0{
                threeWeekArray.removeAllObjects()
            }
            curWeekButton?.isSelected=false
            threeWeekButton?.isSelected=true
            threeMonthButton?.isSelected=false
            
            self.showWorkoutDataforSelectedTopTab(selectedTab: workoutDuration.threeWeek.rawValue)
            
            break
        case 2:
            if(threeMonthArray.count)>0{
                threeMonthArray.removeAllObjects()
            }
            curWeekButton?.isSelected=false
            threeWeekButton?.isSelected=false
            threeMonthButton?.isSelected=true
            self.showWorkoutDataforSelectedTopTab(selectedTab: workoutDuration.threeMonth.rawValue)
            break
        default:
            break
        }
        self.setSelectedButtonOn()
    }

    func setSelectedButtonOn(){
        if (curWeekButton?.isSelected)! {
            curWeekButton?.titleLabel?.alpha = 0.5;
            threeWeekButton?.titleLabel?.alpha = 1;
            threeMonthButton?.titleLabel?.alpha = 1;
        }
        else if(threeWeekButton?.isSelected)!{
            curWeekButton?.titleLabel?.alpha = 1;
            threeWeekButton?.titleLabel?.alpha = 0.5;
            threeMonthButton?.titleLabel?.alpha = 1;
        }
        else{
            curWeekButton?.titleLabel?.alpha = 1;
            threeWeekButton?.titleLabel?.alpha = 1;
            threeMonthButton?.titleLabel?.alpha = 0.5;
        }
        
    }
}
