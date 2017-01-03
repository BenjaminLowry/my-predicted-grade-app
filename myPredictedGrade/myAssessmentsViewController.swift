//
//  myAssessmentsViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/27/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import UIKit

class myAssessmentsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var separatorView: UIView!

    @IBOutlet weak var bodyTableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentSelectionTextField: UITextField!
    @IBOutlet weak var contentOrderingTextField: UITextField!
    
    var contentSelectionPickerView: UIPickerView = UIPickerView()
    var contentOrderingPickerView: UIPickerView = UIPickerView()
    
    var contentSelectionOptions: [String] = ["All", "Physics HL", "Chemistry HL", "Spanish Ab SL"]
    var contentOrderingOptions: [String] = ["Most Recent", "Oldest", "Subject", "Overall Grade", "Percentage Marks", "Title"] //DEVELOPMENT: hide "Subject" when a specific subject is selected (?)
    
    var allAssessments: [Assessment] = [Assessment]()
    var sortedContentList: [Assessment] = [Assessment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTableView.register(UINib(nibName: "TestTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TestCell")
        
        //add shadow to separator view
        separatorView.layer.shadowColor = UIColor.black.cgColor
        separatorView.layer.shadowRadius = 7
        separatorView.layer.shadowOpacity = 1.0
        
        bodyTableView.delegate = self
        bodyTableView.dataSource = self
        
    

        //test of tableview system
        let date2 = Date(timeIntervalSince1970: TimeInterval(exactly: 3095904229.00)!)
        let chemTest = Assessment(assessmentTitle: "Stoichiometry Test", subject: .Chemistry, subjectIsHL: false, date: date2, marksAvailable: 49, marksReceived: 32)
        chemTest.overallGrade = 6
        allAssessments.append(chemTest)
        
        //test of tableview system
        let date = Date(timeIntervalSince1970: TimeInterval(exactly: 30549.00)!)
        let physicsTest = Assessment(assessmentTitle: "Forces & Mechanics Test", subject: .Physics, subjectIsHL: true, date: date, marksAvailable: 45, marksReceived: 36)
        physicsTest.overallGrade = 4
        allAssessments.append(physicsTest)
    
        //test of tableview system
        let date3 = Date(timeIntervalSince1970: TimeInterval(exactly: 3056959229.00)!)
        let mathTest = Assessment(assessmentTitle: "Calculus Test", subject: .Mathematics, subjectIsHL: true, date: date3, marksAvailable: 50, marksReceived: 49)
        mathTest.overallGrade = 5
        allAssessments.append(mathTest)
 

        
        //this sorts the assessments in terms of most recent date
        sortedContentList = allAssessments.sorted { $0.date > $1.date }
        
        //this sorts the assessments in terms of oldest date
        //sortedContentList = allAssessments.sorted { $0.date < $1.date }
        
        //this sorts the assessments into their subject groups (but interior ordering is arbitrary (?) )
        //sortedContentList = allAssessments.sorted { $0.subject.sortIndex < $1.subject.sortIndex }
        
        //this sorts the assessments with highest overall grade first
        //sortedContentList = allAssessments.sorted { $0.overallGrade >  $1.overallGrade }
        
        //this sorts the assessments with highest percentage marks first
        //sortedContentList = allAssessments.sorted { $0.percentageMarksObtained < $1.percentageMarksObtained }
        
        var indexPaths: [IndexPath] = [IndexPath]()
        
        for assessment in sortedContentList {
           
            let indexPath = IndexPath(row: sortedContentList.index(of: assessment)!, section: 0)
            indexPaths.append(indexPath)
            
        }
        
        bodyTableView.insertRows(at: indexPaths, with: .automatic)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPickerViews() {
        contentSelectionPickerView.tag = 1 //for the delegate methods
        //contentSelectionPickerView.isHidden = true
        contentSelectionPickerView.delegate = self
        contentSelectionPickerView.dataSource = self
        
        contentSelectionTextField.inputView = contentSelectionPickerView //set pickerView as responder
        contentSelectionTextField.delegate = self
        
        contentOrderingPickerView.tag = 2 //for the delegate methods
        //contentOrderingPickerView.isHidden = true
        contentOrderingPickerView.delegate = self
        contentOrderingPickerView.dataSource = self
        
        contentOrderingTextField.inputView = contentOrderingPickerView //set pickerView as responder
        contentOrderingTextField.delegate = self
        
        initializePickerViewToolBar(clearButtonFunc: "clearPressedContentSelectionPickerView", doneButtonFunc: "donePressedContentSelectionPickerView", textField: contentSelectionTextField)
        initializePickerViewToolBar(clearButtonFunc: "clearPressedContentOrderingPickerView", doneButtonFunc: "donePressedContentOrderingPickerView", textField: contentOrderingTextField)
    }
    
    func reloadTableViewData() {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //will I be creating sections for each subject? (when ordered by subject)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedContentList.count //temporary, will change if multiple sections are added
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: TestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TestCell") as! TestTableViewCell
        
        configureCell(cell: cell, assessment: sortedContentList[indexPath.row])
        
        return cell
        
    }
    
    func configureCell(cell: TestTableViewCell, assessment: Assessment){
        
        let mainView = cell.recentAssessmentView
        mainView?.awakeFromNib()
        mainView?.updateLabels(assessment: assessment)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //same for both pickers
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 { //contentSelectionPickerView
            return contentSelectionOptions.count
        } else if pickerView.tag == 2 { //contentOrderingPickerView
            return contentOrderingOptions.count
        } else {
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 { //contentSelectionPickerView
            return contentSelectionOptions[row]
        } else if pickerView.tag == 2 { //contentOrderingPickerView
            return contentOrderingOptions[row]
        } else {
            return "1"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            contentSelectionTextField.text = contentSelectionOptions[row]
        } else if pickerView.tag == 2 {
            contentOrderingTextField.text = contentOrderingOptions[row]
        }
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == contentSelectionTextField {
            //contentSelectionPickerView.isHidden = false
        } else if textField == contentOrderingTextField {
            //contentOrderingPickerView.isHidden = false
        }
    
        
    }
    
    //IS THERE A BETTER WAY TO DO THIS???
    func donePressedContentSelectionPickerView(){
        contentSelectionTextField.resignFirstResponder()
    }
    func donePressedContentOrderingPickerView(){
        contentOrderingTextField.resignFirstResponder()
    }
    
    func clearPressedContentSelectionPickerView(){
        contentSelectionTextField.resignFirstResponder()
        contentSelectionTextField.text = ""
    }
    func clearPressedContentOrderingPickerView(){
        contentOrderingTextField.resignFirstResponder()
        contentOrderingTextField.text = ""
    }
    
    func initializePickerViewToolBar(clearButtonFunc: String, doneButtonFunc: String, textField: UITextField){
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: textField.frame.size.height/6, width:  textField.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: textField.frame.size.width/2, y: textField.frame.size.height-20.0)
        toolBar.barStyle = .default
        toolBar.tintColor = UIColor.black
        
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: Selector(clearButtonFunc))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: Selector(doneButtonFunc))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([clearButton,flexSpace,doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
        
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
