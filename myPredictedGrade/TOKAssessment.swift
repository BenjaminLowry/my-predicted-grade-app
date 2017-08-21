//
//  TOKAssessment.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 8/16/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

class TOKAssessment: Assessment {
    
    var assessmentType: AssessmentType
    
    enum AssessmentType: String {
        case Essay = "Essay"
        case Presentation = "Presentation"
    }
    
    init(assessmentTitle: String, subjectObject: SubjectObject, date: Date, marksAvailable: Int, marksReceived: Int, assessmentType: AssessmentType) {
        
        self.assessmentType = assessmentType
        
        super.init(assessmentTitle: assessmentTitle, subjectObject: subjectObject, date: date, marksAvailable: marksAvailable, marksReceived: marksReceived)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        let assessmentTypeString = aDecoder.decodeObject(forKey: "AssessmentTypeString") as! String
        
        if assessmentTypeString == "Essay" {
            assessmentType = .Essay
        } else {
            assessmentType = .Presentation
        }
        
        super.init(coder: aDecoder)
        
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(assessmentType.rawValue, forKey: "AssessmentTypeString")
    }
    
}
