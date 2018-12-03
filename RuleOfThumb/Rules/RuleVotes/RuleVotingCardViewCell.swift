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
    
     var shadowLayer: CAShapeLayer!

    var rule: Rule? {
        didSet {
            guard let rule = rule else {return}
            self.setNameLabel(ruleName: rule.name)
            self.setCreatorLabel(creatorName: "Anne")
            self.setUpView(voted: rule.status != .voting)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addRoundedBorder(to: view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }
    
    func setUpView(voted: Bool) {
        if voted {
            let voteStatus = VotingStatusView()
            voteStatus.backgroundColor = self.backgroundColor
            voteStatus.frame = votingPrompt.frame
            voteStatus.setLabelText(votesLeft: 6)
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
    
    func setupStyle() {
        nameLabel.font = UIFont.primaryText
        nameLabel.textColor = UIColor.dusk
        
        creatorLabel.font = UIFont.terciaryText
        creatorLabel.textColor = UIColor.dusk80
    }
    
    func addRoundedBorder(to view: UIView) {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.masksToBounds = false
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            
            view.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

extension RuleVotingCardViewCell: VotingPromptViewDelegate {
    
    func votedOnRule(agreed: Bool) {
        setUpView(voted: true)
        guard let rule = rule else {return}
        agreed ? delegate?.ruleApproved(rule: rule) : delegate?.ruleRefused(rule: rule)
    }
}
