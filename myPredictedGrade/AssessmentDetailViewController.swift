//
//  AssessmentDetailViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 1/8/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

//protocol to allow myAssessmentsViewController to control this class
protocol AssessmentDetailViewControllerDelegate: class {
    func assessmentDetailViewControllerDidCancel(controller: AssessmentDetailViewController)
    func assessmentDetailViewController(controller: AssessmentDetailViewController, didFinishAddingAssessment: Assessment)
    func assessmentDetailViewController(controller: AssessmentDetailViewController, didFinishEditingAssessment: Assessment)
}

class AssessmentDetailViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var assessmentTitleTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var marksAvailableTextField: UITextField!
    @IBOutlet weak var marksReceivedTextField: UITextField!
    
    @IBOutlet var bodyTableView: UITableView!
    
    var subjectPickerViewData: [String] = [String]()
    var subjectPickerView: UIPickerView = UIPickerView()
    
    var datePicker = UIDatePicker()
    
    var assessmentToEdit: Assessment?
    
    var delegate: AssessmentDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let assessment = assessmentToEdit {
            prepareLabelsForEditing(assessment: assessment)
        }
        
        marksAvailableTextField.keyboardType = UIKeyboardType.numberPad
        marksReceivedTextField.keyboardType = UIKeyboardType.numberPad
        marksAvailableTextField.delegate = self
        marksReceivedTextField.delegate = self
        
        setupDatePicker()
        dateTextField.inputView = datePicker
        dateTextField.delegate = self
        dateTextField.accessibilityIdentifier = "DateTextField"
        
        setupDateTextField()
        
        subjectTextField.inputView = subjectPickerView
        subjectTextField.adjustsFontSizeToFitWidth = true
        subjectTextField.minimumFontSize = 10
        subjectTextField.delegate = self
        subjectTextField.accessibilityIdentifier = "SubjectTextField"
        
        addResponderButtons()
        
        //temporary setup
        let profile = Profile(username: "Benthos", password: "benjiman", subjects: [(Subject.Biology, false), (Subject.ComputerScience, true), (Subject.Physics, true), (Subject.EnvironmentalSystemsandSocities, false), (Subject.InformationTechonologyinaGlobalSociety, true)], colorPreferences: [Subject.Biology: .black], assessments: [])
        AppStatus.loggedInUser = profile
        
        //load pickerview data
        subjectPickerViewData = [String]() //clear array (necessary??)
        if let user = AppStatus.loggedInUser {
            let subjects = user.subjects
            for subject in subjects {
                var hlString = " HL"
                if subject.1 == false {
                    hlString = " SL"
                }
                subjectPickerViewData.append(subject.0.rawValue + hlString)
            }
        }
        
        subjectPickerView.delegate = self
        subjectPickerView.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.assessmentDetailViewControllerDidCancel(controller: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 //ubiquitous among cells
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboards))
        bodyTableView.addGestureRecognizer(tap)
        if textField.accessibilityIdentifier == "DateTextField" {
            handleDatePicker(datePicker)
        } else if textField.accessibilityIdentifier == "SubjectTextField" {
            textField.text = subjectPickerViewData[0]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectPickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectPickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectTextField.text = subjectPickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let label = view as? UILabel {
            label.text = subjectPickerViewData[row]
            return label
        } else {
            let label = UILabel()
            label.font = UIFont(name: "AvenirNext", size: 20)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.text = subjectPickerViewData[row]
            return label
        }
    }
    
    func prepareLabelsForEditing(assessment: Assessment) {
        assessmentTitleTextField.text = assessment.assessmentTitle
        subjectTextField.text = assessment.subject.0.rawValue
        
        let dateFormatter = DateFormatter()
        dateTextField.text = dateFormatter.string(fromSpecific: assessment.date)
        
        marksAvailableTextField.text = String(assessment.marksAvailable)
        marksReceivedTextField.text = String(assessment.marksReceived)
    }
    
    func dismissKeyboards() {
        assessmentTitleTextField.resignFirstResponder()
        subjectTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        
        marksAvailableTextField.resignFirstResponder()
        marksReceivedTextField.resignFirstResponder()
    }
    
    func addResponderButtons() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: view, action: #selector(UIView.endEditing(_:)))
            
        doneBarButton.tintColor = AppStatus.themeColor
        cancelBarButton.tintColor = AppStatus.themeColor
        keyboardToolbar.items = [cancelBarButton, flexBarButton, doneBarButton]
        marksAvailableTextField.inputAccessoryView = keyboardToolbar
        marksReceivedTextField.inputAccessoryView = keyboardToolbar
        
        subjectTextField.inputAccessoryView = keyboardToolbar
        
        
        assessmentTitleTextField.inputAccessoryView = keyboardToolbar
    }
    
    func handleDatePicker(_ sender: UIDatePicker){
        //converting date to appropriate format
        let dateFormatter = DateFormatter()
        let string = dateFormatter.string(fromSpecific: sender.date)
        
        dateTextField.text = string
    }
    
    func setupDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: view, action: #selector(UIView.endEditing(_:)))
        
        doneButton.tintColor = AppStatus.themeColor
        cancelButton.tintColor = AppStatus.themeColor
        
        toolBar.items = [cancelButton, flexButton, doneButton]
        dateTextField.inputAccessoryView = toolBar
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(handleDatePicker(_:)), for: .valueChanged)
    }
    
    func setupDateTextField() {
        //converting date to appropriate format
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSinceNow: 0)
        let string = dateFormatter.string(fromSpecific: date)
        dateTextField.placeholder = string
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
