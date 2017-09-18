//
//  MyTOKAxisFormatter.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 9/7/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation
import Charts

class MyTOKEEAxisFormatter: NSObject, IAxisValueFormatter {
    
    let numFormatter: CustomNumberFormatter
    
    override init() {
        numFormatter = CustomNumberFormatter()
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return numFormatter.string(from: NSNumber(integerLiteral: Int(value)))!
    }
    
}
