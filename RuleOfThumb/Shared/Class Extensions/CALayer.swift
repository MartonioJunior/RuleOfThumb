//
//  CALayer.swift
//  RuleOfThumb
//
//  Created by Paulo José on 30/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    
    func addRoundedCorner(radius: CGFloat) {
        self.cornerRadius = radius
        self.masksToBounds = true
    }
    
    func addShadow(color: UIColor, alpha: Float = 0.5, x: CGFloat, y: CGFloat, blur: CGFloat = 0, spread: CGFloat) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = 4
        
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
    }
    
    
}
