//
//  PromptDateView.swift
//  RuleOfThumb
//
//  Created by Paulo José on 07/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class PromptDateView: XibView {
    
    override var nibName: String {
        get {
            return "PromptDateView"
        }
    }

    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        promptLabel.font = UIFont.promptStyle
        promptLabel.textColor = UIColor.dusk
    }
    
}
