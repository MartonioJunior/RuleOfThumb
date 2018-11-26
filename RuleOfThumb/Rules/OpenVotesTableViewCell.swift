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
    var data = [MockRule]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setDelegate()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDelegate() {
        votesView.delegate = self
        votesView.dataSource = self
        votesView.register(UINib(nibName: "RuleVotingCardViewCell", bundle: nil), forCellWithReuseIdentifier: "VoteCard")
        
        let nib = UINib(nibName: "RuleVotingCardViewCell", bundle: nil)
        print(nib)
    }
    
    func reloadData() {
        votesView.reloadData()
    }
}

// - MARK: CollectionView Delegate & Data Source
extension OpenVotesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = votesView.dequeueReusableCell(withReuseIdentifier: "VoteCard", for: indexPath) as? RuleVotingCardViewCell
        if cell == nil {
            votesView.register(UINib(nibName: "RuleVotingCardViewCell", bundle: nil), forCellWithReuseIdentifier: "VoteCard")
            cell = votesView.dequeueReusableCell(withReuseIdentifier: "VoteCard", for: indexPath) as? RuleVotingCardViewCell
        }
        let rule = data[indexPath.row]
        cell?.setNameLabel(ruleName: rule.title)
        cell?.setCreatorLabel(creatorName: "Anne")
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 323, height: 112)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
