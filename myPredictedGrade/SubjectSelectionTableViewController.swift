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
    
    var subjectList: [[SubjectObject.Subject]] = [[SubjectObject.Subject.ChineseALit, SubjectObject.Subject.ChineseALangLit, SubjectObject.Subject.EnglishALit, SubjectObject.Subject.EnglishALangLit], [SubjectObject.Subject.ChineseAb, SubjectObject.Subject.ChineseB, SubjectObject.Subject.FrenchAb, SubjectObject.Subject.FrenchB, SubjectObject.Subject.GermanAb, SubjectObject.Subject.GermanB, SubjectObject.Subject.SpanishAb, SubjectObject.Subject.SpanishB], [SubjectObject.Subject.BusinessManagement, SubjectObject.Subject.Economics, SubjectObject.Subject.Geography, SubjectObject.Subject.GlobalPolitics, SubjectObject.Subject.History, SubjectObject.Subject.InformationTechonologyinaGlobalSociety, SubjectObject.Subject.Philosophy, SubjectObject.Subject.Psychology, SubjectObject.Subject.SocialandCulturalAnthropology, SubjectObject.Subject.WorldReligions], [SubjectObject.Subject.Biology, SubjectObject.Subject.Chemistry, SubjectObject.Subject.ComputerScience, SubjectObject.Subject.DesignTechnology, SubjectObject.Subject.EnvironmentalSystemsandSocities, SubjectObject.Subject.Physics, SubjectObject.Subject.SportsExcerciseandHealthScience], [SubjectObject.Subject.FurtherMathematics, SubjectObject.Subject.Mathematics, SubjectObject.Subject.MathematicsStudies], [SubjectObject.Subject.Biology, SubjectObject.Subject.BusinessManagement, SubjectObject.Subject.Chemistry, SubjectObject.Subject.ComputerScience, SubjectObject.Subject.Dance, SubjectObject.Subject.DesignTechnology, SubjectObject.Subject.Economics, SubjectObject.Subject.EnvironmentalSystemsandSocities, SubjectObject.Subject.Film, SubjectObject.Subject.Geography, SubjectObject.Subject.GlobalPolitics, SubjectObject.Subject.History, SubjectObject.Subject.InformationTechonologyinaGlobalSociety, SubjectObject.Subject.Music, SubjectObject.Subject.MusicCreating, SubjectObject.Subject.Philosophy, SubjectObject.Subject.Physics, SubjectObject.Subject.Psychology, SubjectObject.Subject.SocialandCulturalAnthropology, SubjectObject.Subject.SportsExcerciseandHealthScience, SubjectObject.Subject.Theatre, SubjectObject.Subject.VisualArts, SubjectObject.Subject.WorldReligions]]
    
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
        invalidSubjects.append(SubjectObject(subject: .ChineseAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .FurtherMathematics, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .MathematicsStudies, isHL: true))
        
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

    @IBAction func subjectSwitchToggled(_ sender: UISwitch) {
        
        let superview = sender.superview
        let cell = superview?.superview?.superview as! UITableViewCell
        
        let indexPath = self.tableView.indexPath(for: cell)
    
        if groupSubjectToggle[(indexPath?.section)!] == true && subjectList[(indexPath?.section)!][(indexPath?.row)!] != groupSubjectSelection[(indexPath?.section)!] { // if a subject has already been selected from this group, and the user isn't trying to deselect their selected subjection
            sender.setOn(false, animated: true) // prevent the toggle, by setting the button as false
            return
        }
        
        let HLLabel = superview?.superview?.viewWithTag(2) as! UILabel
        let HLSwitch = superview?.superview?.viewWithTag(3) as! UISwitch
        
        // Have it always start off when it is toggled
        HLSwitch.isOn = false
        subjectHLList[(indexPath?.section)!] = false
        
        if sender.isOn { // if the switch has been turned on
            
            HLLabel.isHidden = false
            HLSwitch.isHidden = false
            
            // a subject has now been selected for that group
            groupSubjectToggle[(indexPath?.section)!] = true
            
            // set the selected subject in the array
            groupSubjectSelection[(indexPath?.section)!] = subjectList[(indexPath?.section)!][(indexPath?.row)!]
            
        } else { // if the switch has been turned off
            
            HLLabel.isHidden = true
            HLSwitch.isHidden = true
            
            // reset the hl switch
            HLSwitch.isOn = false
            
            // a subject now has not been selected for that group
            groupSubjectToggle[(indexPath?.section)!] = false
            
            // set the value to "nil"
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
