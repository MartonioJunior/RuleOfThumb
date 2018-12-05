//
//  RuleListDelegate.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 04/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

protocol RuleListDelegate {
    func ruleInForce(rule: Rule)
    func ruleRevoked(rule: Rule)
    func ruleVoting(rule: Rule)
}

extension RuleListDelegate where Self: UIViewController {
    func seeRuleInVotation(rule: Rule) {
        performSegue(withIdentifier: "detail", sender: rule)
    }
}
