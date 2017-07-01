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
    
    // MARK: - Instance Variables
    
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
        if let user = AppStatus.loggedInUser {
            let subjects = user.subjects
            for subject in subjects {
                subjectPickerViewData.append(subject)
            }
        }
        
        subjectPickerView.delegate = self
        subjectPickerView.dataSource = self
        
        
        
        // Do any additional setup after loading the view.
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
            
            guard let marksAvailable = Int(marksAvailableText), let marksReceived = Int(marksReceivedText) else {
                print("Input not a number") //add error here
                return
            }
            
            if marksAvailable != 0 {
                updateAssessment()
                
                if let assessment = assessmentToEdit {
                    delegate?.assessmentDetailViewController(controller: self, didFinishEditingAssessment: assessment)
                } else {
                    let dateFormatter = DateFormatter()
                    let date = dateFormatter.date(fromSpecific: dateText)
                    
                    if let subjectObject = subjectValue(forString: subjectText) {
                        let assessment = Assessment(assessmentTitle: assessmentTitle, subjectObject: subjectObject, date: date, marksAvailable: marksAvailable, marksReceived: marksReceived)
                        delegate?.assessmentDetailViewController(controller: self, didFinishAddingAssessment: assessment)
                    }
                    
                }
            } else {
                print("Marks available cannot be zero") //add error here
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
                guard let user = AppStatus.loggedInUser else {
                    print("error")
                    return
                }
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
        print(dateTextField.text!)
        
        guard let assessmentTitle = assessmentTitleTextField.text, let subjectString = subjectTextField.text, let dateText = dateTextField.text, let marksAvailable = Int(marksAvailableTextField.text!), let marksReceived = Int(marksReceivedTextField.text!) else {
            print("error")
            return
        }/*
        guard let dateText = dateTextField.text else {
            print("error")
            return
        }*/
        print(dateText)
        
        guard let subject = subjectValue(forString: subjectString) else {
            print("error")
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
        if let user = AppStatus.loggedInUser {
            for subjectObject in user.subjects {
                if subjectObject.toString() == string {
                    return subjectObject
                }
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
