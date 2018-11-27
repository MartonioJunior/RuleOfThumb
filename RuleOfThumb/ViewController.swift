//
//  ViewController.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 19/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    static func fetchHome(completion: @escaping ((House) -> Void)) {
        let defaults = UserDefaults.standard
        guard let id = defaults.string(forKey: "HouseCreated") else { return }
        CloudKitRepository.fetchById(CKRecord.ID(recordName: id)) { (record) in
            let house = House(from: record)
            completion(house)
        }
    }
}

