//
//  HomController.swift
//  RPA
//
//  Created by Amit Singh on 09/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit

class HomController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Logout(_ sender: Any) {
       
        UserDefaults.standard.set(false, forKey: "login")
        Utils.movietoLoginScreen()
    }
    
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        let segue = CustomUnwindSegue(identifier: identifier, source: fromViewController, destination: toViewController)
        segue.animationType = .push
        return segue
    }


}
