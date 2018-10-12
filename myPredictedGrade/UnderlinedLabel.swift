//
//  UnderlinedLabel.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 2/5/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
