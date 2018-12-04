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
            guard let rule = rule else { return }
            
            //Set the values of the current rule
            self.setNameLabel(ruleName: rule.name)
            self.setCreatorLabel(creatorName: rule.house?.name ?? "")
            
            // Check in core data if rule was already voted by current user
            guard CoreDataManager.current.getVote(rule: rule) == nil else {
                self.setUpView(voted: true)
                return
            }
            
            // get the actual rule and check if it was already voted
            guard let ruleRecordName = rule.recordName else { return }
            let rulesVoted = CoreDataManager.current.fetch(predicate: "ruleRecordName == %@", arg: ruleRecordName)
            if rulesVoted.count > 0 {
                self.setUpView(voted: true)
            } else {
                self.setUpView(voted: false)
            }
            
        }
    }
    
    // By default, user haven't vote yet
    var voted = false
    
    var votesLeft = 1
    
    // setup the current cardview cell
    func setUpView(voted: Bool) {
        if voted {
            let voteStatus = VotingStatusView()
            voteStatus.frame = votingPrompt.frame
            
            // If there's still some user left to vote
            voteStatus.setLabelText(votesLeft: self.votesLeft)
            
            // replace the current votingPrompt to voteStatus
            self.addSubview(voteStatus)
            votingPrompt.removeFromSuperview()
            votingPrompt = voteStatus
        } else {
            let votePrompt = VotingPromptView()
            //votePrompt.backgroundColor = self.backgroundColor
            votePrompt.frame = votingPrompt.frame
            
            // replace the current votingPrompt to voteStatus
            self.addSubview(votePrompt)
            votingPrompt.removeFromSuperview()
            votingPrompt = votePrompt
            
            // set delegate of votePrompt view (to handle click in "agree" or "disagree")
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
        creatorLabel.text = "Proposed by " + creatorName
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension RuleVotingCardViewCell: VotingPromptViewDelegate {
    func votedOnRule(agreed: Bool) {
        //IJProgressView.shared.showProgressView()
        
        guard let rule = self.rule else {return}
        
        // insert the view voted to core data
        CoreDataManager.current.insert(new: rule)
        
        if (agreed) {
            delegate?.ruleApproved(rule: rule, completion: { (votesLeft) in
                self.votesLeft = votesLeft
                
                DispatchQueue.main.sync {
                    // show the "people left view"
                    self.setUpView(voted: true)
                    //IJProgressView.shared.hideProgressView()
                }
            })
        } else {
            delegate?.ruleRejected(rule: rule)
            //IJProgressView.shared.hideProgressView()
        }
        
    }
}
