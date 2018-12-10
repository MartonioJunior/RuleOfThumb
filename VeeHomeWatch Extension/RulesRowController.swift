//
//  RulesRowController.swift
//  VeeHomeWatch Extension
//
//  Created by Débora Oliveira on 06/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import WatchKit

class RulesRowController: NSObject {
    @IBOutlet var ruleNameLabel: WKInterfaceLabel!
    
    
    var ruleName: String? {
        didSet {
            ruleNameLabel.setText(ruleName)
        }
    }
}
