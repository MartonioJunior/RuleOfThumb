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
    var rule: MockRule? {
        didSet {
            self.ruleTitleLabel.text = rule?.title
            self.ruleDescriptionLabel.text = rule?.description
            self.setDateAuthorLabel(date: Date(), author: rule?.author)
        }
    }
    
    override var nibName: String {
        get {
            return "RulePeekView"
        }
    }
    
    func setDateAuthorLabel(date: Date, author: String?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateAuthorLabel.text = "Created in \(dateFormatter.string(from: date)) by "+(author ?? "")
    }
}
