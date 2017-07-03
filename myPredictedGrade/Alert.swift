//
//  Alert.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 7/3/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    var alertController: UIAlertController
    
    enum AlertType: Int {
        case invalidUserResponse = 1
        case unwrappingError = 2
    }
    
    init(message: String, alertType: AlertType) {
        
        alertController = UIAlertController(title: "Error #0\(alertType.rawValue)", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
    }
    
    func show(source: UIViewController) {
        
        source.present(alertController, animated: true, completion: nil)
        
    }
    
    
}
