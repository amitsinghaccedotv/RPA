//
//  ExpandedCell.swift
//  RPA
//
//  Created by Amit Singh on 18/09/17.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit

class ExpandedCell: UITableViewCell {

    @IBOutlet weak var ActivityName :   UILabel!
    @IBOutlet weak var ArrowImage   :   UIImageView!
    @IBOutlet weak var dateLabel    :   UILabel!
    @IBOutlet weak var monthLabel   :   UILabel!
    @IBOutlet weak var minuteLabel  :   UILabel!
    @IBOutlet weak var barView      :   UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
