//
//  SubjectSelectionTableViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 6/6/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class SubjectSelectionTableViewController: UITableViewController {

    var subjectList: [[SubjectObject.Subject]] = [[SubjectObject.Subject.ChineseALit, SubjectObject.Subject.ChineseALangLit, SubjectObject.Subject.EnglishALit, SubjectObject.Subject.EnglishALangLit], [SubjectObject.Subject.ChineseAb, SubjectObject.Subject.ChineseB, SubjectObject.Subject.FrenchAb, SubjectObject.Subject.FrenchB, SubjectObject.Subject.GermanAb, SubjectObject.Subject.GermanB, SubjectObject.Subject.SpanishAb, SubjectObject.Subject.SpanishB], [SubjectObject.Subject.BusinessManagement, SubjectObject.Subject.Economics, SubjectObject.Subject.Geography, SubjectObject.Subject.GlobalPolitics, SubjectObject.Subject.History, SubjectObject.Subject.InformationTechonologyinaGlobalSociety, SubjectObject.Subject.Philosophy, SubjectObject.Subject.Psychology, SubjectObject.Subject.SocialandCulturalAnthropology, SubjectObject.Subject.WorldReligions], [SubjectObject.Subject.Biology, SubjectObject.Subject.Chemistry, SubjectObject.Subject.ComputerScience, SubjectObject.Subject.DesignTechnology, SubjectObject.Subject.EnvironmentalSystemsandSocities, SubjectObject.Subject.Physics, SubjectObject.Subject.SportsExcerciseandHealthScience], [SubjectObject.Subject.FurtherMathematics, SubjectObject.Subject.Mathematics, SubjectObject.Subject.MathematicsStudies], [SubjectObject.Subject.Biology, SubjectObject.Subject.BusinessManagement, SubjectObject.Subject.Chemistry, SubjectObject.Subject.ComputerScience, SubjectObject.Subject.Dance, SubjectObject.Subject.DesignTechnology, SubjectObject.Subject.Economics, SubjectObject.Subject.EnvironmentalSystemsandSocities, SubjectObject.Subject.Film, SubjectObject.Subject.Geography, SubjectObject.Subject.GlobalPolitics, SubjectObject.Subject.History, SubjectObject.Subject.InformationTechonologyinaGlobalSociety, SubjectObject.Subject.Music, SubjectObject.Subject.Music, SubjectObject.Subject.MusicCreating, SubjectObject.Subject.Philosophy, SubjectObject.Subject.Physics, SubjectObject.Subject.Psychology, SubjectObject.Subject.SocialandCulturalAnthropology, SubjectObject.Subject.SportsExcerciseandHealthScience, SubjectObject.Subject.Theatre, SubjectObject.Subject.VisualArts, SubjectObject.Subject.WorldReligions]]
    
    let groupNames = ["Group 1: Language and Literature", "Group 2: Language Acquisition", "Group 3: Individuals and Societies", "Group 4: Sciences", "Group 5: Mathematics", "Group 6: The Arts (+ Others)"]
    
    var groupSubjectToggle = [false, false, false, false, false, false]
    var groupSubjectSelection = [SubjectObject.Subject.Default, SubjectObject.Subject.Default, SubjectObject.Subject.Default, SubjectObject.Subject.Default, SubjectObject.Subject.Default, SubjectObject.Subject.Default]
    var subjectHLList = [false, false, false, false, false, false]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TableView Delegate Funcions

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectList[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Subject Cell", for: indexPath)

        let subjectTitleLabel = cell.viewWithTag(1) as! UILabel
        
        let subject = subjectList[indexPath.section][indexPath.row] 

        subjectTitleLabel.text = subject.rawValue
        subjectTitleLabel.adjustsFontSizeToFitWidth = true
        
        let mainSwitch = cell.viewWithTag(4) as! UISwitch
        let HLLabel = cell.viewWithTag(2) as! UILabel
        let HLSwitch = cell.viewWithTag(3) as! UISwitch
        
        // Makes sure the switches stay off if they are supposed to be off
        if groupSubjectSelection[indexPath.section] == subjectList[indexPath.section][indexPath.row] {
            mainSwitch.isOn = true
            HLLabel.isHidden = false
            HLSwitch.isHidden = false
            
            HLSwitch.isOn = subjectHLList[indexPath.section]
        } else {
            mainSwitch.isOn = false
            HLLabel.isHidden = true
            HLSwitch.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupNames[section]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navigationVC = segue.destination as? UINavigationController {
            
            if let destinationVC = navigationVC.viewControllers[0] as? ColorSelectionViewController {
                
                var subjectList: [SubjectObject] = []
                
                for i in 0..<groupSubjectSelection.count {
                    
                    subjectList.append(SubjectObject(subject: groupSubjectSelection[i], isHL: subjectHLList[i]))
                    
                }
                
                /*
                let subject1 = SubjectObject(subject: .Mathematics, isHL: true)
                let subject2 = SubjectObject(subject: .Physics, isHL: true)
                let subject3 = SubjectObject(subject: .Chemistry, isHL: true)
                let subject4 = SubjectObject(subject: .Economics, isHL: true)
                let subject5 = SubjectObject(subject: .EnglishALit, isHL: false)
                let subject6 = SubjectObject(subject: .SpanishAb, isHL: true)
                */
 
                destinationVC.subjects = subjectList
                
            }
            
        }
        
    }
    
    @IBAction func continueButtonPressed(_ sender: UIBarButtonItem) {
        
        if !groupSubjectToggle.contains(false) {
            
            performSegue(withIdentifier: "Continue", sender: self)
            
        } else {
            
            let alertController = UIAlertController(title: "Error", message: "Please select a subject from each group", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alertController.addAction(alertAction)
            
        }
        
    }

    @IBAction func subjectSwitchToggled(_ sender: UISwitch) {
        
        let superview = sender.superview
        let cell = superview?.superview as! UITableViewCell
        
        let indexPath = self.tableView.indexPath(for: cell)
    
        if groupSubjectToggle[(indexPath?.section)!] == true && subjectList[(indexPath?.section)!][(indexPath?.row)!] != groupSubjectSelection[(indexPath?.section)!] { // if a subject has already been selected from this group, and the user isn't trying to deselect their selected subjection
            sender.setOn(false, animated: true) // prevent the toggle, by setting the button as false
            return
        }
        
        let HLLabel = superview?.viewWithTag(2) as! UILabel
        let HLSwitch = superview?.viewWithTag(3) as! UISwitch
        
        // Have it always start off when it is toggled
        HLSwitch.isOn = false
        subjectHLList[(indexPath?.section)!] = false
        
        if sender.isOn { // if the switch has been turned on
            
            HLLabel.isHidden = false
            HLSwitch.isHidden = false
            
            // a subject has now been selected for that group
            groupSubjectToggle[(indexPath?.section)!] = true
            
            // set the selected subject in the array
            groupSubjectSelection[(indexPath?.section)!] = subjectList[(indexPath?.section)!][(indexPath?.row)!]
            
        } else { // if the switch has been turned off
            
            HLLabel.isHidden = true
            HLSwitch.isHidden = true
            
            // reset the hl switch
            HLSwitch.isOn = false
            
            // a subject now has not been selected for that group
            groupSubjectToggle[(indexPath?.section)!] = false
            
            // set the value to "nil"
            groupSubjectSelection[(indexPath?.section)!] = SubjectObject.Subject.Default
            
        }
        
    }

    
    @IBAction func HLSwitchToggled(_ sender: UISwitch) {
        
        let cell = sender.superview?.superview as! UITableViewCell
        
        let indexPath = tableView.indexPath(for: cell)
        
        subjectHLList[(indexPath?.section)!] = sender.isOn
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
