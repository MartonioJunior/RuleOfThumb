//
//  NotificationFormatter.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 06/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UserNotifications

class NotificationFormatter {
    static func adaptRuleProposalNotification(ruleID: String?, ruleName: String, content: UNMutableNotificationContent) -> UNMutableNotificationContent {
        content.title = "New rule proposed"
        content.body = ruleName
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
    
    static func adaptRuleApprovalNotification(ruleID: String?, ruleName: String, content: UNMutableNotificationContent) -> UNMutableNotificationContent {
        content.title = "Rule approved"
        content.body = ruleName
        content.threadIdentifier = "ruleApproved"
        content.summaryArgument = " new rules approved"
        return content
    }
    
    static func adaptRuleRejectionNotification(ruleID: String?, ruleName: String, content: UNMutableNotificationContent) -> UNMutableNotificationContent {
        content.title = "Rule rejected"
        content.body = ruleName
        content.threadIdentifier = "ruleRejected"
        content.summaryArgument = " new rules rejected"
        return content
    }
}
