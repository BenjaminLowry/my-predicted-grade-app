//
//  DateFormatter.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 1/15/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

extension Date {
    
    func daySuffix() -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: self)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
}
