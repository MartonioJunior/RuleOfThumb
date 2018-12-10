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

    func setupCell(with meeting: Meeting) {
        self.detailLabel.text = meeting.title
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.dateFormat = "dd/MM/yyyy"
        self.dateLabel.text = formatter.string(from: meeting.dateScheduled)
        
        formatter.dateFormat = "HH:mm a"
        self.timeLabel.text = formatter.string(from: meeting.dateScheduled)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
