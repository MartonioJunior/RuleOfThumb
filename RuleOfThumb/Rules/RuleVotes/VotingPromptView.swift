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
        delegate?.votedOnRule(agreed: true)
        print("I agree / Update in CloudKit here")
    }
    
    @IBAction func disagreeToRule(_ sender: UIButton) {
        delegate?.votedOnRule(agreed: false)
        print("I disagree / Update in CloudKit here")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.layoutIfNeeded()
    }
    
}
