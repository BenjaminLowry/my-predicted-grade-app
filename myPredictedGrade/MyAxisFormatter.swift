//
//  MyAxisFormatter.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 2/22/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation
import Charts

class MyAxisFormatter: NSObject, IAxisValueFormatter {
    
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
    
}
