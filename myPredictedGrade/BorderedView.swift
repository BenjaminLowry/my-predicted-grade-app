//
//  BorderedView.swift
//  myPredictedGrade
//
//  Created by Ben LOWRY on 12/23/16.
//  Copyright © 2016 Ben LOWRY. All rights reserved.
//

import Foundation
import UIKit

enum BorderOrientation {
    case Top
    case Bottom
    case Left
    case Right
}

class BorderedView: UIView {
    
    fileprivate weak var border: CAShapeLayer?
    
    var thickness: CGFloat = 1.0
    
    var color: UIColor = UIColor.lightGray
    
    var orientation: BorderOrientation = .Top
    
    func drawBorder(orientation: BorderOrientation, color: UIColor, thickness: CGFloat){
        self.orientation = orientation
        self.thickness = thickness
        self.color = color
        removeIfNeeded(self.border)
        let border = CAShapeLayer()
        let path = UIBezierPath()
        let coordinates = determineCoordinates(orientation: orientation)
        path.move(to: coordinates.0) //start
        path.addLine(to: coordinates.1) //end
        border.path = path.cgPath
        border.strokeColor = color.cgColor
        border.lineWidth = thickness
        border.fillColor = nil
        layer.addSublayer(border)
        self.border = border
    }
    
    func determineCoordinates(orientation: BorderOrientation) -> (CGPoint, CGPoint){
        if orientation == .Top {
            return (CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y), CGPoint(x: self.bounds.origin.x + self.bounds.width, y: self.bounds.origin.y))
        } else if orientation == .Bottom {
            return (CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y + self.bounds.height), CGPoint(x: self.bounds.origin.x + self.bounds.width, y: self.bounds.origin.y + self.bounds.height))
        } else if orientation == .Left {
            return (CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y), CGPoint(x: self.bounds.origin.x, y: self.bounds.origin.y + self.bounds.height))
        } else if orientation == .Right {
            return (CGPoint(x: self.bounds.origin.x + self.bounds.width, y: self.bounds.origin.y), CGPoint(x: self.bounds.origin.x + self.bounds.width, y: self.bounds.origin.y + self.bounds.height))
        } else { //default exhaustive case
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0))
        }
    }
    
    fileprivate func removeIfNeeded(_ border: CAShapeLayer?) {
        if let bdr = border {
            bdr.removeFromSuperlayer()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawBorder(orientation: orientation, color: color, thickness: thickness)
    }
    
}
