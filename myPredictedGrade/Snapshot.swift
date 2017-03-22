//
//  Snapshot.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 2/24/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

class Snapshot {
    
    var date: Date
    var grade: Int
    
    init(grade: Int) {
        self.date = Date(timeIntervalSinceNow: 0)
        self.grade = grade
    }
    
}
