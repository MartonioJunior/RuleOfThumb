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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addRoundedBorder(to: cardView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupStyle()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addRoundedBorder(to view: UIView) {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.masksToBounds = false
            
            shadowLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            
            view.layer.insertSublayer(shadowLayer, at: 0)
        }
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
