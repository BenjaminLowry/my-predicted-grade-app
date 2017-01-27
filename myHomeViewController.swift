//
//  HomeViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/17/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import UIKit

class myHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var overallGradeLabel: UILabel!
    
    @IBOutlet weak var gradeStackView: UIStackView! //full of the numbers for each subject
    
    @IBOutlet weak var bodyTitleView: BorderedView!
    
    @IBOutlet weak var bodyTableView: UITableView!
    
    @IBOutlet weak var leftHeaderView: BorderedView!
    
    // MARK: - Properties
    
    var recentAssessments = [Assessment]()
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //temporary
        AppStatus.loggedInUser = Profile(username: "Benthos", password: "benjiman", subjects: [(Subject.Physics, true), (Subject.Chemistry, false)], colorPreferences: [Subject.Physics: AppStatus.validAssessmentColors[0], Subject.Chemistry: AppStatus.validAssessmentColors[1]], assessments: [])
        
        //bodyTableView.register(UINib(nibName: "CustomAssessmentCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomAssessmentCell")
        bodyTableView.register(UINib(nibName: "AssessmentCell", bundle: Bundle.main), forCellReuseIdentifier: "AssessmentCell")
        
        //set-up headerView shadow
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 4
        headerView.layer.shadowColor = UIColor.black.cgColor
        
        //draw borders for custom "BorderedViews"
        leftHeaderView.drawBorder(orientation: .Right, color: UIColor.black, thickness: 0.5)
        bodyTitleView.drawBorder(orientation: .Bottom, color: UIColor.black, thickness: 1.5)
        
        bodyTableView.delegate = self
        bodyTableView.dataSource = self
        
    
        
        //test of tableview system
        let date = Date(timeIntervalSince1970: TimeInterval(exactly: 30549.00)!)
        let physicsTest = Assessment(assessmentTitle: "Forces & Mechanics Test", subject: .Physics, subjectIsHL: true, date: date, marksAvailable: 45, marksReceived: 36)
        recentAssessments.append(physicsTest)
        
        let newRowIndex = recentAssessments.count
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        bodyTableView.insertRows(at: indexPaths, with: .automatic)

        
        //let date = Date(timeIntervalSinceNow: 0)
        //let biologyTest = Assessment(assessmentTitle: "Cells Test", subject: .Biology, subjectIsHL: true, date: date, marksAvailable: 40, marksReceived: 34)
        //biologyTest.calculateOverallGrade()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //set the overall grade to the sum of the subject grades
        if let gradeLabels: [UILabel] = gradeStackView.subviews as? [UILabel] {
            var sum: Int = 0
            for gradeLabel in gradeLabels {
                let subjectGrade: Int = Int(gradeLabel.text!)! //may fail: NEEDS ERROR HANDLING
                sum += subjectGrade
            }
            overallGradeLabel.text = String(sum)
        }
        
    }
    
    // MARK: - UITableView Delegate Funcs
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recentAssessments.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AssessmentCell = tableView.dequeueReusableCell(withIdentifier: "AssessmentCell") as! AssessmentCell
        cell.recentAssessmentView.infoButton.isHidden = true
        cell.recentAssessmentView.infoButton.isUserInteractionEnabled = false
        
        let assessment = recentAssessments[indexPath.row]
        
        configureCell(cell: cell, assessment: assessment)
        
        return cell
        
    }
    
    // MARK: - Configuration Funcs
    
    func configureCell(cell: AssessmentCell, assessment: Assessment){
        
        let mainView = cell.recentAssessmentView
        mainView?.awakeFromNib()
        mainView?.updateLabels(assessment: assessment)
        
    }

}

