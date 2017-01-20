//
//  Profile.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/31/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

class Profile: NSObject, NSCoding {
    
    var username: String
    var password: String
    
    var subjects: [(Subject, Bool)]
    var colorPreferences: [Subject: UIColor]
    
    var assessments: [Assessment]
    
    required init?(coder aDecoder: NSCoder) {
        username = aDecoder.decodeObject(forKey: "Username") as! String
        password = aDecoder.decodeObject(forKey: "Password") as! String
        
        subjects = aDecoder.decodeObject(forKey: "Subjects") as! [(Subject, Bool)]
        colorPreferences = aDecoder.decodeObject(forKey: "Color Preferences") as! [Subject: UIColor]
        
        assessments = aDecoder.decodeObject(forKey: "Assessments") as! [Assessment]
    }
    
    init(username: String, password: String, subjects: [(Subject, Bool)], colorPreferences: [Subject: UIColor], assessments: [Assessment]) {
        self.username = username
        self.password = password
        
        self.subjects = subjects
        self.colorPreferences = colorPreferences
        
        self.assessments = assessments
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "Username")
        aCoder.encode(password, forKey: "Password")
        
        aCoder.encode(subjects, forKey: "Subjects")
        aCoder.encode(colorPreferences, forKey: "Color Preferences")
        
        aCoder.encode(assessments, forKey: "Assessments")
    }
    
}
