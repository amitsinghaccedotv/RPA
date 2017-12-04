//
//  Utils.swift
//  RPA
//
//  Created by Amit Singh on 08/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import Foundation
import TSMessages
import NVActivityIndicatorView
import SDWebImage

let matrixFacctorHeightInInches = 0.394

class Utils: NSObject {

    static func addLoaderToController(controllerView : UIView){
        let view = UIView()
        view.tag=1001
        view.frame=controllerView.frame;
        view.alpha = 0.7;
        view.backgroundColor=UIColor.black
        controllerView.addSubview(view)
        

//        let jeremyGif = UIImage.gifImageWithName("loading")
//        let imageView = UIImageView(image: jeremyGif)
//        imageView.frame = CGRect(x: view.center.x-50, y: view.center.y-45, width: 100, height: 90)
//        view.addSubview(imageView)
        
    }
    
    static func removeLoaderFromController(controllerView : UIView){
        for case let view in controllerView.subviews {
            if view.tag == 1001 {
                view.removeFromSuperview()
            }
        }
       

    
    }
    
    static func showAlerttoView(controller : UIViewController , message : String , messageType : TSMessageNotificationType){
        
        TSMessage.showNotification(in: controller, title: message, subtitle: "", type: messageType, duration: 1.5)
        
    }
    
    static func getDateFormatter()-> DateFormatter{
        let formatter = DateFormatter()
        formatter.timeZone=NSTimeZone.local
        formatter.dateFormat = "dd MMM yyyy HH:mm"
        return formatter
    }
    static func getDefaultDateFormatter()-> DateFormatter{
        let formatter = DateFormatter()
        formatter.timeZone=NSTimeZone.local
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
    
    static func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with:candidate)
    }
    
    static func removeNavigationItemButton(navController: UINavigationController){
        for  navItems in navController.navigationBar.items! {
            navItems.setRightBarButtonItems(nil, animated: false)
        }
    }
    static func getActiveBarColor()->UIColor{
        return UIColor.init(colorLiteralRed: 20.0/255.0, green: 133.0/255.0, blue: 246.0/255.0, alpha: 1)
    }
    
    static func getMinutesInIntegerFrom(startdate :NSDate , endDate :NSDate)->Double{
        
        var timeInterval = TimeInterval()
        timeInterval=endDate.timeIntervalSince(startdate as Date)
//        let minute = Double(timeInterval / 60)

        return timeInterval
    }
    static func movietoLoginScreen(){
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let loignviewController = mainStoryBoard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        navigationController.pushViewController(loignviewController, animated: false)
    }
    
    static func getMinutesfromDuration(duration : TimeInterval) -> Double {
        return duration/60
    }
    
   static func getCurrentDate(currentDate:NSDate)->Date{
        
        let df = self.getDateFormatter()
        let strDate = df.string(from: currentDate as Date)
        let endDate = df.date(from: strDate)!
        return endDate
    }
    
    
    static func calculateBMI(height:Double , weight : Double) -> Double{
        let heightInch = height * matrixFacctorHeightInInches
        let heightSquare = heightInch * heightInch
        let finalResult = weight / heightSquare
        let BMIResult = finalResult * 703
        return BMIResult
    }
    
    static func saveProfileImage(profileImg:UIImage,UserID:String) -> Bool{
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create a name for your image
        let fileURL = documentsDirectoryURL.appendingPathComponent("profile"+"\(UserID)"+".png")
        var fileSaved = false
            
            do {
                try UIImagePNGRepresentation(profileImg)!.write(to: fileURL)
                print("Image Added Successfully")
                fileSaved = true
            } catch {
                print(error)
                fileSaved = false
            }
        
        return fileSaved
    }
    static func getImagefile(fileName : String)-> UIImage{
        let imageName = "new_profile_icon"
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: imageURL.path) {
                return UIImage(contentsOfFile: imageURL.path)!
            }
            
        }
        return UIImage.init(named: imageName)!
    }
}
