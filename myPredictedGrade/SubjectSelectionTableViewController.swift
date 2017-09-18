//
//  SubjectSelectionTableViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 6/6/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class SubjectSelectionTableViewController: UITableViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    var subjectList: [[SubjectObject.Subject]] = [
            // Group 1
            [ SubjectObject.Subject.ArabicALit, SubjectObject.Subject.ArabicALangLit, SubjectObject.Subject.ChineseALit, SubjectObject.Subject.ChineseALangLit, SubjectObject.Subject.CatalanALit, SubjectObject.Subject.DanishALit, SubjectObject.Subject.DutchALit, SubjectObject.Subject.DutchALangLit,
                SubjectObject.Subject.EnglishALit, SubjectObject.Subject.EnglishALangLit,
                SubjectObject.Subject.FinnishALit, SubjectObject.Subject.FrenchALit,
                SubjectObject.Subject.FrenchALangLit, SubjectObject.Subject.GermanALit,
                SubjectObject.Subject.GermanALangLit, SubjectObject.Subject.IndonesianALit,
                SubjectObject.Subject.IndonesianALangLit, SubjectObject.Subject.ItalianALit,
                SubjectObject.Subject.JapaneseALit, SubjectObject.Subject.JapaneseALangLit,
                SubjectObject.Subject.KoreanALit, SubjectObject.Subject.LiteraturePerformance,
                SubjectObject.Subject.MalayALit, SubjectObject.Subject.ModernGreekALit,
                SubjectObject.Subject.NorwegianALit, SubjectObject.Subject.PolishALit,
                SubjectObject.Subject.PortugueseALangLit, SubjectObject.Subject.RussianALit,
                SubjectObject.Subject.SpanishALit, SubjectObject.Subject.SpanishALangLit,
                SubjectObject.Subject.SwedishALit, SubjectObject.Subject.SwedishALangLit,
                SubjectObject.Subject.ThaiALangLit, SubjectObject.Subject.TurkishALit],
            // Group 2
            [SubjectObject.Subject.ArabicAb, SubjectObject.Subject.ArabicB, SubjectObject.Subject.CantoneseB, SubjectObject.Subject.ChineseALangLit, SubjectObject.Subject.ChineseALit, SubjectObject.Subject.DanishB, SubjectObject.Subject.DutchB,  SubjectObject.Subject.EnglishAb, SubjectObject.Subject.EnglishB, SubjectObject.Subject.FrenchAb, SubjectObject.Subject.FrenchB, SubjectObject.Subject.GermanALit, SubjectObject.Subject.GermanALangLit, SubjectObject.Subject.GermanAb, SubjectObject.Subject.GermanB, SubjectObject.Subject.HindiB, SubjectObject.Subject.IndonesianALit, SubjectObject.Subject.IndonesianALangLit, SubjectObject.Subject.IndonesianB, SubjectObject.Subject.ItalianAb, SubjectObject.Subject.ItalianB, SubjectObject.Subject.JapaneseALit, SubjectObject.Subject.JapaneseALangLit, SubjectObject.Subject.JapaneseAb, SubjectObject.Subject.JapaneseB, SubjectObject.Subject.KoreanALit, SubjectObject.Subject.Latin, SubjectObject.Subject.MalayALit,  SubjectObject.Subject.MandarinAb, SubjectObject.Subject.MandarinB, SubjectObject.Subject.NorwegianB, SubjectObject.Subject.RussianAb, SubjectObject.Subject.RussianB, SubjectObject.Subject.SpanishALit, SubjectObject.Subject.SpanishALangLit, SubjectObject.Subject.SpanishAb, SubjectObject.Subject.SpanishB, SubjectObject.Subject.SwedishB],
            // Group 3
            [SubjectObject.Subject.BrazSocStud, SubjectObject.Subject.BusinessManagement, SubjectObject.Subject.Economics, SubjectObject.Subject.EnvironmentalSystemsandSocities, SubjectObject.Subject.Geography, SubjectObject.Subject.GlobalPolitics, SubjectObject.Subject.History, SubjectObject.Subject.InformationTechonologyinaGlobalSociety, SubjectObject.Subject.Philosophy, SubjectObject.Subject.Psychology, SubjectObject.Subject.SocialCulturalAnthropology, SubjectObject.Subject.Turkey20thCentury, SubjectObject.Subject.WorldReligions],
            // Group 4
            [SubjectObject.Subject.Biology, SubjectObject.Subject.Chemistry, SubjectObject.Subject.ComputerScience, SubjectObject.Subject.DesignTechnology, SubjectObject.Subject.EnvironmentalSystemsandSocities, SubjectObject.Subject.MarineScience,  SubjectObject.Subject.Physics, SubjectObject.Subject.SportsExcerciseandHealthScience],
            // Group 5
            [SubjectObject.Subject.FurtherMathematics, SubjectObject.Subject.Mathematics, SubjectObject.Subject.MathematicsStudies],
            // Group 6
            [SubjectObject.Subject.ArabicAb, SubjectObject.Subject.ArabicB, SubjectObject.Subject.Biology, SubjectObject.Subject.BusinessManagement, SubjectObject.Subject.CantoneseB, SubjectObject.Subject.Chemistry, SubjectObject.Subject.ComputerScience, SubjectObject.Subject.Dance, SubjectObject.Subject.DanishB, SubjectObject.Subject.DesignTechnology, SubjectObject.Subject.DutchB, SubjectObject.Subject.Economics, SubjectObject.Subject.EnglishAb, SubjectObject.Subject.EnglishB, SubjectObject.Subject.EnvironmentalSystemsandSocities, SubjectObject.Subject.Film, SubjectObject.Subject.FrenchAb, SubjectObject.Subject.FrenchB, SubjectObject.Subject.Geography, SubjectObject.Subject.GermanAb, SubjectObject.Subject.GermanB, SubjectObject.Subject.GlobalPolitics, SubjectObject.Subject.HindiB, SubjectObject.Subject.History, SubjectObject.Subject.IndonesianB, SubjectObject.Subject.InformationTechonologyinaGlobalSociety, SubjectObject.Subject.ItalianAb, SubjectObject.Subject.ItalianB, SubjectObject.Subject.JapaneseAb, SubjectObject.Subject.JapaneseB, SubjectObject.Subject.Latin, SubjectObject.Subject.MandarinAb, SubjectObject.Subject.MandarinB,  SubjectObject.Subject.Music, SubjectObject.Subject.MusicGroupPerformance, SubjectObject.Subject.MusicSoloPerformance, SubjectObject.Subject.MusicCreating, SubjectObject.Subject.NorwegianB, SubjectObject.Subject.Philosophy, SubjectObject.Subject.Physics, SubjectObject.Subject.Psychology, SubjectObject.Subject.RussianAb, SubjectObject.Subject.RussianB, SubjectObject.Subject.SocialCulturalAnthropology, SubjectObject.Subject.SpanishAb, SubjectObject.Subject.SpanishB, SubjectObject.Subject.SportsExcerciseandHealthScience, SubjectObject.Subject.SwedishB, SubjectObject.Subject.Theatre, SubjectObject.Subject.VisualArts, SubjectObject.Subject.WorldReligions]]
    
    let groupNames = ["Group 1: Language and Literature", "Group 2: Language Acquisition", "Group 3: Individuals and Societies", "Group 4: Sciences", "Group 5: Mathematics", "Group 6: The Arts (+ Others)"]
    
    var groupSubjectToggle = [false, false, false, false, false, false]
    var groupSubjectSelection = [SubjectObject.Subject.Default, SubjectObject.Subject.Default, SubjectObject.Subject.Default, SubjectObject.Subject.Default, SubjectObject.Subject.Default, SubjectObject.Subject.Default]
    var subjectHLList = [false, false, false, false, false, false]

    var name: String!
    var yearLevel: YearLevelObject!
    
    var previousAssessments: [Assessment]?
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        if previousAssessments != nil {
            backButton.title = ""
            backButton.isEnabled = false
        } else {
            backButton.title = "Back"
            backButton.isEnabled = true
        }
        
    }

    // MARK: - UITableView Delegate Funcs

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectList[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Subject Cell", for: indexPath)

        let subjectTitleLabel = cell.viewWithTag(1) as! UILabel
        
        let subject = subjectList[indexPath.section][indexPath.row]
        
        // Shorten the name string if user is using iPhone 5, 5s
        if UIScreen.main.bounds.height == 568 {
            if subject.shortName != "" {
                subjectTitleLabel.text = subject.shortName
            } else {
                subjectTitleLabel.text = subject.rawValue
            }
        } else {
            subjectTitleLabel.text = subject.rawValue
        }
        
        subjectTitleLabel.adjustsFontSizeToFitWidth = true
        
        let mainSwitch = cell.viewWithTag(4) as! UISwitch
        let HLLabel = cell.viewWithTag(2) as! UILabel
        let HLSwitch = cell.viewWithTag(3) as! UISwitch
        
        if groupSubjectSelection[indexPath.section] == subjectList[indexPath.section][indexPath.row] { // Makes sure the switches stay off if they are supposed to be off
            mainSwitch.isOn = true
            HLLabel.isHidden = false
            HLSwitch.isHidden = false
            
            HLSwitch.isOn = subjectHLList[indexPath.section]
        } else {
            mainSwitch.isOn = false
            HLLabel.isHidden = true
            HLSwitch.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupNames[section]
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navigationVC = segue.destination as? UINavigationController {
            
            if let destinationVC = navigationVC.viewControllers[0] as? ColorSelectionViewController {
                
                var subjectList: [SubjectObject] = []
                
                for i in 0..<groupSubjectSelection.count {
                    
                    subjectList.append(SubjectObject(subject: groupSubjectSelection[i], isHL: subjectHLList[i]))
                    
                }
                
                destinationVC.subjects = subjectList
                
                destinationVC.name = self.name
                destinationVC.yearLevel = self.yearLevel
                
                if let prevAssessments = previousAssessments {
                    destinationVC.previousAssessments = prevAssessments
                } else {
                    destinationVC.previousAssessments = []
                }
                
            }
            
        }
        
    }
    
    // MARK: - IBActions
    
    @IBAction func continueButtonPressed(_ sender: UIBarButtonItem) {
        
        var invalidSubjects = [SubjectObject]()
        invalidSubjects.append(SubjectObject(subject: .SpanishAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .GermanAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .FrenchAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .MandarinAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .EnglishAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .FurtherMathematics, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .MathematicsStudies, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .DutchALit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .IndonesianALangLit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .JapaneseALangLit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .JapaneseALit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .LiteraturePerformance, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .MalayALit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .MarineScience, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .PortugueseALangLit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .ThaiALangLit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .BrazSocStud, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .CatalanALit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .SwedishALangLit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .ArabicAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .ItalianAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .JapaneseAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .RussianAb, isHL: true))
        
        if !groupSubjectToggle.contains(false) {
            
            for i in 0..<groupSubjectSelection.count {
                
                let subject = SubjectObject(subject: groupSubjectSelection[i], isHL: subjectHLList[i])

                for invalidSubject in invalidSubjects {
                    
                    if invalidSubject == subject {
                        
                        let alert = Alert(message: "\(subject.toString()) is an invalid subject choice. Please try again.", alertType: .invalidUserResponse)
                        alert.show(source: self)
                        return
                        
                    }
                    
                }
                
                for j in 0..<groupSubjectSelection.count {
                    
                    if groupSubjectSelection[i] == groupSubjectSelection[j] && i != j {
                        
                        let alert = Alert(message: "You have selected the same subject twice, please try again.", alertType: .invalidUserResponse)
                        alert.show(source: self)
                        return
                        
                    }
                    
                }
            }
            
            var HLCount = 0
            for subject in subjectHLList {
                if subject {
                    HLCount += 1
                }
            }
            
            if HLCount < 3 {
                
                let alert = Alert(message: "You have selected too few HLs, please try again.", alertType: .invalidUserResponse)
                alert.show(source: self)
                return
                
            } else if HLCount > 4 {
                
                let alert = Alert(message: "You have selected too many HLs, please try again.", alertType: .invalidUserResponse)
                alert.show(source: self)
                return
                
            }
            
            performSegue(withIdentifier: "Continue", sender: self)
            
        } else {
            
            let alert = Alert(message: "Please select a subject for each group.", alertType: .invalidUserResponse)
            alert.show(source: self)
            return
            
        }
        
    }
    
    @IBAction func subjectSwitchToggled(_ sender: UIButton) {
    
        let superview = sender.superview
        let cell = superview?.superview?.superview as! UITableViewCell
        
        let mainSwitch = cell.viewWithTag(4) as! UISwitch
        
        let indexPath = self.tableView.indexPath(for: cell)
        
        if groupSubjectToggle[(indexPath?.section)!] == true && subjectList[(indexPath?.section)!][(indexPath?.row)!] != groupSubjectSelection[(indexPath?.section)!] { // If a subject has already been selected from this group, and the user isn't trying to deselect their selected subjection
            mainSwitch.setOn(false, animated: true)
            return
        } else if subjectList[(indexPath?.section)!][(indexPath?.row)!] == groupSubjectSelection[(indexPath?.section)!] { // If the user is trying to deselect the row
            mainSwitch.setOn(false, animated: true)
        } else { // If the toggle-on is valid
            mainSwitch.setOn(true, animated: true)
        }
        
        let HLLabel = superview?.superview?.viewWithTag(2) as! UILabel
        let HLSwitch = superview?.superview?.viewWithTag(3) as! UISwitch
        
        // Have it always start off when it is toggled
        HLSwitch.isOn = false
        subjectHLList[(indexPath?.section)!] = false
        
        if mainSwitch.isOn { // If the switch has been turned on
            
            HLLabel.isHidden = false
            HLSwitch.isHidden = false
            
            // A subject has now been selected for that group
            groupSubjectToggle[(indexPath?.section)!] = true
            
            // Set the selected subject in the array
            groupSubjectSelection[(indexPath?.section)!] = subjectList[(indexPath?.section)!][(indexPath?.row)!]
            
        } else { // If the switch has been turned off
            
            HLLabel.isHidden = true
            HLSwitch.isHidden = true
            
            // Reset the hl switch
            HLSwitch.isOn = false
            
            // A subject now has not been selected for that group
            groupSubjectToggle[(indexPath?.section)!] = false
            
            // Set the value to "nil"
            groupSubjectSelection[(indexPath?.section)!] = SubjectObject.Subject.Default
            
        }
        
    }

    @IBAction func HLSwitchToggled(_ sender: UISwitch) {
        
        let cell = sender.superview?.superview?.superview as! UITableViewCell
        
        let indexPath = tableView.indexPath(for: cell)
        
        subjectHLList[(indexPath?.section)!] = sender.isOn
        
    }
    
    @IBAction func requestButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowRequest", sender: self)
    }

}
