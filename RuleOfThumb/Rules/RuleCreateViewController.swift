//
//  RuleCreateViewController.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 21/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class RuleCreateViewController: UIViewController {
    @IBOutlet weak var promptStep1: PromptView!
    @IBOutlet weak var promptStep2: PromptView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var currentPage: Int {
        get {
            return Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        }
    }
    var delegate: RuleCreateDelegate?
    var ruleName: String = ""
    var ruleReason: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promptStep1.set(title: "Qual regra você gostaria de propor?")
        promptStep2.set(title: "Por quê?")
        promptStep1.set(delegate: self)
        promptStep2.set(delegate: self)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 2, height: scrollView.frame.height)
        scrollView.contentOffset = CGPoint.zero
    }
    
    override func viewDidAppear(_ animated: Bool) {
        promptStep1.inputTextField.becomeFirstResponder()
    }
    
    @IBAction func continueRuleRegistration(_ sender: UIButton) {
        switch currentPage {
            case 0:
                guard let text = promptStep1.input, text != "" else {
                    present(UIAlertController.okAlert(title: "Sem regra", message: "Toda regra precisa ser escrita para existir"), animated: true, completion: nil)
                    return
                }
                ruleName = text
                UIView.animate(withDuration: 0.5) {
                    self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: 0)
                }
                self.actionButton.setTitle("Propor", for: .normal)
                promptStep1.inputTextField.resignFirstResponder()
                promptStep2.inputTextField.becomeFirstResponder()
                break
            case 1:
                guard let text = promptStep2.input, text != "" else {
                    present(UIAlertController.okAlert(title: "Sem justificativa", message: "Toda regra precisa de uma razão, senão ela é injusta"), animated: true, completion: nil)
                    return
                }
                ruleReason = text
                saveRule(name: ruleName, reason: ruleReason)
                promptStep2.inputTextField.resignFirstResponder()
                dismiss(animated: true, completion: nil)
                break
            default:
                break
        }
        pageControl.currentPage = currentPage
    }
    
    func saveRule(name: String, reason: String) {
        let newRule = MockRule(title: name, description: reason, author: "Moura", date: Date(), status: "Em votação")
        delegate?.proposedNewRule(newRule)
    }
    
    @IBAction func cancelRuleCreation(_ sender: UIBarButtonItem) {
        promptStep1.inputTextField.resignFirstResponder()
        promptStep2.inputTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}

extension RuleCreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        continueRuleRegistration(actionButton)
        return false
    }
}
