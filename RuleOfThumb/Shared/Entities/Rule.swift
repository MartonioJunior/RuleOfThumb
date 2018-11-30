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
    
    // --MARK: Test Votation
    var peopleAmountAtHome = Int()
    var votesLeft = Int()
    var peopleAgreed = Int()
    var voted: Bool = false
    
    var number: Int
    var name: String
    var description: String
    var status: Status
    var validFrom: Date?
    var house: House?
    
    init(name: String, description: String, house: House) {
        self.name = name
        self.description = description
        self.house = house
        self.number = 1111
        self.status = .voting
        self.validFrom = Date()
        self.recordType = "Rules"
        self.recordName = self.recordType + "." + UUID().uuidString
        
        // --MARK: Test Votation
        peopleAmountAtHome = house.peopleAmountAtHome
        votesLeft = Int.random(in: 1...peopleAmountAtHome)
        peopleAgreed = Int.random(in: 0...peopleAmountAtHome-votesLeft)
        
        let tempId = CKRecord.ID(recordName: self.recordName!)
        self.recordID = self.ckRecordIDToData(recordID: tempId)
    }
    
    required init(from record: CKRecord) {
        self.recordType = record.recordType
        self.name = record["name"] as! String
        self.number = record["number"] as! Int
        self.description = record["description"] as! String
        self.status = Rule.Status(rawValue: record["status"] as! Int)!
        
        let houseReference = record["house"] as! CKRecord.Reference
        CloudKitRepository.fetchById(houseReference.recordID) { (houseRecord) in
            self.house = House(from: houseRecord)
        }
        
        let recordID = record.recordID
        self.recordID = self.ckRecordIDToData(recordID: recordID)
        
        // --MARK: Test Votation
        peopleAmountAtHome = 7
        votesLeft = Int.random(in: 1...peopleAmountAtHome)
        peopleAgreed = Int.random(in: 0...peopleAmountAtHome-votesLeft)
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
}
