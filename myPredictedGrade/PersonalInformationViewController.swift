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
    
    @IBOutlet weak var yearLevelPickerView: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIBarButtonItem!
    
    // MARK: PickerView Data
    
    var data = ["Year 12", "Year 13"]
    
    // MARK: - Data Collection Variables
    
    var name: String?
    var yearLevel: YearLevelObject? = YearLevelObject(yearLevel: .year12)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.attributedPlaceholder = NSAttributedString(string: "e.g. Jeremy Young",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        
        yearLevelPickerView.delegate = self
        yearLevelPickerView.dataSource = self
        
    }
    
    @IBAction func continueButtonPressed(_ sender: UIBarButtonItem) {
        
        if let text = nameTextField.text {
            
            // If the text contains something other than whitespaces and newlines
            if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                
                name = text
                performSegue(withIdentifier: "Continue", sender: self)
                return
                
            }
            
        }
        
        let alertController = UIAlertController(title: "Error", message: "Please enter a valid name", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(alertAction)
        
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navVC = segue.destination as? UINavigationController {
            
            if let destinationVC = navVC.viewControllers[0] as? SchoolSelectionViewController {
                
                destinationVC.name = self.name
                destinationVC.yearLevel = self.yearLevel
                
            }
            
        }
        
    }

}
