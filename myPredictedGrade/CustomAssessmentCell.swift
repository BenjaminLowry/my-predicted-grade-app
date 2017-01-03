//
//  CustomAssessmentCell.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/24/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

class CustomAssessmentCell: UITableViewCell {
    
    //@IBOutlet var mainCell: CustomAssessmentCell!
    @IBOutlet weak var recentAssessmentView: RecentAssessmentView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("CustomAssessmentCell", owner: self, options: nil)
        //self.addSubview(mainCell)
    }
    
}
