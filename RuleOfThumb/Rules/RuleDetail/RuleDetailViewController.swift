//
//  RuleDetailViewController.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 20/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class RuleDetailViewController: UIViewController {
    @IBOutlet var separatorViews: [UIImageView]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileView: CreatorProfileView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var archiveRuleButton: UIButton!
    var delegate: RuleDetailDelegate?
    var previewActionDelegate: RuleVotingCardViewCell?
    var rule: Rule?
    var showPreviewActions: Bool = true
    
    var ruleTitle = "Sem nome"
    var ruleDescription = "Sem descrição"
    var ruleDate = Date(timeIntervalSinceNow: 0)
    var ruleStatus = "Inexistente"
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let rule = rule else { return }
        titleLabel.text = rule.name
        descriptionLabel.text = rule.description
        setStatusLabel(status: rule.status)
        setCreatedAtLabel(date: rule.validFrom ?? Date())
        
        setupStyle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let rule = rule else { return }
        setCreatorLabel(name: rule.creatorName)
        self.profileView.setCircleImageView(#imageLiteral(resourceName: "user-default"))
        self.navigationController?.navigationBar.setTransparentBackground()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modal" {
            guard let destination = segue.destination as? SugestionViewController else {return}
            destination.modalTitle = "Are you sure that you want to archive this rule?"
            destination.modalDescription = "Make sure that all the members of the house agree with this decision. Maybe you should schedule a meeting before doing that."
            destination.firstButtonTitle = "Not yet"
            destination.secondButtonTitle = "Yes, I'm sure"
            destination.rightAction = confirmArchive
        }
    }
    
    func setStatusLabel(status: Rule.Status) {
        switch status {
        case .voting:
            statusLabel.text = "Voting"
            break
        case .revoked:
            statusLabel.text = "Revoked"
            break
        case .inForce:
            statusLabel.text = "In force"
            break
        }
    }
    
    func setCreatedAtLabel(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let message = "Created at\n"+dateFormatter.string(from: date)
        
        let createdAtString = NSMutableAttributedString(string: message, attributes: nil)
        createdAtString.addAttribute(.font, value: UIFont.primaryTextCentralized, range: NSRange(location: 0, length: createdAtString.string.count))
        createdAtString.addAttribute(.foregroundColor, value: UIColor.dusk80, range: NSRange(location: 0, length: createdAtString.string.count))
        createdAtString.addAttribute(.kern, value: -0.38, range: NSRange(location: 0, length: createdAtString.string.count))
        createdAtString.addAttribute(.font, value: UIFont.terciaryTextCentralized, range: NSRange(location: 0, length: 10))
        createdAtLabel.attributedText = createdAtString
    }
    
    func setCreatorLabel(name: String?) {
        guard let name = name else { return }
//        let message = "Created by\n"+name
        profileView.setProfileLabel(text: name)
    }
    
    func confirmArchive() {
        guard let rule = self.rule else {return}
        delegate?.ruleArchived(rule: rule)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupStyle() {
        titleLabel.font = UIFont.detailsHeader
        titleLabel.textColor = UIColor.dusk
        
        descriptionLabel.font = UIFont.secondaryText
        descriptionLabel.textColor = UIColor.dusk80
        
        statusLabel.font = UIFont.secondaryTextCentralized
        statusLabel.textColor = UIColor.dusk80
        
        separatorViews.forEach { (separator) in
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = separator.bounds
            gradientLayer.colors = [UIColor.lightSalmon.cgColor, UIColor.pale.cgColor]
            gradientLayer.borderColor = separator.layer.borderColor
            gradientLayer.borderWidth = separator.layer.borderWidth
            gradientLayer.cornerRadius = separator.layer.cornerRadius
            
            let gradientOffset = separator.bounds.height / separator.bounds.width / 2
            self.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5 + gradientOffset)
            self.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5 - gradientOffset)
            //gradientLayer.locations = [0.0, 1.0]
            separator.layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
    
    @IBAction func archiveRule(_ sender: UIButton) {
        self.performSegue(withIdentifier: "modal", sender: nil)
    }
    
    @IBAction func returnButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        let agree = UIPreviewAction(title: "Agree", style: .default, handler: { (action, viewController) in
            print("I agree / Update in CloudKit here")
            self.previewActionDelegate?.votedOnRule(agreed: true)
        })
        let disagree = UIPreviewAction(title: "Disagree", style: .default, handler:{ (action, viewController) in
            print("I disagree / Update in CloudKit here")
            self.previewActionDelegate?.votedOnRule(agreed: false)
        })
        let cancel = UIPreviewAction(title: "Cancel", style: .destructive, handler:{ (action, viewController) in
        })

        return[agree, disagree, cancel]
    }

}
