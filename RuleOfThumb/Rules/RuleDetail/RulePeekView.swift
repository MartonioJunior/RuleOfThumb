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
    
    @IBOutlet weak var mainView: UIView!
    
    var rule: Rule? {
        didSet {
            self.ruleTitleLabel.text = rule?.name
            self.ruleDescriptionLabel.text = rule?.description
            self.setDateAuthorLabel(date: rule?.validFrom, author: rule?.house?.name)
        }
    }
    
    override func layoutSubviews() {
        self.contentView.frame = self.mainView.frame
    }
    
    override var nibName: String {
        get {
            return "RulePeekView"
        }
    }
    
    func setDateAuthorLabel(date: Date?, author: String?) {
        var message = "Created "
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            message += "in \(dateFormatter.string(from: date))"
        }
        dateAuthorLabel.text = message+"by "+(author ?? "")
    }
    
}
