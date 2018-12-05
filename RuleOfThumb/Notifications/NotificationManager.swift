//
//  NotificationManager.swift
//  RuleOfThumb
//
//  Created by Matheus Costa on 23/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject {
    
    private var notificationCenter = UNUserNotificationCenter.current()
    
    /// Requests authorization for notifications
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        
        center.requestAuthorization(options: options) { (granted, error) in
            print("granted: \(granted)")
        }
        
        center.delegate = self
    }
    
    func addRequestToNotificationCenter(with notificationContent: UNMutableNotificationContent, forIdentifier identifier: String) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        notificationCenter.add(request) { (error) in
            print(error?.localizedDescription ?? "Error")
        }
    }
    
    func sendRuleProposalNotification(rule: Rule) {
        let notificationContent = self.adaptRuleProposalNotification(rule: rule, content: UNMutableNotificationContent())
        guard let recordName = rule.recordName else { return }
        self.addRequestToNotificationCenter(with: notificationContent, forIdentifier: "Proposed.\(recordName)")
    }
    
    func adaptRuleProposalNotification(rule: Rule, content: UNMutableNotificationContent) -> UNMutableNotificationContent {
        content.title = "New rule proposed"
        content.body = rule.name
        if let numberNotification = content.badge {
            content.badge = NSNumber(integerLiteral: numberNotification.intValue + 1)
        } else {
            content.badge = 1
        }
        content.threadIdentifier = "ruleProposed"
        content.summaryArgument = " new rules proposed"
        
        let agreeAction = UNNotificationAction(identifier: "agree", title: "Agree", options: [])
        let disagreeAction = UNNotificationAction(identifier: "disagree", title: "Disagree", options: [])
        let category = UNNotificationCategory(identifier: "votation", actions: [agreeAction, disagreeAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        content.categoryIdentifier = "votation"
        return content
    }
    
    func sendRuleApprovedNotification(rule: Rule) {
        let notificationContent = adaptRuleApprovalNotification(rule: rule, content: UNMutableNotificationContent())
        guard let recordName = rule.recordName else { return }
        self.addRequestToNotificationCenter(with: notificationContent, forIdentifier: "Approved.\(recordName)")
    }
    
    func adaptRuleApprovalNotification(rule: Rule, content: UNMutableNotificationContent) -> UNMutableNotificationContent {
        content.title = "Rule approved"
        content.body = rule.name
        content.threadIdentifier = "ruleApproved"
        content.summaryArgument = " new rules approved"
        return content
    }
    
    func sendRuleRejectedNotification(rule: Rule) {
        let notificationContent = adaptRuleRejectionNotification(rule: rule, content: UNMutableNotificationContent())
        guard let recordName = rule.recordName else { return }
        self.addRequestToNotificationCenter(with: notificationContent, forIdentifier: "Rejected.\(recordName)")
    }
    
    func adaptRuleRejectionNotification(rule: Rule, content: UNMutableNotificationContent) -> UNMutableNotificationContent {
        content.title = "Rule rejected"
        content.body = rule.name
        content.threadIdentifier = "ruleRejected"
        content.summaryArgument = " new rules rejected"
        return content
    }
    
    func removeNotifications(ofProposed rule: Rule) {
        guard let recordName = rule.recordName else { return }
        notificationCenter.removeDeliveredNotifications(withIdentifiers: ["Proposed.\(recordName)"])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ["Proposed.\(recordName)"])
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        var requestIdentifier = response.notification.request.identifier
        requestIdentifier.removeFirst(9)
        
        if identifier == "agree" {
            print("Agree")
        } else if identifier == "disagree" {
            print("Disagree")
        }
        
        completionHandler()
    }
}
