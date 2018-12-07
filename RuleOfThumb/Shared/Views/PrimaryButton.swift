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
    var firstTimeRendering = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.layer.frame.height / 2
        
        self.titleEdgeInsets = UIEdgeInsets(top: 15.0, left: 5.0, bottom: 15.0, right: 5.0)
        
        var image = UIImage().imageWithGradient(startColor: UIColor.pale, endColor: UIColor.lightSalmon, size: bounds.size)
        self.backgroundColor = UIColor.init(patternImage: image!)
        
        self.titleLabel?.font = UIFont.actionText
        self.setTitleColor(UIColor.white, for: .normal)
    
        
    }
}
