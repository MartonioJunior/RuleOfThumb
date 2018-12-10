//
//  MeetingsCreateViewController.swift
//  RuleOfThumb
//
//  Created by Paulo José on 07/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit

class MeetingsCreateViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var promptStep1: PromptView!
    @IBOutlet weak var promptStep2: PromptView!
    @IBOutlet weak var promptStep3: PromptDateView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var actionButton: FormButton!
    
    var currentPage: Int {
        get {
            return Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        }
    }
    
    var meetingTitle: String = ""
    var meetingReason: String = ""
    var meetingTime: Date = Date()
    
    var repository = AppDelegate.repository
    
    var delegate: MeetingsCreateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        promptStep1.set(title: "What would you like to discuss at this meeting?")
        promptStep2.set(title: "Why?")
        promptStep1.set(delegate: self)
        promptStep2.set(delegate: self)
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width * 3, height: scrollView.frame.height)
        scrollView.contentOffset = CGPoint.zero
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.setTransparentBackground()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        promptStep1.inputTextField.becomeFirstResponder()
    }
    
    @IBAction func continueMeetingCreation(_ sender: Any) {
        switch currentPage {
        case 0:
            guard let text = promptStep1.input, text != "" else {
                present(UIAlertController.okAlert(title: "No meeting", message: "Every meeting must have a name"), animated: true, completion: nil)
                return
            }
            
            meetingTitle = text
            
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width, y: 0)
            }
            
            promptStep1.inputTextField.resignFirstResponder()
            promptStep2.inputTextField.becomeFirstResponder()
            break
        
        case 1:
            guard let text = promptStep2.input, text != "" else {
                present(UIAlertController.okAlert(title: "Why?", message: "Every meetings must have a reason"), animated: true, completion: nil)
                return
            }
            
            meetingReason = text
            
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width * 2, y: 0)
            }
            
            self.actionButton.setTitle("Propose", for: .normal)
//            promptStep2.inputTextField.resignFirstResponder()
            break
            
        case 2:
            let date = promptStep3.datePicker.date
            
            meetingTime = date
            
            self.saveMeeting(title: meetingTitle, agenda: meetingReason, dateScheduled: meetingTime)
            
            dismiss(animated: true, completion: nil)
        default:
            break
        }
        self.pageControl.currentPage = currentPage
    
    }
    
    func saveMeeting(title: String, agenda: String, dateScheduled: Date) {
        self.repository.currentHouse { (house) in
            guard let house = house else { return }
            
            self.repository.getUser(then: { (user) in
                if let username = user.name {
                    let meeting = Meeting(
                        title: title, agenda: agenda, dateScheduled: dateScheduled, creatorName: username, house: house)
                    
                    self.repository.save(meeting: meeting, then: { (savedMeeting) in
                        self.delegate?.proposedNewMeeting(savedMeeting)
                    })
                }
            })
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        promptStep1.resignFirstResponder()
        promptStep2.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
}

extension MeetingsCreateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        continueMeetingCreation(actionButton)
        return false
    }
    
}
