//
//  RuleDetailViewController.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 20/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class RuleDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileView: CreatorProfileView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var archiveRuleButton: UIButton!
    
    var rule: MockRule?
    
    var ruleTitle = "Sem nome"
    var ruleDescription = "Sem descrição"
    var ruleDate = Date(timeIntervalSinceNow: 0)
    var ruleStatus = "Inexistente"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let rule = rule else { return }
        titleLabel.text = rule.title
        descriptionLabel.text = rule.description
        statusLabel.text = rule.status
        setCreatedAtLabel(date: rule.date)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let rule = rule else { return }
        setCreatorLabel(name: rule.author)
        profileView.setCircleImageView(UIImage())
    }
    
    func setCreatedAtLabel(date: Date?) {
        guard let date = date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let message = "Criada em\n"+dateFormatter.string(from: date)
        
        let createdAtString = NSMutableAttributedString(string: message, attributes: nil)
        createdAtString.addAttribute(.font, value: UIFont.systemFont(ofSize: 20.0, weight: .semibold), range: NSRange(location: 0, length: createdAtString.string.count))
        createdAtString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: createdAtString.string.count))
        createdAtString.addAttribute(.kern, value: -0.38, range: NSRange(location: 0, length: createdAtString.string.count))
        createdAtString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0, weight: .regular), range: NSRange(location: 0, length: 9))
        createdAtLabel.attributedText = createdAtString
    }
    
    func setCreatorLabel(name: String?) {
        guard let name = name else { return }
        let message = "Criada por\n"+name
        let creatorString = NSMutableAttributedString(string: message, attributes: nil)
        creatorString.addAttribute(.font, value: UIFont.systemFont(ofSize: 17.0, weight: .regular), range: NSRange(location: 0, length: creatorString.string.count))
        creatorString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: creatorString.string.count))
        creatorString.addAttribute(.kern, value: -0.43, range: NSRange(location: 0, length: creatorString.string.count))
        creatorString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14.0, weight: .semibold), range: NSRange(location: 0, length: 11))
        profileView.setProfileLabel(text: creatorString)
    }
    
    @IBAction func archiveRule(_ sender: UIButton) {
        
    }
    
    @IBAction func returnButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
