//
//  myAssessmentsViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/27/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import UIKit

class myAssessmentsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var filterView: BorderedView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var bodyTableView: UITableView!
    
    @IBOutlet weak var contentSelectionTextField: UITextField!
    @IBOutlet weak var contentOrderingTextField: UITextField!
    
    // MARK: - Properties
    
    var contentSelectionPickerView: UIPickerView = UIPickerView()
    var contentOrderingPickerView: UIPickerView = UIPickerView()
    
    var contentSelectionOptions: [String] = ["All", "Physics HL", "Chemistry HL", "Spanish Ab SL"]
    var contentOrderingOptions: [String] = ["Most Recent", "Oldest", "Subject", "Overall Grade", "Percentage Marks", "Title"] //DEVELOPMENT: hide "Subject" when a specific subject is selected (?)
    
    var allAssessments: [Assessment] = [Assessment]()
    var sortedContentList: [Assessment] = [Assessment]()
    
    var currentScope: Subject?
    
    var noResultsLabel: UILabel = UILabel()
    
    //TEMPORARY
    var userSubjects: [(Subject, Bool)] = [(Subject.Physics, true), (Subject.Chemistry, true), (Subject.SpanishAb, false)]
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //regist XIB for usage
        bodyTableView.register(UINib(nibName: "AssessmentCell", bundle: Bundle.main), forCellReuseIdentifier: "AssessmentCell")
        
        //setup delegates
        searchBar.delegate = self
        bodyTableView.delegate = self
        bodyTableView.dataSource = self
        
        //UI setup
        setupPickerViews()
        setupNoResultsLabel()
        setupSearchBar()
        setupHeaderViews()
        
        
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
 
        var indexPaths: [IndexPath] = [IndexPath]()
        
        for assessment in sortedContentList {
           
            let indexPath = IndexPath(row: sortedContentList.index(of: assessment)!, section: 0)
            indexPaths.append(indexPath)
            
        }
        
        bodyTableView.insertRows(at: indexPaths, with: .automatic)
        
        
        //set the list to "Most Recent" initially
        sortedContentList = allAssessments.sorted { $0.date > $1.date }
        bodyTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.automatic)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView Delegate Funcs
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //will I be creating sections for each subject? (when ordered by subject)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedContentList.count //temporary, will change if multiple sections are added
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AssessmentCell = tableView.dequeueReusableCell(withIdentifier: "AssessmentCell") as! AssessmentCell
        
        configureCell(cell: cell, assessment: sortedContentList[indexPath.row])
        
        return cell
        
    }
    
    // MARK: - UITableView Helper Funcs
    
    func configureCell(cell: AssessmentCell, assessment: Assessment){
        
        cell.isUserInteractionEnabled = false
        
        let mainView = cell.recentAssessmentView
        mainView?.awakeFromNib()
        mainView?.updateLabels(assessment: assessment)
        
    }
    
    // MARK: - UISearchBar Delegate Funcs
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateContent()
    }
    
    //MARK: - UIPickerView Delegate Funcs
    
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
        
        if pickerView.tag == 1 { //Content selection pickerview
            
            contentSelectionTextField.text = contentSelectionOptions[row]
        } else if pickerView.tag == 2 { //Ordering pickerview
            contentOrderingTextField.text = contentOrderingOptions[row]
            
        }
        
    }
    
    // MARK: - Sorting Mechanisms
    
    func updateContent() {
        
        if let scope = currentScope {
            let content = allAssessments.filter { assessment in {
                return assessment.subject.0 == scope
                }()
                
            }
            sortContent(content: content)
            
        } else {
            sortContent(content: allAssessments)
        }
        
    }
    
    func sortContent(content: [Assessment]) {
        
        if searchBar.text == nil || searchBar.text == "" { //if no search
            noResultsLabel.removeFromSuperview()
            sortByHeaderPreference(content: content)
        } else { //if search is in progress
            let searchContent: [Assessment]
            searchContent = content.filter { assessment in {
                return assessment.assessmentTitle.lowercased().contains(searchBar.text!.lowercased())
                }()
            }
            if searchContent.count == 0 { //if no results match the string
                bodyTableView.addSubview(noResultsLabel)
            } else {
                noResultsLabel.removeFromSuperview()
            }
            
            sortByHeaderPreference(content: searchContent)
        }
        
    }
    
    //takes a custom list of assessments and sorts them according to user preference (from the header view)
    func sortByHeaderPreference(content: [Assessment]){
        if contentOrderingTextField.text == "Most Recent" {
            sortedContentList = content.sorted { $0.date > $1.date }
            bodyTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
        } else if contentOrderingTextField.text == "Oldest" {
            sortedContentList = content.sorted { $0.date < $1.date }
            bodyTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
        } else if contentOrderingTextField.text == "Subject" {
            sortedContentList = content.sorted { $0.subject.0.sortIndex > $1.subject.0.sortIndex }
            bodyTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
        } else if contentOrderingTextField.text == "Overall Grade" {
            sortedContentList = content.sorted { $0.overallGrade > $1.overallGrade }
            bodyTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
        } else if contentOrderingTextField.text == "Percentage Marks" {
            sortedContentList = content.sorted { $0.percentageMarksObtained > $1.percentageMarksObtained }
            bodyTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
        } else if contentOrderingTextField.text == "Title" {
            sortedContentList = content.sorted { $0.assessmentTitle < $1.assessmentTitle }
            bodyTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
        }
        
    }
    
    func donePressedContentSelectionPickerView(){
        contentSelectionTextField.resignFirstResponder()
        
        for subject in userSubjects {
            var hlString = ""
            if subject.1 == true {
                hlString = " HL"
            } else {
                hlString = " SL"
            }
            if subject.0.rawValue + hlString == contentSelectionTextField.text! {
                currentScope = subject.0
                updateContent()
            }
        }
    }
    func donePressedContentOrderingPickerView(){
        contentOrderingTextField.resignFirstResponder()
        updateContent()
    }
    
    func clearPressedContentSelectionPickerView(){
        contentSelectionTextField.resignFirstResponder()
        contentSelectionTextField.text = ""
        currentScope = nil
    }
    func clearPressedContentOrderingPickerView(){
        contentOrderingTextField.resignFirstResponder()
        contentOrderingTextField.text = ""
    }
    
    // MARK: - UI Setup
    
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
    
    func setupNoResultsLabel() {
        
        noResultsLabel = UILabel(frame: CGRect(x: bodyTableView.center.x - 50, y: bodyTableView.center.y - 10, width: 100, height: 20))
        noResultsLabel.font = UIFont(name: "AvenirNext", size: 16)
        noResultsLabel.text = "No Results"
        noResultsLabel.textAlignment = .center
        
    }
    
    func setupSearchBar() {
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            glassIconView.tintColor = UIColor.red
            
        }
    }
    
    func setupHeaderViews() {
        filterView.drawBorder(orientation: .Bottom, color: .black, thickness: 0.5)
        
        //create underline graphic for header text fields
        contentSelectionTextField.underlined()
        contentOrderingTextField.underlined()
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

}







