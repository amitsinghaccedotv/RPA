//
//  MaintabBarController.swift
//  RPA
//
//  Created by Amit Singh on 16/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import GradientLoadingBar

class MaintabBarController: UITabBarController ,connectionDelegate{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Move to a background thread to do some long running work
//        DispatchQueue.global(qos: .userInitiated).async {
//            // Bounce back to the main thread to update the UI
//            DispatchQueue.main.async {
//                 self.getProfle()
//            }
//        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden=false
        self.navigationItem.hidesBackButton=true
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "nav_bar"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Get Profile Data
    func getProfle(){
        let loggedInUserData = UserDefaults.standard.value(forKey: "profileData") as! NSMutableDictionary
        let userInfo = loggedInUserData.value(forKey: "userInfo") as! Dictionary <String , Any>
        GradientLoadingBar.sharedInstance().show()
        Utils.addLoaderToController(controllerView:appDelegate.window!)
        let connectionClass = Connection()
        connectionClass.delegate=self
        let params = ["": ""]
        connectionClass.connectToGetProfile(userID: userInfo["userId"] as! Int , parameters: params, token:loggedInUserData["access_token"] as! String)
    }
    
    // MARK: Connection Delegates
    func finishedByGettingResponse(_ result: Any) {
        GradientLoadingBar.sharedInstance().hide()
        Utils.removeLoaderFromController(controllerView: appDelegate.window!)
        print(result)
        
    }
    func failedByGettingResponse(_ result: Any) {
        GradientLoadingBar.sharedInstance().hide()
        Utils.removeLoaderFromController(controllerView: appDelegate.window!)
        print(result)
    }
    
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
