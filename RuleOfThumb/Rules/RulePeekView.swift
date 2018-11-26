//
//  RulePeekView.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 20/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class RulePeekView: XibView {
    @IBOutlet weak var ruleTitleLabel: UILabel!
    @IBOutlet weak var dateAuthorLabel: UILabel!
    @IBOutlet weak var ruleDescriptionLabel: UILabel!
    
    override var nibName: String {
        get {
            return "RulePeekView"
        }
    }
}
