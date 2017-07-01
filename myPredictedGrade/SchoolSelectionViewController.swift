//
//  SchoolSelectionViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 6/8/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class SchoolSelectionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var schoolPickerView: UIPickerView!
    
    var schools = ["Sha Tin College", "Renaissance College", "King George V School", "South Island School", "West Island School", "Island School", "Discovery College", "Discovery Bay International School", "Chinese International School", "French International School", "Singapore International School", "German Swiss International School", "Hong Kong Academy", "Hong Kong International School", "International College Hong Hong", "Australian International School Hong Kong", "American International School"]
    
    var name: String!
    var yearLevel: YearLevelObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        schoolPickerView.delegate = self
        schoolPickerView.dataSource = self
        
        schools.sort()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schools.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return schools[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = schools[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Avenir Next", size: 15.0)!,NSForegroundColorAttributeName:UIColor.white])
        return myTitle
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
