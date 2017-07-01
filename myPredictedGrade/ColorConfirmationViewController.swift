//
//  ColorConfirmationViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 6/30/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class ColorConfirmationViewController: UITableViewController {

    var subjects: [SubjectObject]!
    var colorPreferences: [SubjectObject: UIColor]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //register XIB for usage
        self.tableView.register(UINib(nibName: "AssessmentCell", bundle: Bundle.main), forCellReuseIdentifier: "AssessmentCell")

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssessmentCell") as! AssessmentCell
        
        cell.recentAssessmentView.asssessmentTitleLabel.text = "My \(subjects![indexPath.row].toString()) Assessment"
        cell.recentAssessmentView.subjectDateLabel.text = "\(subjects![indexPath.row].toString()) 18th of March 2017"
        
        cell.recentAssessmentView.updateView(for: colorPreferences[subjects![indexPath.row]]!)
        
        return cell
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
    
        dismiss(animated: true, completion: nil)
    
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
