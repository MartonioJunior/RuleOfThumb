//
//  VotingStatusView.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 22/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class VotingStatusView: XibView {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var votesLeftLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    override var nibName: String {
        get {
            return "VotingStatusView"
        }
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        setupStyle()
    }
    
    func setLabelText(votesLeft: Int) {
        votesLeftLabel.text = votesLeft == 1 ? "1 person left" : "\(votesLeft) people left"
    }
    
    func setupStyle() {
        votesLeftLabel.font = UIFont.terciaryText
        votesLeftLabel.textColor = UIColor.dusk80
        
        statusLabel.font = UIFont.secondaryText
        statusLabel.textColor = UIColor.dusk80
    }
}
