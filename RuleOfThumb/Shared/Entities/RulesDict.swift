//
//  RulesCK.swift
//  RuleOfThumb
//
//  Created by Débora Oliveira on 09/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation

import Foundation

public class RulesDict {
    static var all : [[String: String]] = [] {
        didSet {
            let defaults = UserDefaults(suiteName:
                "group.somanydeadlines.VeeHome")
            
            defaults?.set(all, forKey: "allRulesInForce")
            print(defaults?.array(forKey: "allRulesInForce"))
        }
    }
}
