//
//  GradeStack.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 11/23/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation

class GradeCollection {
    
    var subjectStacks: [GradeStack]
    
    var previousGrades: [SubjectObject: Int]
    
    init(assessments: [Assessment]) {
        
        self.subjectStacks = [GradeStack]()
        
        for subjectObject in AppStatus.user.subjects {
            
            // Get the assessments for the specific subject
            let subjectAssessments = assessments.filter { $0.getSubjectObject() == subjectObject }
            
            let gradeStack = GradeStack(withSubject: subjectObject, andAssessments: subjectAssessments)
            self.subjectStacks.append(gradeStack)
            
        }
        
        self.previousGrades = [SubjectObject: Int]()
        
        // Get the initial grades for the stack and assign them to the previous dictionary
        for stack in subjectStacks {
            previousGrades[stack.subjectObject] = stack.getAverageGrade()
        }
        
    }
    
    func getOverallGrade(withAssessmentAddition assessment: Assessment? = nil) -> Int {
        
        var sum = 0
        for stack in subjectStacks {
            
            if let newAssessment = assessment {
                
                if stack.subjectObject == newAssessment.getSubjectObject() {
                    
                    stack.addAssessment(assessment: newAssessment)
                    let averageGrade = stack.getAverageGrade()
                    sum += averageGrade
                    previousGrades[stack.subjectObject] = averageGrade
                    
                } else {
                    
                    // For every subject except the changed one, sum grades as they were before
                    sum += previousGrades[stack.subjectObject]!
                    
                }
                
            } else {
                
                // If there is no new assessment addition, sum up the grades as they were before
                sum += previousGrades[stack.subjectObject]!
                
            }
            
        }
        
        return sum
        
    }
    
    func getSubjectGrades(withAssessmentAddition assessment: Assessment? = nil) -> [SubjectObject: Int] {
        
        if let newAssessment = assessment {
            
            // Update the subject with the new assessment
            for stack in subjectStacks {
                
                if stack.subjectObject == newAssessment.getSubjectObject() {
                    
                    stack.addAssessment(assessment: newAssessment)
                    previousGrades[stack.subjectObject] = stack.getAverageGrade()
                    
                }
                
            }
            
            return previousGrades
            
        } else { // If no assessment is added
            
            return previousGrades
            
        }
        
    }
    
}

class GradeStack {
    
    var subjectObject: SubjectObject
    var grades: [Int] // Stores percentages
    
    init(withSubject subjectObject: SubjectObject, andAssessments assessments: [Assessment]) {
        
        self.subjectObject = subjectObject
        
        var grades = [Int]()
        
        for assessment in assessments {
            
            grades.append(Int(assessment.percentageMarksObtained))
            
        }
        
        self.grades = grades
        
    }
    
    func addAssessment(assessment: Assessment) {
        self.grades.append(Int(assessment.percentageMarksObtained))
    }
    
    func getAverageGrade() -> Int {
        
        if grades.count > 0 {
            
            let sum = grades.reduce(0) { $0 + $1 }
            
            let averagePercentageGrade = sum / self.grades.count
            
            let grade = AppStatus.user.getGrade(forSubject: self.subjectObject, withPercentage: averagePercentageGrade)
            
            return grade
            
        }
        
        return 0
        
    }
    
    
}
