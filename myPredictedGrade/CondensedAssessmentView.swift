//
//  CondensedAssessmentView.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 9/18/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class CondensedAssessmentView: UIView {

    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var assessmentTitleLabel: UILabel!
    
    @IBOutlet weak var subjectTitleLabel: UILabel!

    @IBOutlet weak var overallGradeLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("CondensedAssessmentView", owner: self, options: nil)
        mainView.layer.borderColor = UIColor.black.cgColor
        mainView.layer.borderWidth = 0.5
        
        // Make sure the width of the view is correct
        mainView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: mainView.frame.height)
        self.addSubview(self.mainView)
        
    }
    
    func updateLabels(assessment: Assessment){
        
        // Update colors
        let user = AppStatus.user
        for subjectObject in user.subjects {
            if assessment.getSubjectObject() == subjectObject {
                var color = user.colorPreferences[subjectObject]
                color = color?.withAlphaComponent(0.30)
                coloredView.backgroundColor = color
                color = color?.withAlphaComponent(0.8)
                overallGradeLabel.textColor = color
            }
        }
        
        assessmentTitleLabel.text = assessment.assessmentTitle
        
        let subjectText = assessment.getSubjectObject().toString()
        subjectTitleLabel.text = subjectText
        subjectTitleLabel.adjustsFontSizeToFitWidth = true
        
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
    
    
}
