//
//  TestTableViewCell.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/29/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import UIKit

class AssessmentCell: UITableViewCell {

    @IBOutlet weak var recentAssessmentView: RecentAssessmentView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
