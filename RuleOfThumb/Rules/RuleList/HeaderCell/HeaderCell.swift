//
//  HeaderCell.swift
//  RuleOfThumb
//
//  Created by Paulo José on 04/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var headerTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headerTitleLabel.font = UIFont.sectionText
        self.headerTitleLabel.textColor = UIColor.dusk
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
