//
//  UITextField.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 1/6/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.5)
        border.borderColor = UIColor.lightGray.cgColor
        border.opacity = 1.0
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
