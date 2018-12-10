//
//  NotificationService.swift
//  RuleOfThumbNotificationService
//
//  Created by Martônio Júnior on 05/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UserNotifications
import CloudKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard var bestAttemptContent = bestAttemptContent, let ck = request.content.userInfo["ck"] as? [String:Any], let record = ck["qry"] as? [String:Any], let queryID = record["rid"] as? String else {
            return
        }
        
        if queryID.hasPrefix("Rules."), let recordArgs = record["af"] as? [String:Any], let ruleName = recordArgs["name"] as? String {
            if let ruleStatus = recordArgs["status"] as? Int {
                if ruleStatus == 1 {
                    bestAttemptContent = NotificationFormatter.adaptRuleRejectionNotification(ruleID: queryID, ruleName: ruleName, content: bestAttemptContent)
                } else if ruleStatus == 2 {
                    bestAttemptContent = NotificationFormatter.adaptRuleApprovalNotification(ruleID: queryID, ruleName: ruleName, content: bestAttemptContent)
                }
            } else {
                bestAttemptContent = NotificationFormatter.adaptRuleProposalNotification(ruleID: queryID, ruleName: ruleName, content: bestAttemptContent)
            }
        }
        
        contentHandler(bestAttemptContent)
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
