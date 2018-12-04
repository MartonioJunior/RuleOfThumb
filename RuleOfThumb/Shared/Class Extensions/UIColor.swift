//
//  UIColor.swift
//  RuleOfThumb
//
//  Created by Débora Oliveira on 23/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

extension UIColor {
    static let defaultButton = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
    
    static let formButton = UIColor(red:0.5, green:0.5, blue:0.5, alpha:1.0)
    static let textColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.0)
    
    @nonobjc class var pastelRed90: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 96.0 / 255.0, blue: 91.0 / 255.0, alpha: 0.9)
    }
    
    @nonobjc class var pastelRed40: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 96.0 / 255.0, blue: 91.0 / 255.0, alpha: 0.4)
    }
    
    @nonobjc class var dusk: UIColor {
        return UIColor(red: 86.0 / 255.0, green: 75.0 / 255.0, blue: 109.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var dusk90: UIColor {
        return UIColor(red: 86.0 / 255.0, green: 75.0 / 255.0, blue: 109.0 / 255.0, alpha: 0.9)
    }
    
    @nonobjc class var dusk80: UIColor {
        return UIColor(red: 86.0 / 255.0, green: 75.0 / 255.0, blue: 109.0 / 255.0, alpha: 0.8)
    }
    
    @nonobjc class var veryLightPink50: UIColor {
        return UIColor(white: 217.0 / 255.0, alpha: 0.5)
    }
    
    @nonobjc class var almostBlack90: UIColor {
        return UIColor(red: 16.0 / 255.0, green: 18.0 / 255.0, blue: 19.0 / 255.0, alpha: 0.9)
    }
    
    @nonobjc class var almostWhite: UIColor {
        return UIColor(white: 248.0 / 255.0, alpha: 1.0)
    }
}
