//
//  RecentAssessmentView.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/23/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

class AssessmentView: UIView {
    
    @IBOutlet var mainView: AssessmentView!
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var headerView: UIView! //parent view of titleLabel, subjectLabel, and dateLabel
    
        @IBOutlet weak var assessmentTitleLabel: UILabel!
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
        
        Bundle.main.loadNibNamed("AssessmentView", owner: self, options: nil)
        mainView.layer.borderColor = UIColor.black.cgColor
        mainView.layer.borderWidth = 0.5
        subjectDateLabel.adjustsFontSizeToFitWidth = true
        assessmentTitleLabel.adjustsFontSizeToFitWidth = true
        
        // Make sure the width of the view is correct
        mainView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: mainView.frame.height)
        self.addSubview(self.mainView)
    
    }
    
    // MARK: - UI Update Funcs
    
    func updateLabels(assessment: Assessment){
        
        // Update colors
        let user = AppStatus.user
        for subjectObject in user.subjects {
            if assessment.getSubjectObject() == subjectObject {
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
        
        assessmentTitleLabel.text = assessment.assessmentTitle
        let subjectText = assessment.getSubjectObject().toShortString()
        
        //converting date to appropriate format
        let dateFormatter = DateFormatter()
        let dateString = dateFormatter.string(fromSpecific: assessment.date)
        
        let labelString: NSString = NSString(string: subjectText + "  " + dateString) //combine the two for the label
        let range = labelString.range(of: dateString)
        
        let attributedString = NSMutableAttributedString(string: labelString as String, attributes: [NSAttributedStringKey.font: UIFont(name: "AvenirNext-Medium", size: 17)!])
        attributedString.setAttributes([NSAttributedStringKey.font: UIFont(name: "Avenir Next", size: 17)! ], range: range)
        
        subjectDateLabel.attributedText = attributedString
        
        marksLabel.text = "\(assessment.marksReceived) / \(assessment.marksAvailable)"
        
        //below consists of number formatting for the percentage label
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        let numberDouble: Double = Double(assessment.marksReceived) / Double(assessment.marksAvailable)
        let number = NSDecimalNumber(decimal: Decimal(numberDouble))
        percentageLabel.text = numberFormatter.string(from: number)
      
        if assessment.getSubjectObject().subject == .TheoryOfKnowledge || assessment.getSubjectObject().subject == .ExtendedEssay {
            
            switch assessment.getOverallGrade() {
            case 5:
                overallGradeLabel.text = "A"
            case 4:
                overallGradeLabel.text = "B"
            case 3:
                overallGradeLabel.text = "C"
            case 2:
                overallGradeLabel.text = "D"
            case 1:
                overallGradeLabel.text = "E"
            default:
                overallGradeLabel.text = "?"
            }
            
            return
        }
        
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










