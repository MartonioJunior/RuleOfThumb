//
//  HomeCreateViewController.swift
//  RuleOfThumb
//
//  Created by Débora Oliveira on 29/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class HomeCreateViewController: UIViewController {
    
    @IBOutlet weak var promptStep1: PromptView!
    @IBOutlet weak var promptStep2: PromptView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var actionButton: FormButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    var currentPage: Int {
        get {
            return Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        }
    }

    var homeCreated: House?
    var copiedKey = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promptStep1.set(title: "What's the name of your home?")
        promptStep2.set(title: "Here's your Home Key")
        promptStep1.set(delegate: self)
        promptStep2.set(delegate: self)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 2, height: scrollView.frame.height)
        scrollView.contentOffset = CGPoint.zero
        
        promptStep2.isUserInteractionEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        promptStep1.inputTextField.becomeFirstResponder()
    }
    
    @IBAction func actionButtonClicked(_ sender: UIButton) {
        switch currentPage {
        case 0:
            // update page control
            pageControl.currentPage = currentPage
            
            //get home name from textfield
            guard let text = promptStep1.input, text != "" else {
                present(UIAlertController.okAlert(title: "Without name", message: "All home needs a name to be called. Be creative!"), animated: true, completion: nil)
                return
            }
            
            saveHome(name: text)
            
            
            UIView.animate(withDuration: 0.5) {
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: 0)
            }
            
            // setup next step
            promptStep2.inputTextField.text = homeCreated?.openKey
            self.actionButton.setTitle("Copy Key", for: .normal)

            break
        case 1:
            // update page control
            pageControl.currentPage = currentPage
            
            if (copiedKey) {
                self.dismiss(animated: true, completion: nil)
            } else {
                //copy text of key
                copy(text: promptStep2.inputTextField.text)
                self.actionButton.setTitle("Ok", for: .normal)
            }
            break
            
        default:
            break
        }
       
    }
    
    func saveHome(name homeName: String) {
        AppDelegate.repository.setupNewHouse(name: homeName) { (home) in
            self.homeCreated = home
            DispatchQueue.main.sync {
                self.showAlert(text: "Your home's been created and you're logged in")
            }
        }
    }
    
    func copy(text: String?)  {
        UIPasteboard.general.string = text
        
        let alertCopy = UIAlertController(title: nil , message: "Key copied!", preferredStyle: .alert)
        self.present(alertCopy, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            alertCopy.dismiss(animated: true, completion: nil)
            self.copiedKey = true
            self.infoLabel.isHidden = false
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
        promptStep2.inputTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}

extension HomeCreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        actionButtonClicked(actionButton)
        return false
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField == promptStep2.inputTextField {
//            return false
//        } else {
//            return true
//        }
//    }
}


