//
//  mySettingsViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 2/9/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        //save changes
        AppStatus.saveData()
        
    }
    
    // MARK: - UIPickerView Helper Funcs
    
    func resignPickerViews() {
        
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
