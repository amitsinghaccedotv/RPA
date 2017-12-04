//
//  WorkoutData.swift
//  RPA
//
//  Created by Accedo Admin on 27/10/2017.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import HealthKit
import CareKit
import ResearchKit

class WorkoutData: NSObject,workoutDelegate {
    
    var delegate : workoutDelegate?
    var requestCount = NSInteger()
     func getWorkoutData(){
        
        if HKHealthStore.isHealthDataAvailable() {
            let healthManager = HealthManager()
            self.requestCount=0;
            healthManager.requestPermissions(completion: { (isPermited) in
                if (isPermited){
                    print("permited")
                    
                    
                    let runningCountOperation = Operation()
                    runningCountOperation.completionBlock = {
                        
                        if #available(iOS 11.0, *) {
                            self.getWorkoutActivity(workoutType: .running)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    let cyclingCountOperation = Operation()
                    cyclingCountOperation.completionBlock = {
                        
                        if #available(iOS 11.0, *) {
                            self.getWorkoutActivity(workoutType: .cycling)
                        } else {
                            // Fallback on earlier versions
                            
                        }
                    }
                    
                    let swimmingCountOperation = Operation()
                    swimmingCountOperation.completionBlock = {
                        if #available(iOS 11.0, *) {
                            
                            self.getWorkoutActivity(workoutType: .swimming)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    let hikingCountOperation = Operation()
                    hikingCountOperation.completionBlock = {
                        if #available(iOS 11.0, *) {
                            
                            self.getWorkoutActivity(workoutType: .hiking)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    let yogaCountOperation = Operation()
                    yogaCountOperation.completionBlock = {
                        if #available(iOS 11.0, *) {
                            
                            self.getWorkoutActivity(workoutType: .yoga)
                        } else {
                            // Fallback on earlier versions
                            
                        }
                    }
                    
                    let crossFitCountOperation = Operation()
                    crossFitCountOperation.completionBlock = {
                        if #available(iOS 11.0, *) {
                            
                            self.getWorkoutActivity(workoutType: .crossTraining)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    let pilatesCountOperation = Operation()
                    pilatesCountOperation.completionBlock = {
                        if #available(iOS 11.0, *) {
                            
                            self.getWorkoutActivity(workoutType: .pilates)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    let walkingCountOperation = Operation()
                    walkingCountOperation.completionBlock = {
                        if #available(iOS 11.0, *) {
                            self.getWorkoutActivity(workoutType: .walking)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    
                    
                    
                    OperationQueue.main.addOperation(runningCountOperation)
                    OperationQueue.main.addOperation(cyclingCountOperation)
                    OperationQueue.main.addOperation(swimmingCountOperation)
                    OperationQueue.main.addOperation(hikingCountOperation)
                    OperationQueue.main.addOperation(yogaCountOperation)
                    OperationQueue.main.addOperation(crossFitCountOperation)
                    OperationQueue.main.addOperation(pilatesCountOperation)
                    OperationQueue.main.addOperation(walkingCountOperation)
                    
                    cyclingCountOperation.addDependency(runningCountOperation)
                    swimmingCountOperation.addDependency(cyclingCountOperation)
                    hikingCountOperation.addDependency(swimmingCountOperation)
                    yogaCountOperation.addDependency(hikingCountOperation)
                    crossFitCountOperation.addDependency(yogaCountOperation)
                    pilatesCountOperation.addDependency(crossFitCountOperation)
                    walkingCountOperation.addDependency(pilatesCountOperation)
                    
                }
            })
            
        } else {
            print("There is a problem accessing HealthKit")
        }
    }
    
    // MARK: Get Workout activity
    @available(iOS 11.0, *)
    func getWorkoutActivity(workoutType:HKWorkoutActivityType)
    {
        let workoutArray = NSMutableArray()
        let healthManager = HealthManager()
        
        
        if #available(iOS 11.0, *) {
            healthManager.getWorkout(activity: workoutType) {
                (results, error, activity,activityArray) in
                if (error != nil){
                    print("Error while getting result",error!)
                }
                else{
                    self.requestCount = self.requestCount+1
                    self.delegate?.finishedByGettingWorkout!(activityArray, requestCount: self.requestCount)
                }
            }
        } else {
            // Fallback on earlier versions
            self.delegate?.failedByGettingWorkout!(workoutArray)
        }
    }
    
    func getProfileData(){
        let healthManager = HealthManager()
        let profileDict = NSMutableDictionary()
        healthManager.requestAuthorisationForHealthStoreForProfile(completion: { (isPermited) in
            if (isPermited){
                print("permited")
               
                do {
                    let userAgeSexAndBloodType = try HealthManager.getAgeSexAndBloodType()
                    profileDict.setValue(self.getBloodType(bloodType: userAgeSexAndBloodType.bloodType), forKey: "bloodType");
                    profileDict.setValue("\(userAgeSexAndBloodType.age)", forKey: "age");
                    profileDict.setValue(self.getSexforUser(bioLogicalSex: userAgeSexAndBloodType.biologicalSex), forKey: "gender");
                    print(profileDict);
                    self.delegate?.finishedByGettingHelathData!(_result: profileDict)
                    
                } catch let error {
                    print("error found",error)
                    self.delegate?.failedByGettingHelathData!()
                }
            }
            
        })
    }
    
    func getBloodType(bloodType : HKBloodType)-> String {
        var bldTypeString = String()
        switch bloodType {
        case .abNegative:
            bldTypeString = "AB-"
            break
        case .abPositive :
            bldTypeString = "AB+"
            break
        case .aNegative :
            bldTypeString = "A-"
            break
        case .aPositive :
            bldTypeString = "A+"
            break
        case .bNegative :
            bldTypeString = "B-"
            break
        case .bPositive :
            bldTypeString = "B+"
            break
        case .oNegative :
            bldTypeString = "O-"
            break
        case .oPositive :
            bldTypeString = "O+"
            break
        default:
             bldTypeString = "Not Set"
            break
        }
        return bldTypeString
    }
    
    func getSexforUser(bioLogicalSex : HKBiologicalSex)-> String {
        var sexTypeString = String()
        switch bioLogicalSex {
        case .female:
            sexTypeString = "Female"
            break
        case .male:
            sexTypeString = "Male"
            break
        case .notSet:
            sexTypeString = "Not Set"
            break
        default:
            sexTypeString = "Other"
            break
        }
        
        return sexTypeString
    }
}

@objc protocol workoutDelegate {
    @objc optional func finishedByGettingWorkout(_ result:NSMutableArray, requestCount:NSInteger)
    @objc optional func failedByGettingWorkout(_ result:NSMutableArray)
    @objc optional func finishedByGettingHelathData(_result:NSDictionary)
    @objc optional func failedByGettingHelathData()
}
