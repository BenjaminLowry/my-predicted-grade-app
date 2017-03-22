//
//  MyValueFormatter.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 2/22/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation
import Charts

class MyValueFormatter: NSObject, IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(Int(round(value)))
    }
    
}
