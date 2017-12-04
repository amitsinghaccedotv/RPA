//
//  CustomPopOver.swift
//  RPA
//
//  Created by Amit Singh on 02/10/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit

class CustomPopOver: UIView ,UITableViewDataSource,UITableViewDelegate{
    
    var custompopoverDelegate : CustomPopOverDelegate?
    
    var contentTable  = UITableView()
    var contentList = NSMutableArray()
    var isActivity = Bool()
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    func createContentList(activity:Bool){
        
        if(contentList.count > 0){
            contentList.removeAllObjects()
        }
        
        if activity {
            for  activityName  in ActivityIdentifier.allValues {
                contentList.add(activityName.rawValue)
            }
        }
        else{
            for  activityName  in IntensityIdentifire.allValues {
                contentList.add(activityName.rawValue)
            }
        }
        
        contentTable.removeFromSuperview()
        contentTable = UITableView.init(frame:CGRect(x:0,y:0,width:frame.size.width,height:frame.size.height))
        contentTable.delegate=self
        contentTable.dataSource=self
        self.addSubview(contentTable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: TableView Delegates and Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifire = "Cell"
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdentifire)
        
        cell.textLabel?.text=contentList[indexPath.row] as? String
        cell.textLabel?.numberOfLines=0
        cell.textLabel?.font.withSize(7.0)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor=UIColor.selectedCellColor()
        cell?.textLabel?.textColor = UIColor.white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.custompopoverDelegate?.selelctedActivity(activityName: self.contentList[indexPath.row] as! String)
        }

    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.textLabel?.textColor = UIColor.black
        
    }
}
protocol CustomPopOverDelegate {
    func selelctedActivity(activityName:String)

}

