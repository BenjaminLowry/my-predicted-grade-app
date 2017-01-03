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
    var subject: (Subject, Bool)
    var date: Date
    
    var marksAvailable: Int
    var marksReceived: Int
    
    var percentageMarksObtained: Double
    
    var overallGrade: Int = 0
    
    var criteriaA: Int?
    var criteriaB: Int?
    var criteriaC: Int?
    var criteriaD: Int?
    
    init (assessmentTitle: String, subject: Subject, subjectIsHL: Bool, date: Date, marksAvailable: Int, marksReceived: Int){
        self.assessmentTitle = assessmentTitle
        self.subject = (subject, subjectIsHL)
        self.date = date
        
        self.marksAvailable = marksAvailable
        self.marksReceived = marksReceived
        
        percentageMarksObtained = Double(marksReceived) / Double(marksAvailable) * 100
    }
    
    //DEVELOPMENT: need more of these for every combinations of criterias assessed?
    init (assessmentTitle: String, subject: Subject, subjectIsHL: Bool, date: Date, marksAvailable: Int, marksReceived: Int, criteriaA: Int, criteriaB: Int, criteriaC: Int, criteriaD: Int){
        self.assessmentTitle = assessmentTitle
        self.subject = (subject, subjectIsHL)
        self.date = date
        
        self.marksAvailable = marksAvailable
        self.marksReceived = marksReceived
        
        percentageMarksObtained = Double(marksReceived) / Double(marksAvailable) * 100
        
        self.criteriaA = criteriaA
        self.criteriaB = criteriaB
        self.criteriaC = criteriaC
        self.criteriaD = criteriaD
    }
    
    required init?(coder aDecoder: NSCoder) {
        assessmentTitle = aDecoder.decodeObject(forKey: "AssessmentTitle") as! String
        subject = aDecoder.decodeObject(forKey: "Subject") as! (Subject, Bool)
        date = aDecoder.decodeObject(forKey: "Date") as! Date
        
        marksAvailable = aDecoder.decodeInteger(forKey: "MarksAvailable")
        marksReceived = aDecoder.decodeInteger(forKey: "MarksReceived")
        
        percentageMarksObtained = Double(marksReceived) / Double(marksAvailable) * 100
        
        overallGrade = aDecoder.decodeInteger(forKey: "OverallGrade")
        
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
        
    }
    
    func calculateOverallGrade() {
        
        let percent: Int = lround(self.percentageMarksObtained)
        
        var hlString = ""
        if subject.1 == true {
            hlString = " HL"
        } else {
            hlString = " SL"
        }
        
        typealias JSONDictionary = [String: Any]
        
        if let url = Bundle.main.url(forResource: "gradeBoundaries", withExtension: "json") { //find the url of the JSON
            do {
                
                let jsonData = try Data(contentsOf: url) //get the data for the JSON
                
                if let jsonResult: JSONDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? JSONDictionary { //the whole JSON
                    
                    let subjects: [JSONDictionary] = jsonResult["Subjects"] as! [JSONDictionary] //list of subjects (which are dictionaries)
                    
                    for subject in subjects { //iterate through the subjects
                        
                        let title: String = subject["Title"] as! String //get subject title
                        
                        if title == self.subject.0.rawValue + hlString { //see if the subject title matches the subject of the assessment
                            
                            let gradeBoundaries: JSONDictionary = subject["Boundaries"] as! JSONDictionary //get dictionary of grade boundaries
                            
                            for key in gradeBoundaries.keys { //iterate through the keys
                                var value: [Int] = gradeBoundaries[key] as! [Int] //get the value of the dictionary for the current key
                                if percent <= value[1] && percent >= value[0] { //if the percentage from the assessment falls between the bounds
                                    overallGrade = Int(key)! //set the overall grade to the current key
                                }
                            }
                            
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
                }
            } catch {
                print(error)
            }
        }
        
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
