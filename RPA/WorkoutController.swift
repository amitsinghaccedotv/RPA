//
//  WorkoutController.swift
//  RPA
//
//  Created by Amit Singh on 16/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import HealthKit
import CareKit
import ResearchKit
import Crashlytics
import PullToRefreshSwift

enum workoutDuration : NSInteger {
    case currentWeek = 1
    case threeWeek   = 2
    case threeMonth  = 3
}

@available(iOS 11.0, *)
class WorkoutController: UIViewController ,workoutDelegate, UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var workoutTable: UITableView!
    let workoutData = WorkoutData()
    var workoutArray = NSMutableArray()
    
    var curWeekWorkoutArray = NSMutableArray()
    var threeWeekWorkoutArray = NSMutableArray()
    var threeMonthWorkoutArray = NSMutableArray()
    
    var isExpandedCell:Bool = false
    var selectedRowIndex = -1
    var totalActivity = NSInteger()
    var completionDataStablise = [(dateComponent: DateComponents, value: Double)]()
    var completionDataMobilise = [(dateComponent: DateComponents, value: Double)]()
    var completionDataEnergise = [(dateComponent: DateComponents, value: Double)]()
    
    @IBOutlet weak var curWeekButton     : UIButton!
    @IBOutlet weak var threeWeekButton   : UIButton!
    @IBOutlet weak var threeMonthButton  : UIButton!
    
    
    fileprivate var insightsViewController: OCKInsightsViewController? = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.title="Workout";
    self.tabBarController?.navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorkout))
        
        self.tabBarController?.navigationController?.navigationBar.tintColor=UIColor.white
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.workoutTable.reloadData()
        }
        if UserDefaults.standard.bool(forKey:"dataChanged") {
            self.fetchWorkoutData()
            UserDefaults.standard.set(false, forKey: "dataChanged")
            curWeekButton.isSelected=true;
        }
    }
    
    func finishedByGettingWorkout(_ result: NSMutableArray, requestCount: NSInteger) {
        print("workout found",requestCount)
        for activityDict in result {
            let activityDict = activityDict as! Dictionary<String, Any>
            workoutArray.add(activityDict);
        }
        
        if requestCount == ActivityIdentifier.allValues.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if(self.curWeekButton.isSelected){
                    self.showWorkoutDataforSelectedTopTab(selectedTab: workoutDuration.currentWeek.rawValue);
                }
                else if(self.threeWeekButton.isSelected){
                    self.showWorkoutDataforSelectedTopTab(selectedTab:workoutDuration.threeWeek.rawValue)
                }
                else{
                    self.showWorkoutDataforSelectedTopTab(selectedTab:workoutDuration.threeMonth.rawValue)
                }
                self.workoutTable.reloadData()
            }
        }
        
    }
    
    
    func failedByGettingWorkout() {
        print("failed to get workout data")
    }
    
    // MARK: Get all Workout Data
    func fetchWorkoutData(){
            if(workoutArray.count>0){
                workoutArray.removeAllObjects()
            }
        
            workoutData.delegate=self
            workoutData.getWorkoutData()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curWeekButton.isSelected=true;
        self.setSelectedButtonOn()
        self.addInsiteController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.createPulltoRefresh()
            self.fetchWorkoutData()
        }
    }
    
    // MARK: add pull to refresh to table
    func createPulltoRefresh(){
        var options = PullToRefreshOption()
        options.indicatorColor = UIColor.white
        
        self.workoutTable.addPullRefresh(options: options, refreshCompletion:
            { [weak self] in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    self?.fetchWorkoutData()
                    self?.workoutTable.reloadData()
                    self?.workoutTable.stopPullRefreshEver()
                }
                
                
        })

    }
    
    
    // MARK : move to add workout page
    func addWorkout(){
        self.performSegue(withIdentifier: "toAddWorkout", sender: nil)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.workoutTable.fixedPullToRefreshViewForDidScroll()
    }
    
    // MARK : ad graph to cell
    func addInsiteController(){
        let viewController = OCKInsightsViewController(insightItems: [OCKInsightItem.emptyInsightsMessage()],
                                                       headerTitle: "RPA", headerSubtitle: "")
        insightsViewController = viewController
    }
    
    func showWorkoutDataforSelectedTopTab(selectedTab : NSInteger){
        
        switch selectedTab {
        case workoutDuration.currentWeek.rawValue:
                    if curWeekWorkoutArray.count>0 {
                        curWeekWorkoutArray.removeAllObjects()
                    }
                    let weekday = NSCalendar.current.component(.weekday, from: Date())
                    let endDate = getCurrentDate(currentDate: NSDate())
                    
                    let startDate = Calendar.current.date(byAdding: .day, value: -weekday, to: endDate)
                    self.sortArrayAccordingtoDate(startDate: startDate!, endDate: endDate)
            
            break
        case workoutDuration.threeWeek.rawValue:
                if(threeWeekWorkoutArray.count>0){
                    threeWeekWorkoutArray.removeAllObjects()
                }
                    let startDate = Calendar.current.date(byAdding: .day, value: -21, to: Date())
                    let endDate = getCurrentDate(currentDate: NSDate())
                    self.sortArrayAccordingtoDate(startDate: startDate!, endDate: endDate)
            break
        case workoutDuration.threeMonth.rawValue:
                    if threeMonthWorkoutArray.count>0 {
                        threeMonthWorkoutArray.removeAllObjects()
                    }
                   
                    let startDate = Calendar.current.date(byAdding:.month, value: -3, to: Date())
                    let endDate = getCurrentDate(currentDate: NSDate())
                    
                    self.sortArrayAccordingtoDate(startDate: startDate!, endDate: endDate)
            break
        default:
            break
        }
        
    }
    // MARK: top button activities
    
    @IBAction func topActivityClicked(_ sender: UIButton) {
        let button = sender
        switch button.tag {
        case 0:
            if curWeekWorkoutArray.count>0 {
                curWeekWorkoutArray.removeAllObjects()
            }
                curWeekButton.isSelected=true
                threeWeekButton.isSelected=false
                threeMonthButton.isSelected=false
                self.showWorkoutDataforSelectedTopTab(selectedTab: workoutDuration.currentWeek.rawValue)

            break
        case 1:
            if threeWeekWorkoutArray.count>0{
                threeWeekWorkoutArray.removeAllObjects()
            }
                curWeekButton.isSelected=false
                threeWeekButton.isSelected=true
                threeMonthButton.isSelected=false
            
                self.showWorkoutDataforSelectedTopTab(selectedTab: workoutDuration.threeWeek.rawValue)

            break
        case 2:
            if(threeMonthWorkoutArray.count > 0){
                threeMonthWorkoutArray.removeAllObjects()
            }
                curWeekButton.isSelected=false
                threeWeekButton.isSelected=false
                threeMonthButton.isSelected=true
                self.showWorkoutDataforSelectedTopTab(selectedTab: workoutDuration.threeMonth.rawValue)
            break
        default:
            break
        }
        self.setSelectedButtonOn()
    }
    func setSelectedButtonOn(){
        if curWeekButton.isSelected {
            curWeekButton.titleLabel?.alpha = 0.5;
            threeWeekButton.titleLabel?.alpha = 1;
            threeMonthButton.titleLabel?.alpha = 1;
        }
        else if(threeWeekButton.isSelected){
            curWeekButton.titleLabel?.alpha = 1;
            threeWeekButton.titleLabel?.alpha = 0.5;
            threeMonthButton.titleLabel?.alpha = 1;
        }
        else{
            curWeekButton.titleLabel?.alpha = 1;
            threeWeekButton.titleLabel?.alpha = 1;
            threeMonthButton.titleLabel?.alpha = 0.5;
        }
        
    }
    func getCurrentDate(currentDate:NSDate)->Date{
        return Utils.getCurrentDate(currentDate:currentDate)
    }
    
    
    func sortArrayAccordingtoDate(startDate: Date , endDate: Date){
        
        for dict  in self.workoutArray {
            let activityDict = dict  as! Dictionary<String, Any>
            let actDate = activityDict["startDate"] as! Date
                        
            if actDate <= endDate && actDate >= startDate {
                if (curWeekButton.isSelected) {
                    curWeekWorkoutArray.add(activityDict)
                }
                else if (threeWeekButton.isSelected) {
                    threeWeekWorkoutArray.add(activityDict)
                }
                else{
                    threeMonthWorkoutArray.add(activityDict)
                }
            }
        }
        self.workoutTable.reloadData()
    }
    
    func getNearestDateFrom(dateArray : Array<Any>) ->Array<Any>
    {
        let toodayUnixTime = NSDate().timeIntervalSince1970
        var dates = dateArray
        dates.sort(by: { abs(($0 as AnyObject).timeIntervalSince1970 - toodayUnixTime) < abs(($1 as AnyObject).timeIntervalSince1970 - toodayUnixTime) })
        return dates
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: TableView Delegates and Data Source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex {
            return 275
        }
        return 75
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if curWeekButton.isSelected {
            return curWeekWorkoutArray.count
        }
        else if (threeWeekButton.isSelected){
            return threeWeekWorkoutArray.count
        }
        return threeMonthWorkoutArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if isExpandedCell && indexPath.row==selectedRowIndex{
            let cell = tableView.dequeueReusableCell(withIdentifier: "expandedCell", for: indexPath) as! ExpandedCell
            
            let activityDict = self.getWorkoutArrayforCell().object(at: indexPath.row) as! Dictionary<String, Any>
                cell.ActivityName.text  =   activityDict["activityname"] as! String?
                let enDate = activityDict["endDate"]
                let stDate = activityDict["startDate"]
                cell.monthLabel.text    =   self.getMonthFromDate(date: enDate! as! NSDate)
                cell.dateLabel.text     =   self.getDateFrom(date: enDate! as! NSDate)
                cell.minuteLabel.text   =   self.getMinutesFrom(startdate: stDate! as! NSDate, endDate: enDate! as! NSDate)
            
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            print(activityDict);
            var count = Double()
//            if (activityDict["totalActivity"] as! Double > 0){
//                count = activityDict["totalActivity"] as! Double
//            }
//            else{
//                count = activityDict["duration"] as! Double
//            }
            count = Utils.getMinutesfromDuration(duration: activityDict["duration"] as! TimeInterval)
            
            
            
            let viewController = OCKInsightsViewController.init(insightItems: self.produceInsightforActivity(activityType: activityDict["activityname"] as! String ,totalTime:count, intencityType: self.getIntencityIdentifire(activityDict: activityDict), activeEnerge: self.getActiveEnergy(activityDict: activityDict)), headerTitle: "", headerSubtitle: "This workout's % contribution towards \n your weekly RPA")
            viewController.view.backgroundColor=UIColor.clear
            
            viewController.view.frame=CGRect(x:0,y:0,width:cell.barView.frame.size.width-10,height:cell.barView.frame.size.height)
            cell.barView.addSubview((viewController.view)!)
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! HeaderCell
        let activityDict = self.getWorkoutArrayforCell().object(at: indexPath.row) as! Dictionary<String, Any>
        cell.ActivityName.text  =   activityDict["activityname"] as! String?
        
        let enDate = activityDict["endDate"]
        let stDate = activityDict["startDate"]
        cell.monthLabel.text    =   self.getMonthFromDate(date: enDate! as! NSDate)
        cell.dateLabel.text     =   self.getDateFrom(date: enDate! as! NSDate)
        cell.minuteLabel.text   =   self.getMinutesFrom(startdate: stDate! as! NSDate, endDate: enDate! as! NSDate)
        
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
    func getIntencityIdentifire(activityDict : Dictionary <String, Any>) -> IntensityIdentifire {
        if(activityDict["Intencity"] != nil){
            return  IntensityIdentifire(rawValue: activityDict["Intencity"] as! String)!
        }
        else if (activityDict["activeEnergy"] != nil)
        {
            print(activityDict["activeEnergy"] as Any)
        }
        
        return .Mild
    }
    
    func getActiveEnergy(activityDict : Dictionary <String, Any>)-> NSInteger{
        if (activityDict["activeEnergy"] != nil) {
            return activityDict["activeEnergy"] as! NSInteger
        }
        return 0;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.resetPreviousSelection()
        
        if selectedRowIndex == indexPath.row {
            selectedRowIndex = -1
        } else {
            isExpandedCell = true
            selectedRowIndex = indexPath.row
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.none, animated: false)
    }
        
    
    
    func getWorkoutArrayforCell()-> NSMutableArray{
        if curWeekButton.isSelected {
            return curWeekWorkoutArray
        }
        else if(threeWeekButton.isSelected){
            return threeWeekWorkoutArray
        }
        
        return threeMonthWorkoutArray
    }
   
    func getMonthFromDate(date :NSDate)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone=NSTimeZone.local;
        dateFormatter.dateFormat="MMM"
        dateFormatter.shortMonthSymbols = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        return dateFormatter.string(from: date as Date)
    }
    
    func getDateFrom(date :NSDate)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="dd"
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: date as Date)
    }
    
    func getMinutesFrom(startdate :NSDate , endDate :NSDate)->String{
        
        var timeInterval = TimeInterval()
        timeInterval=endDate.timeIntervalSince(startdate as Date)
        let minute = Int(timeInterval/60)
        return NSString(format: "%d", minute) as String
    }
    
    
    func resetPreviousSelection(){
        isExpandedCell = false
        let previousIndex = IndexPath.init(row: selectedRowIndex, section: 0)
        self.workoutTable.reloadRows(at: [previousIndex], with: .automatic)
    }
    
    func produceInsightforActivity(activityType:String , totalTime : Double , intencityType : IntensityIdentifire , activeEnerge : NSInteger) -> [OCKInsightItem] {
        
        
        self.completionDataStablise.removeAll()
        self.completionDataMobilise.removeAll()
        self.completionDataEnergise.removeAll()
        
        let dateCm = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        self.completionDataStablise.append((dateCm,RPA.getStablize(activityTime: totalTime, activity: activityType, intesity: intencityType.rawValue, activCalories: activeEnerge)))
        
        let dateCm1 = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        self.completionDataMobilise.append((dateCm1,RPA.getMoblize(activityTime: totalTime, activity: activityType, intesity: intencityType.rawValue, activCalories: activeEnerge)))
        
        let dateCm2 = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        
        self.completionDataEnergise.append((dateCm2,RPA.getEnergize(activityTime: totalTime, activity: activityType, intesity: intencityType.rawValue, activCalories: activeEnerge)))
        
        let chart = OCKBarChart(
            title: "",
            text: "",
            tintColor: UIColor.green,
            axisTitles: nil,
            axisSubtitles: nil,
            dataSeries: [mobilizeSeries,stablizeSeries,energizeSeries])
        
        return [chart]
    }
    
    var mobilizeSeries: OCKBarSeries {
        let completionValues = completionDataMobilise.map({NSNumber(value:$0.value * 100)})
        let completionValueLabels = completionValues
            .map({ NumberFormatter.localizedString(from: $0, number: .decimal) + "%"})
        return OCKBarSeries(
            title: "Mobilize",
            values: completionValues,
            valueLabels: completionValueLabels,
            tintColor: UIColor.mobilizeColor())
    }
    
    var stablizeSeries: OCKBarSeries {
        let completionValues = completionDataStablise.map({NSNumber(value:$0.value * 100)})
        let completionValueLabels = completionValues
            .map({ NumberFormatter.localizedString(from: $0, number: .decimal) + "%"})
        return OCKBarSeries(
            title: "Stabilize",
            values: completionValues,
            valueLabels: completionValueLabels,
            tintColor: UIColor.stablizeColor())
    }
    var energizeSeries: OCKBarSeries {
        let completionValues = completionDataEnergise.map({ NSNumber(value:$0.value * 100) })
        let completionValueLabels = completionValues
            .map({ NumberFormatter.localizedString(from: $0, number: .decimal) + "%"})
        return OCKBarSeries(
            title: "Energize",
            values: completionValues,
            valueLabels: completionValueLabels,
            tintColor: UIColor.energizeColor())
    }
}
   





