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
    var subjectObject: SubjectObject
    var date: Date
    
    var marksAvailable: Int
    var marksReceived: Int
    
    var percentageMarksObtained: Double
    
    fileprivate var overallGrade: Int = 0
  
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
        
        overallGrade = aDecoder.decodeInteger(forKey: "OverallGrade")
        
    }
    
    func getOverallGrade() -> Int {
        
        if self.subjectObject.subject == .TheoryOfKnowledge {
            
            switch marksReceived {
            case let x where x >= 8:
                self.overallGrade = 5 // A
            case let x where x >= 6:
                self.overallGrade = 4 // B
            case let x where x >= 4:
                self.overallGrade = 3 // C
            case let x where x >= 2:
                self.overallGrade = 5 // D
            default:
                self.overallGrade = 1 // E
            }
            
            return self.overallGrade
        } else if self.subjectObject.subject == .ExtendedEssay {
            
            switch marksReceived {
            case let x where x >= 29:
                self.overallGrade = 5 // A
            case let x where x >= 23:
                self.overallGrade = 4 // B
            case let x where x >= 16:
                self.overallGrade = 3 // C
            case let x where x >= 8:
                self.overallGrade = 2 // D
            default:
                self.overallGrade = 1 // E
            }
            
            return self.overallGrade
        }
        
        percentageMarksObtained = Double(marksReceived) / Double(marksAvailable) * 100
        
        let percent: Int = lround(self.percentageMarksObtained)
        
        typealias JSONDictionary = [String: Any]
        
        if let url = Bundle.main.url(forResource: "gradeBoundaries", withExtension: "json") { //find the url of the JSON
            do {
                
                let jsonData = try Data(contentsOf: url) //get the data for the JSON
                
                if let jsonResult: JSONDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? JSONDictionary { //the whole JSON
                    
                    let subjects: [JSONDictionary] = jsonResult["Subjects"] as! [JSONDictionary] //list of subjects (which are dictionaries)
                    
                    for subject in subjects { //iterate through the subjects
                        
                        let title: String = subject["Title"] as! String //get subject title
                        
                        if title == self.subjectObject.toString() { //see if the subject title matches the subject of the assessment
                            
                            let gradeBoundaries: JSONDictionary = subject["Boundaries"] as! JSONDictionary //get dictionary of grade boundaries
                            
                            for key in gradeBoundaries.keys { //iterate through the keys
                                var value: [Int] = gradeBoundaries[key] as! [Int] //get the value of the dictionary for the current key
                                if percent < value[1] + 1 && percent >= value[0] { //if the percentage from the assessment falls between the bounds
                                    self.overallGrade = Int(key)! //set the overall grade to the current key
                                }
                            }
                            
                            
                        }
                        
                    }
                    
                }
            } catch {
                
                // Can't do alert since this is not a view controller
                print(error)
                
            }
        }
        
        return self.overallGrade
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(assessmentTitle, forKey: "AssessmentTitle")
        aCoder.encode(subjectObject, forKey: "SubjectObject")
        aCoder.encode(date, forKey: "Date")
        
        aCoder.encode(marksAvailable, forKey: "MarksAvailable")
        aCoder.encode(marksReceived, forKey: "MarksReceived")
    }
    
}
