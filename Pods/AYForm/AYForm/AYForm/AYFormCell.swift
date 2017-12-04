//
//  AYFormCell.swift
//  AYForm
//
//  Created by Ayman Rawashdeh on 4/23/17.
//  Copyright © 2017 Ayman Rawashdeh. All rights reserved.
//

import Foundation

public class AYFormCell {
    
    var identifier: String
    var uniqueIdentifier: String?
    var section: Int
    var isHidden: Bool = false
    var outputs: [AYFormOutput]
    
    init(identifier: String, uniqueIdentifier: String!, section: Int, outputs: [AYFormOutput]! ) {
        
        self.identifier = identifier
        self.uniqueIdentifier = uniqueIdentifier
        self.section = section
        self.outputs = outputs ?? [AYFormOutput]()
    }
}
