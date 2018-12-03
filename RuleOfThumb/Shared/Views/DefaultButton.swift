//
//  CustomButton.swift
//  RuleOfThumb
//
//  Created by Débora Oliveira on 23/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class DefaultButton: UIButton {

    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.frame.size.height = 40
        
        self.titleEdgeInsets = UIEdgeInsets(top: 15.0, left: 5.0, bottom: 15.0, right: 5.0)
        
        self.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1.0)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        self.setTitleColor(UIColor.black, for: .normal)
    }

}
