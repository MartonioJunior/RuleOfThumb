//
//  HouseSignupViewController.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 29/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class HouseSignupViewController: UIViewController {
    
    func enterExistingHouse(key openKey: String) {
        // Fetch house from CloudKit
        let house = House(name: "Mockup") //House(from: <#T##CKRecord#>)
        // Add user to the House
        // Update House on CloudKit
        // Update User on CloudKit
        let defaults = UserDefaults.standard
        defaults.set(house.openKey ,forKey: "HouseCreated")
    }

}
