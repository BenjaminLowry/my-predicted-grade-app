//
//  MyTOKEEValueFormatter.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 9/7/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation
import Charts

class MyTOKEEValueFormatter: NSObject, IValueFormatter {
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let numFormatter = CustomNumberFormatter()
        return numFormatter.string(from: NSNumber(integerLiteral: Int(value)))!
    }
    
}
