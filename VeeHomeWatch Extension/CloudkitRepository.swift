//
//  CloudkitRepository.swift
//  VeeHomeWatch Extension
//
//  Created by Débora Oliveira on 10/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitRepository {
    let container = CKContainer(identifier: "iCloud.somanydeadlines.VeeHome-Debora")
    var customZone: CKRecordZone?
    var privateDB: CKDatabase?
    var publicDB: CKDatabase?
    
    init() {
        self.customZone = CKRecordZone(zoneName: "RulesZone")
        self.privateDB = self.container.privateCloudDatabase
        self.publicDB = self.container.publicCloudDatabase
    }
    
    static func fetchById(_ id: CKRecord.ID, then completion: @escaping ((CKRecord?) -> Void)) {
        let container = CKContainer(identifier: "iCloud.somanydeadlines.VeeHome-Debora")
        container.publicCloudDatabase.fetch(withRecordID: id, completionHandler: { (record, error) in
            guard let record = record, error == nil else {
                print("On CloudKitRepository: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            completion(record)
        })
    }
    
}
