//
//  PersonalInformationViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 6/8/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class PersonalInformationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var yearLevelPickerView: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIBarButtonItem!
    
    // MARK: - Properites
    
    var data = ["Year 12 / 11th Grade", "Year 13 / 12th Grade"]
    
    var name: String?
    var yearLevel: YearLevelObject? = YearLevelObject(yearLevel: .year12)
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.attributedPlaceholder = NSAttributedString(string: "e.g. Jeremy Young",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        yearLevelPickerView.delegate = self
        yearLevelPickerView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    // MARK: - IBActions
    
    @IBAction func continueButtonPressed(_ sender: UIBarButtonItem) {
        
        if let text = nameTextField.text {
            
            // If the text contains something other than whitespaces and newlines
            if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                name = text
                performSegue(withIdentifier: "Continue", sender: self)
                return
            }
            
        }
        
        let alert = Alert(message: "Please enter a valid name.", alertType: .invalidUserResponse)
        alert.show(source: self)
        return
        
    }

    // MARK: - UIPickerView Delegation Funcs
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = data[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Avenir Next", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if data[row] == "Year 12" {
            yearLevel = YearLevelObject(yearLevel: .year12)
        } else if data[row] == "Year 13" {
            yearLevel = YearLevelObject(yearLevel: .year13)
        }
        
    }
    
    // MARK: - UITextField Helper Funcs
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if UIScreen.main.bounds.height == 568 {
            self.view.frame.origin.y = -130 // Move view 130 points upward
        } else {
            self.view.frame.origin.y = -100 // Move view 100 points upward
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navVC = segue.destination as? UINavigationController {
            
            if let destinationVC = navVC.viewControllers[0] as? SubjectSelectionTableViewController {
                
                destinationVC.name = self.name
                destinationVC.yearLevel = self.yearLevel
                
            }
            
        }
        
    }

}
