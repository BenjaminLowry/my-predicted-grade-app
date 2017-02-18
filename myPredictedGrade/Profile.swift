//
//  Profile.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/31/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

class Profile: NSObject, NSCoding {
    
    var username: String
    var password: String
    
    var subjects: [(Subject, Bool)]
    var colorPreferences: [Subject: UIColor]
    
    var assessments: [Assessment]
    
    var yearLevel: YearLevel
    
    var subjectGradeSetting: SubjectGradeCalculation
    
    fileprivate var subjectGrades: [Subject: Int]
    
    fileprivate var overallGrade: Int
    
    fileprivate var averageGrade: Double
    
    fileprivate var bestSubject: (Subject, Bool)
    
    required init?(coder aDecoder: NSCoder) {
        username = aDecoder.decodeObject(forKey: "Username") as! String
        password = aDecoder.decodeObject(forKey: "Password") as! String
        
        subjects = aDecoder.decodeObject(forKey: "Subjects") as! [(Subject, Bool)]
        colorPreferences = aDecoder.decodeObject(forKey: "Color Preferences") as! [Subject: UIColor]
        
        assessments = aDecoder.decodeObject(forKey: "Assessments") as! [Assessment]
        
        yearLevel = aDecoder.decodeObject(forKey: "Year Level") as! YearLevel
        
        subjectGrades = aDecoder.decodeObject(forKey: "Subject Grades") as! [Subject: Int]
        
        overallGrade = aDecoder.decodeObject(forKey: "Overall Grade") as! Int
        
        averageGrade = aDecoder.decodeObject(forKey: "Average Grade") as! Double
        
        bestSubject = aDecoder.decodeObject(forKey: "Best Subject") as! (Subject, Bool)
        
        subjectGradeSetting = aDecoder.decodeObject(forKey: "Subject Grade Settings") as! SubjectGradeCalculation
    }
    
    init(username: String, password: String, yearLevel: YearLevel, subjects: [(Subject, Bool)], colorPreferences: [Subject: UIColor], assessments: [Assessment]) {
        
        self.username = username
        self.password = password
        
        self.subjects = subjects
        self.colorPreferences = colorPreferences
        
        self.assessments = assessments
        
        self.yearLevel = yearLevel
        
        self.subjectGrades = [Subject: Int]()
        
        self.overallGrade = 0
        
        self.averageGrade = 0
        
        //default
        self.bestSubject = (Subject.Biology, true)
        
        self.subjectGradeSetting = SubjectGradeCalculation.averageOfGrades
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "Username")
        aCoder.encode(password, forKey: "Password")
        
        aCoder.encode(subjects, forKey: "Subjects")
        aCoder.encode(colorPreferences, forKey: "Color Preferences")
        
        aCoder.encode(assessments, forKey: "Assessments")
        
        aCoder.encode(yearLevel, forKey: "Year Level")
        
        aCoder.encode(subjectGrades, forKey: "Subject Grades")
        
        aCoder.encode(overallGrade, forKey: "Overall Grade")
        
        aCoder.encode(averageGrade, forKey: "Average Grade")
        
        aCoder.encode(bestSubject, forKey: "Best Subject")
        
        aCoder.encode(subjectGradeSetting, forKey: "Subject Grade Settings")
    }
    
    func getBestSubject() -> (Subject, Bool) {
        
        var bestAverage = 0.0
        
        for (subject, isHL) in subjects {
            
            let assessmentsForSubject = assessments.filter { $0.subject.0 == subject }
            
            var sum = 0
            var numberOfAssessments = 0
            
            for assessment in assessmentsForSubject {
                
                sum += assessment.getOverallGrade()
                numberOfAssessments += 1
                
            }
            
            if numberOfAssessments != 0 {
                let average = Double(sum / numberOfAssessments)
                if average > bestAverage {
                    
                    bestAverage = average
                    bestSubject = (subject, isHL)
                    
                }
            }
            
        }
        
        return bestSubject
    }
    
    func getAverageGrade() -> Double {
        
        var sum = 0
        var numberOfAssessments = 0
        
        for assessment in assessments {
            
            sum += assessment.getOverallGrade()
            numberOfAssessments += 1
            
        }
        
        averageGrade = Double(sum/numberOfAssessments)
        
        return averageGrade
    }
    
    func getOverallGrade() -> Int {
        
        overallGrade = 0
        subjectGrades = getSubjectGrades()
        
        for (_, grade) in subjectGrades {
            
            overallGrade += grade
            
        }
        
        return overallGrade
    }
    
    func getSubjectGrades() -> [Subject: Int] {
    
        for (subject, isHL) in subjects {
            
            var sumPercentageMarks = 0.0
            var numberOfAssessments = 0
            
            var subjectAssessments = [Assessment]()
            
            for assessment in assessments {
                
                if assessment.subject.0 == subject {
                    sumPercentageMarks += assessment.percentageMarksObtained
                    
                    subjectAssessments.append(assessment)
                    
                    numberOfAssessments += 1
                }
                
                
            }
            
            //if the subject has no assessments
            if subjectAssessments.count == 0 {
                return subjectGrades
            }
            
            //return the median grade if that is the preference
            if let user = AppStatus.loggedInUser {
                if user.subjectGradeSetting == .medianGrade {
                    
                    let sortedSubjectAssessments = subjectAssessments.sorted { $0.getOverallGrade() > $1.getOverallGrade() }
                    
                    /*
                     
                     The below code works in both scenarios because the higher grade will be used when the count is even,
                     and the "sortedSubjectAssessments.count / 2" is rounded up when the count is odd
                     
                     */
                    var assessment: Assessment?
                    if sortedSubjectAssessments.count == 1 {
                        assessment = sortedSubjectAssessments[0]
                    } else {
                        assessment = sortedSubjectAssessments[sortedSubjectAssessments.count / 2]
                    }
                    let medianGrade = assessment?.getOverallGrade()
                    
                    subjectGrades[subject] = medianGrade
                    continue
                }
            }
            
            //return the time weighted grade if that is the preference
            if let user = AppStatus.loggedInUser {
                if user.subjectGradeSetting == .dateWeighted {
                    
                    //sort the subjects in terms of date
                    let dateSortedAssessments = subjectAssessments.sorted { $0.date < $1.date }
                    
                    //get the sum of how much extra weight I will allocate
                    let totalBonusPercentage: Int = sum(startIndex: 0, endIndex: dateSortedAssessments.count - 1, expression: { i in
                        return i
                    })
                    
                    //determines the base percentage for each assessment
                    let leftOverPercentage: Double = 1.0 - Double(totalBonusPercentage)/100.0
                    
                    var gradeWeights = [Double]()
                    
                    //determine the weight for each grade
                    for i in 0..<dateSortedAssessments.count {
                        
                        gradeWeights.append(leftOverPercentage/Double(dateSortedAssessments.count) + Double(i) / 100)
                        
                    }
                    
                    //add up the weight * grade for each assessment
                    var gradeSum = 0.0
                    for i in 0..<gradeWeights.count {
                        
                        let overallGrade = Double(dateSortedAssessments[i].getOverallGrade())
                        gradeSum += gradeWeights[i] * overallGrade
                        
                    }
                    
                    let returnGrade = Int(round(gradeSum))
                    subjectGrades[subject] = returnGrade
                    
                    return subjectGrades
                    
                }
            }
            
            let averagePercentage = sumPercentageMarks / Double(numberOfAssessments)
            
            typealias JSONDictionary = [String: Any]
            
            if let url = Bundle.main.url(forResource: "gradeBoundaries", withExtension: "json") { //find the url of the JSON
                do {
                    
                    let jsonData = try Data(contentsOf: url) //get the data for the JSON
                    
                    if let jsonResult: JSONDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? JSONDictionary { //the whole JSON
                        
                        let subjects: [JSONDictionary] = jsonResult["Subjects"] as! [JSONDictionary] //list of subjects (which are dictionaries)
                        
                        for aSubject in subjects { //iterate through the subjects
                            
                            let title: String = aSubject["Title"] as! String //get subject title
                            
                            if title == subject.rawValue + " \(isHL ? "HL" : "SL")" { //see if the subject title matches the subject of the assessment
                                
                                let gradeBoundaries: JSONDictionary = aSubject["Boundaries"] as! JSONDictionary //get dictionary of grade boundaries
                                
                                for key in gradeBoundaries.keys { //iterate through the keys
                                    var value: [Int] = gradeBoundaries[key] as! [Int] //get the value of the dictionary for the current key
                                    
                                    if let user = AppStatus.loggedInUser {
                                        
                                        //if the user's preference is "pessimist mode"
                                        if user.subjectGradeSetting == .pessimistMode {
                                            
                                            if averagePercentage - 5.0 < Double(value[1] + 1) && averagePercentage - 5.0 >= Double(value[0]) { //if the percentage (minus five) from the assessment falls between the bounds
                                                
                                                subjectGrades[subject] = Int(key) //add the subject grade to the dictionary
                                            }
                                            
                                        } else { //if the user just wants a simple average done
                                            
                                            if averagePercentage < Double(value[1] + 1) && averagePercentage >= Double(value[0]) { //if the percentage (minus five) from the assessment falls between the bounds
                                                
                                                subjectGrades[subject] = Int(key) //add the subject grade to the dictionary
                                            }
                                            
                                        }
                                        
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
        
        return subjectGrades
    }
    
}
