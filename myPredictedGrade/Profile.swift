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
    
    var name: String
    
    var subjects: [SubjectObject]
    var colorPreferences: [SubjectObject: UIColor]
    
    var assessments: [Assessment]
    
    var yearLevelObject: YearLevelObject
    
    var subjectGradeSetting: SubjectGradeCalculation
    var subjectGradeSettingString: String
    
    fileprivate var subjectGradeSnapshots: [SubjectSnapshot]
    fileprivate var overallGradeSnapshots: [OverallGradeSnapshot]
    
    fileprivate var subjectGrades: [SubjectObject: Int]
    
    fileprivate var overallGrade: Int
    
    fileprivate var averageGrade: Double
    
    fileprivate var bestSubject: SubjectObject
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        
        subjects = aDecoder.decodeObject(forKey: "Subjects") as! [SubjectObject]
        colorPreferences = aDecoder.decodeObject(forKey: "Color Preferences") as! [SubjectObject: UIColor]
        
        assessments = aDecoder.decodeObject(forKey: "Assessments") as! [Assessment]
        
        yearLevelObject = aDecoder.decodeObject(forKey: "Year Level") as! YearLevelObject
        
        subjectGrades = aDecoder.decodeObject(forKey: "Subject Grades") as! [SubjectObject: Int]
        
        overallGrade = aDecoder.decodeInteger(forKey: "Overall Grade")
        
        averageGrade = aDecoder.decodeDouble(forKey: "Average Grade")
        
        bestSubject = aDecoder.decodeObject(forKey: "Best Subject") as! SubjectObject
        
        subjectGradeSetting = SubjectGradeCalculation.averageOfGrades //default value, can be improved?
        subjectGradeSettingString = aDecoder.decodeObject(forKey: "Subject Grade Setting String") as! String
        
        subjectGradeSnapshots = aDecoder.decodeObject(forKey: "Subject Snapshots") as! [SubjectSnapshot]
        overallGradeSnapshots = aDecoder.decodeObject(forKey: "Overall Grade Snapshots") as! [OverallGradeSnapshot]
        
        super.init()
        
        //take the string which is encodable and then find the right enum option
        subjectGradeSetting = subjectGradeSettingEnum(from: subjectGradeSettingString)
    }
    
    init(name: String, yearLevelObject: YearLevelObject, subjects: [SubjectObject], colorPreferences: [SubjectObject: UIColor], assessments: [Assessment]) {
        
        self.name = name
        
        self.subjects = subjects
        self.colorPreferences = colorPreferences
        
        self.assessments = assessments
        
        self.yearLevelObject = yearLevelObject
        
        self.subjectGrades = [SubjectObject: Int]()
        
        self.overallGrade = 0
        
        self.averageGrade = 0
        
        //default
        self.bestSubject = subjects[0]
        
        self.subjectGradeSetting = SubjectGradeCalculation.averageOfGrades
        self.subjectGradeSettingString = "Average of Grades" //default value
        
        self.subjectGradeSnapshots = [SubjectSnapshot]()
        self.overallGradeSnapshots = [OverallGradeSnapshot]()
        
        super.init()
        
        updateGradeSettingString()
    }
    
    override init() {
        
        self.name = "John Doe"
        
        self.subjects = []
        self.colorPreferences = [SubjectObject: UIColor]()
        
        self.assessments = []
        
        self.yearLevelObject = YearLevelObject(yearLevel: .year12)
        
        self.subjectGrades = [SubjectObject: Int]()
        
        self.overallGrade = 0
        self.averageGrade = 0
        
        self.bestSubject = SubjectObject(subject: .Default, isHL: false)
        
        self.subjectGradeSetting = SubjectGradeCalculation.averageOfGrades
        self.subjectGradeSettingString = "Average of Grades" //default value
        
        self.subjectGradeSnapshots = [SubjectSnapshot]()
        self.overallGradeSnapshots = [OverallGradeSnapshot]()
        
        super.init()
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        
        aCoder.encode(subjects, forKey: "Subjects")
        aCoder.encode(colorPreferences, forKey: "Color Preferences")
        
        aCoder.encode(assessments, forKey: "Assessments")
        
        aCoder.encode(yearLevelObject, forKey: "Year Level")
        
        aCoder.encode(subjectGrades, forKey: "Subject Grades")
        
        aCoder.encode(overallGrade, forKey: "Overall Grade")
        
        aCoder.encode(averageGrade, forKey: "Average Grade")
        
        aCoder.encode(bestSubject, forKey: "Best Subject")
        
        aCoder.encode(subjectGradeSetting.rawValue, forKey: "Subject Grade Setting String")
        
        aCoder.encode(subjectGradeSnapshots, forKey: "Subject Snapshots")
        aCoder.encode(overallGradeSnapshots, forKey: "Overall Grade Snapshots")
    }
    
    func addSubjectSnapshot(snapshot: SubjectSnapshot) {
        
        subjectGradeSnapshots.append(snapshot)
        
    }
    
    func addOverallGradeSnapshot(snapshot: OverallGradeSnapshot) {
        
        overallGradeSnapshots.append(snapshot)
        
    }
    
    func getSubjectSnapshots() -> [SubjectSnapshot] {
        
        return subjectGradeSnapshots
        
    }
    
    func getOverallGradeSnapshots() -> [OverallGradeSnapshot] {
        
        return overallGradeSnapshots
        
    }
    
    func getBestSubject() -> SubjectObject {
        
        var bestAverage = 0.0
        var bestPercentageAverage = 0.0
        
        for subjectObject in subjects {
            
            let assessmentsForSubject = assessments.filter { $0.subjectObject == subjectObject }
            
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
                    bestSubject = subjectObject
                    
                    var percentageSum = 0.0
                    
                    for assessment in assessmentsForSubject {
                        
                        percentageSum += assessment.percentageMarksObtained
                        
                    }
                    
                    bestPercentageAverage = percentageSum / Double(numberOfAssessments)
                    
                } else if average == bestAverage { //if the average grade is the same for two subjects
                    
                    var percentageSum = 0.0
                    
                    for assessment in assessmentsForSubject {
                        
                        percentageSum += assessment.percentageMarksObtained
                        
                    }
                    
                    if percentageSum / Double(numberOfAssessments) > bestPercentageAverage { //if the current subject has better percentages even with the same grade
                        
                        //no need to set best average again since it will be the same
                        bestSubject = subjectObject
                        bestPercentageAverage = percentageSum / Double(numberOfAssessments)
                        
                    }
                    
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
        
        averageGrade = Double(sum)/Double(numberOfAssessments)
        
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
    
    func getSubjectGrades() -> [SubjectObject: Int] {
    
        for subjectObject in subjects {

            var sumPercentageMarks = 0.0
            var numberOfAssessments = 0
            
            var subjectAssessments = [Assessment]()
            
            for assessment in assessments {
                
                if assessment.subjectObject == subjectObject {
                    sumPercentageMarks += assessment.percentageMarksObtained
                    
                    subjectAssessments.append(assessment)
                    
                    numberOfAssessments += 1
                }
                
                
            }
            
            //if the subject has no assessments
            if subjectAssessments.count == 0 {
                continue
            }
            
            //return the median grade if that is the preference
            let user = AppStatus.user
            if user.subjectGradeSetting == .medianGrade {
                    
                let sortedSubjectAssessments = subjectAssessments.sorted { $0.getOverallGrade() > $1.getOverallGrade() }
                    
                /*
                     
                The below code works in both scenarios because the higher grade will be used when the count is even,
                and the "sortedSubjectAssessments.count / 2" is rounded up when the count is odd
                     
                */
                
                if sortedSubjectAssessments.count == 1 {
                    let assessment = sortedSubjectAssessments[0]
                    
                    let medianGrade = assessment.getOverallGrade()
                    subjectGrades[subjectObject] = medianGrade
                } else {
                    let assessment1 = sortedSubjectAssessments[sortedSubjectAssessments.count / 2 - 1]
                    let assessment2 = sortedSubjectAssessments[sortedSubjectAssessments.count / 2]
    
                    let medianGrade = lround((Double)(assessment1.getOverallGrade() + assessment2.getOverallGrade()) / 2)
                    subjectGrades[subjectObject] = medianGrade
                }
                
                continue
            }
            
            //return the time weighted grade if that is the preference
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
                subjectGrades[subjectObject] = returnGrade
                    
                continue
                    
            }
            
            let averagePercentage = lround(sumPercentageMarks / Double(numberOfAssessments))
            
            typealias JSONDictionary = [String: Any]
            
            if let url = Bundle.main.url(forResource: "gradeBoundaries", withExtension: "json") { //find the url of the JSON
                do {
                    
                    let jsonData = try Data(contentsOf: url) //get the data for the JSON
                    
                    if let jsonResult: JSONDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? JSONDictionary { //the whole JSON
                        
                        let subjects: [JSONDictionary] = jsonResult["Subjects"] as! [JSONDictionary] //list of subjects (which are dictionaries)
                        
                        for aSubject in subjects { //iterate through the subjects
                            
                            let title: String = aSubject["Title"] as! String //get subject title
                            
                            if title == subjectObject.toString() { //see if the subject title matches the subject of the assessment
                                
                                let gradeBoundaries: JSONDictionary = aSubject["Boundaries"] as! JSONDictionary //get dictionary of grade boundaries
                                
                                for key in gradeBoundaries.keys { //iterate through the keys
                                    var value: [Int] = gradeBoundaries[key] as! [Int] //get the value of the dictionary for the current key
                                    
                                    let user = AppStatus.user
                                        
                                    //if the user's preference is "pessimist mode"
                                    if user.subjectGradeSetting == .pessimistMode {
                                            
                                        if averagePercentage - 5 < value[1] + 1 && averagePercentage - 5 >= value[0] { //if the percentage (minus five) from the assessment falls between the bounds
                                                
                                            subjectGrades[subjectObject] = Int(key) //add the subject grade to the dictionary
                                        }
                                            
                                    } else { //if the user just wants a simple average done
                                            
                                        if averagePercentage < value[1] + 1 && averagePercentage >= value[0] { //if the percentage (minus five) from the assessment falls between the bounds
                                                
                                            subjectGrades[subjectObject] = Int(key) //add the subject grade to the dictionary
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
    
    func subjectGradeSettingEnum(from string: String) -> SubjectGradeCalculation{
        
        if string == "Average of Grades" {
            return SubjectGradeCalculation.averageOfGrades
        } else if string == "Median Grade" {
            return SubjectGradeCalculation.medianGrade
        } else if string == "Pessimist Mode" {
            return SubjectGradeCalculation.pessimistMode
        } else if string == "Date Weighted" {
            return SubjectGradeCalculation.dateWeighted
        } else { //to shut the compiler up
            return SubjectGradeCalculation.averageOfGrades
        }
        
    }
    
    func updateGradeSettingString() {
        
        subjectGradeSettingString = subjectGradeSetting.rawValue
        
    }
    
}
