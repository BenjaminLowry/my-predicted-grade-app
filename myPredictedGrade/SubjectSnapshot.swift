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
    
    init(grade: Int, subjectObject: SubjectObject) {
        
        self.subjectObject = subjectObject
        
        super.init(grade: grade)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        subjectObject = aDecoder.decodeObject(forKey: "Subject Object") as! SubjectObject
        
        super.init(coder: aDecoder)
        
    }
    
    override func encode(with aCoder: NSCoder) {
        
        aCoder.encode(subjectObject, forKey: "Subject Object")
        
        super.encode(with: aCoder)
    }
    
}
