//
//  CustomGenderCell.swift
//  RPA
//
//  Created by Accedo Admin on 9/11/2017.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit

class CustomGenderCell: UITableViewCell {

    @IBOutlet weak var maleRadioButton   : UIButton!
    @IBOutlet weak var femaleRadioButton : UIButton!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
