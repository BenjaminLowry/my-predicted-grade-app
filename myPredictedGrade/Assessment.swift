//
//  Assessment.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/24/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation

class Assessment: NSObject, NSCoding {
    
    var assessmentTitle: String
    fileprivate var subjectObject: SubjectObject
    var date: Date
    
    var marksAvailable: Int
    var marksReceived: Int
    
    var percentageMarksObtained: Double
    
    init (assessmentTitle: String, subjectObject: SubjectObject, date: Date, marksAvailable: Int, marksReceived: Int){
        self.assessmentTitle = assessmentTitle
        self.subjectObject = subjectObject
        self.date = date
        
        self.marksAvailable = marksAvailable
        self.marksReceived = marksReceived
        
        percentageMarksObtained = Double(marksReceived) / Double(marksAvailable) * 100
    }
    
    required init?(coder aDecoder: NSCoder) {
        assessmentTitle = aDecoder.decodeObject(forKey: "AssessmentTitle") as! String
        subjectObject = aDecoder.decodeObject(forKey: "SubjectObject") as! SubjectObject
        date = aDecoder.decodeObject(forKey: "Date") as! Date
        
        marksAvailable = aDecoder.decodeInteger(forKey: "MarksAvailable")
        marksReceived = aDecoder.decodeInteger(forKey: "MarksReceived")
        
        percentageMarksObtained = Double(marksReceived) / Double(marksAvailable) * 100
        
    }
    
    func getOverallGrade() -> Int {
        
        return AppStatus.user.getGrade(forSubject: self.subjectObject, withPercentage: Int(self.percentageMarksObtained))
    
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(assessmentTitle, forKey: "AssessmentTitle")
        aCoder.encode(subjectObject, forKey: "SubjectObject")
        aCoder.encode(date, forKey: "Date")
        
        aCoder.encode(marksAvailable, forKey: "MarksAvailable")
        aCoder.encode(marksReceived, forKey: "MarksReceived")
    }
    
    func getSubjectObject() -> SubjectObject {
        updateSubject()
        return self.subjectObject
    }
    
    func setSubjectObject(subject: SubjectObject) {
        self.subjectObject = subject
        updateSubject()
    }
    
    func updateSubject() {
        
        for subject in AppStatus.user.subjects {
            
            if subject.toString() == self.subjectObject.toString() {
                self.subjectObject = subject
                return
            }
            
        }
        
    }
    
}
