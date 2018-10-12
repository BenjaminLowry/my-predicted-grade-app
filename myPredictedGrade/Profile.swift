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
    
    fileprivate var subjectGradeTrendData: [SubjectObject: [Snapshot]]
    fileprivate var overallGradeTrendData: [Snapshot]
    
    fileprivate var gradeBoundaries: [SubjectObject: [String: [String: [Int: [Int]]]]]
    
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
        
        subjectGradeSetting = SubjectGradeCalculation.averageOfGrades
        subjectGradeSettingString = aDecoder.decodeObject(forKey: "Subject Grade Setting String") as! String
        
        subjectGradeSnapshots = aDecoder.decodeObject(forKey: "Subject Snapshots") as! [SubjectSnapshot]
        overallGradeSnapshots = aDecoder.decodeObject(forKey: "Overall Grade Snapshots") as! [OverallGradeSnapshot]
        
        if let subjectData = aDecoder.decodeObject(forKey: "Subject Grade Trend Data") as? [SubjectObject: [Snapshot]] {
            subjectGradeTrendData = subjectData
        } else {
            subjectGradeTrendData = [SubjectObject: [Snapshot]]()
        }
        
        if let overallData = aDecoder.decodeObject(forKey: "Overall Grade Trend Data") as? [Snapshot] {
            overallGradeTrendData = overallData
        } else {
            overallGradeTrendData = [Snapshot]()
        }
        
        // Check if you can pull the new M17 grade boundaries
        if let boundariesData = aDecoder.decodeObject(forKey: "Grade Boundaries") as? [SubjectObject: [String: [String: [Int: [Int]]]]] {
            gradeBoundaries = boundariesData
        } else {
            // Wait for the user to try and access the grade boundaries before intializing them, so that the custom boundaries aren't overriden
            gradeBoundaries = [SubjectObject: [String: [String: [Int: [Int]]]]]()
        }

        super.init()
        
        // Take the string which is encodable and then find the right enum option
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
        
        // Default value
        self.bestSubject = subjects[0]
        
        self.subjectGradeSetting = SubjectGradeCalculation.averageOfGrades
        self.subjectGradeSettingString = "Average of Grades" // Default value
        
        self.subjectGradeSnapshots = [SubjectSnapshot]()
        self.overallGradeSnapshots = [OverallGradeSnapshot]()
        
        self.subjectGradeTrendData = [SubjectObject: [Snapshot]]()
        self.overallGradeTrendData = [Snapshot]()
        
        // Default value
        self.gradeBoundaries = [SubjectObject: [String: [String: [Int: [Int]]]]]()
        
        super.init()
        
        // Get boundaries from JSON
        initGradeBoundaries()
        
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
        self.subjectGradeSettingString = "Average of Grades" // Default value
        
        self.subjectGradeSnapshots = [SubjectSnapshot]()
        self.overallGradeSnapshots = [OverallGradeSnapshot]()
        
        self.subjectGradeTrendData = [SubjectObject: [Snapshot]]()
        self.overallGradeTrendData = [Snapshot]()
        
        self.gradeBoundaries = [SubjectObject: [String: [String: [Int: [Int]]]]]()
        
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
        
        aCoder.encode(gradeBoundaries, forKey: "Grade Boundaries")
        
        aCoder.encode(subjectGradeTrendData, forKey: "Subject Grade Trend Data")
        aCoder.encode(overallGradeTrendData, forKey: "Overall Grade Trend Data")
        
    }
    
    // MARK: - Grade Boundaries Funcs
    
    func getGrade(forSubject subject: SubjectObject, withPercentage percentage: Int) -> Int {
        
        if subject.subject == .TheoryOfKnowledge {
            
            // The following switches have been converted to a percentage out of 10 marks for TOK
            
            switch percentage {
            case let x where x >= 80:
                return 5 // A
            case let x where x >= 60:
                return 4 // B
            case let x where x >= 40:
                return 3 // C
            case let x where x >= 20:
                return 2 // D
            default:
                return 1 // E
            }
            
        } else if subject.subject == .ExtendedEssay {
            
            // The following switches have been converted to a percentage out of 36 marks for EE
            
            switch percentage {
            case let x where x >= 80:
                return 5 // A
            case let x where x >= 63:
                return 4 // B
            case let x where x >= 44:
                return 3 // C
            case let x where x >= 22:
                return 2 // D
            default:
                return 1 // E
            }
            
        }
        
        let gradeBoundaries = getGradeBoundaries()
        
        if let subjectBoundaries = gradeBoundaries[subject] {
            
            var timezone = ""
            if subjectBoundaries.keys.count == 1 {
                timezone = "TZ0"
            } else if subjectBoundaries.keys.count == 2 {
                // Default to TZ1 (for now)
                timezone = "TZ1"
            }
            
            if let tzBoundaries = subjectBoundaries[timezone] {
                
                // Only get "final" boundaries
                if let finalBoundaries = tzBoundaries["Final"] {
                    
                    for (key, _) in finalBoundaries {
                        
                        let values: [Int] = finalBoundaries[key]! // Get the value of the dictionary for the current key
                        if percentage < values[1] + 1 && percentage >= values[0] { // If the percentage from the assessment falls between the bounds
                            return Int(key) // Set the overall grade to the current key
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        return 0
    }
    
    func getGradeBoundaries() -> [SubjectObject: [String: [String: [Int: [Int]]]]] {
        
        // In case the grade boundaries have never been set before
        if self.gradeBoundaries.count == 0 {
            self.initGradeBoundaries()
            
            return self.gradeBoundaries
        } else {
            return self.gradeBoundaries
        }
        
    }
    
    func getGradeBoundaries(forSubject subject: SubjectObject) -> [Int: [Int]] {
        
        let boundaries = self.getGradeBoundaries()
        
        var timezone = ""
        if boundaries[subject]!.keys.count == 1 {
            timezone = "TZ0"
        } else if boundaries[subject]!.keys.count == 2 {
            timezone = "TZ1"
        }
        
        return boundaries[subject]![timezone]!["Final"]!
        
    }
    
    func changeGradeBoundaries(forSubject subject: SubjectObject, withBoundaries boundaries: [Int: [Int]]) {
        
        if self.gradeBoundaries[subject]!.keys.count == 1 {
            self.gradeBoundaries[subject]!["TZ0"]!["Final"] = boundaries
        } else if self.gradeBoundaries[subject]!.keys.count == 2 {
            self.gradeBoundaries[subject]!["TZ1"]!["Final"] = boundaries
        }
        
        AppStatus.saveData()
        
    }
    
    // MARK: - Boundary Data-pulling Funcs
    
    // Called whenever thew boundaries should be initialized
    func initGradeBoundaries() {
        
        updateGradeBoundariesM17()
        
    }
    
    // Called to pull boundaries from the new M17 data
    func updateGradeBoundariesM17() {
        
        var boundaries = [SubjectObject: [String: [String: [Int: [Int]]]]]()
        
        typealias JSONDictionary = [String: Any]
        
        if let url = Bundle.main.url(forResource: "May 2017 Boundaries", withExtension: ".json") {
            
            do {
                
                let jsonData = try Data(contentsOf: url)
                
                if let jsonResult: JSONDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? JSONDictionary {
                    
                    for subject in AppStatus.user.subjects {
                        
                        let subjectName = subject.toString()
                        
                        // If the subject can be found in the new boundaries
                        if let subjectJSONInfo: JSONDictionary = jsonResult[subjectName] as? JSONDictionary { // Contains all data from timezones and further
                            
                            for (timezone_key, _) in subjectJSONInfo { // Loop through timezones
                                
                                if let timezoneData: JSONDictionary = subjectJSONInfo[timezone_key] as? JSONDictionary {
                                    
                                    for (assessment_key, _) in timezoneData { // Loop through assessments
                                        
                                        if let assessmentBoundaryData: JSONDictionary = timezoneData[assessment_key] as? JSONDictionary {
                                            
                                            for (grade_key, value) in assessmentBoundaryData {
                                                
                                                let boundary = value as! [Int]
                                                
                                                boundaries[subject]![timezone_key]![assessment_key]![Int(grade_key)!]! = boundary
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        } else { // If the subject only exists in the previous grade boundaries
                            
                            let subjectBoundary = getOldSubjectGradeBoundary(subject: subject)
                            
                            let assessmentDict = ["Final": subjectBoundary]
                            let timezoneDict = ["TZ0": assessmentDict]
                            
                            boundaries[subject] = timezoneDict
                            
                        }
                        
                        
                        
                    }
                    
                }
                
            } catch {
                
                print("JSON Error \(error)")
                
            }
            
            
        }
        
        self.gradeBoundaries = boundaries
        
    }
    
    func getOldSubjectGradeBoundary(subject: SubjectObject) -> [Int: [Int]] {
        
        var boundariesDict = [Int: [Int]]()
        
        typealias JSONDictionary = [String: Any]
        
        if let url = Bundle.main.url(forResource: "gradeBoundaries", withExtension: "json") { //find the url of the JSON
            do {
                
                let jsonData = try Data(contentsOf: url) //get the data for the JSON
                
                if let jsonResult: JSONDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? JSONDictionary { //the whole JSON
                    
                    let subjects: [JSONDictionary] = jsonResult["Subjects"] as! [JSONDictionary] //list of subjects (which are dictionaries)
                    
                    for aSubject in subjects { // Iterate through IB subjects
                        
                        let title: String = aSubject["Title"] as! String //get subject title
                        
                        if title == subject.toString() { //see if the subject title matches the subject of the assessment
                            
                            let gradeBoundaries: JSONDictionary = aSubject["Boundaries"] as! JSONDictionary //get dictionary of grade boundaries
                            
                            for key in gradeBoundaries.keys { //iterate through the keys
                                let value: [Int] = gradeBoundaries[key] as! [Int] //get the value of the dictionary for the current key
                                
                                let grade = Int(key)!
                                
                                boundariesDict[grade] = value
                            }
                            
                            return boundariesDict
                            
                        }
                        
                    }
                    
                }
                
            } catch {
                
                print("JSON error: \(error)")
                
            }
        }
        
        return boundariesDict
        
    }
    
    // MARK: - Subject Snapshot Funcs
    
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
    
    // MARK: - Subject Trend Data Funcs
    
    func updateTrendData(withAssessment assessment: Assessment) {
        
        updateOverallGradeTrendData()
        updateSubjectGradeTrendData(forSubject: assessment.getSubjectObject())
        
    }
    
    private func updateOverallGradeTrendData() {
        
        var snapshots = [Snapshot]()
        
        // From newest to oldest
        let dateSortedAssessments = self.assessments.sorted { $0.date > $1.date }
        
        var mostRecentAssessments = ArraySlice<Assessment>()
        var olderAssessments = ArraySlice<Assessment>()
        
        if dateSortedAssessments.count >= 10 {
            
            // 10 most recent assessments
            mostRecentAssessments = dateSortedAssessments[0...9]
            
            // The rest of the assessments
            olderAssessments = dateSortedAssessments[10..<dateSortedAssessments.count]
            
        } else { // If the user has less than 10 assessments right now
            
            // Return all of the current asssesments
            mostRecentAssessments = dateSortedAssessments[0..<dateSortedAssessments.count]
            
        }
        
        let gradeCollection = GradeCollection(assessments: convertArraySlicetoArray(arraySlice: olderAssessments))
        
        mostRecentAssessments.reverse() // Reverse order for appropriate simulation in next for-loop
        
        for assessment in mostRecentAssessments {
            
            let overallGrade = gradeCollection.getOverallGrade(withAssessmentAddition: assessment)
            
            snapshots.append(Snapshot(grade: overallGrade, withDate: assessment.date))
            
        }
        
        self.overallGradeTrendData = snapshots
        
    }
    
    private func convertArraySlicetoArray(arraySlice: ArraySlice<Assessment>) -> [Assessment] {
        
        var oldAssessmentList = [Assessment]()
        
        // Convert the array slice into a new array
        for oldAssessment in arraySlice {
            
            oldAssessmentList.append(oldAssessment)
            
        }
        
        return oldAssessmentList
        
    }
    
    private func updateSubjectGradeTrendData(forSubject subject: SubjectObject) {
        
        var snapshots = [Snapshot]()
        
        // Only select assessments from this subject
        let subjectAssessments = self.assessments.filter { $0.getSubjectObject() == subject }
        
        // From newest to oldest
        let dateSortedAssessments = subjectAssessments.sorted { $0.date > $1.date }
        
        var mostRecentAssessments = ArraySlice<Assessment>()
        var olderAssessments = ArraySlice<Assessment>()
        
        if dateSortedAssessments.count >= 10 {
            
            // 10 most recent assessments
            mostRecentAssessments = dateSortedAssessments[0...9]
            
            // The rest of the assessments
            olderAssessments = dateSortedAssessments[10..<dateSortedAssessments.count]
            
        } else { // If the user has less than 10 assessments right now
            
            // Return all of the current asssesments
            mostRecentAssessments = dateSortedAssessments[0..<dateSortedAssessments.count]
            
        }

        let gradeStack = GradeStack(withSubject: subject, andAssessments: convertArraySlicetoArray(arraySlice: olderAssessments))
        
        for assessment in mostRecentAssessments {
            
            gradeStack.addAssessment(assessment: assessment)
            let overallGrade = gradeStack.getAverageGrade()
            
            snapshots.append(Snapshot(grade: overallGrade, withDate: assessment.date))
            
        }
        
        self.subjectGradeTrendData[subject] = snapshots
        
    }
    
    func getOverallGradeTrendData() -> [Snapshot] {
        return overallGradeTrendData
    }
    
    func getSubjectGradeTrendData(forSubject subject: SubjectObject) -> [Snapshot] {
        return subjectGradeTrendData[subject]!
    }
    
    func getBestSubject() -> SubjectObject {
        
        var bestAverage = 0.0
        var bestPercentageAverage = 0.0
        
        for subjectObject in subjects {
            
            // Ignore TOK and EE
            if subjectObject.subject == .TheoryOfKnowledge || subjectObject.subject == .ExtendedEssay {
                continue
            }
            
            let assessmentsForSubject = assessments.filter { $0.getSubjectObject() == subjectObject }
            
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
                    
                } else if average == bestAverage { // If the average grade is the same for two subjects
                    
                    var percentageSum = 0.0
                    
                    for assessment in assessmentsForSubject {
                        
                        percentageSum += assessment.percentageMarksObtained
                        
                    }
                    
                    if percentageSum / Double(numberOfAssessments) > bestPercentageAverage { // If the current subject has better percentages even with the same grade
                        
                        // No need to set best average again since it will be the same
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
            
            // Ignore TOK and EE
            if assessment.getSubjectObject().subject == .TheoryOfKnowledge || assessment.getSubjectObject().subject == .ExtendedEssay {
                continue
            }
            
            sum += assessment.getOverallGrade()
            numberOfAssessments += 1
            
        }
        
        if numberOfAssessments == 0 { // If there were no assessments, or just TOK/EE
            return 8
        }
        
        averageGrade = Double(sum)/Double(numberOfAssessments)
        
        return averageGrade
    }
    
    func getOverallGrade() -> Int {
        
        overallGrade = 0
        subjectGrades = getSubjectGrades()
        
        var TOKGrade = 0
        var EEGrade = 0
        
        for (subject, grade) in subjectGrades {
            
            if subject.subject == .TheoryOfKnowledge {
                TOKGrade = grade
            } else if subject.subject == .ExtendedEssay {
                EEGrade = grade
            } else {
                overallGrade += grade
                continue // If TOK/EE aren't the last subjects, make sure they don't get added again
            }
            
            if TOKGrade != 0 && EEGrade != 0 {
                switch TOKGrade * EEGrade {
                case 25: // A-A
                    overallGrade += 3
                case 20: // A-B | B-A
                    overallGrade += 3
                case 16: // B-B 
                    overallGrade += 2
                case 15: // A-C | C-A
                    overallGrade += 2
                case 12: // B-C | C-B
                    overallGrade += 1
                case 10: // A-D | D-A
                    overallGrade += 2
                case 9:  // C-C
                    overallGrade += 1
                case 8:  // B-D | D-B
                    overallGrade += 1
                case 5:  // A-E | E-A
                    overallGrade += 1
                default:
                    overallGrade += 0
                }
            }
            
        }
        
        return overallGrade
    }
    
    func getSubjectGrades() -> [SubjectObject: Int] {
    
        // Reset the subject grades
        subjectGrades = [SubjectObject: Int]()
        
        for subjectObject in subjects {

            if subjectObject.subject == .TheoryOfKnowledge  {
                
                var totalEssayMarks = 0
                var essayCount = 0
                
                var totalPresentationMarks = 0
                var presentationCount = 0
                
                for assessment in assessments {
                    
                    if assessment.getSubjectObject() == subjectObject {
                        
                        if let newAssessment = assessment as? TOKAssessment {
                            
                            if newAssessment.assessmentType == .Essay {
                                totalEssayMarks += newAssessment.marksReceived
                                essayCount += 1
                            } else if newAssessment.assessmentType == .Presentation {
                                totalPresentationMarks += newAssessment.marksReceived
                                presentationCount += 1
                            }
                            
                        }
        
                    }
                    
                }
                
                if essayCount == 0 && presentationCount == 0 {
                    continue
                } else if essayCount == 0 || presentationCount == 0 {
                    var averageMarks = 0
                    if essayCount == 0 { // If there are only presentations
                        averageMarks = Int(round(Double(totalPresentationMarks) / Double(presentationCount)))
                    } else { // If there are only essays
                        averageMarks = Int(round(Double(totalEssayMarks) / Double(essayCount)))
                    }
                    
                    switch averageMarks {
                    case let x where x >= 8:
                        subjectGrades[subjectObject] = 5 // A
                    case let x where x >= 6:
                        subjectGrades[subjectObject] = 4 // B
                    case let x where x >= 4:
                        subjectGrades[subjectObject] = 3 // C
                    case let x where x >= 2:
                        subjectGrades[subjectObject] = 2 // D
                    default:
                        subjectGrades[subjectObject] = 1 // E
                    }
                    continue
                }
                
                let averageEssayMarks = Int(round(Double(totalEssayMarks) / Double(essayCount)))
                let averagePresentationMarks = Int(round(Double(totalPresentationMarks) / Double(presentationCount)))
            
                let totalMarks = averageEssayMarks * 2 + averagePresentationMarks
                
                switch totalMarks {
                case let x where x >= 22:
                    subjectGrades[subjectObject] = 5 // A
                case let x where x >= 16:
                    subjectGrades[subjectObject] = 4 // B
                case let x where x >= 10:
                    subjectGrades[subjectObject] = 3 // C
                case let x where x >= 4:
                    subjectGrades[subjectObject] = 2 // D
                default:
                    subjectGrades[subjectObject] = 1 // E
                }
                
            } else if subjectObject.subject == .ExtendedEssay {
                
                var totalMarks = 0
                var count = 0
                
                for assessment in assessments {
                    
                    if assessment.getSubjectObject() == subjectObject {
                        
                        totalMarks += assessment.marksReceived
                        count += 1
                        
                    }
                    
                }
                
                if count == 0 {
                    continue
                }
                
                let averageMarks = Int(round(Double(totalMarks) / Double(count)))
                
                switch averageMarks {
                case let x where x >= 29:
                    subjectGrades[subjectObject] = 5 // A
                case let x where x >= 23:
                    subjectGrades[subjectObject] = 4 // B
                case let x where x >= 16:
                    subjectGrades[subjectObject] = 3 // C
                case let x where x >= 8:
                    subjectGrades[subjectObject] = 2 // D
                default:
                    subjectGrades[subjectObject] = 1 // E
                }
                
                
            }
            
            
            var sumPercentageMarks = 0.0
            var numberOfAssessments = 0
            
            var subjectAssessments = [Assessment]()
            
            for assessment in assessments {
                
                if assessment.getSubjectObject() == subjectObject {
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
            
            subjectGrades[subjectObject] = self.getGrade(forSubject: subjectObject, withPercentage: averagePercentage)
            
        }
        
        return subjectGrades
    }
    
    func getAveragePercentageMarks() -> [SubjectObject: Int] {
        
        var averagePercentageMarks = [SubjectObject: Int]()
        
        for subject in subjects {
            
            if subject.subject == .TheoryOfKnowledge  {
                
                var totalEssayMarks = 0
                var essayCount = 0
                
                var totalPresentationMarks = 0
                var presentationCount = 0
                
                for assessment in assessments {
                    
                    if assessment.getSubjectObject() == subject {
                        
                        if let newAssessment = assessment as? TOKAssessment {
                            
                            if newAssessment.assessmentType == .Essay {
                                totalEssayMarks += newAssessment.marksReceived
                                essayCount += 1
                            } else if newAssessment.assessmentType == .Presentation {
                                totalPresentationMarks += newAssessment.marksReceived
                                presentationCount += 1
                            }
                            
                        }
                        
                    }
                    
                }
                
                if essayCount == 0 && presentationCount == 0 {
                    continue
                } else if essayCount == 0 || presentationCount == 0 {
                    var averageMarks = 0
                    if essayCount == 0 { // If there are only presentations
                        averageMarks = Int(round(Double(totalPresentationMarks) / Double(presentationCount)))
                    } else { // If there are only essays
                        averageMarks = Int(round(Double(totalEssayMarks) / Double(essayCount)))
                    }
                    
                    averagePercentageMarks[subject] = averageMarks * 3
                    continue
                }
                
                let averageEssayMarks = Int(round(Double(totalEssayMarks) / Double(essayCount)))
                let averagePresentationMarks = Int(round(Double(totalPresentationMarks) / Double(presentationCount)))
                
                let totalMarks = averageEssayMarks * 2 + averagePresentationMarks
                
                averagePercentageMarks[subject] = totalMarks
                continue
                
            } else if subject.subject == .ExtendedEssay {
                
                var totalMarks = 0
                var count = 0
                
                for assessment in assessments {
                    
                    if assessment.getSubjectObject() == subject {
                        
                        totalMarks += assessment.marksReceived
                        count += 1
                        
                    }
                    
                }
                
                if count == 0 {
                    continue
                }
                
                let averageMarks = Int(round(Double(totalMarks) / Double(count)))
            
                averagePercentageMarks[subject] = averageMarks
                continue
                
            }
            
            
            let subjectAssessments = assessments.filter { $0.getSubjectObject() == subject }
            
            var totalMarks = 0.0
            var count = 0
            
            for assessment in subjectAssessments {
                
                totalMarks += assessment.percentageMarksObtained
                count += 1
                
            }
            
            if subjectAssessments.count > 0 {
                averagePercentageMarks[subject] = Int(lround(totalMarks / Double(count)))
            }
            
        }
        
        return averagePercentageMarks
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
        } else { // To shut the compiler up
            return SubjectGradeCalculation.averageOfGrades
        }
        
    }
    
    func updateGradeSettingString() {
        
        subjectGradeSettingString = subjectGradeSetting.rawValue
        
    }
    
}

enum EditingStyle {
    case added
    case edited
    case deleted
}


