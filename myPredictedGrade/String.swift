//
//  String.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/26/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation

extension String {
    func insert(string:String,ind:Int) -> String {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}
