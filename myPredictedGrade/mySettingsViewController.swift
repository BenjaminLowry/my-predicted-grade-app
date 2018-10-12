//
//  mySettingsViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 2/9/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit
import SafariServices

class mySettingsViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet weak var gradeCalculationTextField: UITextField!
    @IBOutlet weak var gradeCalculationLabel: UILabel!
    
    // MARK - Properties
    
    var gradeCalculationData = ["Average of Grades", "Date Weighted", "Median Grade", "Pessimist Mode"]
    
    var gradeCalculationPickerView = UIPickerView()
    
    // MARK - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradeCalculationTextField.inputView = gradeCalculationPickerView

        gradeCalculationPickerView.delegate = self
        gradeCalculationPickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignPickerViews))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.items = [flexSpace, doneButton]
        toolBar.tintColor = UIColor.black
        
        gradeCalculationTextField.inputAccessoryView = toolBar
        
        gradeCalculationLabel.adjustsFontSizeToFitWidth = true
        
        // Update picker view for selected option
        let currentSetting = AppStatus.user.subjectGradeSetting.rawValue
        gradeCalculationTextField.text = currentSetting
        gradeCalculationPickerView.selectRow(gradeCalculationData.index(of: currentSetting)!, inComponent: 0, animated: true)
        
    }
    
    @IBAction func changeSubjects(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "Any assessments from subjects you get rid of will be deleted.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { alert in
            self.performSegue(withIdentifier: "Change Subjects", sender: self)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func resetGradeBoundaries(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "This action cannot be undone.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { alert in
            // Reset boundaries
            AppStatus.user.initGradeBoundaries()
            
            let alertController = UIAlertController(title: "Success!", message: "Boundaries reset.", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(confirmAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func contactDeveloper(_ sender: Any) {
        
        // Opens a new draft email to me in mail app
        let email = "benjaminpaullowry.appdev@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
        
    }
    
    @IBAction func watchDemoVideo(_ sender: Any) {
        
        let url = URL(string: "https://youtu.be/CD30wwjPQys")!
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
        
    }
    
    // MARK - UIPickerView Delegate Funcs
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gradeCalculationData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gradeCalculationData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        gradeCalculationTextField.text = gradeCalculationData[row]
        
        var subjectGradeSettings = AppStatus.user.subjectGradeSetting
        switch row {
        case 0:
            subjectGradeSettings = SubjectGradeCalculation.averageOfGrades
        case 1:
            subjectGradeSettings = SubjectGradeCalculation.dateWeighted
        case 2:
            subjectGradeSettings = SubjectGradeCalculation.medianGrade
        case 3:
            subjectGradeSettings = SubjectGradeCalculation.pessimistMode
        default:
            return
        }
                
        AppStatus.user.subjectGradeSetting = subjectGradeSettings
        
        // Snapshot data
        takeSnapshots()
        
        // Save changes
        AppStatus.saveData()
        
    }
    
    // Snapshot data helper funcs
    
    func takeSnapshots() {
        
        let user = AppStatus.user
        
        let subjectGrades = user.getSubjectGrades()
        
        for (subjectObject, grade) in subjectGrades {
            
            let assessmentsForSubject = AppStatus.user.assessments.filter { $0.getSubjectObject() == subjectObject }
            
            var totalPercentageMarks = 0.0
            var count = 0
            
            for assessment in assessmentsForSubject {
                totalPercentageMarks += assessment.percentageMarksObtained
                count += 1
            }
            
            if count == 0 { // If there are no assessments for that subject
                continue
            }
            
            let averagePercentageMarks = Int(totalPercentageMarks / Double(count))
            
            let subjectSnapshot = SubjectSnapshot(grade: grade, subjectObject: subjectObject, averagePercentageMarks: averagePercentageMarks)
            user.addSubjectSnapshot(snapshot: subjectSnapshot)
            
        }
        
        let overallGradeSnapshot = OverallGradeSnapshot(grade: user.getOverallGrade())
        user.addOverallGradeSnapshot(snapshot: overallGradeSnapshot)
        
        
    }
    
    // MARK: - UIPickerView Helper Funcs
    
    @objc func resignPickerViews() {
        
        gradeCalculationTextField.resignFirstResponder()
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navController = segue.destination as? UINavigationController {
            
            if let vc = navController.viewControllers[0] as? SubjectSelectionTableViewController {
                
                vc.name = AppStatus.user.name
                vc.yearLevel = AppStatus.user.yearLevelObject
                
                vc.previousAssessments = AppStatus.user.assessments
                
            }
            
        }
        
    }
    
}
