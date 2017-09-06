//
//  HomeViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/17/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.


import UIKit
import SafariServices

class myHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet var gradeBoundariesView: UIView!
    @IBOutlet weak var boundariesSubjectLabel: UILabel!
    @IBOutlet weak var boundariesStackView: UIStackView!
    @IBOutlet weak var boundariesAverageMarksLabel: UILabel!
    
    @IBOutlet var helpView: UIView!
    
    @IBOutlet var TOKEEView: UIView!
    @IBOutlet weak var TOKAverageMarksLabel: UILabel!
    @IBOutlet weak var EEAverageMarksLabel: UILabel!
    @IBOutlet weak var TOKGradeLabel: UILabel!
    @IBOutlet weak var EEGradeLabel: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var overallGradeLabel: UILabel!
    
    @IBOutlet weak var subjectStackView: UIStackView!
    @IBOutlet weak var gradeStackView: UIStackView! //full of the numbers for each subject
    
    @IBOutlet weak var bodyTableView: UITableView!
    
    @IBOutlet weak var leftHeaderView: BorderedView!
    
    @IBOutlet weak var bodyScrollView: UIScrollView!
    
    @IBOutlet weak var userLabel: UnderlinedLabel!
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var bestSubjectContentLabel: UILabel!
    @IBOutlet weak var averageGradeContentLabel: UILabel!
    @IBOutlet weak var IBPercentileContentLabel: UILabel!
    @IBOutlet weak var loggedAssessmentsContentLabel: UILabel!
    @IBOutlet weak var easilyImprovedSubjectContentLabel: UILabel!
    @IBOutlet weak var subjectToMonitorContentLabel: UILabel!
    
    // MARK: - Properties
    
    var mostRecentAssessment: Assessment!
    
    var noAssessmentsLabel = UILabel()
    
    var visualEffectView: UIVisualEffectView!
    
    var averagePercentageMarks = [SubjectObject: Int]()
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppStatus.isSignedUp != true {
            AppStatus.loadData()
        }
        
        bodyTableView.register(UINib(nibName: "AssessmentCell", bundle: Bundle.main), forCellReuseIdentifier: "AssessmentCell")
        
        //UI setup
        setupNoAssessmentsLabel()
        setupHeaderView()
        setupAssessmentTableView()
        setupBodyView()
        setupBoundariesView()
        bodyScrollView.contentSize = CGSize(width: self.view.frame.width, height: 736)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //set the overall grade to the sum of the subject grades
        let overallGrade = AppStatus.user.getOverallGrade()
        overallGradeLabel.text = String(describing: overallGrade)
        
        averagePercentageMarks = AppStatus.user.getAveragePercentageMarks()
        
        mostRecentAssessment = nil
        
        setupAssessmentTableView()
        setupStackViews()
        setupBodyView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if AppStatus.isSignedUp != true {
            performSegue(withIdentifier: "StartSignup", sender: self)
            return
        }
        
        if AppStatus.isFirstLoad == true {
            
            if AppStatus.disclaimerSigned == false {
                self.performSegue(withIdentifier: "ShowDisclaimer", sender: self)
                return
            }
            
            let alertController = UIAlertController(title: "Demo", message: "Would you like to watch the demo video before starting?", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: { alert in
                
                let url = URL(string: "https://youtu.be/CD30wwjPQys")!
                let controller = SFSafariViewController(url: url)
                self.present(controller, animated: true, completion: {
                    AppStatus.isFirstLoad = false
                    AppStatus.saveData()
                })
                
            })
            let denyAction = UIAlertAction(title: "No, I'll figure it out", style: .default, handler: { alert in
                AppStatus.isFirstLoad = false
                AppStatus.saveData()
            })
            
            alertController.addAction(confirmAction)
            alertController.addAction(denyAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: - UITableView Delegate Funcs
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (mostRecentAssessment != nil) ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: AssessmentCell = tableView.dequeueReusableCell(withIdentifier: "AssessmentCell") as! AssessmentCell
        cell.recentAssessmentView.infoButton.isHidden = true
        cell.recentAssessmentView.infoButton.isUserInteractionEnabled = false
        
        if let assessment = mostRecentAssessment {
            configureCell(cell: cell, assessment: assessment)
        }
        
        return cell
        
    }
    
    // MARK: - IBActions
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        
        self.view.addSubview(helpView)
        helpView.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 30)
        
        for view in subjectStackView.subviews {
            view.isUserInteractionEnabled = false
        }
        
        helpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        helpView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 0.75
            self.helpView.alpha = 1
            self.helpView.transform = CGAffineTransform.identity
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateHelpOut))
        self.view.addGestureRecognizer(tapGesture)
        
        self.helpButton.isUserInteractionEnabled = false
        
    }
    
    // MARK: - Configuration Funcs
    
    func configureCell(cell: AssessmentCell, assessment: Assessment){
        
        let mainView = cell.recentAssessmentView
        mainView?.awakeFromNib()
        mainView?.updateLabels(assessment: assessment)
        
    }
    
    // MARK: - TOK/EE View Funcs
    
    func setupTOKEEView() {
        
        let visualEffect = UIBlurEffect(style: .extraLight)
        visualEffectView = UIVisualEffectView(effect: visualEffect)
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.alpha = 0
        visualEffectView.isUserInteractionEnabled = false
        
        view.addSubview(visualEffectView)
        
        TOKEEView.layer.cornerRadius = 5
        
    }
    
    func animateTOKEEIn(sender: UITapGestureRecognizer) {
        
        if let averageTOKMarks = averagePercentageMarks[AppStatus.user.subjects[6]] {
            TOKAverageMarksLabel.text = "\(averageTOKMarks)"
        } else {
            TOKAverageMarksLabel.text = "N/A"
        }
        
        if let averageEEMarks = averagePercentageMarks[AppStatus.user.subjects[7]] {
            EEAverageMarksLabel.text = "\(averageEEMarks)"
        } else {
            EEAverageMarksLabel.text = "N/A"
        }
        
        let subjectGrades = AppStatus.user.getSubjectGrades()
        
        if let grade = subjectGrades[AppStatus.user.subjects[6]] {
            switch grade {
            case 5:
                TOKGradeLabel.text = "A"
            case 4:
                TOKGradeLabel.text = "B"
            case 3:
                TOKGradeLabel.text = "C"
            case 2:
                TOKGradeLabel.text = "D"
            case 1:
                TOKGradeLabel.text = "E"
            default:
                break
            }
        } else {
            TOKGradeLabel.text = "N/A"
        }
        
        if let grade = subjectGrades[AppStatus.user.subjects[7]] {
            switch grade {
            case 5:
                EEGradeLabel.text = "A"
            case 4:
                EEGradeLabel.text = "B"
            case 3:
                EEGradeLabel.text = "C"
            case 2:
                EEGradeLabel.text = "D"
            case 1:
                EEGradeLabel.text = "E"
            default:
                break
            }
        } else {
            EEGradeLabel.text = "N/A"
        }
        
        self.view.addSubview(TOKEEView)
        TOKEEView.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 20)
        
        for view in subjectStackView.subviews {
            view.isUserInteractionEnabled = false
        }
        
        TOKEEView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        TOKEEView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 0.75
            self.TOKEEView.alpha = 1
            self.TOKEEView.transform = CGAffineTransform.identity
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateTOKEEOut))
        self.view.addGestureRecognizer(tapGesture)
        
        self.helpButton.isUserInteractionEnabled = false
        
    }
    
    func animateTOKEEOut() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.TOKEEView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.TOKEEView.alpha = 0
            
            self.visualEffectView.alpha = 0
            
        }) { (success:Bool) in
            self.TOKEEView.removeFromSuperview()
            
            for view in self.subjectStackView.subviews {
                view.isUserInteractionEnabled = true
            }
            
            self.helpButton.isUserInteractionEnabled = true
        }
        
    }
    
    // MARK: - Help View Funcs
    
    func setupHelpView() {
        
        let visualEffect = UIBlurEffect(style: .extraLight)
        visualEffectView = UIVisualEffectView(effect: visualEffect)
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.alpha = 0
        visualEffectView.isUserInteractionEnabled = false
        
        view.addSubview(visualEffectView)
        
        helpView.layer.cornerRadius = 5
        
    }
    
    func animateHelpOut() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.helpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.helpView.alpha = 0
            
            self.visualEffectView.alpha = 0
            
        }) { (success:Bool) in
            self.helpView.removeFromSuperview()
            
            for view in self.subjectStackView.subviews {
                view.isUserInteractionEnabled = true
            }
            
            self.helpButton.isUserInteractionEnabled = true
        }
        
    }
    
    // MARK: - Boundaries View Funcs
    
    func setupBoundariesView() {
        
        let visualEffect = UIBlurEffect(style: .extraLight)
        visualEffectView = UIVisualEffectView(effect: visualEffect)
        visualEffectView.frame = view.bounds
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.alpha = 0
        visualEffectView.isUserInteractionEnabled = false
        
        view.addSubview(visualEffectView)
        
        gradeBoundariesView.layer.cornerRadius = 5
        
        boundariesSubjectLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    func animateIn(sender: UITapGestureRecognizer) {
        
        if let senderLabel = sender.view as? UILabel {
            
            let selectedSubject = AppStatus.user.subjects[senderLabel.tag]
            
            boundariesSubjectLabel.text = selectedSubject.toShortString()
            
            let boundaries = getBoundaries(subject: selectedSubject)
            
            for i in 0..<boundaries.count {
                
                if let stackView = boundariesStackView.arrangedSubviews[i] as? UIStackView {
                    
                    if let boundariesLabel = stackView.arrangedSubviews[1] as? UILabel {
                        
                        boundariesLabel.text = "\(boundaries[i].0) - \(boundaries[i].1)"
                        
                    }
                    
                }
                
            }
            
            if let averageMarks = averagePercentageMarks[selectedSubject] {
                boundariesAverageMarksLabel.text = "\(averageMarks)"
            } else {
                boundariesAverageMarksLabel.text = "N/A"
            }
            
        }
        
        self.view.addSubview(gradeBoundariesView)
        gradeBoundariesView.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 20)
        
        for view in subjectStackView.subviews {
            view.isUserInteractionEnabled = false
        }
        
        gradeBoundariesView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        gradeBoundariesView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 0.75
            self.gradeBoundariesView.alpha = 1
            self.gradeBoundariesView.transform = CGAffineTransform.identity
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateOut))
        self.view.addGestureRecognizer(tapGesture)
        
        self.helpButton.isUserInteractionEnabled = false
        
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.gradeBoundariesView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.gradeBoundariesView.alpha = 0
            
            self.visualEffectView.alpha = 0
            
        }) { (success:Bool) in
            self.gradeBoundariesView.removeFromSuperview()
            
            for view in self.subjectStackView.subviews {
                view.isUserInteractionEnabled = true
            }
            
            self.helpButton.isUserInteractionEnabled = true
        }
    }
    
    func getBoundaries(subject: SubjectObject) -> [(Int, Int)]{
        
        var boundaries = [(Int, Int)]()
        
        typealias JSONDictionary = [String: Any]
        
        if let url = Bundle.main.url(forResource: "gradeBoundaries", withExtension: "json") { //find the url of the JSON
            do {
                
                let jsonData = try Data(contentsOf: url) //get the data for the JSON
                
                if let jsonResult: JSONDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? JSONDictionary { //the whole JSON
                    
                    let subjects: [JSONDictionary] = jsonResult["Subjects"] as! [JSONDictionary] //list of subjects (which are dictionaries)
                    
                    for aSubject in subjects { //iterate through the subjects
                        
                        let title: String = aSubject["Title"] as! String //get subject title
                        
                        if title == subject.toString() { //see if the subject title matches the subject of the assessment
                            
                            let gradeBoundaries: JSONDictionary = aSubject["Boundaries"] as! JSONDictionary //get dictionary of grade boundaries
                            
                            for key in gradeBoundaries.keys { //iterate through the keys
                                var value: [Int] = gradeBoundaries[key] as! [Int] //get the value of the dictionary for the current key
                                
                                boundaries.append((value[0], value[1]))
                            }
                            
                        }
                        
                    }
                    
                }
            } catch {
                
                let alert = Alert(message: "Uh-oh. Please try again.", alertType: .jsonParsingError)
                alert.show(source: self)
                
            }
        }
        
        boundaries = boundaries.sorted { $0.0 < $1.0 }
        return boundaries
        
    }
    
    // MARK: - UI Setup
    
    func setupStackViews() {
        
        //empty the stack view
        for view in subjectStackView.subviews {
            subjectStackView.removeArrangedSubview(view)
        }
        
        var counter = 0
        
        for subjectObject in AppStatus.user.subjects {
            
            var tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateIn(sender:)))
            
            if subjectObject.subject == .TheoryOfKnowledge || subjectObject.subject == .ExtendedEssay {
                tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateTOKEEIn(sender:)))
                
                let label = UILabel()
                label.text = "TOK / EE"
                label.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
                label.textAlignment = .right
                label.adjustsFontSizeToFitWidth = true
                let color = AppStatus.user.colorPreferences[subjectObject]
                label.textColor = color?.withAlphaComponent(0.8)
                label.addGestureRecognizer(tapGesture)
                label.tag = counter
                
                label.isUserInteractionEnabled = true
                
                subjectStackView.addArrangedSubview(label)
                
                counter += 1
                
                break
            }
            
            let label = UILabel()
            label.text = subjectObject.toShortString()
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
            label.textAlignment = .right
            label.adjustsFontSizeToFitWidth = true
            let color = AppStatus.user.colorPreferences[subjectObject]
            label.textColor = color?.withAlphaComponent(0.8)
            label.addGestureRecognizer(tapGesture)
            label.tag = counter
            
            label.isUserInteractionEnabled = true
            
            subjectStackView.addArrangedSubview(label)
            
            counter += 1
            
        }
        
        for view in gradeStackView.subviews {
            gradeStackView.removeArrangedSubview(view)
        }
        
        let subjectGrades = AppStatus.user.getSubjectGrades()
        
        var TOKGrade = 0
        var EEGrade = 0
        
        for subject in AppStatus.user.subjects {
            
            let label = UILabel()
            
            if subject.subject == .TheoryOfKnowledge {
                if let grade = subjectGrades[subject] {
                    TOKGrade = grade
                }
                continue
            } else if subject.subject == .ExtendedEssay {
                if let grade = subjectGrades[subject] {
                    EEGrade = grade
                }
            } else {
                if let grade = subjectGrades[subject] {
                    label.text = "\(grade)"
                } else {
                    label.text = "?"
                }
                label.font = UIFont(name: "AvenirNext-Medium", size: 17)
                label.textAlignment = .center
                gradeStackView.addArrangedSubview(label)
                continue
            }
            
            if TOKGrade != 0 && EEGrade != 0 {
                switch TOKGrade * EEGrade {
                case 25: // A-A
                    label.text = "3"
                case 20: // A-B | B-A
                    label.text = "3"
                case 16: // B-B
                    label.text = "2"
                case 15: // A-C | C-A
                    label.text = "2"
                case 12: // B-C | C-B
                    label.text = "1"
                case 10: // A-D | D-A
                    label.text = "2"
                case 9:  // C-C
                    label.text = "1"
                case 8:  // B-D | D-B
                    label.text = "1"
                case 5:  // A-E | E-A
                    label.text = "1"
                default:
                    label.text = "0"
                }
            } else {
                label.text = "?"
            }
            
            label.font = UIFont(name: "AvenirNext-Medium", size: 17)
            label.textAlignment = .center
            gradeStackView.addArrangedSubview(label)
            
        }
        
    }
    
    func setupAssessmentTableView() {
        
        bodyTableView.delegate = self
        bodyTableView.dataSource = self
        
        // Get the most recent assessment
        if AppStatus.user.assessments.count == 0 { // If they haven't logged any assessments yet
            bodyScrollView.addSubview(noAssessmentsLabel)
            bodyTableView.reloadData()
        } else {
            noAssessmentsLabel.removeFromSuperview()
            
            let assessmentsByDate = AppStatus.user.assessments.sorted { $0.date > $1.date }
            
            mostRecentAssessment = assessmentsByDate[0]
            bodyTableView.reloadData()
        }
        
        // Can't scroll because only one item
        bodyTableView.isScrollEnabled = false
    }
    
    func setupBodyView() {
        bestSubjectContentLabel.adjustsFontSizeToFitWidth = true
        
        let yearLevelObject = AppStatus.user.yearLevelObject
        let name = AppStatus.user.name
        userLabel.text = "\(name) - \(yearLevelObject.yearLevel.rawValue) Student"
        
        if AppStatus.user.assessments.count == 0 { // If there are no logged assessments
            averageGradeContentLabel.text = "N/A"
            bestSubjectContentLabel.text = "N/A"
            loggedAssessmentsContentLabel.text = "0"
            IBPercentileContentLabel.text = "N/A"
            easilyImprovedSubjectContentLabel.text = "N/A"
            subjectToMonitorContentLabel.text = "N/A"
            return
        }
        
        let averageGrade = AppStatus.user.getAverageGrade()
        
        if averageGrade != 8 {
            let averageGradeInt: Int = Int(averageGrade * 10.0)
            averageGradeContentLabel.text = String(describing: Double(averageGradeInt) / 10.0)
        } else { // All assessments are EE or TOK
            averageGradeContentLabel.text = "N/A"
            bestSubjectContentLabel.text = "N/A"
            loggedAssessmentsContentLabel.text = "\(AppStatus.user.assessments.count)"
            IBPercentileContentLabel.text = "N/A"
            easilyImprovedSubjectContentLabel.text = "N/A"
            subjectToMonitorContentLabel.text = "N/A"
            return
        }
        
        let bestSubject = AppStatus.user.getBestSubject()
        bestSubjectContentLabel.text = bestSubject.toString()
        bestSubjectContentLabel.adjustsFontSizeToFitWidth = true
        
        let assessmentsCount = AppStatus.user.assessments.count
        loggedAssessmentsContentLabel.text = String(assessmentsCount)
        
        let overallGrade = AppStatus.user.getOverallGrade()
        if overallGrade >= 24 {
            let gradePercentile = getGradePercentile(grade: overallGrade)
            IBPercentileContentLabel.text = String(gradePercentile)
        } else {
            IBPercentileContentLabel.text = "N/A"
        }
        
        let subjectGrades = AppStatus.user.getSubjectGrades()
        let subjectAveragePercentages = AppStatus.user.getAveragePercentageMarks()
    
        if subjectAveragePercentages.count == 0 {
            easilyImprovedSubjectContentLabel.text = "N/A"
            subjectToMonitorContentLabel.text = "N/A"
            return
        }
        
        var minimumDistToTop = 100
        var minimumDistToBottom = 100
        var subjectToImprove = SubjectObject(subject: .Default, isHL: false)
        var subjectToWatch = SubjectObject(subject: .Default, isHL: false)
        
        for subject in subjectGrades.keys {
            
            if subject.subject == .TheoryOfKnowledge || subject.subject == .ExtendedEssay {
                continue
            }
            
            guard let averagePercentage = subjectAveragePercentages[subject] else {
                let alert = Alert(message: "Error", alertType: .unwrappingError)
                alert.show(source: self)
                return
            }
            
            let boundaries = getBoundaries(subject: subject)
            
            for boundary in boundaries {
                
                if averagePercentage >= boundary.0 && averagePercentage <= boundary.1 {
                    
                    if boundary.1 - averagePercentage < minimumDistToTop && subjectGrades[subject] != 7 {
                        
                        minimumDistToTop = boundary.1 - averagePercentage
                        subjectToImprove = subject
                        
                    }
                    
                    if averagePercentage - boundary.0 < minimumDistToBottom {
                        
                        minimumDistToBottom = averagePercentage - boundary.0
                        subjectToWatch = subject
                        
                    }
                    
                }
                
            }
            
        }
        
        subjectToMonitorContentLabel.text = "\(subjectToWatch.toShortString())"
        
        // If all of the subjects are sevens
        if subjectToImprove == SubjectObject(subject: .Default, isHL: false){
            easilyImprovedSubjectContentLabel.text = "N/A"
        } else {
            let name = subjectToImprove.toShortString()
            easilyImprovedSubjectContentLabel.text = "\(name)"
        }
        
    }
    
    func getGradePercentile(grade: Int) -> Double {
        
        var percentile = 0.0
        
        typealias JSONObject = [String: Any]
        
        if let url = Bundle.main.url(forResource: "gradePercentiles", withExtension: "json") {
            
            do {
                
                let data = try Data(contentsOf: url)
                
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSONObject {
                    
                    if let percentilesDictionary = jsonObject["Percentiles"] as? JSONObject {
                        
                        if let value = percentilesDictionary[String(grade)] as? Double {
                            
                            percentile = value
                            
                        }
                        
                    }
                    
                }
                
            } catch {
                
                let alert = Alert(message: "Internal error. Please try again.", alertType: .jsonParsingError)
                alert.show(source: self)
                return percentile
                
            }
            
        }
        
        return percentile
    }
    
    func setupNoAssessmentsLabel() {
        
        noAssessmentsLabel = UILabel(frame: CGRect(x: self.bodyTableView.frame.origin.x, y: self.bodyTableView.frame.origin.y, width: UIScreen.main.bounds.width, height: self.bodyTableView.frame.height))
        noAssessmentsLabel.text = "No Assessments Yet!"
        noAssessmentsLabel.font = UIFont(name: "Avenir Next", size: 16)
        noAssessmentsLabel.textAlignment = .center
        
    }
    
    func setupHeaderView() {
        
        // Set-up headerView shadow
        headerView.layer.shadowOpacity = 1.0
        headerView.layer.shadowRadius = 4
        headerView.layer.shadowColor = UIColor.black.cgColor
        
        // Draw borders for custom "BorderedViews"
        leftHeaderView.drawBorder(orientation: .Right, color: UIColor.black, thickness: 0.5)
    }

}

