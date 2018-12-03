//
//  UIView.swift
//  RuleOfThumb
//
//  Created by Paulo José on 30/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addGradientWith(colors: [CGColor]) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
