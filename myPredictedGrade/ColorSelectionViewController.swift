//
//  ColorSelectionViewController.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 6/12/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import UIKit

class ColorSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet weak var previewAssessmentView: RecentAssessmentView!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    // Constraint for space between navigation and title label; adjusted for screen-size
    @IBOutlet weak var titleHeaderSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Properties
    
    var colors = [UIColor]()
    var selectedCellTag: Int!
    
    var colorPreferences: [SubjectObject: UIColor] = [SubjectObject: UIColor]()
    
    var checkImageView = UIImageView()
    
    var counter = 1
    
    var subjects: [SubjectObject]!

    var name: String!
    var yearLevel: YearLevelObject!
    
    // MARK: - Inherited Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        previewAssessmentView.awakeFromNib()
        
        previewAssessmentView.asssessmentTitleLabel.text = "My Assessment"
        previewAssessmentView.subjectDateLabel.text = "\(subjects![0].toString()) 20th of September 2016"
        previewAssessmentView.marksLabel.text = "45 / 50"
        previewAssessmentView.overallGradeLabel.text = "7"
        
        subjectLabel.text = "1. \(subjects[0].toString())"
        subjectLabel.adjustsFontSizeToFitWidth = true
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
        if UIScreen.main.bounds.height == 568 { // If the user has an iPhone 5, 5s
            titleHeaderSpaceConstraint.constant = 20
            collectionViewHeightConstraint.constant = 60
            colorCollectionView.showsHorizontalScrollIndicator = true
        }
        
        colors.append(UIColor(red: 178/255, green: 0, blue: 3/255, alpha: 1.0))
        colors.append(UIColor(red: 255/255, green: 89/255, blue: 0/255, alpha: 1.0))
        colors.append(UIColor(red: 178/255, green: 178/255, blue: 0, alpha: 1.0))
        colors.append(UIColor(red: 0, green: 178/255, blue: 0, alpha: 1.0))
        colors.append(UIColor(red: 0, green: 0, blue: 178/255, alpha: 1.0))
        colors.append(UIColor(red: 89/255, green: 0, blue: 178/255, alpha: 1.0))
        colors.append(UIColor(red: 178/255, green: 0, blue: 89/255, alpha: 1.0))
        colors.append(UIColor(red: 1, green: 89/255, blue: 178/255, alpha: 1.0))
        colors.append(UIColor(red: 0, green: 89/255, blue: 89/255, alpha: 1.0))
        colors.append(UIColor(red: 0, green: 178/255, blue: 178/255, alpha: 1.0))
        colors.append(UIColor(red: 178/255, green: 0, blue: 178/255, alpha: 1.0))
        colors.append(UIColor(red: 89/255, green: 0, blue: 89/255, alpha: 1.0))
        
        checkImageView = UIImageView(image: UIImage(named: "Checkmark_ffffff_100"))
        checkImageView.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        
        previewAssessmentView.updateView(for: UIColor.gray)
        
        nextButton.isHidden = true
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let navVC = segue.destination as? UINavigationController {
            
            if let destinationVC = navVC.viewControllers[0] as? ColorConfirmationViewController {
                
                destinationVC.subjects = self.subjects
                destinationVC.colorPreferences = self.colorPreferences
                
                destinationVC.name = self.name
                destinationVC.yearLevel = self.yearLevel
                
            }
            
        }
        
    }
    
    func performCustomSegue(finished: () -> Void) {
        
        performSegue(withIdentifier: "ColorsSelected", sender: self)
        
        finished()
        
    }
    
    // MARK: - IBActions
    
    //
    // Description: Called when next button pressed, updates content for next subject
    //
    @IBAction func transitionToNextSubject(_ sender: UIButton) {
        
        colorPreferences[subjects[counter-1]] = colors[selectedCellTag]
        
        if counter == 6 {
            
            performCustomSegue {
                reset()
            }
            return
            
        }
        
        // Increment counter
        counter += 1
        
        // Update subject label
        subjectLabel.text = "\(counter). \(subjects[counter-1].toString())"
        
        // Remove color from collection
        colors.remove(at: selectedCellTag)
        
        // No cell is selected now
        selectedCellTag = nil
        checkImageView.removeFromSuperview()
        
        // Reload the collection
        UIView.transition(with: colorCollectionView, duration: 0, options: .transitionCrossDissolve, animations: {self.colorCollectionView.reloadData()}, completion: nil)
        
        // Make the preview gray color and change labels
        previewAssessmentView.updateView(for: UIColor.gray)
        previewAssessmentView.subjectDateLabel.text = "\(subjects![counter-1].toString()) 20th of September 2016"

        // Hide the next button
        nextButton.isHidden = true
        
    }
    
    // MARK: - UICollectionView Delegate Funcs
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Color Cell", for: indexPath) 
        cell.backgroundColor = colors[indexPath.row]
        
        cell.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorCellPressed(sender:)))
        cell.addGestureRecognizer(tapGesture)
        
        if selectedCellTag != nil {
            
            if cell.tag == selectedCellTag {
                
                cell.addSubview(checkImageView)
                cell.backgroundColor = cell.backgroundColor?.withAlphaComponent(0.7)
                
            }
            
        }
        
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: - UICollectionView Helper Funcs
    
    func colorCellPressed(sender: UITapGestureRecognizer) {
        
        let cell = sender.view as! UICollectionViewCell
        selectedCellTag = cell.tag
        
        previewAssessmentView.updateView(for: cell.backgroundColor!)
        
        colorCollectionView.reloadData()
        
        nextButton.isHidden = false
        
    }
    
    // MARK: - App Cycle Control Funcs
    
    func reset() {
        
        counter = 1
        
        selectedCellTag = nil
        
        previewAssessmentView.subjectDateLabel.text = "\(subjects![0].toString()) 20th of September 2016"
        
        subjectLabel.text = "1. \(subjects![0].toString())"
        
        checkImageView.removeFromSuperview()
        
        colors = []

        colors.append(UIColor(red: 178/255, green: 0, blue: 3/255, alpha: 1.0))
        colors.append(UIColor(red: 255/255, green: 89/255, blue: 0/255, alpha: 1.0))
        colors.append(UIColor(red: 178/255, green: 178/255, blue: 0, alpha: 1.0))
        colors.append(UIColor(red: 0, green: 178/255, blue: 0, alpha: 1.0))
        colors.append(UIColor(red: 0, green: 0, blue: 178/255, alpha: 1.0))
        colors.append(UIColor(red: 89/255, green: 0, blue: 178/255, alpha: 1.0))
        colors.append(UIColor(red: 178/255, green: 0, blue: 89/255, alpha: 1.0))
        colors.append(UIColor(red: 1, green: 89/255, blue: 178/255, alpha: 1.0))
        colors.append(UIColor(red: 0, green: 89/255, blue: 89/255, alpha: 1.0))
        colors.append(UIColor(red: 0, green: 178/255, blue: 178/255, alpha: 1.0))
        colors.append(UIColor(red: 178/255, green: 0, blue: 178/255, alpha: 1.0))
        colors.append(UIColor(red: 89/255, green: 0, blue: 89/255, alpha: 1.0))
        
        colorCollectionView.reloadData()
        
        previewAssessmentView.updateView(for: UIColor.gray)
        
        nextButton.isHidden = true
        
    }
    

}
