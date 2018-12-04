//
//  PrimaryButton.swift
//  RuleOfThumb
//
//  Created by Débora Oliveira on 03/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

@IBDesignable
class PrimaryButton: UIButton {
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor)
        }
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            
            let gradientOffset = self.bounds.height / self.bounds.width / 2
            self.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5 + gradientOffset)
            self.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5 - gradientOffset)
            //gradientLayer.locations = [0.0, 1.0]
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }

}
