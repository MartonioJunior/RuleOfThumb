//
//  VotingPromptView.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 22/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class VotingPromptView: XibView {
    
    @IBOutlet weak var view: UIView!
    
    override var nibName: String {
        get {
            return "VotingPromptView"
        }
    }
    var delegate: VotingPromptViewDelegate?

    @IBAction func agreedToRule(_ sender: UIButton) {
        delegate?.votedOnRule(Rule(name: "Regra teste", description: "Concordada", house: House(name: "000")), agreed: true)
        print("I agree / Update in CloudKit here")
    }
    
    @IBAction func disagreeToRule(_ sender: UIButton) {
        delegate?.votedOnRule(Rule(name: "Regra teste", description: "Discordada", house: House(name: "000")), agreed: false)
        print("I disagree / Update in CloudKit here")
    }
}
