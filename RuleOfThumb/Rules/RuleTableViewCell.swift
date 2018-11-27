//
//  RuleTableViewCell.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 19/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class RuleTableViewCell: UITableViewCell {
    @IBOutlet weak var ruleTitleLabel: UILabel!
    @IBOutlet weak var ruleDescriptionLabel: UILabel!
    var rule: Rule? {
        didSet {
            ruleTitleLabel.text = rule?.name
            ruleDescriptionLabel.text = rule?.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
