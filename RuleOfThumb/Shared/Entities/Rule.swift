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
        case voting = 0
        case revoked = 1
        case inForce = 2
    }
    
    enum VoteType {
        case upVote
        case downVote
    }
    
    // CK default fields
    var recordName: String?
    var recordID: Data?
    var recordType: String
    
    var number: Int
    var name: String
    var description: String
    var creatorName: String
    var status: Status
    var validFrom: Date?
    var house: House?
    var remainingVotes: Int
    var upVotes: Int
    var downVotes: Int
    
    init(name: String, description: String, house: House, creatorName: String) {
        self.name = name
        self.description = description
        self.house = house
        self.number = 1111
        self.creatorName = creatorName
        self.status = .voting
        self.remainingVotes = house.users.count
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
        self.creatorName = record["creatorName"] as! String
        self.status = Rule.Status(rawValue: record["status"] as! Int)!
        self.validFrom = record["validFrom"] as? Date
        self.remainingVotes = record["remainingVotes"] as! Int
        self.upVotes = record["upVotes"] as! Int
        self.downVotes = record["downVotes"] as! Int
        
        let houseReference = record["house"] as! CKRecord.Reference
        self.house = House(from: houseReference)
        
        let recordID = record.recordID
        self.recordID = self.ckRecordIDToData(recordID: recordID)
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
            record["creatorName"] = self.creatorName as CKRecordValue
            record["validFrom"] = self.validFrom as CKRecordValue?
            record["status"] = self.status.rawValue as CKRecordValue
            record["remainingVotes"] = self.remainingVotes as CKRecordValue
            record["upVotes"] = self.upVotes as CKRecordValue
            record["downVotes"] = self.downVotes as CKRecordValue
            
            if let houseID = self.house?.ckRecordId() {
                record["house"] = CKRecord.Reference(recordID: houseID, action: .deleteSelf)
            }
            
            completion(record)
        }
    }

    // Função auxiliar, não é a melhor solução, vai ficar por agora.
    private func updateFromCloudKit(then completion: @escaping ((Bool) -> Void)) {
        CloudKitRepository.fetchById(self.ckRecordId()) { (record) in
            guard let record = record else { return }
            
            self.name = record["name"] as! String
            self.number = record["number"] as! Int
            self.description = record["description"] as! String
            self.creatorName = record["creatorName"] as! String
            self.status = Rule.Status(rawValue: record["status"] as! Int)!
            self.validFrom = record["validFrom"] as? Date
            self.remainingVotes = record["remainingVotes"] as! Int
            self.upVotes = record["upVotes"] as! Int
            self.downVotes = record["downVotes"] as! Int
            
            let houseReference = record["house"] as! CKRecord.Reference
            self.house = House(from: houseReference)
            
            completion(true)
        }
    }
    
    func addVote(_ vote: VoteType, then completion: @escaping ((Bool) -> Void)) {
        guard self.status != .voting else {
            completion(false)
            return
        }
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .default).async {
            self.updateFromCloudKit { (success) in
                if success {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if vote == .downVote {
                self.downVotes = 1
                self.remainingVotes = 0
                self.status = .revoked
            } else {
                self.upVotes += 1
                self.remainingVotes -= 1
                let totalUsers = self.house?.users.count
                
                if totalUsers == self.upVotes {
                    self.status = .inForce
                    self.validFrom = Date()
                }
            }
            
            completion(true)
        }
    }
    
}
