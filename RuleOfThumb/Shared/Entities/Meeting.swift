//
//  Meeting.swift
//  RuleOfThumb
//
//  Created by Matheus Costa on 06/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import CloudKit

class Meeting: CKManagedObject {
    enum Status: Int {
        case willHappen
        case alreadyHappened
        case cancelled
    }
    
    var recordName: String?
    var recordID: Data?
    var recordType: String
    
    var title: String
    var agenda: String  // Pauta
    var result: String? // Ata
    var status: Status
    var dateScheduled: Date
    var creatorName: String
    var house: House
    
    init(title: String, agenda: String, dateScheduled: Date, creatorName: String, house: House) {
        self.title = title
        self.agenda = agenda
        self.dateScheduled = dateScheduled
        self.creatorName = creatorName
        self.house = house
        self.status = .willHappen
        
        self.recordType = "Meetings"
        self.recordName = self.recordType + "." + UUID().uuidString
        
        let tempId = CKRecord.ID(recordName: self.recordName!)
        self.recordID = self.ckRecordIDToData(recordID: tempId)
    }
    
    required init(from record: CKRecord) {
        self.recordType = record.recordType
        self.recordName = record.recordID.recordName
        
        self.title = record["title"] as! String
        self.agenda = record["agenda"] as! String
        self.dateScheduled = record["dateScheduled"] as! Date
        self.creatorName = record["creatorName"] as! String
        self.status = Meeting.Status(rawValue: record["status"] as! Int)!
        self.result = record["result"] as? String
        
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
            
            record["title"] = self.title as CKRecordValue
            record["agenda"] = self.agenda as CKRecordValue
            record["dateScheduled"] = self.dateScheduled as CKRecordValue
            record["creatorName"] = self.creatorName as CKRecordValue
            record["status"] = self.status.rawValue as CKRecordValue
            
            let houseID = self.house.ckRecordId()
            record["house"] = CKRecord.Reference(recordID: houseID, action: .deleteSelf)
            
            if let result = self.result {
                record["result"] = result as CKRecordValue
            }
            
            completion(record)
        }
    }
    
}
