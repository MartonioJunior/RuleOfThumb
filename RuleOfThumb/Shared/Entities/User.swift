//
//  User.swift
//  RuleOfThumb
//
//  Created by Matheus Costa on 29/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import CloudKit


class User: CKManagedObject {
    var name: String?
    var email: String?
    var house: House?
    
    var recordName: String?
    var recordID: Data?
    var recordType: String
    
    init(name: String, email: String?, house: House?) {
        self.recordType = "Users"
        self.name = name
        self.email = email
        self.house = house
    }
    
    required init(from record: CKRecord) {
        self.recordType = record.recordType
        self.recordName = record.recordID.recordName
        
        let recordID = record.recordID
        self.recordID = self.ckRecordIDToData(recordID: recordID)
    }
    
    // Isso não é para ser usado.
    func toCKRecord(_ completion: @escaping ((CKRecord) -> Void)) {
        completion(CKRecord(recordType: self.recordType))
    }
}
