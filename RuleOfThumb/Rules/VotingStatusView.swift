//
//  VotingStatusView.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 22/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class VotingStatusView: XibView {
    @IBOutlet weak var votesLeftLabel: UILabel!
    override var nibName: String {
        get {
            return "VotingStatusView"
        }
    }
    
    func setLabelText(votesLeft: Int) {
        votesLeftLabel.text = votesLeft == 1 ? "1 person left" : "\(votesLeft) people left"
    }
}
