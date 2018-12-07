//
//  MeetingsDetailViewController.swift
//  RuleOfThumb
//
//  Created by Paulo José on 07/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class MeetingsDetailViewController: UIViewController {
    @IBOutlet var separatorViews: [UIImageView]!
    
    @IBOutlet weak var meetingTitleLabel: UILabel!
    @IBOutlet weak var whyLabel: UILabel!
    @IBOutlet weak var whyDescriptionLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileView: CreatorProfileView!
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.profileView.setCircleImageView(#imageLiteral(resourceName: "user-default"))
        self.navigationController?.navigationBar.setTransparentBackground()
    }
    
    func setScheduleLabel(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let message = "Schedule\n" + dateFormatter.string(from: date)
        
        let scheduleString = NSMutableAttributedString(string: message, attributes: nil)
        
        scheduleString.addAttribute(.font, value: UIFont.primaryTextCentralized, range: NSRange(location: 0, length: scheduleString.string.count))
        scheduleString.addAttribute(.foregroundColor, value: UIColor.dusk80, range: NSRange(location: 0, length: scheduleString.string.count))
        scheduleString.addAttribute(.kern, value: -0.38, range: NSRange(location: 0, length: scheduleString.string.count))
        scheduleString.addAttribute(.font, value: UIFont.terciaryTextCentralized, range: NSRange(location: 0, length: 8))
        
        scheduleLabel.attributedText = scheduleString
    }
    
    func setTimeLabel(date: Date) {
        let dateFormatter = DateFormatter()
        
        let message = "Starts at\n" + dateFormatter.string(from: date)
        
        let timeString = NSMutableAttributedString(string: message, attributes: nil)
        
        timeString.addAttribute(.font, value: UIFont.primaryTextCentralized, range: NSRange(location: 0, length: timeString.string.count))
        timeString.addAttribute(.foregroundColor, value: UIColor.dusk80, range: NSRange(location: 0, length: timeString.string.count))
        timeString.addAttribute(.kern, value: -0.38, range: NSRange(location: 0, length: timeString.string.count))
        timeString.addAttribute(.font, value: UIFont.terciaryTextCentralized, range: NSRange(location: 0, length: 9))
        
        timeLabel.attributedText = timeString
    }
    
    func setupStyle() {
        meetingTitleLabel.font = UIFont.detailsHeader
        meetingTitleLabel.textColor = UIColor.dusk
        
        whyLabel.font = UIFont.secondaryTextCentralized
        whyLabel.textColor = UIColor.dusk80
        
        whyDescriptionLabel.font = UIFont.secondaryTextCentralized
        whyDescriptionLabel.textColor = UIColor.dusk80
        
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

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
