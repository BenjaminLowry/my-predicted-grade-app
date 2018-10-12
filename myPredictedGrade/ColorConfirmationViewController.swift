//
//  ColorConfirmationViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 6/30/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class ColorConfirmationViewController: UITableViewController {

    // MARK: - Properties
    
    var name: String!
    var yearLevel: YearLevelObject!
    
    var previousAsessments: [Assessment]!
    
    var subjects: [SubjectObject]!
    var colorPreferences: [SubjectObject: UIColor]!
    
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register XIB for usage
        self.tableView.register(UINib(nibName: "AssessmentCell", bundle: Bundle.main), forCellReuseIdentifier: "AssessmentCell")
        
    }

    // MARK: - UITableView Delegate Funcs
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentCell") as! AssessmentCell
        
        cell.assessmentView.assessmentTitleLabel.text = "My \(subjects![indexPath.row].toString()) Assessment"
        cell.assessmentView.subjectDateLabel.text = "\(subjects![indexPath.row].toString()) 18th of March 2017"
        
        cell.assessmentView.infoButton.isHidden = true
        
        cell.assessmentView.updateView(for: colorPreferences[subjects![indexPath.row]]!)
        
        return cell
    }
    
    // MARK: - IBActions
    
    @IBAction func confirmButtonPressed(_ sender: UIBarButtonItem) {
        
        // Add TOK and EE
        let TOK = SubjectObject(subject: .TheoryOfKnowledge, isHL: false)
        let EE = SubjectObject(subject: .ExtendedEssay, isHL: false)
        subjects.append(TOK)
        subjects.append(EE)
        
        var assessmentsToKeep = [Assessment]()
        
        for assessment in previousAsessments {
            
            for subjectObject in subjects {
                
                if assessment.getSubjectObject() == subjectObject {
                    
                    assessmentsToKeep.append(assessment)
                    break
                    
                }
                
            }
            
        }
        
        colorPreferences[TOK] = UIColor.init(red: 8/255, green: 32/255, blue: 56/255, alpha: 1.0)
        colorPreferences[EE] = UIColor.init(red: 8/255, green: 32/255, blue: 56/255, alpha: 1.0)
        
        let newProfile = Profile(name: self.name, yearLevelObject: self.yearLevel, subjects: self.subjects, colorPreferences: self.colorPreferences, assessments: assessmentsToKeep)
        AppStatus.user = newProfile
        AppStatus.user.initGradeBoundaries()
        AppStatus.isSignedUp = true
        
        AppStatus.saveData()
        
        performSegue(withIdentifier: "SignupFinished", sender: self)
    
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
    
        dismiss(animated: true, completion: nil)
    
    }
    
}
