//
//  RuleVotingCardViewCell.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 22/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class RuleVotingCardViewCell: UICollectionViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var votingPrompt: XibView!
    @IBOutlet weak var view: UIView!
    
    var voteStatus: VotingStatusView?
    var delegate: OpenVotesDelegate?

    var rule: Rule? {
        didSet {
            guard let rule = rule else {return}
            self.setNameLabel(ruleName: rule.name)
            self.setCreatorLabel(creatorName: "Anne")
            self.setUpView(voted: rule.status != .voting) // || rule.voted)
        }
    }
    var voted = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpView(voted: Bool) {
        if voted {
            let voteStatus = VotingStatusView()
            voteStatus.backgroundColor = self.backgroundColor
            voteStatus.frame = votingPrompt.frame
            //if let votesLeft = rule?.votesLeft {
                voteStatus.setLabelText(votesLeft: 1) //votesLeft)
            //}
            self.addSubview(voteStatus)
            votingPrompt.removeFromSuperview()
            votingPrompt = voteStatus
        } else {
            let votePrompt = VotingPromptView()
            votePrompt.backgroundColor = self.backgroundColor
            votePrompt.frame = votingPrompt.frame
            self.addSubview(votePrompt)
            votingPrompt.removeFromSuperview()
            votingPrompt = votePrompt
            setDelegate()
        }
    }
    
    private func setDelegate() {
        guard let votingPrompt = votingPrompt as? VotingPromptView else {
            return
        }
        votingPrompt.delegate = self
    }
    
    func setNameLabel(ruleName: String) {
        nameLabel.text = ruleName
    }
    
    func setCreatorLabel(creatorName: String) {
        creatorLabel.text = "Proposed by "+creatorName
    }
}

extension RuleVotingCardViewCell: VotingPromptViewDelegate {
    func votedOnRule(agreed: Bool) {
        guard let rule = rule else {return}
        let peopleAmountAtHome = 7
        var votesLeft = Int.random(in: 1...peopleAmountAtHome)
        var peopleAgreed = Int.random(in: 1...peopleAmountAtHome-votesLeft)
        voted = true
        votesLeft -= 1
        setUpView(voted: voted)
        if agreed { peopleAgreed += 1 }
        if votesLeft <= 0 {
            (peopleAgreed * 2 > peopleAmountAtHome) ? delegate?.ruleApproved(rule: rule) : delegate?.ruleRefused(rule: rule)
        }
    }
}
