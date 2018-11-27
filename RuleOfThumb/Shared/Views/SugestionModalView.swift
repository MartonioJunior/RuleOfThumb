//
//  PromptView.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 21/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class SugestionModalView: XibView {
    
    @IBOutlet weak var modalImage: UIImageView!
    @IBOutlet weak var modalTitleLabel: UILabel!
    @IBOutlet weak var modalDescriptionLabel: UILabel!
    @IBOutlet weak var firstActionButton: UIButton!
    @IBOutlet weak var secondActionButton: UIButton!
    
    override var nibName: String {
        get {
            return "SugestionModalView"
        }
    }
    
    func setModalImageView(_ image: UIImage) {
        guard let modalImage = modalImage else { return }
        modalImage.image = image
    }
    
    func setTitleLabel(text: String) {
        guard let modalTitleLabel = modalTitleLabel else { return }
        modalTitleLabel.text = text
    }

    func setDescriptionLabel(text: String) {
        guard let modalDescriptionLabel = modalDescriptionLabel else { return }
        modalDescriptionLabel.text = text
    }

    func setFirstButtonTitle(text: String) {
        guard let firstActionButton = firstActionButton else { return }
        firstActionButton.setTitle(text, for: .normal)
    }

    func setSecondButtonTitle(text: String) {
        guard let secondActionButton = secondActionButton else { return }
        secondActionButton.setTitle(text, for: .normal)
    }

    
}
