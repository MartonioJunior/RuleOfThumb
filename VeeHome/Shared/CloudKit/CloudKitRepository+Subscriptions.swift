//
//  CloudKitRepository+Subscriptions.swift
//  RuleOfThumb
//
//  Created by Matheus Costa on 07/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import CloudKit

extension CloudKitRepository {
    private func subscription(for recordType: String, with house: House, options: CKQuerySubscription.Options, notificationInfo: CKSubscription.NotificationInfo) {
        let reference = CKRecord.Reference(recordID: house.ckRecordId(), action: .deleteSelf)
        let subscription = CKQuerySubscription(
            recordType: recordType,
            predicate: NSPredicate(format: "house == %@", reference),
            options: options)
        
        subscription.notificationInfo = notificationInfo
        
        self.publicDB?.save(subscription, completionHandler: { (saved, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print("Subscription \(String(describing: saved?.subscriptionID)) saved for \(recordType)")
        })
    }
    
    // FIXME: Refatorar isso para usar uma mesma função para os dois tipos de subscriptions
    func recordCreatedSubscription(in recordType: String, with house: House) {
        let info = CKSubscription.NotificationInfo()
        info.alertLocalizationKey = "New record on \(recordType): %@"
        info.alertLocalizationArgs = ["name"]
        info.shouldSendContentAvailable = false
        info.shouldSendMutableContent = true
        info.desiredKeys = ["name"]
        info.category = "RecordAdded"
        
        self.subscription(for: "Rules", with: house, options: [.firesOnRecordCreation], notificationInfo: info)
        
    }
    
    func recordUpdatedSubscription(in recordType: String, with house: House) {
        let info = CKSubscription.NotificationInfo()
        info.alertLocalizationKey = "Record updated on \(recordType): %@"
        info.alertLocalizationArgs = ["name"]
        info.shouldSendContentAvailable = false
        info.shouldSendMutableContent = true
        info.desiredKeys = ["name", "status"]
        info.category = "RecordUpdated"
        
        self.subscription(for: "Rules", with: house, options: [.firesOnRecordUpdate], notificationInfo: info)
    }

}
