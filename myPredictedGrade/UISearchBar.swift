//
//  UISearchBar .swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 1/7/17.
//  Copyright © 2017 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    
    func removeBackground() {
        for subView in self.subviews {
            for view in subView.subviews {
                if view.isKind(of: NSClassFromString("UIImageView")!){
                    let imageView = view as! UIImageView
                    imageView.removeFromSuperview()
                }
            }
        }
    }
}
