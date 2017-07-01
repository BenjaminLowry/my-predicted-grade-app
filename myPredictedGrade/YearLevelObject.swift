//
//  YearLevel.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 4/29/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

class YearLevelObject: NSObject, NSCoding {
    
    var yearLevel: YearLevel
    
    enum YearLevel: String {
        case year12 = "Year 12"
        case year13 = "Year 13"
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        let stringValue = aDecoder.decodeObject(forKey: "Year Level") as! String
        if stringValue == "Year 12" {
            self.yearLevel = .year12
        } else {
            self.yearLevel = .year13
        }
        
    }
    
    init(yearLevel: YearLevel) {
        
        self.yearLevel = yearLevel
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(yearLevel.rawValue, forKey: "Year Level")
        
    }
    
}

    
