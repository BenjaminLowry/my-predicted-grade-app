//
//  LandingViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 6/1/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    @IBOutlet weak var loginRedirectionButton: UnderlinedLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let yearLevel = YearLevelObject(yearLevel: .year12)
        let subject = SubjectObject(subject: .Default, isHL: false)
        let assessment = Assessment(assessmentTitle: "This is not an assessment", subjectObject: subject, date: Date.init(timeIntervalSinceNow: 0), marksAvailable: 666, marksReceived: 0)
        let newProfile = Profile(name: "John Doe", yearLevelObject: yearLevel, subjects: [subject], colorPreferences: [subject: UIColor.darkGray], assessments: [assessment])
        
        AppStatus.loggedInUser = newProfile
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        loginRedirectionButton.text = "Already have an account? Login here"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
