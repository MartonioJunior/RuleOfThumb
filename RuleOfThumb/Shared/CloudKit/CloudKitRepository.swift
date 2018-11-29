//
//  CloudKitRepository.swift
//  RuleOfThumb
//
//  Created by Matheus Costa on 21/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitRepository {
    let container = CKContainer.default()
    var customZone: CKRecordZone?
    var privateDB: CKDatabase?
    var publicDB: CKDatabase?
    
    init() {
        self.customZone = CKRecordZone(zoneName: "RulesZone")
        self.privateDB = self.container.privateCloudDatabase
        self.publicDB = self.container.publicCloudDatabase
    }
    
    static func fetchById(_ id: CKRecord.ID, then completion: @escaping ((CKRecord) -> Void)) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id, completionHandler: { (record, error) in
            guard let record = record, error == nil else {
                print("On CloudKitRepository: \(error!.localizedDescription)")
                return
            }
            
            completion(record)
        })
    }
    
    /// Cria uma nova subscription para o Record Type passado como parâmetro. Sempre
    /// deve haver uma casa, pois a referência dela será usada como filtro.
    ///
    /// - Parameters:
    ///   - recordType: nome do Record Type
    ///   - house: objeto da casa do usuário salva no dispositivo.
    func subscription(in recordType: String, with house: House) {
        let reference = CKRecord.Reference(recordID: house.ckRecordId(), action: .none)
        let subscription = CKQuerySubscription(
            recordType: recordType,
            predicate: NSPredicate(format: "house == %@", reference),
            options: [.firesOnRecordCreation])
        
        let info = CKSubscription.NotificationInfo()
        info.alertLocalizationKey = "New record on \(recordType): %@"
        info.alertLocalizationArgs = ["name"]
        info.shouldSendContentAvailable = false
        info.category = "RecordAdded"
        
        subscription.notificationInfo = info
        
        self.publicDB?.save(subscription, completionHandler: { (subscription, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print("Subscription \(String(describing: subscription?.subscriptionID)) saved for \(recordType)")
        })
    }
    
}

// - MARK: RulesRepository protocol implementation.
extension CloudKitRepository: RulesRepository {

    func fetchAllRules(from house: House, then completion: @escaping (([Rule]) -> Void)) {
        let houseReference = CKRecord.Reference(recordID: house.ckRecordId(), action: .none)
        let query = CKQuery(recordType: "Rules", predicate: NSPredicate(format: "house == %@", houseReference))
        query.sortDescriptors = [NSSortDescriptor(key: "number", ascending: true)]
        
        self.publicDB?.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            var rules = [Rule]()
            
            records?.forEach({ (record) in
                rules.append(Rule(from: record))
            })
            
            completion(rules)
        })
    }
    
    func save(rule: Rule, then completion: @escaping ((Rule) -> Void)) {
        let record = rule.toCKRecord()
        
        self.publicDB?.save(record, completionHandler: { (saved, error) in
            guard let saved = saved, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print("Rule \(String(describing: saved.recordID)) saved")
            
            completion(rule)
        })
    }
    
    func delete(rule: Rule, then completion: @escaping ((Bool) -> Void)) {
        self.publicDB?.delete(withRecordID: rule.ckRecordId(), completionHandler: { (recordID, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(false)
                return
            }
            
            print("Rule \(String(describing: recordID)) deleted")
            
            completion(true)
        })
    }
    
}

// - MARK: HousesRepository protocol implementation.
extension CloudKitRepository: HousesRepository {

    func currentHouse(_ completion: @escaping ((House) -> Void)) {
        let defaults = UserDefaults.standard
        
        // Teoricamente quando chamar essa função, já deve estar inicializada.
        if let houseCreated = defaults.string(forKey: "HouseCreated") {
            CloudKitRepository.fetchById(CKRecord.ID(recordName: houseCreated)) { (record) in
                let house = House(from: record)
                
                completion(house)
            }
        }
    }
    
    func create(house: House, then completion: @escaping ((House) -> Void)) {
        let defaults = UserDefaults.standard
        let record = house.toCKRecord()
        
        self.publicDB?.save(record, completionHandler: { (saved, error) in
            guard let saved = saved, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print("House \(saved.recordID) saved")
            
            defaults.set(house.recordName, forKey: "HomeCreated")
            
            completion(house)
        })
    }
    
}
