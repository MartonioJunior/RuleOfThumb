//
//  UIView.swift
//  RuleOfThumb
//
//  Created by Paulo José on 04/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addRoundedBorder() {
        let shadowLayer = CAShapeLayer()
        shadowLayer.masksToBounds = false
        
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 12).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        shadowLayer.shadowOpacity = 0.2
        shadowLayer.shadowRadius = 3
        
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
    
}
