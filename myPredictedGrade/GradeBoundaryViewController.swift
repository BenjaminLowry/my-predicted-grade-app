//
//  GradeBoundaryViewController.swift
//  
//
//  Created by Ben LOWRY on 12/8/17.
//
//

import UIKit

class GradeBoundaryViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var subjectTitleLabel: UILabel!
    
    @IBOutlet weak var gradeTitleLabel: UILabel!
    @IBOutlet weak var lowTitleLabel: UILabel!
    @IBOutlet weak var highTitleLabel: UILabel!
    
    @IBOutlet weak var borderedView: BorderedView!
    
    @IBOutlet weak var cell7: UITableViewCell!
    @IBOutlet weak var cell6: UITableViewCell!
    @IBOutlet weak var cell5: UITableViewCell!
    @IBOutlet weak var cell4: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell1: UITableViewCell!
    
    @IBOutlet weak var subjectTitleCell: UITableViewCell!
    @IBOutlet weak var titleCell: UITableViewCell!
    
    // Boundaries Text Fields
    @IBOutlet weak var low7: UITextField!
    @IBOutlet weak var low6: UITextField!
    @IBOutlet weak var high6: UITextField!
    @IBOutlet weak var low5: UITextField!
    @IBOutlet weak var high5: UITextField!
    @IBOutlet weak var low4: UITextField!
    @IBOutlet weak var high4: UITextField!
    @IBOutlet weak var low3: UITextField!
    @IBOutlet weak var high3: UITextField!
    @IBOutlet weak var low2: UITextField!
    @IBOutlet weak var high2: UITextField!
    @IBOutlet weak var high1: UITextField!
    
    var cells = [UITableViewCell]()
    
    var boundariesTextFields = [UITextField]()
    
    var subjectObject: SubjectObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cells = [cell7, cell6, cell5, cell4, cell3, cell2, cell1, subjectTitleCell, titleCell]
        
        boundariesTextFields = [low7, high6, low6, high5, low5, high4, low4, high3, low3, high2, low2, high1]
        
        let subjectColor = AppStatus.user.colorPreferences[self.subjectObject]!
        
        subjectTitleLabel.textColor = subjectColor
        subjectTitleLabel.text = subjectObject.toString()
        
        gradeTitleLabel.textColor = subjectColor
        lowTitleLabel.textColor = subjectColor
        highTitleLabel.textColor = subjectColor
        
        let currentGradeBoundaries = AppStatus.user.getGradeBoundaries()
        let currentBoundariesForSubject = currentGradeBoundaries[self.subjectObject]!
        
        var timezone = ""
        if currentBoundariesForSubject.keys.count == 1 {
            timezone = "TZ0"
        } else if currentBoundariesForSubject.keys.count == 2 {
            timezone = "TZ1"
        }
        
        let gradeBoundaries = currentBoundariesForSubject[timezone]!["Final"]!
        
        for textField in boundariesTextFields {
            
            textField.delegate = self
            textField.keyboardType = .numberPad
            
            switch textField {
            case low7:
                textField.placeholder = String(gradeBoundaries[7]![0])
            case low6:
                textField.placeholder = String(gradeBoundaries[6]![0])
            case high6:
                textField.placeholder = String(gradeBoundaries[6]![1])
            case low5:
                textField.placeholder = String(gradeBoundaries[5]![0])
            case high5:
                textField.placeholder = String(gradeBoundaries[5]![1])
            case low4:
                textField.placeholder = String(gradeBoundaries[4]![0])
            case high4:
                textField.placeholder = String(gradeBoundaries[4]![1])
            case low3:
                textField.placeholder = String(gradeBoundaries[3]![0])
            case high3:
                textField.placeholder = String(gradeBoundaries[3]![1])
            case low2:
                textField.placeholder = String(gradeBoundaries[2]![0])
            case high2:
                textField.placeholder = String(gradeBoundaries[2]![1])
            case high1:
                textField.placeholder = String(gradeBoundaries[1]![1])
            default:
                print("Error in setting previous boundaries.")
            }
            
        }
        
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        dismissKeyboards()
        
        for textField in boundariesTextFields {
            
            if textField.text == "" {
                
                showAlert(withMessage: "One of the boundaries is empty. Please try again.")
                return
                
            } else if Int(textField.text!) != nil {} else {
                
                showAlert(withMessage: "One of the boundaries contains a non-number. Please try again.")
                return
                
            }
            
            
        }
        
        // Make sure that all of the boundaries "connect" and do not overlap
        for i in 0..<boundariesTextFields.count {
            
            if i == boundariesTextFields.count - 1 {
                continue
            }
            
            if i % 2 == 1 { // Doesn't include 0 since 0 % 2 == 2
                
                if Int(boundariesTextFields[i].text!)! <= Int(boundariesTextFields[i+1].text!)! {
                    
                    showAlert(withMessage: "A high boundary must be higher than its corresponding low boundary. Please try again.")
                    return
                    
                }
                
            } else if Int(boundariesTextFields[i].text!)! - 1 != Int(boundariesTextFields[i+1].text!)! {
                
                showAlert(withMessage: "The boundaries entered are invalid. Boundaries must include all percentages from 0 to 100 and must not overlap. Please try again.")
                return
                
            }
            
        }
        
        let newBoundaries =
            [7:
                [Int(low7.text!)!, 100],
            6:
                [Int(low6.text!)!, Int(high6.text!)!],
            5:
                [Int(low5.text!)!, Int(high5.text!)!],
            4:
                [Int(low4.text!)!, Int(high4.text!)!],
            3:
                [Int(low3.text!)!, Int(high3.text!)!],
            2:
                [Int(low2.text!)!, Int(high2.text!)!],
            1:
                [0, Int(high1.text!)!]
            ]
        
        showConfirmationAlert(newBoundaries: newBoundaries)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboards))
        self.view.addGestureRecognizer(gesture)
        
    }
    
    func showAlert(withMessage message: String) {
        
        let alert = Alert(message: message, alertType: .invalidUserResponse)
        alert.show(source: self)
        
    }
    
    func showConfirmationAlert(newBoundaries: [Int: [Int]]) {
        
        let alertController = UIAlertController(title: "Are you sure?", message: "This action cannot be undone.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Yes, change the boundaries.", style: .default, handler: { alert in
            self.changeBoundaries(newBoundaries: newBoundaries)
        })
        let denyAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(denyAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func changeBoundaries(newBoundaries: [Int: [Int]]) {
        
        let user = AppStatus.user
        user.changeGradeBoundaries(forSubject: subjectObject, withBoundaries: newBoundaries)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func dismissKeyboards() {
        for textField in boundariesTextFields {
            textField.resignFirstResponder()
        }
    }
    
    
}
