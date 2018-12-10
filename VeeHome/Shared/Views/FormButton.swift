//
//  FormButton.swift
//  RuleOfThumb
//
//  Created by Débora Oliveira on 23/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class FormButton: UIButton {
   
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
        //self.layer.borderWidth = 1.0
        //self.layer.borderColor = UIColor.pastelRed90.cgColor
        
        self.titleEdgeInsets = UIEdgeInsets(top: 15.0, left: 5.0, bottom: 15.0, right: 5.0)
        
//        self.layer.backgroundColor = UIColor(red: 235/255, green: 185/255, blue: 170/255, alpha: 1.0).cgColor
        self.titleLabel?.font = UIFont.actionText
        self.setTitleColor(UIColor.white, for: .normal)
        
        let bgImage = UIImage().imageWithGradient(startColor: UIColor.lightSalmon, endColor: UIColor.pale, size: self.layer.bounds.size)
        self.backgroundColor = UIColor(patternImage: bgImage!)
        
        
    }

}
