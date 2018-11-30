//
//  HouseSignupViewController.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 29/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class HouseSignupViewController: UIViewController {
    @IBOutlet weak var promptStep1: PromptView!
    @IBOutlet weak var promptStep2: PromptView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var houseName: String = ""
    var houseID: UUID?
    
    var currentPage: Int {
        get {
            return Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promptStep1.set(title: "Qual o nome da sua casa?")
        promptStep2.set(title: "O ID da sua casa é")
        promptStep1.set(delegate: self)
        promptStep2.set(delegate: self)
        promptStep2.inputTextField.allowsEditingTextAttributes = false
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 2, height: scrollView.frame.height)
        scrollView.contentOffset = CGPoint.zero
    }

    override func viewDidAppear(_ animated: Bool) {
        promptStep1.inputTextField.becomeFirstResponder()
    }
    
    @IBAction func continueHouseRegistration(_ sender: UIButton) {
        switch currentPage {
        case 0:
            guard let text = promptStep1.input, text != "" else {
                present(UIAlertController.okAlert(title: "Sem nome", message: "A casa precisa de um nome"), animated: true, completion: nil)
                return
            }
            houseName = text
            if houseID == nil {
                houseID = UUID()
                saveHouse(house: houseName, id: houseID)
            }
            UIView.animate(withDuration: 0.5) {
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: 0)
            }
            self.actionButton.setTitle("Feito", for: .normal)
            promptStep1.inputTextField.resignFirstResponder()
            break
        case 1:
            promptStep2.inputTextField.resignFirstResponder()
            dismiss(animated: true, completion: nil)
            break
        default:
            break
        }
        pageControl.currentPage = currentPage
    }
    
    func saveHouse(house: String, id: UUID?) {
        guard let id = id else { return }
        let defaults = UserDefaults.standard
        let house = House(name: house)
        house.recordID = id.uuidString.data(using: .utf8)
        AppDelegate.repository.create(house: house) { (house) in
            defaults.set(house.recordName, forKey: "HouseCreated")
        }
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        switch currentPage {
            case 0:
                promptStep1.inputTextField.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
                break
            case 1:
                promptStep2.inputTextField.resignFirstResponder()
                promptStep1.inputTextField.becomeFirstResponder()
                UIView.animate(withDuration: 0.5) {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                }
                break
            default:
                break
        }
        pageControl.currentPage = currentPage
    }
    
    @IBAction func changedValue(_ sender: UITextField) {
        
    }
}

extension HouseSignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        continueHouseRegistration(actionButton)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == promptStep2.inputTextField {
            return false
        } else {
            return true
        }
    }
}
