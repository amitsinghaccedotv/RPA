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
    case HealthOut_Mobilize     =  "HealthOut Mobilize"
    case HealthOut_Stabilize    =  "HealthOut Stabilize"
    case HealthOut_Energize     =  "HealthOut Energize"
    case Strength_Training      =  "Strength Training"
    case Walking                =  "Walking"
    case Cycling                =  "Cycling"
    case Running                =  "Running"
    case Swimming               =  "Swimming"
    case Hiking                 =  "Hiking"
    case Yoga                   =  "Yoga"
    case Pilates                =  "Pilates"
    case Crossfit               =  "Crossfit"
    case American_Football      =  "American Football"
    case Australian_Football    =  "Australian Football"
    case Badminton              = "Badminton"
    case Cricket                = "Cricket"
    case Curling                = "Curling"
    case Elliptical             = "Elliptical"
    case Equestrian_Sports      = "Equestrian Sports"
    case Fencing                = "Fencing"
    case Golf                   = "Golf"
    case Gymnastics             = "Gymnastics"
    case Hand_Cycling           = "Hand Cycling"
    case Handball               = "Handball"
    case Hunting                = "Hunting"
    case Lacrosse               = "Lacrosse"
    case MindandBody            = "Mind and Body"
    case MixedCardio            = "Mixed Cardio"
    case PaddleSports           = "Paddle Sports"
    case Racquetball            = "Racquetball"
    case Sailing                = "Sailing"
    case SnowSports             = "Snow Sports"
    case SkatingSport           = "Skating Sport"
    case AllWorkout             = "AllWorkout"
    case Softball               = "Softball"
    case Squash                 = "Squash"
    case StairStepper           = "Stair Stepper"
    case Stairs                 = "Stairs"
    case StepTraining           = "Step Training"
    case Tabletennis            = "Table tennis"
    case WaterPolo              = "Water Polo"
    case WaterSports            = "Water Sports"
    case MixedMetabolicCardioTraining = "Mixed Metabolic Cardio Training"
    case Barre                  = "Barre"
    case Baseball               = "Baseball"
    case Basketball             = "Basketball"
    case Boxing                 = "Boxing"
    case Climbing               = "Climbing"
    case CoreTraining           = "Core Training"
    case CrossCountrySkiing     = "Cross Country Skiing"
    case CrossTraining          = "Cross Training"
    case Dance                  = "Dance"
    case DownhillSkiing         = "DownhillSkiing"
    case Play                   = "Play"
    case PreparationandRecovery = "Preparation and Recovery"
    case Rowing                 = "Rowing"
    case Rugby                  = "Rugby"
    case RunningSnowSports      = "Running Snow Sports"
    case Snowboarding           = "Snowboarding"
    case Soccer                 = "Soccer"
    case SurfingSports          = "Surfing Sports"
    case SwimmingTaiChi         = "Swimming Tai Chi"
    case Tennis                 = "Tennis"
    case TrackandField          = "Track and Field"
    case TraditionalStrengthTraining = "Traditional Strength Training"
    case Volleyball             = "Volleyball"
    case Waterfitness           = "Water fitness"
    case Wheelchairrunpace      = "Wheelchair run pace"
    case Wrestling              = "Wrestling"
    
    
    static let allValues = [Walking, Cycling,Running,Swimming,Hiking,Yoga,Pilates,Crossfit,American_Football,Australian_Football,Badminton,Cricket,Curling,Elliptical,Equestrian_Sports,Fencing,Golf,Gymnastics,Hand_Cycling,Handball,Hunting,Lacrosse,MindandBody,MixedCardio,PaddleSports,Racquetball,Sailing,SnowSports,Softball,Squash,StairStepper,Stairs,StepTraining,Tabletennis,WaterPolo,WaterSports,MixedMetabolicCardioTraining,Barre,Baseball,Basketball,Boxing,Climbing,CoreTraining,CrossTraining,CrossCountrySkiing,Dance,DownhillSkiing,Play,PreparationandRecovery,Rowing,Rugby,RunningSnowSports,Snowboarding,Soccer,SurfingSports,SwimmingTaiChi,Tennis,TrackandField,TraditionalStrengthTraining,Volleyball,Volleyball,Waterfitness,Wheelchairrunpace,Wrestling]
   
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
        return moblzValue/8.5
    }
    static func getStablize (activityTime : Double,activity: String, intesity : String , activCalories : NSInteger)->Double{

        let wrkout = workout.init(workouType: activity)
        let stablizeValue  = wrkout.getStablize(intencity: intesity, totalCalories: activCalories)
        let stblize = stablizeValue * activityTime
        return stblize/8.5
    }
    static func getEnergize (activityTime : Double,activity: String, intesity : String, activCalories : NSInteger)->Double{

        let wrkout = workout.init(workouType: activity)
        let energzeValue  = wrkout.getEnergize(intencity: intesity, totalCalories: activCalories)
        if activCalories == 0 {
            let energize = energzeValue * activityTime
            return energize/5
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
        case .americanFootball:
             activityResult = ActivityIdentifier.American_Football.rawValue
            break
        case .australianFootball:
            activityResult = ActivityIdentifier.Australian_Football.rawValue
            break
        case .badminton:
            activityResult = ActivityIdentifier.Badminton.rawValue
            break
        case .cricket:
            activityResult =  ActivityIdentifier.Cricket.rawValue
            break
        case .curling:
            activityResult = ActivityIdentifier.Curling.rawValue
            break
        case .elliptical:
            activityResult = ActivityIdentifier.Elliptical.rawValue
            break
        case .equestrianSports :
            activityResult = ActivityIdentifier.Equestrian_Sports.rawValue
            break
        case .fencing :
            activityResult = ActivityIdentifier.Fencing.rawValue
            break
        case .golf :
            activityResult = ActivityIdentifier.Golf.rawValue
            break
        case .gymnastics :
            activityResult = ActivityIdentifier.Gymnastics.rawValue
            break
        case .handCycling :
            activityResult = ActivityIdentifier.Hand_Cycling.rawValue
            break
        case .handball :
            activityResult = ActivityIdentifier.Hand_Cycling.rawValue
            break
        case .hunting :
            activityResult = ActivityIdentifier.Hunting.rawValue
            break
        case .lacrosse :
            activityResult = ActivityIdentifier.Lacrosse.rawValue
            break
        case .mindAndBody :
            activityResult = ActivityIdentifier.MindandBody.rawValue
            break
        case .mixedCardio :
            activityResult = ActivityIdentifier.MixedCardio.rawValue
            break
        case .paddleSports :
            activityResult = ActivityIdentifier.PaddleSports.rawValue
            break
        case .racquetball :
            activityResult = ActivityIdentifier.Racquetball.rawValue
            break
        case .sailing :
            activityResult = ActivityIdentifier.Sailing.rawValue
            break
        case .skatingSports :
            activityResult = ActivityIdentifier.SkatingSport.rawValue
            break
        case .snowSports :
            activityResult = ActivityIdentifier.SnowSports.rawValue
            break
        case .softball :
            activityResult = ActivityIdentifier.Softball.rawValue
            break
        case .squash :
            activityResult = ActivityIdentifier.Squash.rawValue
            break
        case .stairClimbing :
            activityResult = ActivityIdentifier.StairStepper.rawValue
            break
        case .stairs :
            activityResult = ActivityIdentifier.Stairs.rawValue
            break
        case .stepTraining :
            activityResult = ActivityIdentifier.StepTraining.rawValue
            break
        case .tableTennis :
            activityResult = ActivityIdentifier.Tabletennis.rawValue
            break
        case .waterPolo :
            activityResult = ActivityIdentifier.WaterPolo.rawValue
            break
        case .waterSports :
            activityResult = ActivityIdentifier.WaterSports.rawValue
            break
        case .mixedMetabolicCardioTraining :
            activityResult = ActivityIdentifier.MixedMetabolicCardioTraining.rawValue
            break
        case .barre :
            activityResult = ActivityIdentifier.Barre.rawValue
            break
        case .baseball :
            activityResult = ActivityIdentifier.Baseball.rawValue
            break
        case .basketball :
            activityResult = ActivityIdentifier.Basketball.rawValue
            break
        case .boxing :
            activityResult = ActivityIdentifier.Boxing.rawValue
            break
        case .climbing :
            activityResult = ActivityIdentifier.Climbing.rawValue
            break
        case .coreTraining :
            activityResult = ActivityIdentifier.CoreTraining.rawValue
            break
        case .crossCountrySkiing :
            activityResult = ActivityIdentifier.WaterSports.rawValue
            break
        case .dance :
            activityResult = ActivityIdentifier.Dance.rawValue
            break
        case .downhillSkiing :
            activityResult = ActivityIdentifier.DownhillSkiing.rawValue
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
        let rpaResult = Float()
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
            
        case ActivityIdentifier.American_Football.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.03;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break

        case ActivityIdentifier.Australian_Football.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.03;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
        
        case ActivityIdentifier.Badminton.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.025;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Cricket.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.01;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
        
        case ActivityIdentifier.Curling.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.2
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.01;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Elliptical.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.025;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Equestrian_Sports.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.01;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Fencing.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.25
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.015;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Golf.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.01;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Gymnastics.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.33
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.33
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.015;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Hand_Cycling.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.025;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Handball.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.025;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Hunting.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.01;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
            
        case ActivityIdentifier.Lacrosse.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.015;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
            
        case ActivityIdentifier.MindandBody.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.2
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.2
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.01;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.MixedCardio.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.025;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.PaddleSports.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.02;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Racquetball.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.025;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
            
        case ActivityIdentifier.Sailing.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.015;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.SkatingSport.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.25
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.02;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.SnowSports.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.015;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Softball.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.05
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.05
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.02;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Squash.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.05;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.StairStepper.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.05;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Stairs.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.05;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.StepTraining.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.05;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Tabletennis.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.015;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
            
        case ActivityIdentifier.WaterPolo.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.5
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.05;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.WaterSports.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.015;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.MixedMetabolicCardioTraining.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.2
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.33
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.075;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Barre.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.2
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.33
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.075;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Baseball.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.05
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.05
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.025;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Basketball.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.05
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.20
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.05;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Boxing.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.15
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.075;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break

        case ActivityIdentifier.Climbing.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.25
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.50
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.025;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break

        case ActivityIdentifier.CoreTraining.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.25
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.75
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.075;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.CrossCountrySkiing.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.0
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.1
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.075;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break

        case ActivityIdentifier.CrossTraining.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.2
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.33
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.075;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.Dance.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.33
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.33
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.025;
                }
                else{
                    rpaResult = (activeEnergy/150)/35
                }
                break
            default:
                break
            }
            break
            
        case ActivityIdentifier.DownhillSkiing.rawValue:
            switch (rpaType){
            case RpaType.Moblize.rawValue:
                rpaResult=0.05
                break
            case RpaType.Stablize.rawValue:
                rpaResult=0.2
                break
            case RpaType.Energize.rawValue:
                if(activeEnergy == 0){
                    rpaResult = 0.01;
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


