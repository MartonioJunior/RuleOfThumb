//
//  MeetingsListTableViewCell.swift
//  RuleOfThumb
//
//  Created by Paulo José on 07/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class MeetingsListTableViewCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dateLabel.font = UIFont.primaryText
        dateLabel.textColor = UIColor.dusk
        
        timeLabel.font = UIFont.terciaryText
        timeLabel.textColor = UIColor.dusk80
        
        detailLabel.font = UIFont.secondaryText
        detailLabel.textColor = UIColor.dusk80
        
        cardView.addRoundedBorder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
