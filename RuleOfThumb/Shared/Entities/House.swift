//
//  House.swift
//  RuleOfThumb
//
//  Created by Matheus Costa on 21/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import CloudKit

class House: CKManagedObject {
    var recordType: String
    var recordID: Data?
    var recordName: String?
    
    var name: String
    var openKey: String
    
    // Essa propriedade é unica que não foi trocada por uma abstração,
    // mas depois posso ver se era possível.
    var users: [CKRecord.Reference]
    
    init(name: String) {
        self.name = name
        self.openKey = UUID().uuidString
        self.recordType = "Houses"
        self.recordName = self.recordType + "." + self.openKey 
        self.users = [CKRecord.Reference]()
        
        let tempId = CKRecord.ID(recordName: self.recordName!)
        self.recordID = self.ckRecordIDToData(recordID: tempId)
    }
    
    required init(from record: CKRecord) {
        self.name = record.value(forKey: "name") as! String
        self.openKey = record.value(forKey: "openKey") as! String
        self.recordName = record.recordID.recordName
        self.recordType = record.recordType
        self.users = record.value(forKey: "users") as! [CKRecord.Reference]
        
        let recordID = record.recordID
        self.recordID = self.ckRecordIDToData(recordID: recordID)
    }
    
    convenience init(from ckReference: CKRecord.Reference) {
        let group = DispatchGroup()
        var record = CKRecord(recordType: "Houses")
        
        group.enter()
        CloudKitRepository.fetchById(ckReference.recordID) { (houseRecord) in
            record = houseRecord
            group.leave()
        }
        group.wait()
        
        self.init(from: record)
    }
    
    func toCKRecord(_ completion: @escaping ((CKRecord) -> Void)) {
        CloudKitRepository.fetchById(self.ckRecordId()) { (record) in
            record["name"] = self.name as CKRecordValue
            record["openKey"] = self.openKey as CKRecordValue
            record["users"] = self.users as CKRecordValue
            
            completion(record)
        }
    }
    
    func createCKRecord() -> CKRecord {
        let record = CKRecord(recordType: self.recordType, recordID: self.ckRecordId())
        
        record["name"] = self.name as CKRecordValue
        record["openKey"] = self.openKey as CKRecordValue
        record["users"] = self.users as CKRecordValue

        return record
    }
    
}
