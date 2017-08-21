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
    static var user: Profile = Profile()
    static var isSignedUp: Bool = false
    static var isFirstLoad: Bool = true
    static var disclaimerSigned: Bool = false
    
    static let themeColor = UIColor(red: 40/255, green: 73/255, blue: 98/255, alpha: 1.0)
    static let validAssessmentColors = [UIColor(red: 178/255, green: 0, blue: 3/255, alpha: 1.0), UIColor(red: 89/255, green: 0/255, blue: 178/255, alpha: 1.0), UIColor(red: 0, green: 0, blue: 178/255, alpha: 1.0), UIColor(red: 178/255, green: 0, blue: 178/255, alpha: 1.0), UIColor(red: 0, green: 178/255, blue: 0, alpha: 1.0), UIColor(red: 0, green: 178/255, blue: 178/255, alpha: 1.0)]
    
    static func setUser(user: Profile) {
        self.user = user
    }
    
    static func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    static func dataFilePath() -> String {
        return (documentsDirectory() as NSString).appendingPathComponent("UserData.plist")
    }
    
    static func loadData() {
        let path = dataFilePath()
        
        if FileManager.default.fileExists(atPath: path){
            
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)){
                
                let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
                AppStatus.user = unarchiver.decodeObject(forKey: "User") as! Profile
                AppStatus.isSignedUp = unarchiver.decodeBool(forKey: "Signed Up")
                AppStatus.isFirstLoad = unarchiver.decodeBool(forKey: "First Load")
                AppStatus.disclaimerSigned = unarchiver.decodeBool(forKey: "Disclaimer Signed")
                
                unarchiver.finishDecoding()
            }
            
        }
    }
    
    static func saveData() {
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(AppStatus.user, forKey: "User")
        archiver.encode(AppStatus.isSignedUp, forKey: "Signed Up")
        archiver.encode(AppStatus.isFirstLoad, forKey: "First Load")
        archiver.encode(AppStatus.disclaimerSigned, forKey: "Disclaimer Signed")
        archiver.finishEncoding()
        data.write(toFile: dataFilePath(), atomically: true)
        
    }
}
