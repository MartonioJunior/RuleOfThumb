//
//  RuleEmptyTableViewCell.swift
//  RuleOfThumb
//
//  Created by Paulo José on 06/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class RuleEmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        statusLabel.font = UIFont.primaryTextCentralized
        statusLabel.textColor = UIColor.dusk
        
        commentLabel.font = UIFont.secondaryTextCentralized
        commentLabel.textColor = UIColor.dusk80
        
        cardView.addRoundedBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
