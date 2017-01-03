//
//  RecentAssessmentView.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/23/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

class RecentAssessmentView: UIView {
    
    @IBOutlet var mainView: RecentAssessmentView!
    
    //UI members
    @IBOutlet weak var headerView: UIView! //parent view of titleLabel, subjectLabel, and dateLabel
    
        @IBOutlet weak var asssessmentTitleLabel: UILabel!
        @IBOutlet weak var subjectLabel: UILabel!
        @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var bodyView: UIView! //parent view of the following:
    
        @IBOutlet weak var marksLabel: UILabel! //format: "45 / 54"
        @IBOutlet weak var marksTitleLabel: UILabel!
    
        @IBOutlet weak var bodyMiddleView: UIView!
    
            @IBOutlet weak var percentageTitleLabel: UILabel!
            @IBOutlet weak var percentageLabel: UILabel!
    
            @IBOutlet weak var parentStackView: UIStackView!
    
                @IBOutlet weak var criteriaStackView: UIStackView!
                @IBOutlet weak var markStackView: UIStackView!
    
                    @IBOutlet weak var criterionAMarkLabel: UILabel!
                    @IBOutlet weak var criterionBMarkLabel: UILabel!
                    @IBOutlet weak var criterionCMarkLabel: UILabel!
                    @IBOutlet weak var criterionDMarkLabel: UILabel!
    
        @IBOutlet weak var overallGradeTitleLabel: UILabel!
        @IBOutlet weak var overallGradeLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("RecentAssessmentView", owner: self, options: nil)
        self.addSubview(self.mainView)
    }
    
    func updateLabels(assessment: Assessment){
        
        asssessmentTitleLabel.text = assessment.assessmentTitle
        subjectLabel.text = assessment.subject.0.rawValue
        
        //converting date to appropriate format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        var string = dateFormatter.string(from: assessment.date)
        print(assessment.date)
        print(string)
        string = string.insert(string: daySuffix(from: assessment.date), ind: 7)
        if string[5] == "0" {
            string.remove(at: string.characters.index(of: "0")!)
        }
        
        dateLabel.text = string
        
        marksLabel.text = "\(assessment.marksReceived) / \(assessment.marksAvailable)"
        
        //below consists of number formatting for the percentage label
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        let numberDouble: Double = Double(assessment.marksReceived) / Double(assessment.marksAvailable)
        let number = NSDecimalNumber(decimal: Decimal(numberDouble))
        percentageLabel.text = numberFormatter.string(from: number)
        
        if let criteriaA = assessment.criteriaA {
            criterionAMarkLabel.text = String(criteriaA)
        } else {
            criterionAMarkLabel.text = "~"
        }
        if let criteriaB = assessment.criteriaB {
            criterionBMarkLabel.text = String(criteriaB)
        } else {
            criterionBMarkLabel.text = "~"
        }
        if let criteriaC = assessment.criteriaC {
            criterionCMarkLabel.text = String(criteriaC)
        } else {
            criterionCMarkLabel.text = "~"
        }
        if let criteriaD = assessment.criteriaD {
            criterionDMarkLabel.text = String(criteriaD)
        } else {
            criterionDMarkLabel.text = "~"
        }
        
        assessment.calculateOverallGrade()
        overallGradeLabel.text = String(assessment.overallGrade)
        
    }
    
    func daySuffix(from date: Date) -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: date)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
    
}










