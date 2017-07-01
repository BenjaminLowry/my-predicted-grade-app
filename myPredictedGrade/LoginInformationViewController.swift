//
//  LoginInformationViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 6/10/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class LoginInformationViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.attributedPlaceholder = NSAttributedString(string: "e.g. \"CAS Master\"",
                                                                 attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "e.g. \"IB454eva\"",
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        // Do any additional setup after loading the view.
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
