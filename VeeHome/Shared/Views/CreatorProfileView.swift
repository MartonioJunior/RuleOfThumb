//
//  CreatorProfileView.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 20/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class CreatorProfileView: XibView {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    
    override var nibName: String {
        get {
           return "CreatorProfileView"
        }
    }
    
    func setCircleImageView(_ image: UIImage) {
        guard let profileImage = profileImage else { return }
        profileImage.backgroundColor = .white
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 0
        profileImage.image = image
    }
    
    func setProfileLabel(text: String?) {
        guard let profileLabel = profileLabel, let text = text else { return }
        
        let creatorString = NSMutableAttributedString(string: "Created by\n"+text, attributes: nil)
        creatorString.addAttribute(.font, value: UIFont.primaryTextCentralized, range: NSRange(location: 0, length: creatorString.string.count))
        creatorString.addAttribute(.foregroundColor, value: UIColor.dusk80, range: NSRange(location: 0, length: creatorString.string.count))
        creatorString.addAttribute(.kern, value: -0.43, range: NSRange(location: 0, length: creatorString.string.count))
        creatorString.addAttribute(.font, value: UIFont.terciaryTextCentralized, range: NSRange(location: 0, length: 11))
        
        profileLabel.attributedText = creatorString
    }
}
