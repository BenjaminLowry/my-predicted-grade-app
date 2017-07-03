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
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var headerView: UIView! //parent view of titleLabel, subjectLabel, and dateLabel
    
        @IBOutlet weak var asssessmentTitleLabel: UILabel!
        @IBOutlet weak var subjectDateLabel: UILabel!
    
        @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var bodyView: UIView! //parent view of the following:
    
        @IBOutlet weak var marksLabel: UILabel! //format: "45 / 54"
        @IBOutlet weak var marksTitleLabel: UILabel!
    
        @IBOutlet weak var bodyMiddleView: UIView!
    
            @IBOutlet weak var percentageTitleLabel: UILabel!
            @IBOutlet weak var percentageLabel: UILabel!
    
        @IBOutlet weak var overallGradeTitleLabel: UILabel!
        @IBOutlet weak var overallGradeLabel: UILabel!

    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("RecentAssessmentView", owner: self, options: nil)
        mainView.layer.borderColor = UIColor.black.cgColor
        mainView.layer.borderWidth = 0.5
        subjectDateLabel.adjustsFontSizeToFitWidth = true
        asssessmentTitleLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(self.mainView)
        
    }
    
    // MARK: - UI Update Funcs
    
    func updateLabels(assessment: Assessment){
        
        //update colors
        let user = AppStatus.user
        for subjectObject in user.subjects {
            if assessment.subjectObject == subjectObject {
                var color = user.colorPreferences[subjectObject]
                color = color?.withAlphaComponent(0.30)
                headerView.backgroundColor = color
                color = color?.withAlphaComponent(0)
                bodyView.backgroundColor = color
                color = color?.withAlphaComponent(0.8)
                marksLabel.textColor = color
                percentageLabel.textColor = color
                overallGradeLabel.textColor = color
            }
        }
        
        asssessmentTitleLabel.text = assessment.assessmentTitle
        let subjectText = assessment.subjectObject.toString()
        
        //converting date to appropriate format
        let dateFormatter = DateFormatter()
        let dateString = dateFormatter.string(fromSpecific: assessment.date)
        
        let labelString: NSString = NSString(string: subjectText + "  " + dateString) //combine the two for the label
        let range = labelString.range(of: dateString)
        
        let attributedString = NSMutableAttributedString(string: labelString as String, attributes: [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 17)!])
        attributedString.setAttributes([NSFontAttributeName: UIFont(name: "Avenir Next", size: 17)! ], range: range)
        
        subjectDateLabel.attributedText = attributedString
        
        marksLabel.text = "\(assessment.marksReceived) / \(assessment.marksAvailable)"
        
        //below consists of number formatting for the percentage label
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        let numberDouble: Double = Double(assessment.marksReceived) / Double(assessment.marksAvailable)
        let number = NSDecimalNumber(decimal: Decimal(numberDouble))
        percentageLabel.text = numberFormatter.string(from: number)
        
        /*
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
        */
        overallGradeLabel.text = String(assessment.getOverallGrade())
        
    }
    
    func updateView(for color: UIColor) {
        
        var color = color
        color = color.withAlphaComponent(0.30)
        headerView.backgroundColor = color
        color = color.withAlphaComponent(0)
        bodyView.backgroundColor = color
        color = color.withAlphaComponent(0.8)
        marksLabel.textColor = color
        percentageLabel.textColor = color
        overallGradeLabel.textColor = color
        
    }
    
}










