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
        let notificationContent = NotificationFormatter.adaptRuleProposalNotification(ruleID: rule.recordName, ruleName: rule.name, content: UNMutableNotificationContent())
        guard let recordName = rule.recordName else { return }
        self.addRequestToNotificationCenter(with: notificationContent, forIdentifier: "Proposed.\(recordName)")
    }
    
    func sendRuleApprovedNotification(rule: Rule) {
        let notificationContent = NotificationFormatter.adaptRuleApprovalNotification(ruleID: rule.recordName, ruleName: rule.name, content: UNMutableNotificationContent())
        guard let recordName = rule.recordName else { return }
        self.addRequestToNotificationCenter(with: notificationContent, forIdentifier: "Approved.\(recordName)")
    }
    
    func sendRuleRejectedNotification(rule: Rule) {
        let notificationContent = NotificationFormatter.adaptRuleRejectionNotification(ruleID: rule.recordName, ruleName: rule.name, content: UNMutableNotificationContent())
        guard let recordName = rule.recordName else { return }
        self.addRequestToNotificationCenter(with: notificationContent, forIdentifier: "Rejected.\(recordName)")
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
