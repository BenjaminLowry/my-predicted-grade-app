//
//  HomeViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/17/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var bodyTitleView: BorderedView!
    
    @IBOutlet weak var bodyTableView: UITableView!
    
    @IBOutlet weak var leftHeaderView: BorderedView!
    
    var recentAssessments = [Assessment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set-up headerView shadow
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 4
        headerView.layer.shadowColor = UIColor.black.cgColor
        
        //draw borders for custom "BorderedViews"
        leftHeaderView.drawBorder(orientation: .Right, color: UIColor.black, thickness: 1)
        bodyTitleView.drawBorder(orientation: .Bottom, color: UIColor.black, thickness: 1.5)
        
        bodyTableView.delegate = self
        bodyTableView.dataSource = self
        
        var date = Date(timeIntervalSince1970: TimeInterval(exactly: 55230549.00)!)
        var physicsTest = Assessment(assessmentTitle: "Forces & Mechanics Test", subject: .Physics, date: date, marksAvailable: 45, marksReceived: 36)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recentAssessments.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomAssessmentCell") as! CustomAssessmentCell //possible error thrown here
        
        let assessment = recentAssessments[indexPath.row]
        
        configureCell(cell: cell, assessment: assessment)
        
        return cell
        
    }
    
    func configureCell(cell: CustomAssessmentCell, assessment: Assessment){
        
        let mainView = cell.recentAssessmentView
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

