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
    
    @IBOutlet weak var cardView: UIView!
    
    var shadowLayer: CAShapeLayer!
    
    var rule: Rule? {
        didSet {
            ruleTitleLabel.text = rule?.name
            ruleDescriptionLabel.text = rule?.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.addRoundedBorder()
        setupStyle()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupStyle() {
        
        contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        
        ruleTitleLabel.font = UIFont.primaryText
        ruleTitleLabel.textColor = UIColor.dusk
        
        ruleDescriptionLabel.font = UIFont.secondaryText
        ruleDescriptionLabel.textColor = UIColor.dusk80
        
    }
    
}
