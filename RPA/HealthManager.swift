//
//  HealthManager.swift
//  RPA
//
//  Created by Amit Singh on 19/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import HealthKit


@available(iOS 10.0, *)
class HealthManager {
    
    public let healthStore = HKHealthStore()
    public func requestPermissions(completion:@escaping (Bool)->()) {

        let writableTypes: Set<HKSampleType> = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, HKWorkoutType.workoutType(), HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        let readableTypes: Set<HKSampleType> = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, HKWorkoutType.workoutType(), HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!, HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        
//        let readDataTypes : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceSwimming)!,HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceCycling)!];
//
//        let shareDataTypes : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!];
        
        healthStore.requestAuthorization(toShare: writableTypes, read: readableTypes, completion: { (success, error) in
            var isSuccess :Bool = false
            if success {
                print("Authorization complete")
                      isSuccess=true
            } else {
                print("Authorization error: \(String(describing: error?.localizedDescription))")
                isSuccess = false
            }
            
            completion(isSuccess)
        })
    }
    
    func requestAuthorisationForHealthStoreForProfile(completion:@escaping (Bool)->()) {
        
        let dateOfBirthCharacteristic = HKCharacteristicType.characteristicType(
            forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)
        
        let biologicalSexCharacteristic = HKCharacteristicType.characteristicType(
            forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)
        
        let bloodTypeCharacteristic = HKCharacteristicType.characteristicType(
            forIdentifier: HKCharacteristicTypeIdentifier.bloodType)
        
        let heightTypeCharacteristic = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
        
        let dataTypesToRead = NSSet(objects:
            dateOfBirthCharacteristic as Any,
                                    biologicalSexCharacteristic as Any,
                                    bloodTypeCharacteristic as Any,heightTypeCharacteristic as Any)
        
        healthStore.requestAuthorization(toShare: dataTypesToRead as? Set<HKSampleType>, read: (dataTypesToRead as! Set<HKObjectType>), completion: { (success, error) in
            var isSuccess :Bool = false
            if success {
                print("Authorization complete")
                isSuccess=true
            } else {
                print("Authorization error: \(String(describing: error?.localizedDescription))")
                isSuccess = false
            }
            
            completion(isSuccess)
        })
    }
    
    
    public func getRecords(activityType :HKQuantityTypeIdentifier , completion:@escaping (Double,NSError?,NSMutableArray,HKQuantityTypeIdentifier)->())
    {
        let type = HKSampleType.quantityType(forIdentifier: activityType)
        let lastMonth = NSCalendar.current.date(byAdding: Calendar.Component.day, value: -30, to: NSDate() as Date)
        
        let predicate = HKQuery.predicateForSamples(withStart: lastMonth, end: NSDate() as Date, options: [])
        
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors:nil) { (query, results, Error) in
            var steps: Double = 0
            let activityArray = NSMutableArray()
            var activityname = NSString()
            if ((results) != nil){
                for result in results as! [HKQuantitySample]{
                    
                    switch activityType {
                    case HKQuantityTypeIdentifier.distanceWalkingRunning:
                        steps += result.quantity.doubleValue(for: HKUnit.meter())
                        activityname = "Running"
                        break
                    case HKQuantityTypeIdentifier.distanceCycling:
                        steps += result.quantity.doubleValue(for: HKUnit.meter())
                        activityname = "Cycling"
                        break
                    case HKQuantityTypeIdentifier.distanceSwimming:
                        steps += result.quantity.doubleValue(for: HKUnit.meter())
                        activityname = "Swimming"
                        break
                    case HKQuantityTypeIdentifier.stepCount:
                        steps += result.quantity.doubleValue(for: HKUnit.count())
                        activityname = "Step Count"
                        break
                    default:
                        break;
                    }
                    
                    let activityDict = NSMutableDictionary()
                    activityDict.setValue(result.quantityType, forKey: "quantityType")
                    activityDict.setValue(result.startDate, forKey: "startDate")
                    activityDict.setValue(result.endDate, forKey: "endDate")
                    activityDict.setValue(activityname, forKey: "activityname")
                    activityArray.add(activityDict)
                }
                
            }
            completion(steps , Error as NSError? ,activityArray , activityType)
        }
        healthStore.execute(query)
    }
    
    @available(iOS 11.0, *)
    @available(iOS 11.0, *)
    public func getWorkout(activity:HKWorkoutActivityType, completion: @escaping (([HKWorkout]?, Error? , HKWorkoutActivityType,NSMutableArray) -> Swift.Void)){
        
        let activityArray = NSMutableArray()
        let predicate = HKQuery.predicateForWorkouts(with: activity)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                              ascending: false)
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor])
        {
            (sampleQuery, results, error ) -> Void in
            
            if let queryError = error {
                print( "There was an error while reading the samples: \(queryError.localizedDescription)")
            }
            else
            {
                
                for samples: HKSample in results! {
                    let result: HKWorkout = (samples as! HKWorkout)
                    let activityName = RPA.getActivityName(activity: activity)
                    let activityDict = NSMutableDictionary()
                    print(result.totalEnergyBurned as Any)
                    
                    if((result.metadata) != nil && (result.metadata!["workoutIntencity"] != nil)){
                        print(result.metadata as Any)
                        activityDict.setValue(result.metadata?["workoutIntencity"], forKey: "Intencity")
                    }
//                    if (result.totalEnergyBurned != nil){
//                        print(result.totalEnergyBurned?.doubleValue(for: HKUnit.largeCalorie()) as Any)
//                        
//                        activityDict.setValue(result.totalEnergyBurned?.doubleValue(for: HKUnit.largeCalorie()) as Any, forKey: "activeEnergy")
//                    }
                    activityDict.setValue(result.workoutActivityType, forKey: "quantityType")
                    activityDict.setValue(result.startDate, forKey: "startDate")
                    activityDict.setValue(result.endDate, forKey: "endDate")
                    activityDict.setValue(activityName, forKey: "activityname")
                    activityDict.setValue(result.duration, forKey: "duration")
                    activityDict.setValue(self.getRPAforActivity(acitivityType: activityName, duration: result.duration, dict: activityDict as! Dictionary<String, Any>), forKey: "rpa")
                    activityArray.add(activityDict)
                }
                
            }
            completion(results as? [HKWorkout],error,activity,activityArray)
        }
        
        HKHealthStore().execute(sampleQuery)
    }
    
    func saveWorkout(workoutDuration : TimeInterval ,StartDate : Date , EndDate : Date ,activityType:HKWorkoutActivityType,intencityType:IntensityIdentifire,completion: @escaping ((Error? , Bool) -> Swift.Void)){
        
        
        let metaData_items = NSMutableDictionary()
        metaData_items.setValue(intencityType.rawValue, forKey: "workoutIntencity")
        
        
        let workout = HKWorkout.init(activityType: activityType, start: StartDate , end: EndDate , duration: workoutDuration, totalEnergyBurned: nil, totalDistance: nil, metadata: metaData_items as? [String : Any])
        HKHealthStore().save(workout) {
            (success, error) in
            
                if (success){
                    print("successfully added")
                }
                else{
                    print("error",error.debugDescription)
                    
            }
            completion(error,success)
        }
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
    func getRPAforActivity(acitivityType : String , duration: Double , dict : Dictionary <String,Any>)-> NSMutableDictionary{
        
        let RPADict = NSMutableDictionary()
        let minute  = duration/60
        RPADict.setValue( RPA.getStablize(activityTime: minute, activity: acitivityType, intesity: self.getIntencityIdentifire(activityDict: dict).rawValue, activCalories: self.getActiveEnergy(activityDict: dict)), forKey:RpaType.Stablize.rawValue)
        RPADict.setValue(RPA.getMoblize(activityTime: minute, activity: acitivityType, intesity: self.getIntencityIdentifire(activityDict: dict).rawValue, activCalories: self.getActiveEnergy(activityDict: dict)), forKey: RpaType.Moblize.rawValue)
        RPADict.setValue(RPA.getEnergize(activityTime: minute, activity: acitivityType, intesity: self.getIntencityIdentifire(activityDict: dict).rawValue, activCalories: self.getActiveEnergy(activityDict: dict)), forKey: RpaType.Energize.rawValue)
        
        return RPADict
    }
    
    class func getAgeSexAndBloodType() throws -> (age: Date,
        biologicalSex: HKBiologicalSex,
        bloodType: HKBloodType) {
            
            let healthKitStore = HKHealthStore()
            
            do {
                
                //1. This method throws an error if these data are not available.
                let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
                let biologicalSex =       try healthKitStore.biologicalSex()
                let bloodType =           try healthKitStore.bloodType()
                
                //2. Use Calendar to calculate age.
//                let today = Date()
//                let calendar = Calendar.current
//                let todayDateComponents = calendar.dateComponents([.year],
//                                                                  from: today)
//                let thisYear = todayDateComponents.year!
//                let age = thisYear - birthdayComponents.year!
                
                //3. Unwrap the wrappers to get the underlying enum values.
                let unwrappedBiologicalSex = biologicalSex.biologicalSex
                let unwrappedBloodType = bloodType.bloodType
                let unwrappedDateOfBirth = birthdayComponents.date
                
                return (unwrappedDateOfBirth!, unwrappedBiologicalSex, unwrappedBloodType)
            }
    }

}

