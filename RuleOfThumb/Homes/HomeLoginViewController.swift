//
//  HomeLoginViewController.swift
//  RuleOfThumb
//
//  Created by Débora Oliveira on 30/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class HomeLoginViewController: UIViewController {
    
    @IBOutlet weak var promptStep1: PromptView!
    @IBOutlet weak var actionButton: FormButton!
    
    var currentHouse : House?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promptStep1.set(title: "What's your home key?")
        promptStep1.set(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        promptStep1.inputTextField.becomeFirstResponder()
    }
    
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        //get home key from textfield
        guard let text = promptStep1.input, text != "" else {
            present(UIAlertController.okAlert(title: "Without key", message: "How do you intend to get into a house without the key?"), animated: true, completion: nil)
            return
        }
        
        loginHome(key: text)
    }
    
    func loginHome(key: String) {
        AppDelegate.repository.getHouse(by: key) { (home) in
            self.currentHouse = home
            
            guard let currentHouse = self.currentHouse else {
                print("Can't find current house")
                return
            }
            
            AppDelegate.repository.addUser(to: currentHouse) { (sucess) in
                if (sucess) {
                    DispatchQueue.main.sync {
                        self.showAlert(text: "You were logged in.")
                        print("User logged in current house.")
                    }
                } else {
                    DispatchQueue.main.sync {
                        self.showAlert(text: "Can't log you in.")
                        print("Can't login user in current house.")
                    }
                }
            }
        }
        
    }
    
    func showAlert(text: String)  {
        let alert = UIAlertController(title: nil , message: text, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelHomeCreation(_ sender: UIBarButtonItem) {
        promptStep1.inputTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}

extension HomeLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        actionButtonClicked(actionButton)
        return false
    }
}

