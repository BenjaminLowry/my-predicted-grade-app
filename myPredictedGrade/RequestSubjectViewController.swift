//
//  RequestSubjectViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 7/3/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class RequestSubjectViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailButton: UIButton!

    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    // MARK: - IBActions
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {
        
        // Opens a new draft email to me in mail app
        let email = "benjaminpaullowry.appdev@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
