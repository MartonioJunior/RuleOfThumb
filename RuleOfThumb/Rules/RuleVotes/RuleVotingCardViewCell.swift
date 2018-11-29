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
    var voteStatus: VotingStatusView?
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDelegate()
    }
    
    private func setDelegate() {
        guard let votePrompt = votingPrompt as? VotingPromptView else {
            return
        }
        votePrompt.delegate = self
    }
    
    func setNameLabel(ruleName: String) {
        nameLabel.text = ruleName
    }
    
    func setCreatorLabel(creatorName: String) {
        creatorLabel.text = "Proposed by "+creatorName
    }
}

extension RuleVotingCardViewCell: VotingPromptViewDelegate {
    
    func votedOnRule(_ rule: Rule, agreed: Bool) {
        let voteStatus = VotingStatusView()
        
        voteStatus.frame = votingPrompt.frame
        voteStatus.setLabelText(votesLeft: 6)
        
        self.addSubview(voteStatus)
        votingPrompt.removeFromSuperview()
        
        votingPrompt = voteStatus
    }
}
