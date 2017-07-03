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
    
    var subjects: [SubjectObject]!
    var colorPreferences: [SubjectObject: UIColor]!
    
    var name: String!
    var yearLevel: YearLevelObject!
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //register XIB for usage
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
        
        cell.recentAssessmentView.asssessmentTitleLabel.text = "My \(subjects![indexPath.row].toString()) Assessment"
        cell.recentAssessmentView.subjectDateLabel.text = "\(subjects![indexPath.row].toString()) 18th of March 2017"
        
        cell.recentAssessmentView.updateView(for: colorPreferences[subjects![indexPath.row]]!)
        
        return cell
    }
    
    // MARK: - IBActions
    
    @IBAction func confirmButtonPressed(_ sender: UIBarButtonItem) {
    
        let newProfile = Profile(name: self.name, yearLevelObject: self.yearLevel, subjects: self.subjects, colorPreferences: self.colorPreferences, assessments: [])
        AppStatus.user = newProfile
        AppStatus.isSignedUp = true
        
        AppStatus.saveData()
        
        //dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "SignupFinished", sender: self)
    
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
    
        dismiss(animated: true, completion: nil)
    
    }

}
