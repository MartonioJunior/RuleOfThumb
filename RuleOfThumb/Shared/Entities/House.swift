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
    
    // --MARK: Test Votation
    var peopleAmountAtHome = 7
    
    init(name: String) {
        self.name = name
        self.openKey = "ABC123"
        self.recordType = "Houses"
        self.recordName = self.recordType + "." + UUID().uuidString
        
        let tempId = CKRecord.ID(recordName: self.recordName!)
        self.recordID = self.ckRecordIDToData(recordID: tempId)
    }
    
    required init(from record: CKRecord) {
        self.name = record.value(forKey: "name") as! String
        self.openKey = record.value(forKey: "openKey") as! String
        self.recordName = record.value(forKey: "recordName") as? String
        self.recordType = record.recordType
        
        let recordID = record.recordID
        self.recordID = self.ckRecordIDToData(recordID: recordID)
    }
    
    func toCKRecord() -> CKRecord {
        let record = CKRecord(recordType: self.recordType, recordID: self.ckRecordId())
        
        record["name"] = self.name as CKRecordValue
        record["openKey"] = self.openKey as CKRecordValue
        
        return record
    }
    
}
