//
//  WelcomeScreen.swift
//  RPA
//
//  Created by Amit Singh on 07/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit

class WelcomeScreen: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var startAppButton: UIButton!
    
    static let kWalk_Through = "walk_through"
    var walkthrough: WalkthroughController? {
        didSet {
            walkthrough?.welcomeDelegate = self
        }
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden=true
         pageControl.addTarget(self, action: #selector(WelcomeScreen.didChangePageControlValue), for: .valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let walkthroughpage = segue.destination as? WalkthroughController {
            self.walkthrough = walkthroughpage
        }
    }
    
    func didChangePageControlValue() {
        walkthrough?.scrollToViewController(index: pageControl.currentPage)
    }
    
    
    
    @IBAction func GetStarted(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: WelcomeScreen.kWalk_Through)
        self.performSegue(withIdentifier: "toLoginView", sender: self)
    }
    
}

extension WelcomeScreen: WalkthroughControllerDelegate {
    
    
    func welcomePageViewController(_ welcomeController: WalkthroughController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func welcomePageViewController(_ welcomeController: WalkthroughController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}
