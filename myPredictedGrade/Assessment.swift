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
    var subject: Subject
    var date: Date
    
    var marksAvailable: Int
    var marksReceived: Int
    
    var overallGrade: Int = 0
    
    var criteriaA: Int?
    var criteriaB: Int?
    var criteriaC: Int?
    var criteriaD: Int?
    
    init (assessmentTitle: String, subject: Subject, date: Date, marksAvailable: Int, marksReceived: Int){
        self.assessmentTitle = assessmentTitle
        self.subject = subject
        self.date = date
        
        self.marksAvailable = marksAvailable
        self.marksReceived = marksReceived
    }
    
    //DEVELOPMENT: need more of these for every combinations of criterias assessed?
    init (assessmentTitle: String, subject: Subject, date: Date, marksAvailable: Int, marksReceived: Int, criteriaA: Int, criteriaB: Int, criteriaC: Int, criteriaD: Int){
        self.assessmentTitle = assessmentTitle
        self.subject = subject
        self.date = date
        
        self.marksAvailable = marksAvailable
        self.marksReceived = marksReceived
        
        self.criteriaA = criteriaA
        self.criteriaB = criteriaB
        self.criteriaC = criteriaC
        self.criteriaD = criteriaD
    }
    
    required init?(coder aDecoder: NSCoder) {
        assessmentTitle = aDecoder.decodeObject(forKey: "AssessmentTitle") as! String
        subject = aDecoder.decodeObject(forKey: "Subject") as! Subject
        date = aDecoder.decodeObject(forKey: "Date") as! Date
        
        marksAvailable = aDecoder.decodeInteger(forKey: "MarksAvailable")
        marksReceived = aDecoder.decodeInteger(forKey: "MarksReceived")
        
        if let criteriaA = aDecoder.decodeInteger(forKey: "CriteriaA") as Int? {
            self.criteriaA = criteriaA
        }
        if let criteriaB = aDecoder.decodeInteger(forKey: "CriteriaB") as Int? {
            self.criteriaB = criteriaB
        }
        if let criteriaC = aDecoder.decodeInteger(forKey: "CriteriaC") as Int? {
            self.criteriaC = criteriaC
        }
        if let criteriaD = aDecoder.decodeInteger(forKey: "CriteriaD") as Int? {
            self.criteriaD = criteriaD
        }
        
        overallGrade = aDecoder.decodeInteger(forKey: "OverallGrade")
        
    }
    
    func calculateOverallGrade() -> Int {
        
        //THIS IS WHERE I WILL CORRESPOND THE DATE WITH THE BOUNDARIES
        
        return 5 //THIS IS IS A TEMPORARY MEASURE
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(assessmentTitle, forKey: "AssessmentTitle")
        aCoder.encode(subject, forKey: "Subject")
        aCoder.encode(date, forKey: "Date")
        
        aCoder.encode(marksAvailable, forKey: "MarksAvailable")
        aCoder.encode(marksReceived, forKey: "MarksReceived")
        
        aCoder.encode(criteriaA, forKey: "CriteriaA")
        aCoder.encode(criteriaB, forKey: "CriteriaB")
        aCoder.encode(criteriaB, forKey: "CriteriaC")
        aCoder.encode(criteriaB, forKey: "CriteriaD")
    }
    
}
