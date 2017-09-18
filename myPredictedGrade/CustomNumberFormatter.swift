//
//  CustomNumberFormatter.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 9/7/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

class CustomNumberFormatter: NumberFormatter {
    
    override func string(from number: NSNumber) -> String? {
        
        switch number {
        case 1:
            return "E"
        case 2:
            return "D"
        case 3:
            return "C"
        case 4:
            return "B"
        case 5:
            return "A"
        default:
            return ""
        }
        
    }
    
}
