//
//  VotingPromptView.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 22/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class VotingPromptView: XibView {
    override var nibName: String {
        get {
            return "VotingPromptView"
        }
    }
    var delegate: VotingPromptViewDelegate?

    @IBAction func agreedToRule(_ sender: UIButton) {
        delegate?.votedOnRule(agreed: true)
    }
    
    @IBAction func disagreeToRule(_ sender: UIButton) {
        delegate?.votedOnRule(agreed: false)
    }
}
