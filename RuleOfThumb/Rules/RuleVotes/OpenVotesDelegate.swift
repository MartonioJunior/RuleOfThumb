//
//  OpenVotesDelegate.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 28/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

protocol OpenVotesDelegate {
    func ruleApproved(rule: Rule)
    func ruleRefused(rule: Rule)
}

extension OpenVotesDelegate where Self: UIViewController {
    func seeRuleInVotation(rule: Rule) {
        performSegue(withIdentifier: "detail", sender: rule)
    }
}
