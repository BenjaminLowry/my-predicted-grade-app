//
//  AssessmentDetailViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 1/8/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

// MARK: - Delegate Protocol

//protocol to allow myAssessmentsViewController to control this class
protocol AssessmentDetailViewControllerDelegate: class {
    func assessmentDetailViewControllerDidCancel(controller: AssessmentDetailViewController)
    func assessmentDetailViewController(controller: AssessmentDetailViewController, didFinishAddingAssessment assessment: Assessment)
    func assessmentDetailViewController(controller: AssessmentDetailViewController, didFinishEditingAssessment assessment: Assessment)
}

class AssessmentDetailViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet weak var assessmentTitleTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var marksAvailableTextField: UITextField!
    @IBOutlet weak var marksReceivedTextField: UITextField!
    
    @IBOutlet var bodyTableView: UITableView!
    
    // MARK: - Properties
    
    var subjectPickerViewData: [SubjectObject] = [SubjectObject]()
    var subjectPickerView: UIPickerView = UIPickerView()
    
    var datePicker = UIDatePicker()
    
    var assessmentToEdit: Assessment?
    var indexOfAssessment: Int?
    
    var delegate: AssessmentDetailViewControllerDelegate?
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let assessment = assessmentToEdit {
            prepareLabelsForEditing(assessment: assessment)
            self.navigationItem.title = "Edit Assessment"
        }
        
        marksAvailableTextField.keyboardType = UIKeyboardType.numberPad
        marksReceivedTextField.keyboardType = UIKeyboardType.numberPad
        marksAvailableTextField.delegate = self
        marksReceivedTextField.delegate = self
        
        assessmentTitleTextField.delegate = self
        
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
        
        //load pickerview data
        subjectPickerViewData = [SubjectObject]() //clear array (necessary??)
        let user = AppStatus.user
        let subjects = user.subjects
        for subject in subjects {
            subjectPickerViewData.append(subject)
        }
        
        subjectPickerView.delegate = self
        subjectPickerView.dataSource = self
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 //ubiquitous among cells
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.assessmentDetailViewControllerDidCancel(controller: self)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        if let marksAvailableText = marksAvailableTextField.text, let marksReceivedText = marksReceivedTextField.text, let assessmentTitle = assessmentTitleTextField.text, let dateText = dateTextField.text, let subjectText = subjectTextField.text {
            
            if assessmentTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                
                let alert = Alert(message: "Your assessment title cannot be empty.", alertType: .invalidUserResponse)
                alert.show(source: self)
                return
                
            }
            
            guard let marksAvailable = Int(marksAvailableText), let marksReceived = Int(marksReceivedText) else {
                
                let alert = Alert(message: "Please only input numbers for marks.", alertType: .invalidUserResponse)
                alert.show(source: self)
                return
                
            }
            
            if marksReceived > marksAvailable {
                
                let alert = Alert(message: "Your received marks cannot be larger than the marks available.", alertType: .invalidUserResponse)
                alert.show(source: self)
                return
            
            }
            
            if assessmentTitle.characters.count > 30 {
                
                let alert = Alert(message: "Assessment title must be less than 30 characters.", alertType: .invalidUserResponse)
                alert.show(source: self)
                return
                
            }
            
            if marksAvailable != 0 {
                updateAssessment()
                
                let dateFormatter = DateFormatter()
                let date = dateFormatter.date(fromSpecific: dateText)
                
                if date > Date(timeIntervalSinceNow: 0) {
                    
                    let alert = Alert(message: "Please choose a date before today. You are not a fortune teller.", alertType: .invalidUserResponse)
                    alert.show(source: self)
                    return
                    
                }
                
                if let assessment = assessmentToEdit {
                    
                    delegate?.assessmentDetailViewController(controller: self, didFinishEditingAssessment: assessment)
                } else {

                    if let subjectObject = subjectValue(forString: subjectText) {
                        let assessment = Assessment(assessmentTitle: assessmentTitle, subjectObject: subjectObject, date: date, marksAvailable: marksAvailable, marksReceived: marksReceived)
                        delegate?.assessmentDetailViewController(controller: self, didFinishAddingAssessment: assessment)
                    }
                    
                }
            } else {
                
                let alert = Alert(message: "The marks available cannot be zero.", alertType: .invalidUserResponse)
                alert.show(source: self)
                return
                
            }
            
        }
    }
    
    // MARK: - UITextField Delegate Funcs
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboards))
        bodyTableView.addGestureRecognizer(tap)
        if textField.accessibilityIdentifier == "DateTextField" {
            handleDatePicker(datePicker)
        } else if textField.accessibilityIdentifier == "SubjectTextField" {
            if let assessment = assessmentToEdit {
                let user = AppStatus.user
                for subjectObject in user.subjects {
                    if assessment.subjectObject == subjectObject {
                        if let row = subjectPickerViewData.index(where: {$0 == subjectObject}) {
                            textField.text = subjectString(forSubjectAtRow: row)
                        }
                    } else {
                        textField.text = subjectString(forSubjectAtRow: 0)
                    }
                }
            } else {
                textField.text = subjectString(forSubjectAtRow: 0)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location == (textField.text?.characters.count)! && string == " " {
            
            let space: String = "\u{00a0}"
            textField.text?.append(space)
            return false
            
        }
        
        return true
    }
    
    // MARK: - UIPickerView Delegate Funcs
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return subjectPickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return subjectString(forSubjectAtRow: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectTextField.text = subjectString(forSubjectAtRow: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let label = view as? UILabel {
            label.text = subjectString(forSubjectAtRow: row)
            return label
        } else {
            let label = UILabel()
            label.font = UIFont(name: "AvenirNext", size: 20)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.text = subjectString(forSubjectAtRow: row)
            return label
        }
    }
    
    // MARK: - Date Creation Funcs
    
    func updateAssessment(){
        
        guard let assessmentTitle = assessmentTitleTextField.text, let subjectString = subjectTextField.text, let dateText = dateTextField.text, let marksAvailable = Int(marksAvailableTextField.text!), let marksReceived = Int(marksReceivedTextField.text!) else {
            
            let alert = Alert(message: "Info inputted incorrectly, please try again.", alertType: .invalidUserResponse)
            alert.show(source: self)
            return
            
        }
        
        guard let subject = subjectValue(forString: subjectString) else {
            
            let alert = Alert(message: "Please select a subject.", alertType: .invalidUserResponse)
            alert.show(source: self)
            return
            
        }
        
        let dateFormatter = DateFormatter()
        let date = dateFormatter.date(fromSpecific: dateText)
        
        assessmentToEdit?.assessmentTitle = assessmentTitle
        assessmentToEdit?.subjectObject = subject
        assessmentToEdit?.date = date
        assessmentToEdit?.marksAvailable = marksAvailable
        assessmentToEdit?.marksReceived = marksReceived
        
    }
    
    // MARK: - UITextField Helper Funcs
    
    func dismissKeyboards() {
        assessmentTitleTextField.resignFirstResponder()
        subjectTextField.resignFirstResponder()
        dateTextField.resignFirstResponder()
        
        marksAvailableTextField.resignFirstResponder()
        marksReceivedTextField.resignFirstResponder()
    }
    
    // MARK: - Subject Helper Funcs
    
    func subjectString(forSubjectAtRow row: Int) -> String {
        return subjectPickerViewData[row].toString()
    }
    
    func subjectValue(forString string: String) -> SubjectObject? {
        let user = AppStatus.user
        for subjectObject in user.subjects {
            if subjectObject.toString() == string {
                return subjectObject
            }
        }
        return nil
    }
    
    // MARK: - DatePicker Helper Funcs
    
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
        
        if let assessment = assessmentToEdit {
            datePicker.setDate(assessment.date, animated: true)
        }
    }
    
    // MARK: - UI Setup
    
    func prepareLabelsForEditing(assessment: Assessment) {
        assessmentTitleTextField.text = assessment.assessmentTitle
        subjectTextField.text = assessment.subjectObject.toString()
        
        let dateFormatter = DateFormatter()
        dateTextField.text = dateFormatter.string(fromSpecific: assessment.date)
        
        marksAvailableTextField.text = String(assessment.marksAvailable)
        marksReceivedTextField.text = String(assessment.marksReceived)
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
    
    func setupDateTextField() {
        //converting date to appropriate format
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSinceNow: 0)
        let string = dateFormatter.string(fromSpecific: date)
        dateTextField.placeholder = string
    }
    
}
