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
    
    func setProfileLabel(text: NSAttributedString?) {
        guard let profileLabel = profileLabel else { return }
        profileLabel.attributedText = text
    }
}
