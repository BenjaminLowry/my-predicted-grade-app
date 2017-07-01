//
//  HomeViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/17/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.


import UIKit

class myHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var overallGradeLabel: UILabel!
    
    @IBOutlet weak var subjectStackView: UIStackView!
    @IBOutlet weak var gradeStackView: UIStackView! //full of the numbers for each subject
    
    @IBOutlet weak var bodyTableView: UITableView!
    
    @IBOutlet weak var leftHeaderView: BorderedView!
    
    @IBOutlet weak var bodyScrollView: UIScrollView!
    
    @IBOutlet weak var userLabel: UnderlinedLabel!
    
    @IBOutlet weak var bestSubjectContentLabel: UILabel!
    @IBOutlet weak var averageGradeContentLabel: UILabel!
    @IBOutlet weak var IBPercentileContentLabel: UILabel!
    @IBOutlet weak var loggedAssessmentsContentLabel: UILabel!
    
    // MARK: - Properties
    
    var mostRecentAssessment: Assessment!
    
    var noAssessmentsLabel = UILabel()
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppStatus.loadData()
        print(AppStatus.loggedInUser?.assessments)
        //where is my assessment?
        
        let subject1 = SubjectObject(subject: .Physics, isHL: true)
        let subject2 = SubjectObject(subject: .Chemistry, isHL: true)
        let subject3 = SubjectObject(subject: .Mathematics, isHL: true)
        let subject4 = SubjectObject(subject: .Economics, isHL: true)
        let subject5 = SubjectObject(subject: .EnglishALit, isHL: false)
        let subject6 = SubjectObject(subject: .SpanishAb, isHL: false)
        
        let subjects = [subject1, subject2, subject3, subject4, subject5, subject6]
        
        let yearLevelObject = YearLevelObject(yearLevel: .year12)
        
        //temporary
        AppStatus.loggedInUser = Profile(name: "Benthos", yearLevelObject: yearLevelObject, subjects: subjects, colorPreferences: [subject1: AppStatus.validAssessmentColors[0], subject2: AppStatus.validAssessmentColors[1], subject3: AppStatus.validAssessmentColors[2], subject4: AppStatus.validAssessmentColors[3], subject6: AppStatus.validAssessmentColors[4], subject5: AppStatus.validAssessmentColors[5]], assessments: [])
        
        bodyTableView.register(UINib(nibName: "AssessmentCell", bundle: Bundle.main), forCellReuseIdentifier: "AssessmentCell")
        
        //UI setup
        setupNoAssessmentsLabel()
        setupHeaderView()
        setupAssessmentTableView()
        setupBodyView()
        bodyScrollView.contentSize = CGSize(width: self.view.frame.width, height: 736)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set the overall grade to the sum of the subject grades
        
        if let overallGrade = AppStatus.loggedInUser?.getOverallGrade() {
            overallGradeLabel.text = String(describing: overallGrade)
        }
        
        setupAssessmentTableView()
        setupStackViews()
        setupBodyView()
    }
    
    // MARK: - UITableView Delegate Funcs
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mostRecentAssessment != nil) ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AssessmentCell = tableView.dequeueReusableCell(withIdentifier: "AssessmentCell") as! AssessmentCell
        cell.recentAssessmentView.infoButton.isHidden = true
        cell.recentAssessmentView.infoButton.isUserInteractionEnabled = false
        
        if let assessment = mostRecentAssessment {
            configureCell(cell: cell, assessment: assessment)
        }
        
        return cell
        
    }
    
    // MARK: - Configuration Funcs
    
    func configureCell(cell: AssessmentCell, assessment: Assessment){
        
        let mainView = cell.recentAssessmentView
        mainView?.awakeFromNib()
        mainView?.updateLabels(assessment: assessment)
        
    }
    
    // MARK: - UI Setup
    
    func setupStackViews() {
        
        //print("number of assessments: \(AppStatus.loggedInUser?.assessments.count)")
        
        //empty the stack view
        for view in subjectStackView.subviews {
            subjectStackView.removeArrangedSubview(view)
        }
        
        var subjectArray = [SubjectObject]()
        
        for subjectObject in (AppStatus.loggedInUser?.subjects)! {
            
            let label = UILabel()
            if subjectObject.subject.shortName == "" {
                label.text = subjectObject.toString()
            } else {
                label.text = subjectObject.toShortString()
            }
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
            label.textAlignment = .right
            label.adjustsFontSizeToFitWidth = true
            let color = AppStatus.loggedInUser?.colorPreferences[subjectObject]
            label.textColor = color?.withAlphaComponent(0.8)
            subjectStackView.addArrangedSubview(label)
            
            subjectArray.append(subjectObject)
        }
        
        for view in gradeStackView.subviews {
            gradeStackView.removeArrangedSubview(view)
        }
        
        let subjectGrades = AppStatus.loggedInUser?.getSubjectGrades()
        
        for subject in subjectArray {
            
            let label = UILabel()
            
            if let grade = subjectGrades?[subject] {
                label.text = "\(grade)"
            } else {
                label.text = "?"
            }
            
            label.font = UIFont(name: "AvenirNext-Medium", size: 17)
            label.textAlignment = .center
            gradeStackView.addArrangedSubview(label)
            
        }
        
    }
    
    
    func setupAssessmentTableView() {
        
        bodyTableView.delegate = self
        bodyTableView.dataSource = self
        
        //get the most recent assessment
        print(AppStatus.loggedInUser?.name)
        if AppStatus.loggedInUser?.assessments.count == 0 { //if they haven't logged any assessments yet
            bodyScrollView.addSubview(noAssessmentsLabel)
            bodyTableView.reloadData()
        } else {
            noAssessmentsLabel.removeFromSuperview()
            mostRecentAssessment = AppStatus.loggedInUser?.assessments[0]
            bodyTableView.reloadData()
        }
        
        //can't scroll because only one item
        bodyTableView.isScrollEnabled = false
    }
    
    func setupBodyView() {
        bestSubjectContentLabel.adjustsFontSizeToFitWidth = true
        
        if AppStatus.loggedInUser?.assessments.count == 0 { //if there are no logged assessments
            averageGradeContentLabel.text = "N/A"
            bestSubjectContentLabel.text = "N/A"
            loggedAssessmentsContentLabel.text = "0"
            IBPercentileContentLabel.text = "N/A"
            return
        }
        
        if let yearLevelObject = AppStatus.loggedInUser?.yearLevelObject {
            userLabel.text = "Benjamin Lowry - \(yearLevelObject.yearLevel.rawValue) Student"
        }
        
        if let averageGrade = AppStatus.loggedInUser?.getAverageGrade() {
            let averageGradeInt: Int = Int(averageGrade * 10.0)
            averageGradeContentLabel.text = String(describing: Double(averageGradeInt) / 10.0)
        }
        
        if let bestSubject = AppStatus.loggedInUser?.getBestSubject() {
            bestSubjectContentLabel.text = bestSubject.toString()
        }
        
        if let assessmentsCount = AppStatus.loggedInUser?.assessments.count {
            loggedAssessmentsContentLabel.text = String(assessmentsCount)
        }
        
        if let overallGrade = AppStatus.loggedInUser?.getOverallGrade() {
            if overallGrade >= 24 {
                let gradePercentile = getGradePercentile(grade: overallGrade)
                IBPercentileContentLabel.text = String(gradePercentile)
            } else {
                IBPercentileContentLabel.text = "N/A"
            }
            
        }
        
    }
    
    func getGradePercentile(grade: Int) -> Double {
        
        var percentile = 0.0
        
        typealias JSONObject = [String: Any]
        
        if let url = Bundle.main.url(forResource: "gradePercentiles", withExtension: "json") {
            
            do {
                
                let data = try Data(contentsOf: url)
                
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSONObject {
                    
                    if let percentilesDictionary = jsonObject["Percentiles"] as? JSONObject {
                        
                        if let value = percentilesDictionary[String(grade)] as? Double {
                            
                            percentile = value
                            
                        }
                        
                    }
                    
                }
                
                
            } catch {
                print(error)
            }
            
        }
        
        return percentile
    }
    
    func setupNoAssessmentsLabel() {
        
        noAssessmentsLabel = UILabel(frame: CGRect(x: self.bodyTableView.frame.origin.x, y: self.bodyTableView.frame.origin.y, width: UIScreen.main.bounds.width, height: self.bodyTableView.frame.height))
        noAssessmentsLabel.text = "No Assessments Yet!"
        noAssessmentsLabel.font = UIFont(name: "AvenirNext-UltraLight", size: 16)
        noAssessmentsLabel.textAlignment = .center
        
    }
    
    func setupHeaderView() {
        
        //set-up headerView shadow
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 4
        headerView.layer.shadowColor = UIColor.black.cgColor
        
        //draw borders for custom "BorderedViews"
        leftHeaderView.drawBorder(orientation: .Right, color: UIColor.black, thickness: 0.5)
    }

}

