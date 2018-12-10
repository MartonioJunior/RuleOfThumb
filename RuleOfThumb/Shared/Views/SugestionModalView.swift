//
//  PromptView.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 21/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class SugestionModalView: XibView {
    
    @IBOutlet weak var cardView: UIView!
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
    var delegate: SugestionModalViewDelegate?
    
    override func layoutSubviews() {
        let image = UIImage().imageWithGradient(startColor: UIColor.pale, endColor: UIColor.lightSalmon, size: bounds.size)
        
        self.secondActionButton.backgroundColor = UIColor.init(patternImage: image!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        cardView.addRoundedBorder()
    }
    
    func setDelegate(_ del: SugestionModalViewDelegate) {
        delegate = del
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
    
    func setFirstButtonHidden(hidden: Bool) {
        guard let firstActionButton = firstActionButton else { return }
        firstActionButton.isHidden = hidden
    }
    
    @IBAction func firstButtonAction(_ sender: UIButton) {
        delegate?.pressedLeftButton()
    }
    
    func setSecondButtonTitle(text: String) {
        guard let secondActionButton = secondActionButton else { return }
        secondActionButton.setTitle(text, for: .normal)
    }
    
    func setSecondButtonHidden(hidden: Bool) {
        guard let secondActionButton = secondActionButton else { return }
        secondActionButton.isHidden = hidden
    }

    @IBAction func secondButtonAction(_ sender: UIButton) {
        delegate?.pressedRightButton()
    }
    
}
