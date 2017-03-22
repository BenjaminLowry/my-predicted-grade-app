//
//  SubjectSnapshot.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 2/24/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

class SubjectSnapshot: Snapshot {
    
    var subject: Subject
    
    init(grade: Int, subject: Subject) {
        
        self.subject = subject
        
        super.init(grade: grade)
        
    }
    
}
