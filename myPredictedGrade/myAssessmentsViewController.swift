//
//  myAssessmentsViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/27/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import UIKit

class myAssessmentsViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, AssessmentDetailViewControllerDelegate {
    
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
    
    typealias JSONObject = [String: Any]
    
    var allAssessments: [Assessment] = [Assessment]()
    var sortedContentList: [Assessment] = [Assessment]()
    
    var currentScope: SubjectObject?
    
    var noResultsLabel: UILabel = UILabel()
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register XIB for usage
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
        
        allAssessments = (AppStatus.loggedInUser?.assessments)!
        
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! UINavigationController
        
        if let viewController = controller.topViewController as? AssessmentDetailViewController {
            viewController.delegate = self
            
            if segue.identifier == "EditAssessment" {
                
                if let cell = sender as? AssessmentCell {
                    
                    let index = bodyTableView.indexPath(for: cell)
                    
                    //set the assessment to edit as the sorted content list since sorted content list will always be the data source
                    let assessment = sortedContentList[index!.row]
                    viewController.assessmentToEdit = assessment
                    
                }
                
            }
        }
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
        
        cell.recentAssessmentView.infoButton.addTarget(self, action: #selector(segueAway(_:)), for: .touchUpInside)
        cell.recentAssessmentView.infoButton.tag = indexPath.row
        
        configureCell(cell: cell, assessment: sortedContentList[indexPath.row])
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "EditAssessment", sender: tableView.cellForRow(at: indexPath))
    }
    
    func segueAway(_ sender: UIButton){
        let cell = bodyTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0))
        performSegue(withIdentifier: "EditAssessment", sender: cell)
    }
    
    
    // MARK: - AssessmentDetailViewController Delegate Funcs
    
    func assessmentDetailViewControllerDidCancel(controller: AssessmentDetailViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func assessmentDetailViewController(controller: AssessmentDetailViewController, didFinishAddingAssessment assessment: Assessment) {
        
        allAssessments.append(assessment)
        
        currentScope = nil
        contentSelectionTextField.text = "All"
        updateContent()
        bodyTableView.reloadData()
    
        if let user = AppStatus.loggedInUser {
            
            //** Take snapshots of data **//
            
            user.assessments = allAssessments
            
            let subjectGrades = user.getSubjectGrades()
            
            for (subjectObject, grade) in subjectGrades {
                
                let subjectSnapshot = SubjectSnapshot(grade: grade, subjectObject: subjectObject)
                user.addSubjectSnapshot(snapshot: subjectSnapshot)
                
            }
            
            let overallGradeSnapshot = OverallGradeSnapshot(grade: user.getOverallGrade())
            user.addOverallGradeSnapshot(snapshot: overallGradeSnapshot)
            
        }
        
        //save changes
        AppStatus.saveData()
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func assessmentDetailViewController(controller: AssessmentDetailViewController, didFinishEditingAssessment assessment: Assessment) {
        if let index = allAssessments.index(of: assessment) {
            allAssessments[index] = assessment //update the assessment
            let indexPath = IndexPath(row: index, section: 0)
            
            if let cell = tableView(bodyTableView, cellForRowAt: indexPath) as? AssessmentCell {
                configureCell(cell: cell, assessment: assessment) //update the labels
                currentScope = nil
                contentSelectionTextField.text = "All"
                updateContent()
                bodyTableView.reloadData()
            }
            
        }
        
        if let user = AppStatus.loggedInUser {
            
            //** Take snapshots of data **//
            
            user.assessments = allAssessments
            
            let subjectGrades = user.getSubjectGrades()
            
            for (subjectObject, grade) in subjectGrades {
                
                let subjectSnapshot = SubjectSnapshot(grade: grade, subjectObject: subjectObject)
                user.addSubjectSnapshot(snapshot: subjectSnapshot)
                
            }
            
            let overallGradeSnapshot = OverallGradeSnapshot(grade: user.getOverallGrade())
            user.addOverallGradeSnapshot(snapshot: overallGradeSnapshot)
            
        }
        
        //save changes
        AppStatus.saveData()
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableView Helper Funcs
    
    func configureCell(cell: AssessmentCell, assessment: Assessment){
        
        let mainView = cell.recentAssessmentView
        mainView?.awakeFromNib()
        mainView?.updateLabels(assessment: assessment)
        
    }
    
    // MARK: - UISearchBar Delegate Funcs
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateContent()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignSearchResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignSearchResponder))
        view.addGestureRecognizer(tapGesture)
    }
    
    func resignSearchResponder() {
        searchBar.resignFirstResponder()
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
            
            for subjectObject in (AppStatus.loggedInUser?.subjects)! {
                
                if subjectObject.toString() == contentSelectionTextField.text! {
                    currentScope = subjectObject
                    updateContent()
                    return
                }
                
            }
            if contentSelectionTextField.text! == "All" {
                currentScope = nil
            }
            //if the pickerview subject does not match any subjects
            currentScope = nil
            updateContent()
        } else if pickerView.tag == 2 { //Ordering pickerview
            contentOrderingTextField.text = contentOrderingOptions[row]
            
            updateContent()
        }
        
    }
    
    // MARK: - Sorting Mechanisms
    
    func updateContent() {
        
        if let scope = currentScope { //if there is content selection
            let content = allAssessments.filter { assessment in {
                return assessment.subjectObject == scope
                }()
                
            }
            sortContent(content: content)
            
        } else if contentSelectionTextField.text! != "All" {
            sortContent(content: [])
        } else {
            sortContent(content: allAssessments)
        }
        
    }
    
    func sortContent(content: [Assessment]) {
        
        if content.isEmpty {
            bodyTableView.addSubview(noResultsLabel)
            sortedContentList.removeAll()
            bodyTableView.reloadData()
        } else if searchBar.text == nil || searchBar.text == "" { //if no search
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
            sortedContentList = content.sorted { $0.subjectObject.subject.sortIndex > $1.subjectObject.subject.sortIndex }
            bodyTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableViewRowAnimation.none)
        } else if contentOrderingTextField.text == "Overall Grade" {
            sortedContentList = content.sorted { $0.getOverallGrade() > $1.getOverallGrade() }
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
        
        for subjectObject in (AppStatus.loggedInUser?.subjects)! {
    
            if subjectObject.toString() == contentSelectionTextField.text! {
                currentScope = subjectObject
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
        
        initializePickerViewToolBar()
    }
    
    func setupNoResultsLabel() {
        
        noResultsLabel = UILabel(frame: CGRect(x: bodyTableView.center.x - 50, y: bodyTableView.center.y - 10, width: 100, height: 20))
        noResultsLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 16)
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
    
    func initializePickerViewToolBar(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        //toolBar.tintColor = UIColor.black
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: view, action: #selector(UIView.endEditing(_:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        cancelButton.tintColor = AppStatus.themeColor
        doneButton.tintColor = AppStatus.themeColor
        
        toolBar.setItems([cancelButton,flexSpace,doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        contentSelectionTextField.inputAccessoryView = toolBar
        contentOrderingTextField.inputAccessoryView = toolBar
        
    }

}







