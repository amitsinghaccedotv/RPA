//
//  HeaderCell.swift
//  RPA
//
//  Created by Amit Singh on 18/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var ActivityName :   UILabel!
    @IBOutlet weak var ArrowImage   :   UIImageView!
    @IBOutlet weak var dateLabel    :   UILabel!
    @IBOutlet weak var monthLabel   :   UILabel!
    @IBOutlet weak var minuteLabel  :   UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
