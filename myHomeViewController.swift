//
//  HomeViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/17/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import UIKit

class myHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var overallGradeLabel: UILabel!
    
    @IBOutlet weak var gradeStackView: UIStackView! //full of the numbers for each subject
    
    @IBOutlet weak var bodyTitleView: BorderedView!
    
    @IBOutlet weak var bodyTableView: UITableView!
    
    @IBOutlet weak var leftHeaderView: BorderedView!
    
    var recentAssessments = [Assessment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bodyTableView.register(UINib(nibName: "CustomAssessmentCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomAssessmentCell")
        bodyTableView.register(UINib(nibName: "TestTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TestCell")
        
        //set-up headerView shadow
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 4
        headerView.layer.shadowColor = UIColor.black.cgColor
        
        //draw borders for custom "BorderedViews"
        leftHeaderView.drawBorder(orientation: .Right, color: UIColor.black, thickness: 1)
        bodyTitleView.drawBorder(orientation: .Bottom, color: UIColor.black, thickness: 1.5)
        
        bodyTableView.delegate = self
        bodyTableView.dataSource = self
        
        /*
        
        //test of tableview system
        let date = Date(timeIntervalSince1970: TimeInterval(exactly: 30549.00)!)
        let physicsTest = Assessment(assessmentTitle: "Forces & Mechanics Test", subject: .Physics, subjectIsHL: true, date: date, marksAvailable: 45, marksReceived: 36)
        recentAssessments.append(physicsTest)
        
        let newRowIndex = recentAssessments.count
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        bodyTableView.insertRows(at: indexPaths, with: .automatic)
 
 */
        
        let date = Date(timeIntervalSinceNow: 0)
        let biologyTest = Assessment(assessmentTitle: "Cells Test", subject: .Biology, subjectIsHL: true, date: date, marksAvailable: 40, marksReceived: 34)
        biologyTest.calculateOverallGrade()
        
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recentAssessments.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell: CustomAssessmentCell = tableView.dequeueReusableCell(withIdentifier: "CustomAssessmentCell") as! CustomAssessmentCell //possible error thrown here
        let cell: TestTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TestCell") as! TestTableViewCell
        //cell.mainCell.awakeFromNib()
        
        let press = UILongPressGestureRecognizer(target: self, action: #selector(handlePress))
        press.minimumPressDuration = 2.0 //however long you want
        cell.addGestureRecognizer(press)
        
        let assessment = recentAssessments[indexPath.row]
        
        configureCell(cell: cell, assessment: assessment)
        
        return cell
        
    }
    
    func handlePress() {
        
    }
    
    func configureCell(cell: TestTableViewCell, assessment: Assessment){
        
        let mainView = cell.recentAssessmentView
        mainView?.awakeFromNib()
        mainView?.updateLabels(assessment: assessment)
        
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

