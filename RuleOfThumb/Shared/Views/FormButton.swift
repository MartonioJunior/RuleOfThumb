//
//  FormButton.swift
//  RuleOfThumb
//
//  Created by Débora Oliveira on 23/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class FormButton: UIButton {

    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.formButton.cgColor
        
        self.titleEdgeInsets = UIEdgeInsets(top: 15.0, left: 5.0, bottom: 15.0, right: 5.0)
        
        self.backgroundColor = UIColor.gray
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        self.setTitleColor(UIColor.textColor, for: .normal)
    }

}
