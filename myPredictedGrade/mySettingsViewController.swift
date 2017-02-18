//
//  mySettingsViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 2/9/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class mySettingsViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var gradeCalculationTextField: UITextField!
    
    var gradeCalculationData = ["Average of Grades", "Date Weighted", "Median Grade", "Pessimist Mode"]
    
    var gradeCalculationPickerView = UIPickerView()
    
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
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(resignPickerViews))
        
        toolBar.items = [cancelButton, flexSpace, doneButton]
        
        gradeCalculationTextField.inputAccessoryView = toolBar
        
        
        // Do any additional setup after loading the view.
    }
    
    func resignPickerViews() {
        
        gradeCalculationTextField.resignFirstResponder()
        
        //temporary
        AppStatus.loggedInUser?.getSubjectGrades()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        
        if var subjectGradeSettings = AppStatus.loggedInUser?.subjectGradeSetting {
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
            
            AppStatus.loggedInUser?.subjectGradeSetting = subjectGradeSettings
        }
        
    }
    
    

}
