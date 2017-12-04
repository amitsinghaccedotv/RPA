//
//  WorkoutModel.swift
//  RPA
//
//  Created by Accedo Admin on 29/10/2017.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit

class WorkoutModel: NSObject {
    
    //MARK: Shared Instance
    static let sharedInstance : WorkoutModel = {
        let instance = WorkoutModel()
        return instance
    }()
    
    func preparePlistForUse(){
        let fileManager = FileManager.default
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = documentDirectory.appending("/workoutData.plist")
        
        if(!fileManager.fileExists(atPath: path)){
            print(path)
            
//            let data : [String: String] = [
//                "Company": "My Company",
//                "FullName": "My Full Name",
//                "FirstName": "My First Name",
//                "LastName": "My Last Name",
//                // any other key values
//            ]
//
//            let someData = NSDictionary(dictionary: data)
//            let isWritten = someData.write(toFile: path, atomically: true)
//            print("is the file created: \(isWritten)")
            
            let plistContent = NSDictionary()
                let success:Bool = plistContent.write(toFile: path, atomically: true)
                if success {
                    print("file has been created!")
                }else{
                    print("unable to create the file")
                }

            
            
            
        } else {
            print("file exists")
        }
    }
    
    func saveWorkout(){
        
    }
}
