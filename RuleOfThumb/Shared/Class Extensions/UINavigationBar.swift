//
//  UINavigationBar.swift
//  RuleOfThumb
//
//  Created by Paulo José on 04/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        var updatedFrame = bounds
        updatedFrame.size.height += 44
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        self.setBackgroundImage(gradientLayer.createGradienteImage(), for: .default)
    }
    
    func setTransparentBackground() {
//        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.barTintColor = UIColor(patternImage:UIImage())
    }
    
    func setBarTintColorWithGradient(colors: [UIColor], size: CGSize) {
        let image = UIImage().imageWithGradient(startColor: colors[0], endColor: colors[1], size: size)
        self.barTintColor = UIColor(patternImage: image!)
        self.shadowImage = UIImage()
    }
    
}
