//
//  FieldTableViewCell.swift
//  AYForm
//
//  Created by Ayman Rawashdeh on 4/6/17.
//  Copyright © 2017 Ayman Rawashdeh. All rights reserved.
//

import UIKit

class FieldTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
