//
//  RpaCalculations.swift
//  RPA
//
//  Created by Amit Singh on 30/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
enum ActivityIdentifier: String {
    case HealthOut_Mobilize  =  "HealthOut Mobilize"
    case HealthOut_Stabilize =  "HealthOut Stabilize"
    case HealthOut_Energize  =  "HealthOut Energize"
    case Strength_Training   =  "Strength Training"
    case Walking             =  "Walking"
    case Cycling             =  "Cycling"
    case Running             =  "Running"
    case Swimming            =  "Swimming"
    case Hiking              =  "Hiking"
    case Yoga                =  "Yoga"
    case Pilates             =  "Pilates"
    case Crossfit            =  "Crossfit"
    case Other               =  "Other"
    case AllWorkout          =  "AllWorkout"
    
    static let allValues = [Walking, Cycling,Running,Swimming,Hiking,Yoga,Pilates,Crossfit]
   
    var index : Int {
        return ActivityIdentifier.allValues.index(of: self)!
    }

}

enum IntensityIdentifire : String {
    case Mild       =  "Mild(4-5/10, Deep breathing, but I can still talk)"
    case Moderate   =  "Moderate(6-7/10,I can talk, but its difficult)"
    case Intense    =  "Mild(8-10/10, I can't talk, I am working out!)"
    
    static let allValues = [Mild, Moderate, Intense]
    
    var index : Int {
        return IntensityIdentifire.allValues.index(of: self)!
    }
}

enum RpaType : String {
    case Moblize
    case Stablize
    case Energize
}

class RPA : NSObject {
    
    static func getMoblize (activityTime : Double,activity: String, intesity : String , activCalories : NSInteger)->Double{
        
        let wrkout = workout.init(workouType: activity)
        let moblizeValue  = wrkout.getMobileze(intencity: intesity, totalCalories: activCalories)
        let moblzValue = moblizeValue * activityTime
        return moblzValue/60
    }
    static func getStablize (activityTime : Double,activity: String, intesity : String , activCalories : NSInteger)->Double{

        let wrkout = workout.init(workouType: activity)
        let stablizeValue  = wrkout.getStablize(intencity: intesity, totalCalories: activCalories)
        let stblize = stablizeValue * activityTime
        return stblize/60
    }
    static func getEnergize (activityTime : Double,activity: String, intesity : String, activCalories : NSInteger)->Double{

        let wrkout = workout.init(workouType: activity)
        let energzeValue  = wrkout.getEnergize(intencity: intesity, totalCalories: activCalories)
        if activCalories == 0 {
            let energize = energzeValue * activityTime
            return energize/35
        }
        return  energzeValue
    }
    
    static func getActivityName(activity: HKWorkoutActivityType) -> String{
        
        var activityResult = String()
        switch activity {
        case .running:
            activityResult =  ActivityIdentifier.Running.rawValue
            break
        case .walking:
            activityResult =  ActivityIdentifier.Walking.rawValue
            break
        case .cycling:
            activityResult = ActivityIdentifier.Cycling.rawValue
            break
        case .hiking:
            activityResult = ActivityIdentifier.Hiking.rawValue
            break
        case .swimming:
            activityResult = ActivityIdentifier.Swimming.rawValue
            break
        case .crossTraining:
            activityResult = ActivityIdentifier.Crossfit.rawValue
            break
        case .yoga:
            activityResult = ActivityIdentifier.Yoga.rawValue
            break
        case .pilates:
            activityResult = ActivityIdentifier.Pilates.rawValue
            break
            
        default:
            break
        }
        return activityResult
    }
    
}


struct workout {
    var workouType = String()
    
    func getMobileze(intencity : String , totalCalories : NSInteger) -> Double {
        
        return Double(getRPAforActivity(activity: workouType, rpaType: RpaType.Moblize.rawValue, workoutIntencity: intencity, activeEnergy: Float(totalCalories)))
    }
    func getStablize(intencity : String ,totalCalories : NSInteger) -> Double {
        return Double(getRPAforActivity(activity: workouType, rpaType: RpaType.Stablize.rawValue, workoutIntencity: intencity, activeEnergy: Float(totalCalories)))
    }
    func getEnergize(intencity : String , totalCalories : NSInteger) -> Double {
        return Double(getRPAforActivity(activity: workouType, rpaType: RpaType.Energize.rawValue, workoutIntencity: intencity, activeEnergy: Float(totalCalories)))
    }
    
    func getRPAforallWorkoutActivity(rpaType:String , duration:TimeInterval)-> Float{
        var rpaResult = Float()
        switch (rpaType){
            case RpaType.Moblize.rawValue:
                
                break
            case RpaType.Stablize.rawValue:
                break
            case RpaType.Energize.rawValue:
                break
            default:
                break
        }
        return rpaResult
    }
    func getRPAforActivity(activity:String , rpaType:String ,workoutIntencity : String , activeEnergy : Float) -> Float{
        var rpaResult = Float()
        switch activity {
        case ActivityIdentifier.Running.rawValue:
                switch (rpaType){
                    case RpaType.Moblize.rawValue:
                            rpaResult = 0;
                        break
                    case RpaType.Stablize.rawValue:
                            rpaResult = 0.1;
                        break
                    case RpaType.Energize.rawValue:
                        
                        if(activeEnergy == 0){
                            if(workoutIntencity == IntensityIdentifire.Mild.rawValue){
                                rpaResult=0.05;
                            }
                            else if (workoutIntencity == IntensityIdentifire.Moderate.rawValue){
                                rpaResult = 0.075;
                            }
                            else{
                                rpaResult = 0.1;
                            }
                        }
                        else{
                            
                            rpaResult = (activeEnergy/150.0)/35.0
                        }
                        
                        
                        break
                    default:
                        break
                }
            break
        case ActivityIdentifier.Walking.rawValue:
                switch (rpaType){
                case RpaType.Moblize.rawValue:
                        rpaResult=0
                    break
                case RpaType.Stablize.rawValue:
                        rpaResult=0.1
                    break
                case RpaType.Energize.rawValue:
                    if(activeEnergy == 0){
                        if(workoutIntencity == IntensityIdentifire.Mild.rawValue){
                            rpaResult=0.05;
                        }
                        else if (workoutIntencity == IntensityIdentifire.Moderate.rawValue){
                            rpaResult = 0.075;
                        }
                        else{
                            rpaResult = 0.1;
                        }
                    }
                    else{
                        rpaResult = (activeEnergy/150)/35
                    }

                    
                    break
                default:
                    break
                }
            break
        case ActivityIdentifier.Swimming.rawValue:
                switch (rpaType){
                case RpaType.Moblize.rawValue:
                        rpaResult=0.25
                    break
                case RpaType.Stablize.rawValue:
                        rpaResult=0.5
                    break
                case RpaType.Energize.rawValue:
                    if(activeEnergy == 0){
                        if(workoutIntencity == IntensityIdentifire.Mild.rawValue){
                            rpaResult=0.05;
                        }
                        else if (workoutIntencity == IntensityIdentifire.Moderate.rawValue){
                            rpaResult = 0.075;
                        }
                        else{
                            rpaResult = 0.1;
                        }
                    }
                    else{
                        rpaResult = (activeEnergy/150)/35
                    }

                    break
                default:
                    break
                }
            break
        case ActivityIdentifier.Hiking.rawValue:
                switch (rpaType){
                case RpaType.Moblize.rawValue:
                        rpaResult=0
                    break
                case RpaType.Stablize.rawValue:
                        rpaResult=0.1
                    break
                case RpaType.Energize.rawValue:
                    if(activeEnergy == 0){
                        if(workoutIntencity == IntensityIdentifire.Mild.rawValue){
                            rpaResult=0.05;
                        }
                        else if (workoutIntencity == IntensityIdentifire.Moderate.rawValue){
                            rpaResult = 0.075;
                        }
                        else{
                            rpaResult = 0.1;
                        }
                    }
                    else{
                        rpaResult = (activeEnergy/150)/35
                    }

                    break
                default:
                    break
                }
            break
        case ActivityIdentifier.Crossfit.rawValue:
                switch (rpaType){
                case RpaType.Moblize.rawValue:
                        rpaResult=0.33
                    break
                case RpaType.Stablize.rawValue:
                        rpaResult=0.15
                    break
                case RpaType.Energize.rawValue:
                    if(activeEnergy == 0){
                        if(workoutIntencity == IntensityIdentifire.Mild.rawValue){
                            rpaResult=0.05;
                        }
                        else if (workoutIntencity == IntensityIdentifire.Moderate.rawValue){
                            rpaResult = 0.075;
                        }
                        else{
                            rpaResult = 0.1;
                        }
                    }
                    else{
                        rpaResult = (activeEnergy/150)/35
                    }

                    break
                default:
                    break
                }
            break
        case ActivityIdentifier.Strength_Training.rawValue:
                switch (rpaType){
                case RpaType.Moblize.rawValue:
                        rpaResult=0.15
                    break
                case RpaType.Stablize.rawValue:
                        rpaResult=0.5
                    break
                case RpaType.Energize.rawValue:
                    if(activeEnergy == 0){
                        if(workoutIntencity == IntensityIdentifire.Mild.rawValue){
                            rpaResult=0.05;
                        }
                        else if (workoutIntencity == IntensityIdentifire.Moderate.rawValue){
                            rpaResult = 0.075;
                        }
                        else{
                            rpaResult = 0.1;
                        }
                    }
                    else{
                        rpaResult = (activeEnergy/150)/35
                    }

                    break
                default:
                    break
                }
            break
        case ActivityIdentifier.Yoga.rawValue:
                switch (rpaType){
                case RpaType.Moblize.rawValue:
                        rpaResult=0.75
                    break
                case RpaType.Stablize.rawValue:
                        rpaResult=0.25
                    break
                case RpaType.Energize.rawValue:
                    if(activeEnergy == 0){
                        if(workoutIntencity == IntensityIdentifire.Mild.rawValue){
                            rpaResult=0.05;
                        }
                        else if (workoutIntencity == IntensityIdentifire.Moderate.rawValue){
                            rpaResult = 0.075;
                        }
                        else{
                            rpaResult = 0.1;
                        }
                    }
                    else{
                        rpaResult = (activeEnergy/150)/35
                    }

                    break
                default:
                    break
                }
            break
        case ActivityIdentifier.Pilates.rawValue:
                switch (rpaType){
                case RpaType.Moblize.rawValue:
                        rpaResult=0.5
                    break
                case RpaType.Stablize.rawValue:
                        rpaResult=0.5
                    break
                case RpaType.Energize.rawValue:
                    if(activeEnergy == 0){
                        if(workoutIntencity == IntensityIdentifire.Mild.rawValue){
                            rpaResult=0.05;
                        }
                        else if (workoutIntencity == IntensityIdentifire.Moderate.rawValue){
                            rpaResult = 0.075;
                        }
                        else{
                            rpaResult = 0.1;
                        }
                    }
                    else{
                        rpaResult = (activeEnergy/150)/35
                    }

                    break
                default:
                    break
                }
            break
        case ActivityIdentifier.Cycling.rawValue:
                switch (rpaType){
                case RpaType.Moblize.rawValue:
                        rpaResult=0.0
                    break
                case RpaType.Stablize.rawValue:
                        rpaResult=0.1
                    break
                case RpaType.Energize.rawValue:
                    if(activeEnergy == 0){
                        if(workoutIntencity == IntensityIdentifire.Mild.rawValue){
                            rpaResult=0.05;
                        }
                        else if (workoutIntencity == IntensityIdentifire.Moderate.rawValue){
                            rpaResult = 0.075;
                        }
                        else{
                            rpaResult = 0.1;
                        }
                    }
                    else{
                        rpaResult = (activeEnergy/150)/35
                    }
                    break
                default:
                    break
                }
            break
        default:
            break
        }
        return rpaResult
    }
    
}
extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


