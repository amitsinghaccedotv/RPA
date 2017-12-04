//
//  ButtonTableViewCell.swift
//  AYForm
//
//  Created by Ayman Rawashdeh on 4/6/17.
//  Copyright © 2017 Ayman Rawashdeh. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
