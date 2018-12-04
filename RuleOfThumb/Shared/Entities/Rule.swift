//
//  Rule.swift
//  RuleOfThumb
//
//  Created by Matheus Costa on 21/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import CloudKit

/// Classe da entidade de Regra
/// - Atributos para serem salvos no CoreData
/// - Herdar de NSManagedObject
/// - Métodos para transformar e criar a partir de um CKRecord
class Rule: CKManagedObject {
    enum Status: Int {
        case voting
        case revoked
        case inForce
    }
    
    // CK default fields
    var recordName: String?
    var recordID: Data?
    var recordType: String
    
    var number: Int
    var name: String
    var description: String
    var status: Status
    var validFrom: Date?
    var house: House?
    var upVotes: Int {
        didSet { self.checkVotes() }
    }
    var downVotes: Int {
        didSet { self.checkVotes() }
    }
    
    init(name: String, description: String, house: House) {
        self.name = name
        self.description = description
        self.house = house
        self.number = 1111
        self.status = .voting
        self.upVotes = 0
        self.downVotes = 0
      
        self.recordType = "Rules"
        self.recordName = self.recordType + "." + UUID().uuidString
        
        let tempId = CKRecord.ID(recordName: self.recordName!)
        self.recordID = self.ckRecordIDToData(recordID: tempId)
    }
    
    required init(from record: CKRecord) {
        self.recordType = record.recordType
        self.recordName = record.recordID.recordName
      
        self.name = record["name"] as! String
        self.number = record["number"] as! Int
        self.description = record["description"] as! String
        self.status = Rule.Status(rawValue: record["status"] as! Int)!
        self.validFrom = record["validFrom"] as? Date
        self.upVotes = record["upVotes"] as! Int
        self.downVotes = record["downVotes"] as! Int
        
        let houseReference = record["house"] as! CKRecord.Reference
        self.house = House(from: houseReference)
        
        let recordID = record.recordID
        self.recordID = self.ckRecordIDToData(recordID: recordID)
    }
    
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: self.recordType, recordID: self.ckRecordId())
        
        record["name"] = self.name as CKRecordValue
        record["number"] = self.number as CKRecordValue
        record["description"] = self.description as CKRecordValue
        record["validFrom"] = self.validFrom as CKRecordValue?
        record["status"] = self.status.rawValue as CKRecordValue
        
        if let houseID = self.house?.ckRecordId() {
            record["house"] = CKRecord.Reference(recordID: houseID, action: .deleteSelf)
        }
        
        return record
    }
    
    func toCKRecord(_ completion: @escaping ((CKRecord) -> Void)) {
        var record = CKRecord(recordType: self.recordType, recordID: self.ckRecordId())
        
        CloudKitRepository.fetchById(self.ckRecordId()) { (fetched) in
            if let fetched = fetched {
                record = fetched
            }
            
            record["name"] = self.name as CKRecordValue
            record["number"] = self.number as CKRecordValue
            record["description"] = self.description as CKRecordValue
            record["validFrom"] = self.validFrom as CKRecordValue?
            record["status"] = self.status.rawValue as CKRecordValue
            record["upVotes"] = self.upVotes as CKRecordValue
            record["downVotes"] = self.downVotes as CKRecordValue
            
            if let houseID = self.house?.ckRecordId() {
                record["house"] = CKRecord.Reference(recordID: houseID, action: .deleteSelf)
            }
            
            completion(record)
        }
    }

    // Função auxiliar, não é a melhor solução, vai ficar por agora.
    private func updateFromCloudKit() {
        CloudKitRepository.fetchById(self.ckRecordId()) { (record) in
            guard let record = record else { return }
            
            self.name = record["name"] as! String
            self.number = record["number"] as! Int
            self.description = record["description"] as! String
            self.status = Rule.Status(rawValue: record["status"] as! Int)!
            self.validFrom = record["validFrom"] as? Date
            self.upVotes = record["upVotes"] as! Int
            self.downVotes = record["downVotes"] as! Int
            
            let houseReference = record["house"] as! CKRecord.Reference
            self.house = House(from: houseReference)
        }
    }
    
    private func checkVotes() {
        guard self.status != .revoked else { return }
        
        self.updateFromCloudKit()
        
        // FIXME: Isso pode dar um erro caso a casa esteja desatualizada.
        let totalUsers = self.house?.users.count
        
        if self.downVotes != 0 {
            self.status = .revoked
        } else if totalUsers == self.upVotes {
            self.status = .inForce
            self.validFrom = Date()
        }
    }
    
}
