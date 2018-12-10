//
//  DetailsInterfaceController.swift
//  VeeHomeWatch Extension
//
//  Created by Débora Oliveira on 06/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import WatchKit
import Foundation


class DetailsInterfaceController: WKInterfaceController {

    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    @IBOutlet weak var descriptionLabel: WKInterfaceLabel!
    @IBOutlet weak var creatorLabel: WKInterfaceLabel!
    @IBOutlet weak var creatorImage: WKInterfaceImage!
    
    var rule : [String : String] = [:] {
        didSet {
            nameLabel.setText(rule["name"])
            descriptionLabel.setText(rule["description"])
            creatorLabel.setText(rule["creator"])
            creatorImage.setImage(UIImage(named: "user-default"))
            dateLabel.setText(rule["date"])
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let rule = context as? [String : String] {
            self.rule = rule
        } else {
            print("Rule haven't been sent.")
        }
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

}
