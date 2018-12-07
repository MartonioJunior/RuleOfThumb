//
//  RuleVotingEmptyCardViewCell.swift
//  RuleOfThumb
//
//  Created by Paulo José on 07/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class RuleVotingEmptyCardViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cardView.addRoundedBorder()
        statusLabel.font = UIFont.primaryTextCentralized
        statusLabel.textColor = UIColor.dusk
        
    }

}
