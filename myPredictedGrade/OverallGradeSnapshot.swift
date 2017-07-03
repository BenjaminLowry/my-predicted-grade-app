//
//  OverallGradeSnapshot.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 4/29/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

class OverallGradeSnapshot: Snapshot {
    
    var percentile: Double
    
    override init (grade: Int) {
        
        self.percentile = 0.0
        
        super.init(grade: grade)
        
        percentile = getGradePercentile(grade: grade)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        percentile = aDecoder.decodeDouble(forKey: "Percentile")
        
        super.init(coder: aDecoder)
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
        aCoder.encode(percentile, forKey: "Percentile")
        
        super.encode(with: aCoder)
    }
    
    func getGradePercentile(grade: Int) -> Double {
        
        var percentile = 0.0
        
        typealias JSONObject = [String: Any]
        
        if let url = Bundle.main.url(forResource: "gradePercentiles", withExtension: "json") {
            
            do {
                
                let data = try Data(contentsOf: url)
                
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSONObject {
                    
                    if let percentilesDictionary = jsonObject["Percentiles"] as? JSONObject {
                        
                        if let value = percentilesDictionary[String(grade)] as? Double {
                            
                            percentile = value
                            
                        }
                        
                    }
                    
                }
                
            } catch {
                
                // Can't do alert since this is not a view controller
                print(error)
                
            }
            
        }
        
        return percentile
    }
    
}
