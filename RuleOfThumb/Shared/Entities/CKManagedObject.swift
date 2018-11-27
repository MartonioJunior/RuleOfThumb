//
//  CKManagedObject.swift
//  RuleOfThumb
//
//  Created by Matheus Costa on 22/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation
import CloudKit


/// Protocolo base para as entidades do app com as propriedades e métodos
/// a serem salvos no CoreData que também são necessários em um CKRecord.
protocol CKManagedObject {
    var recordName: String? { get set }
    var recordID: Data? { get set }
    var recordType: String { get }
    
    init(from record: CKRecord)
    func toCKRecord() -> CKRecord
    func ckRecordId() -> CKRecord.ID
    func ckRecordIDToData(recordID: CKRecord.ID) -> Data
}

extension CKManagedObject {
    
    // FIXME: Isso tá muito mau implementado, é uma boa reescrever isso de uma forma melhor.
    func ckRecordId() -> CKRecord.ID {
        let obj = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self.recordID!)
        
        return obj as! CKRecord.ID
    }
    
    func ckRecordIDToData(recordID: CKRecord.ID) -> Data {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: recordID, requiringSecureCoding: true)
        } catch let error {
            fatalError("Cannot convert recordID to Data: \(error.localizedDescription)")
        }
    }
}
