//
//  CustomButton.swift
//  RuleOfThumb
//
//  Created by Débora Oliveira on 23/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class SecondaryButton: UIButton {
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
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.pastelRed90.cgColor
        
        self.titleEdgeInsets = UIEdgeInsets(top: 15.0, left: 5.0, bottom: 15.0, right: 5.0)
        
        self.backgroundColor = UIColor.white
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        self.setTitleColor(UIColor.pastelRed90, for: .normal)
    }
}
