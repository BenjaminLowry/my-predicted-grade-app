//
//  ChooseSubjectsViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 3/30/18.
//  Copyright © 2018 Ben LOWRY. All rights reserved.
//

import UIKit

class ChooseSubjectsViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var group1Cell: UITableViewCell!
    @IBOutlet weak var group2Cell: UITableViewCell!
    @IBOutlet weak var group3Cell: UITableViewCell!
    @IBOutlet weak var group4Cell: UITableViewCell!
    @IBOutlet weak var group5Cell: UITableViewCell!
    @IBOutlet weak var group6Cell: UITableViewCell!
    
    @IBOutlet weak var group1SubjectLabel: UILabel!
    @IBOutlet weak var group2SubjectLabel: UILabel!
    @IBOutlet weak var group3SubjectLabel: UILabel!
    @IBOutlet weak var group4SubjectLabel: UILabel!
    @IBOutlet weak var group5SubjectLabel: UILabel!
    @IBOutlet weak var group6SubjectLabel: UILabel!
    
    @IBOutlet var subjectSelectorView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var groupLabel: UILabel!
    
    var visualEffectView: UIVisualEffectView!
    
    var selectedGroup: Int? = nil
    var searchContent: [SubjectObject.Subject] = []
    
    var tableCells: [UITableViewCell] = []
    var tableLabels: [UILabel] = []

    var chosenSubjects: [UILabel: SubjectObject?] = [:]
    
    var subjectList: [[SubjectObject.Subject]] = [
        // Group 1
        [ SubjectObject.Subject.ArabicALit, SubjectObject.Subject.ArabicALangLit, SubjectObject.Subject.ChineseALit, SubjectObject.Subject.ChineseALangLit, SubjectObject.Subject.CatalanALit, SubjectObject.Subject.DanishALit, SubjectObject.Subject.DutchALit, SubjectObject.Subject.DutchALangLit,
          SubjectObject.Subject.EnglishALit, SubjectObject.Subject.EnglishALangLit,
          SubjectObject.Subject.FinnishALit, SubjectObject.Subject.FrenchALit,
          SubjectObject.Subject.FrenchALangLit, SubjectObject.Subject.GermanALit,
          SubjectObject.Subject.GermanALangLit, SubjectObject.Subject.IndonesianALit,
          SubjectObject.Subject.IndonesianALangLit, SubjectObject.Subject.ItalianALit,
          SubjectObject.Subject.JapaneseALit, SubjectObject.Subject.JapaneseALangLit,
          SubjectObject.Subject.KoreanALit, SubjectObject.Subject.LiteraturePerformance,
          SubjectObject.Subject.MalayALit, SubjectObject.Subject.ModernGreekALit,
          SubjectObject.Subject.NorwegianALit, SubjectObject.Subject.PolishALit,
          SubjectObject.Subject.PortugueseALangLit, SubjectObject.Subject.RussianALit,
          SubjectObject.Subject.SpanishALit, SubjectObject.Subject.SpanishALangLit,
          SubjectObject.Subject.SwedishALit, SubjectObject.Subject.SwedishALangLit,
          SubjectObject.Subject.ThaiALangLit, SubjectObject.Subject.TurkishALit],
        // Group 2
        [SubjectObject.Subject.ArabicAb, SubjectObject.Subject.ArabicB, SubjectObject.Subject.CantoneseB, SubjectObject.Subject.ChineseALangLit, SubjectObject.Subject.ChineseALit, SubjectObject.Subject.DanishB, SubjectObject.Subject.DutchB, SubjectObject.Subject.EnglishALangLit, SubjectObject.Subject.EnglishALit,  SubjectObject.Subject.EnglishAb, SubjectObject.Subject.EnglishB, SubjectObject.Subject.FrenchALangLit, SubjectObject.Subject.FrenchALit, SubjectObject.Subject.FrenchAb, SubjectObject.Subject.FrenchB, SubjectObject.Subject.GermanALit, SubjectObject.Subject.GermanALangLit, SubjectObject.Subject.GermanAb, SubjectObject.Subject.GermanB, SubjectObject.Subject.HindiB, SubjectObject.Subject.IndonesianALit, SubjectObject.Subject.IndonesianALangLit, SubjectObject.Subject.IndonesianB, SubjectObject.Subject.ItalianAb, SubjectObject.Subject.ItalianB, SubjectObject.Subject.JapaneseALit, SubjectObject.Subject.JapaneseALangLit, SubjectObject.Subject.JapaneseAb, SubjectObject.Subject.JapaneseB, SubjectObject.Subject.KoreanALit, SubjectObject.Subject.Latin, SubjectObject.Subject.MalayALit,  SubjectObject.Subject.MandarinAb, SubjectObject.Subject.MandarinB, SubjectObject.Subject.NorwegianB, SubjectObject.Subject.RussianAb, SubjectObject.Subject.RussianB, SubjectObject.Subject.SpanishALit, SubjectObject.Subject.SpanishALangLit, SubjectObject.Subject.SpanishAb, SubjectObject.Subject.SpanishB, SubjectObject.Subject.SwedishB],
        // Group 3
        [SubjectObject.Subject.BrazSocStud, SubjectObject.Subject.BusinessManagement, SubjectObject.Subject.Economics, SubjectObject.Subject.EnvironmentalSystemsandSocities, SubjectObject.Subject.Geography, SubjectObject.Subject.GlobalPolitics, SubjectObject.Subject.History, SubjectObject.Subject.InformationTechonologyinaGlobalSociety, SubjectObject.Subject.Philosophy, SubjectObject.Subject.Psychology, SubjectObject.Subject.SocialCulturalAnthropology, SubjectObject.Subject.Turkey20thCentury, SubjectObject.Subject.WorldReligions],
        // Group 4
        [SubjectObject.Subject.Biology, SubjectObject.Subject.Chemistry, SubjectObject.Subject.ComputerScience, SubjectObject.Subject.DesignTechnology, SubjectObject.Subject.EnvironmentalSystemsandSocities, SubjectObject.Subject.MarineScience,  SubjectObject.Subject.Physics, SubjectObject.Subject.SportsExcerciseandHealthScience],
        // Group 5
        [SubjectObject.Subject.FurtherMathematics, SubjectObject.Subject.Mathematics, SubjectObject.Subject.MathematicsStudies],
        // Group 6
        [SubjectObject.Subject.ArabicAb, SubjectObject.Subject.ArabicB, SubjectObject.Subject.Biology, SubjectObject.Subject.BusinessManagement, SubjectObject.Subject.CantoneseB, SubjectObject.Subject.Chemistry, SubjectObject.Subject.ComputerScience, SubjectObject.Subject.Dance, SubjectObject.Subject.DanishB, SubjectObject.Subject.DesignTechnology, SubjectObject.Subject.DutchB, SubjectObject.Subject.Economics, SubjectObject.Subject.EnglishAb, SubjectObject.Subject.EnglishB, SubjectObject.Subject.EnvironmentalSystemsandSocities, SubjectObject.Subject.Film, SubjectObject.Subject.FrenchAb, SubjectObject.Subject.FrenchB, SubjectObject.Subject.Geography, SubjectObject.Subject.GermanAb, SubjectObject.Subject.GermanB, SubjectObject.Subject.GlobalPolitics, SubjectObject.Subject.HindiB, SubjectObject.Subject.History, SubjectObject.Subject.IndonesianB, SubjectObject.Subject.InformationTechonologyinaGlobalSociety, SubjectObject.Subject.ItalianAb, SubjectObject.Subject.ItalianB, SubjectObject.Subject.JapaneseAb, SubjectObject.Subject.JapaneseB, SubjectObject.Subject.Latin, SubjectObject.Subject.MandarinAb, SubjectObject.Subject.MandarinB,  SubjectObject.Subject.Music, SubjectObject.Subject.MusicGroupPerformance, SubjectObject.Subject.MusicSoloPerformance, SubjectObject.Subject.MusicCreating, SubjectObject.Subject.NorwegianB, SubjectObject.Subject.Philosophy, SubjectObject.Subject.Physics, SubjectObject.Subject.Psychology, SubjectObject.Subject.RussianAb, SubjectObject.Subject.RussianB, SubjectObject.Subject.SocialCulturalAnthropology, SubjectObject.Subject.SpanishAb, SubjectObject.Subject.SpanishB, SubjectObject.Subject.SportsExcerciseandHealthScience, SubjectObject.Subject.SwedishB, SubjectObject.Subject.Theatre, SubjectObject.Subject.VisualArts, SubjectObject.Subject.WorldReligions]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableCells = [group1Cell, group2Cell, group3Cell, group4Cell, group5Cell, group6Cell]
        self.tableLabels = [group1SubjectLabel, group2SubjectLabel, group3SubjectLabel, group4SubjectLabel, group5SubjectLabel, group6SubjectLabel]
        
        self.chosenSubjects = [group1SubjectLabel: nil, group2SubjectLabel: nil, group3SubjectLabel: nil, group4SubjectLabel: nil, group5SubjectLabel: nil, group6SubjectLabel: nil]
        
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        
        self.searchBar.delegate = self
        
        updateLabels()
        setupSelectorView()
        setupSearchBar()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setupSelectorView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        var sections = 0
        if tableView == searchTableView {
            sections = 1
        } else if tableView == self.tableView {
            sections = 6
        }
        return sections
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows = 0
        if tableView == searchTableView {
            rows = searchContent.count
        } else if tableView == self.tableView {
            rows = 1
        }
        return rows
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cellToReturn = UITableViewCell()
        if tableView == searchTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Subject Cell")!
            
            let subjectLabel = cell.viewWithTag(1) as! UILabel
            subjectLabel.text = searchContent[indexPath.row].rawValue
            
            cellToReturn = cell
            
        } else if tableView == self.tableView {
            cellToReturn = tableCells[indexPath.section]
        }
        return cellToReturn
        
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: 200, height: 26))
        
        label.text = "Group \(section + 1)"
        label.font = UIFont(name: "Avenir Next", size: 15)
        label.textColor = UIColor.white
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 26))
        view.addSubview(label)
        
        return view
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("touched")
        if tableView == self.tableView {
            
            selectedGroup = indexPath.section + 1
            animateIn()
            
            tableView.deselectRow(at: indexPath, animated: false)
            
        } else if tableView == searchTableView {
            
            tableView.deselectRow(at: indexPath, animated: false)
            
            let groupLabel = self.tableLabels[self.selectedGroup! - 1]
            let selectedSubject = self.searchContent[indexPath.row]
            
            let alertController = UIAlertController(title: "Subject Level", message: "HL or SL?", preferredStyle: .alert)
            
            let HLAction = UIAlertAction(title: "HL", style: .default, handler: { alert in
                let subjectObject = SubjectObject(subject: selectedSubject, isHL: true)
                
                if self.validateSubjectChoice(chosenSubject: subjectObject) { // If this is a valid subject
                    self.chosenSubjects[groupLabel] = subjectObject
                    self.updateLabels()
                    self.animateOut()
                }
                
            })
            let SLAction = UIAlertAction(title: "SL", style: .default, handler: { alert in
                let subjectObject = SubjectObject(subject: selectedSubject, isHL: false)
                
                if self.validateSubjectChoice(chosenSubject: subjectObject) { // If this is a valid subject
                    self.chosenSubjects[groupLabel] = subjectObject
                    self.updateLabels()
                    self.animateOut()
                }
            })
            
            alertController.addAction(HLAction)
            alertController.addAction(SLAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            
        }
        
        
        
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButton(_ sender: Any) {
        
        self.animateOut()
        
    }
    
    
    // MARK: - UISearchBar Delegate Funcs
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateContent(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignSearchResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignSearchResponder))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func resignSearchResponder() {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Sorting Mechanisms
    
    func updateContent(searchText: String) {
        
        if searchText == "" {
            searchContent = subjectList[selectedGroup! - 1]
        } else {
            searchContent = searchContent.filter { $0.rawValue.contains(searchText) }
        }
        
        searchTableView.reloadData()
        
    }
    
    func validateSubjectChoice(chosenSubject: SubjectObject) -> Bool {
        
        var invalidSubjects = [SubjectObject]()
        invalidSubjects.append(SubjectObject(subject: .SpanishAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .GermanAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .FrenchAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .MandarinAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .EnglishAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .FurtherMathematics, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .MathematicsStudies, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .DutchALit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .IndonesianALangLit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .JapaneseALangLit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .JapaneseALit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .LiteraturePerformance, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .MalayALit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .MarineScience, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .GlobalPolitics, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .PortugueseALangLit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .ThaiALangLit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .BrazSocStud, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .CatalanALit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .SwedishALangLit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .ArabicAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .ItalianAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .JapaneseAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .RussianAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .DanishB, isHL: false))
        
        for invalidChoice in invalidSubjects {
            
            if invalidChoice.toString() == chosenSubject.toString() {
                
                let alert = Alert(message: "\(chosenSubject.toString()) is an invalid subject choice. Please try again.", alertType: .invalidUserResponse)
                alert.show(source: self)
                return false
                
            }
            
        }
        return true
        
    }
    
    /*
    func continueButtonPressed() {
        
        var invalidSubjects = [SubjectObject]()
        invalidSubjects.append(SubjectObject(subject: .SpanishAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .GermanAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .FrenchAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .MandarinAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .EnglishAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .FurtherMathematics, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .MathematicsStudies, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .DutchALit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .IndonesianALangLit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .JapaneseALangLit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .JapaneseALit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .LiteraturePerformance, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .MalayALit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .MarineScience, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .GlobalPolitics, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .PortugueseALangLit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .ThaiALangLit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .BrazSocStud, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .CatalanALit, isHL: false))
        invalidSubjects.append(SubjectObject(subject: .SwedishALangLit, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .ArabicAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .ItalianAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .JapaneseAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .RussianAb, isHL: true))
        invalidSubjects.append(SubjectObject(subject: .DanishB, isHL: false))
        
        if !groupSubjectToggle.contains(false) {
            
            for i in 0..<groupSubjectSelection.count {
                
                let subject = SubjectObject(subject: groupSubjectSelection[i], isHL: subjectHLList[i])
                
                for invalidSubject in invalidSubjects {
                    
                    if invalidSubject == subject {
                        
                        let alert = Alert(message: "\(subject.toString()) is an invalid subject choice. Please try again.", alertType: .invalidUserResponse)
                        alert.show(source: self)
                        return
                        
                    }
                    
                }
                
                for j in 0..<groupSubjectSelection.count {
                    
                    if groupSubjectSelection[i] == groupSubjectSelection[j] && i != j {
                        
                        let alert = Alert(message: "You have selected the same subject twice, please try again.", alertType: .invalidUserResponse)
                        alert.show(source: self)
                        return
                        
                    }
                    
                }
            }
            
            var HLCount = 0
            for subject in subjectHLList {
                if subject {
                    HLCount += 1
                }
            }
            
            if HLCount < 3 {
                
                let alert = Alert(message: "You have selected too few HLs, please try again.", alertType: .invalidUserResponse)
                alert.show(source: self)
                return
                
            } else if HLCount > 4 {
                
                let alert = Alert(message: "You have selected too many HLs, please try again.", alertType: .invalidUserResponse)
                alert.show(source: self)
                return
                
            }
            
            performSegue(withIdentifier: "Continue", sender: self)
            
        } else {
            
            let alert = Alert(message: "Please select a subject for each group.", alertType: .invalidUserResponse)
            alert.show(source: self)
            return
            
        }
        
    }*/
    
    
    func setupSelectorView() {
        
        let visualEffect = UIBlurEffect(style: .extraLight)
        visualEffectView = UIVisualEffectView(effect: visualEffect)
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.alpha = 0
        visualEffectView.isUserInteractionEnabled = false
        
        if let navController = navigationController {
            navController.view.addSubview(visualEffectView)
        }
        
        subjectSelectorView.layer.cornerRadius = 3
        subjectSelectorView.layer.borderWidth = 1
        subjectSelectorView.layer.borderColor = UIColor.black.cgColor
        
    }
    
    func setupSearchBar() {
        if let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            // Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            glassIconView.tintColor = UIColor.red
            
        }
    }
    
    // Function for showing the normal grade boundaries view
    func animateIn() {
        
        self.searchTableView.setContentOffset(CGPoint.zero, animated: false)
        
        groupLabel.text = "Group \(self.selectedGroup!)"
        
        if let navController = navigationController {

            navController.view.addSubview(subjectSelectorView)
            subjectSelectorView.center = CGPoint(x: navController.view.center.x, y: navController.view.center.y)
            
            subjectSelectorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            subjectSelectorView.alpha = 0
            
            UIView.animate(withDuration: 0.4) {
                self.visualEffectView.alpha = 0.75
                self.subjectSelectorView.alpha = 1
                self.subjectSelectorView.transform = CGAffineTransform.identity
            }
            
            //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateOut(sender:)))
            //navController.view.addGestureRecognizer(tapGesture)
            
            self.tableView.isUserInteractionEnabled = false
            
        }
        
        updateContent(searchText: "")
        
    }
    
    // Function for fading out the normal grade boundaries view
    @objc func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.subjectSelectorView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.subjectSelectorView.alpha = 0
            
            self.visualEffectView.alpha = 0
            
        }) { (success:Bool) in
            self.subjectSelectorView.removeFromSuperview()
            //self.navigationController?.view.removeGestureRecognizer(sender)
            
            self.tableView.isUserInteractionEnabled = true
        }
        
        self.selectedGroup = nil
    }
    
    func updateLabels() {
        
        for (label, subject) in self.chosenSubjects {
            
            if let chosenSubject = subject {
                
                label.text = chosenSubject.toString()
                
            } else {
                
                label.text = "Select a subject"
                
            }
            
        }
        
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
