//
//  DisclaimerViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 8/20/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIScreen.main.bounds.height == 568 { // iPhone 5
            textView.font = UIFont(name: "Avenir Next", size: 11)
        } else {
            textView.font = UIFont(name: "Avenir Next", size: 14)
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func agreeButtonPressed(_ sender: Any) {
        AppStatus.disclaimerSigned = true
        AppStatus.saveData()
        self.dismiss(animated: true, completion: nil)
    }

}
