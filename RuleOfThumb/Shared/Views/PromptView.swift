//
//  PromptView.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 21/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class PromptView: XibView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    override var nibName: String {
        get {
            return "PromptView"
        }
    }
    
    var input: String? {
        get {
            return inputTextField.text
        }
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(delegate: UITextFieldDelegate) {
        inputTextField.delegate = delegate
    }
}
