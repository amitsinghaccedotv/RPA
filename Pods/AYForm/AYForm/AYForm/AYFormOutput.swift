//
//  AYFormOutput.swift
//  AYForm
//
//  Created by Ayman Rawashdeh on 4/23/17.
//  Copyright © 2017 Ayman Rawashdeh. All rights reserved.
//

import Foundation


public class AYFormOutput: NSObject {
    
    public var fieldOutput: String
    public var label: String
    
    init(fieldOutput: String, label: String) {
        
        self.fieldOutput = fieldOutput
        self.label = label
    }
    
    static func getOutputs(_ outputs: [(String, String)?]!) -> [AYFormOutput] {
        
        var array = [AYFormOutput]()
        
        if let outputs = outputs {
            
            for output in outputs {
                
                if let output = output {
                    
                    array.append(AYFormOutput(fieldOutput: output.0, label: output.1))
                }
            }
        }
        
        return array
    }
}
