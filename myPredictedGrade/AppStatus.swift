//
//  AppStatus.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/31/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

/* 
 * NOTE:
 * THIS IS THE MODEL USED FOR THE APP
 *
 */

struct AppStatus {
    static var loggedInUser: Profile?
    
    static let themeColor = UIColor(red: 40/255, green: 73/255, blue: 98/255, alpha: 1.0)
    static let validAssessmentColors = [UIColor(red: 178/255, green: 0, blue: 3/255, alpha: 1.0), UIColor(red: 89/255, green: 0/255, blue: 178/255, alpha: 1.0), UIColor(red: 0, green: 0, blue: 178/255, alpha: 1.0), UIColor(red: 178/255, green: 0, blue: 178/255, alpha: 1.0), UIColor(red: 0, green: 178/255, blue: 0, alpha: 1.0), UIColor(red: 0, green: 178/255, blue: 178/255, alpha: 1.0)]
}
