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
            
            records?.forEach({ (record) in
                print(record.value(forKey: "name") ?? "Sem nome")
            })
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
        
    }
    
}

// - MARK: HousesRepository protocol implementation.
extension CloudKitRepository: HousesRepository {
    
    func create(house: House, then completion: @escaping ((House) -> Void)) {
        let record = house.toCKRecord()
        
        self.publicDB?.save(record, completionHandler: { (saved, error) in
            guard let saved = saved, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print("House \(saved.recordID) saved")
            
            completion(house)
        })
    }
    
}
