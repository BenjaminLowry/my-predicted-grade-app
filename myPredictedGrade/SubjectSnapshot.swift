//
//  SubjectSnapshot.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 2/24/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

class SubjectSnapshot: Snapshot {
    
    var subjectObject: SubjectObject
    var averagePercentageMarks: Int
    
    init(grade: Int, subjectObject: SubjectObject, averagePercentageMarks: Int) {
        
        self.subjectObject = subjectObject
        self.averagePercentageMarks = averagePercentageMarks
        
        super.init(grade: grade)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        subjectObject = aDecoder.decodeObject(forKey: "Subject Object") as! SubjectObject
        averagePercentageMarks = aDecoder.decodeInteger(forKey: "Average Percentage")
        
        super.init(coder: aDecoder)
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
        aCoder.encode(subjectObject, forKey: "Subject Object")
        aCoder.encode(averagePercentageMarks, forKey: "Average Percentage")
        
        super.encode(with: aCoder)
    }
    
}
