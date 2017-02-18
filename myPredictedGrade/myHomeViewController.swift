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
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //temporary
        AppStatus.loggedInUser = Profile(username: "Benthos", password: "benjiman", yearLevel: YearLevel.year12, subjects: [(Subject.Physics, true), (Subject.Chemistry, true), (Subject.Mathematics, true), (Subject.Economics, true), (Subject.InformationTechonologyinaGlobalSociety, false), (Subject.SpanishAb, false)], colorPreferences: [Subject.Physics: AppStatus.validAssessmentColors[0], Subject.Chemistry: AppStatus.validAssessmentColors[1], Subject.Mathematics: AppStatus.validAssessmentColors[2], Subject.Economics: AppStatus.validAssessmentColors[3], Subject.SpanishAb: AppStatus.validAssessmentColors[4], Subject.InformationTechonologyinaGlobalSociety: AppStatus.validAssessmentColors[5]], assessments: [])
        
        //create assessment
        let date = Date(timeIntervalSince1970: TimeInterval(exactly: 30549.00)!)
        let physicsTest = Assessment(assessmentTitle: "Forces & Mechanics Test", subject: .Physics, subjectIsHL: true, date: date, marksAvailable: 45, marksReceived: 31)
        
        AppStatus.loggedInUser?.assessments = [physicsTest]
        
        //bodyTableView.register(UINib(nibName: "CustomAssessmentCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomAssessmentCell")
        bodyTableView.register(UINib(nibName: "AssessmentCell", bundle: Bundle.main), forCellReuseIdentifier: "AssessmentCell")
        
        
        setupHeaderView()
        
        setupAssessmentTableView()
        
        setupBodyView()
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //set the overall grade to the sum of the subject grades
        
        if let overallGrade = AppStatus.loggedInUser?.getOverallGrade() {
            overallGradeLabel.text = String(describing: overallGrade)
        }
        
        setupStackViews()
    }
    
    // MARK: - UITableView Delegate Funcs
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AssessmentCell = tableView.dequeueReusableCell(withIdentifier: "AssessmentCell") as! AssessmentCell
        cell.recentAssessmentView.infoButton.isHidden = true
        cell.recentAssessmentView.infoButton.isUserInteractionEnabled = false
        
        let assessment = mostRecentAssessment
        
        configureCell(cell: cell, assessment: assessment!)
        
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
        
        //empty the stack view
        for view in subjectStackView.subviews {
            subjectStackView.removeArrangedSubview(view)
        }
        
        var subjectArray = [Subject]()
        
        for (subject, isHL) in (AppStatus.loggedInUser?.subjects)! {
            
            let label = UILabel()
            if subject.shortName == "" {
                label.text = "\(subject.rawValue) \(isHL ? "HL" : "SL" ):"
            } else {
                label.text = subject.shortName + " \(isHL ? "HL" : "SL")"
            }
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
            label.textAlignment = .right
            label.adjustsFontSizeToFitWidth = true
            let color = AppStatus.loggedInUser?.colorPreferences[subject]
            label.textColor = color?.withAlphaComponent(0.8)
            subjectStackView.addArrangedSubview(label)
            
            subjectArray.append(subject)
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
        mostRecentAssessment = AppStatus.loggedInUser?.assessments[0]
        bodyTableView.reloadData()
        
        
        //can't scroll because only one item
        bodyTableView.isScrollEnabled = false
    }
    
    func setupBodyView() {
        bodyScrollView.contentSize = CGSize(width: self.view.frame.width, height: 736)
        bestSubjectContentLabel.adjustsFontSizeToFitWidth = true
        
        if let yearLevel = AppStatus.loggedInUser?.yearLevel {
            userLabel.text = "Benjamin Lowry - \(yearLevel.rawValue) Student"
        }
        
        if let averageGrade = AppStatus.loggedInUser?.getAverageGrade() {
            averageGradeContentLabel.text = String(describing: averageGrade)
        }
        
        if let bestSubject = AppStatus.loggedInUser?.getBestSubject() {
            bestSubjectContentLabel.text = "\(bestSubject.0) \(bestSubject.1 ? "HL" : "SL")"
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
    
    func setupHeaderView() {
        
        //set-up headerView shadow
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 4
        headerView.layer.shadowColor = UIColor.black.cgColor
        
        //draw borders for custom "BorderedViews"
        leftHeaderView.drawBorder(orientation: .Right, color: UIColor.black, thickness: 0.5)
    }

}

