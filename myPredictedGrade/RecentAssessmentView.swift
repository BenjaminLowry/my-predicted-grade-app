//
//  RecentAssessmentView.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/23/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

enum Subject: String {
    //start of group 1: language and literature
    case EnglishALit = "English A Literature"
    case EnglishALangLit = "English A Language and Literature"
    case ChineseALit = "Chinese A Literature"
    case ChineseALangLit = "Chinese A Language and Literature"
    
    //start of group 2: language acquisition
    case SpanishAb = "Spanish Ab Initio"
    case SpanishB = "Spanish B"
    case ChineseAb = "Chinese Ab Initio"
    case ChineseB = "Chinese B"
    case FrenchAb = "French Ab Initio"
    case FrenchB = "French B"
    
    //start of group 3: individuals and socities
    case BusinessManagement = "Business Management"
    case Economics = "Economics"
    case Geography = "Geography"
    case History = "History"
    case InformationTechonologyinaGlobalSociety = "Information Technology in a Global Society"
    case Philosophy = "Philosophy"
    case Psychology = "Psychology"
    case SocialandCulturalAnthropology = "Social and Cultural Anthropology"
    case WorldReligions = "World Religions"
    case GlobalPolitics = "Global Politics"
    
    //start of group 4: science
    case Biology = "Biology"
    case Chemistry = "Chemistry"
    case ComputerScience = "Computer Science"
    case DesignTechnology = "Design Technology"
    case EnvironmentalSystemsandSocities = "Environmental Systems and Societies"
    case Physics = "Physics"
    case SportsExcerciseandHealthScience = "Sports Excercise and Health Science"
    
    //start of group 5: mathematics
    case MathematicsStudies = "Mathematics Studies"
    case Mathematics = "Mathematics"
    case FurtherMathematics = "Further Mathematics"
    
    //start of group 6: arts
    case Dance = "Dance"
    case Film = "Film"
    case Music = "Music"
    case Theatre = "Theatre"
    case VisualArts = "Visual Arts"
    
    //others
    case TheoryofKnowledge = "Theory of Knowledge"
    
}

class RecentAssessmentView: UIView {
    
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
        
    }
    
    func updateLabels(assessment: Assessment){
        
        asssessmentTitleLabel.text = assessment.assessmentTitle
        subjectLabel.text = assessment.subject.rawValue
        
        //converting date to appropriate format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy"
        var string = dateFormatter.string(from: assessment.date)
        string = string.insert(string: daySuffix(from: assessment.date), ind: 8)
        dateLabel.text = string
        
        marksLabel.text = "\(assessment.marksReceived) / \(assessment.marksAvailable)"
        
        if let criteriaA = assessment.criteriaA {
            criterionAMarkLabel.text = String(criteriaA)
        }
        if let criteriaB = assessment.criteriaB {
            criterionBMarkLabel.text = String(criteriaB)
        }
        if let criteriaC = assessment.criteriaC {
            criterionCMarkLabel.text = String(criteriaC)
        }
        if let criteriaD = assessment.criteriaD {
            criterionDMarkLabel.text = String(criteriaD)
        }
        
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










