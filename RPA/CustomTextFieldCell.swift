//
//  CustomTextFieldCell.swift
//  RPA
//
//  Created by Accedo Admin on 9/11/2017.
//  Copyright © 2017 Amt. All rights reserved.
//

import UIKit
import TextFieldEffects

class CustomTextFieldCell: UITableViewCell ,UITextFieldDelegate{
    
    @IBOutlet weak var customTextField : HoshiTextField!
    @IBOutlet weak var customCellIcon  : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
       
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == self.tag {
            print("found row")
        }
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        // Update the model.
        
        return true
    }
    
}

