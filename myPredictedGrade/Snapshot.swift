//
//  Snapshot.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 2/24/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

class Snapshot: NSObject, NSCoding {
    
    var date: Date
    var grade: Int
    
    init(grade: Int) {
        self.date = Date(timeIntervalSinceNow: 0)
        self.grade = grade
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        print(aDecoder.decodeObject(forKey: "Date"))
        date = aDecoder.decodeObject(forKey: "Date") as! Date
        
        grade = aDecoder.decodeInteger(forKey: "Grade")
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(date, forKey: "Date")
        
        aCoder.encode(grade, forKey: "Grade")
        
    }
    
}
