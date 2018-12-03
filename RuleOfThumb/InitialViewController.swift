//
//  InitialViewController.swift
//  RuleOfThumb
//
//  Created by Débora Oliveira on 03/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let defaults = UserDefaults.standard
//
//        if defaults.string(forKey: "HomeCreated") != nil {
//            self.performSegue(withIdentifier: "goToMain", sender: nil)
//            print("Already logged")
//        } else {
//            print("Not logged yet")
//        }
        
        AppDelegate.repository.currentHouse { (home) in
            if home != nil {
                DispatchQueue.main.sync {
                    self.performSegue(withIdentifier: "goToMain", sender: nil)
                    print("Already logged")
                }
            } else {
                print("Not logged yet")
            }
        }
    }

}
