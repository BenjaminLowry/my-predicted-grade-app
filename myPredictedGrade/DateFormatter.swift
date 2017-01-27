//
//  DateFormatter.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 1/19/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    func date(fromSpecific inputString: String) -> Date {
        let stringsToDelete = ["th", "st", "nd", "rd"]
        var dateString = inputString
        for string in stringsToDelete {
            dateString = dateString.replacingOccurrences(of: string, with: "")
        }
        
        self.dateFormat = "EEE, d MMM yyyy"
        
        let date = self.date(from: dateString)
        return date!
        
    }
    
    func string(fromSpecific inputDate: Date) -> String {
        self.dateFormat = "EEE, d MMM yyyy"
        var dateString = self.string(from: inputDate)
        
        if dateString.characters.count == 16 {
            dateString = dateString.insert(string: inputDate.daySuffix(), ind: 7)
        } else if dateString.characters.count == 15 {
            dateString = dateString.insert(string: inputDate.daySuffix(), ind: 6)
        }
        
        return dateString
    }
}
