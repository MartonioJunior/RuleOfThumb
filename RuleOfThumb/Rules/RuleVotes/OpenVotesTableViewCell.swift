//
//  OpenVotesTableViewCell.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 22/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class OpenVotesTableViewCell: UITableViewCell {
    @IBOutlet weak var votesView: UICollectionView!
    var data = [Rule]()
    var delegate: RuleListViewController?
    var highlightedIndex = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDelegate()
        
        contentView.backgroundColor = UIColor.almostWhite
        votesView.backgroundColor = UIColor.almostWhite
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDelegate() {
        votesView.delegate = self
        votesView.dataSource = self
        votesView.register(UINib(nibName: "RuleVotingCardViewCell", bundle: nil), forCellWithReuseIdentifier: "VoteCard")
        sortAndReload()
    }
    
    func source(forLocation location: CGPoint) -> RuleVotingCardViewCell? {
        guard let indexPath = votesView.indexPathForItem(at: location), let cell = votesView.cellForItem(at: indexPath) as? RuleVotingCardViewCell else {
            return nil
        }
        return cell
    }
    
    func reloadData() {
        votesView.reloadData()
    }
}

// - MARK: CollectionView Delegate & Data Source
extension OpenVotesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = votesView.dequeueReusableCell(withReuseIdentifier: "VoteCard", for: indexPath) as? RuleVotingCardViewCell
        if cell == nil {
            votesView.register(UINib(nibName: "RuleVotingCardViewCell", bundle: nil), forCellWithReuseIdentifier: "VoteCard")
            cell = votesView.dequeueReusableCell(withReuseIdentifier: "VoteCard", for: indexPath) as? RuleVotingCardViewCell
        }
        let rule = data[indexPath.row]
        cell?.rule = rule
        cell?.delegate = self
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 339 , height: 134)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.seeRuleInVotation(rule: data[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        highlightedIndex = indexPath.row
    }
}

// --MARK: Open Votes Delegate
extension OpenVotesTableViewCell: OpenVotesDelegate {
    
    func sortAndReload() {
        data.sort(by: {a,b in
            return a.status == Rule.Status.voting
        })
        DispatchQueue.main.async {
            self.votesView.reloadData()
        }
    }
    
    func ruleApproved(rule: Rule)  {
        rule.addVote(.upVote) { (success) in
            if success {
        
                AppDelegate.repository.save(rule: rule) { (rule) in
                    DispatchQueue.main.sync {
                        // insert the rule voted to core data
                        CoreDataManager.current.insert(new: rule)
                    }
                    
                    if rule.status == Rule.Status.voting {
                        self.delegate?.ruleVoting(rule: rule)
                    } else {
                        self.delegate?.ruleInForce(rule: rule)
                    }
                }
            }
        }
    }
    
    func ruleRejected(rule: Rule) {
        rule.addVote(.downVote) { (success) in
            if success {
                AppDelegate.repository.save(rule: rule) { (rule) in
                    DispatchQueue.main.sync {
                        // insert the rule voted to core data
                        CoreDataManager.current.insert(new: rule)
                    }
                    
                    self.delegate?.ruleRevoked(rule: rule)
                }
            }
        }
    }
    
    
}

// --MARK: Peek and Pop
extension OpenVotesTableViewCell: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let displayInfo = source(forLocation: location), let rule = displayInfo.rule else {
            return nil
        }
        previewingContext.sourceRect = displayInfo.frame
        let peekView = RulePeekView()
        peekView.rule = rule
        
        var previewRule: RuleDetailViewController
        if CoreDataManager.current.getVote(rule: rule) == nil {
            previewRule = RuleDetailViewController()
            previewRule.previewActionDelegate = displayInfo
        } else {
            previewRule = ActionlessRuleDetailViewController()
        }
        previewRule.view.addSubview(peekView)
        previewRule.preferredContentSize = CGSize(width: 0, height:  peekView.mainView.frame.height)
        
        return previewRule
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        delegate?.seeRuleInVotation(rule: data[highlightedIndex])
    }
}
