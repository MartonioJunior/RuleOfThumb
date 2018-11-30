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
    
    /// Cria uma nova subscription para o Record Type passado como parâmetro. Sempre
    /// deve haver uma casa, pois a referência dela será usada como filtro.
    ///
    /// - Parameters:
    ///   - recordType: nome do Record Type
    ///   - house: objeto da casa do usuário salva no dispositivo.
    func subscription(in recordType: String, with house: House) {
        let reference = CKRecord.Reference(recordID: house.ckRecordId(), action: .none)
        let subscription = CKQuerySubscription(
            recordType: recordType,
            predicate: NSPredicate(format: "house == %@", reference),
            options: [.firesOnRecordCreation])
        
        let info = CKSubscription.NotificationInfo()
        info.alertLocalizationKey = "New record on \(recordType): %@"
        info.alertLocalizationArgs = ["name"]
        info.shouldSendContentAvailable = false
        info.category = "RecordAdded"
        
        subscription.notificationInfo = info
        
        self.publicDB?.save(subscription, completionHandler: { (subscription, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print("Subscription \(String(describing: subscription?.subscriptionID)) saved for \(recordType)")
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
            
            var rules = [Rule]()
            
            records?.forEach({ (record) in
                rules.append(Rule(from: record))
            })
            
            completion(rules)
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
        self.publicDB?.delete(withRecordID: rule.ckRecordId(), completionHandler: { (recordID, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(false)
                return
            }
            
            print("Rule \(String(describing: recordID)) deleted")
            
            completion(true)
        })
    }
    
}

// - MARK: HousesRepository protocol implementation.
extension CloudKitRepository: HousesRepository {    

    func currentHouse(_ completion: @escaping ((House) -> Void)) {
        let defaults = UserDefaults.standard
        
        // Teoricamente quando chamar essa função, já deve estar inicializada.
        if let houseCreated = defaults.string(forKey: "HouseCreated") {
            CloudKitRepository.fetchById(CKRecord.ID(recordName: houseCreated)) { (record) in
                let house = House(from: record)
                
                completion(house)
            }
        }
    }
    
    func create(house: House, then completion: @escaping ((House) -> Void)) {
        let defaults = UserDefaults.standard
        let record = house.createCKRecord()
        
        self.publicDB?.save(record, completionHandler: { (saved, error) in
            guard let saved = saved, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print("House \(saved.recordID) saved")
            
            defaults.set(house.recordName, forKey: "HomeCreated")
            
            completion(house)
        })
    }
    
    // TODO: Reescrever isso para usar a abstração de House.
    func getHouse(by openkey: String, then completion: @escaping ((House?) -> Void)) {
        let recordName = "Houses." + openkey
        
        self.publicDB?.fetch(withRecordID: CKRecord.ID(recordName: recordName)) { (record, error) in
            guard let record = record, error == nil else {
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            
            let house = House(from: record)
            
            completion(house)
        }
    }
    
}

// - MARK: Users logic
extension CloudKitRepository {

    private func verifyAccountStatus(_ completion: @escaping ((Bool) -> Void)) {
        self.container.accountStatus { (status, error) in
            switch status {
            case .available:
                completion(true)
            case .couldNotDetermine, .noAccount, .restricted:
                completion(false)
            }
        }
    }
    
    // Essa função cria uma nova casa e já adiciona o usuário a mesma, e depois
    // adiciona a referência da casa ao usuário.
    func setupNewHouse(name: String, then completion: @escaping ((House?) -> Void)) {
        self.verifyAccountStatus { (success) in
            if success {
                let defaults = UserDefaults.standard
                
                self.container.fetchUserRecordID { (userRecordID, error) in
                    guard let userRecordID = userRecordID, error == nil else {
                        print(error!.localizedDescription)
                        completion(nil)
                        return
                    }
                    
                    self.publicDB?.fetch(withRecordID: userRecordID) { (userRecord, error) in
                        guard let userRecord = userRecord, error == nil else {
                            print(error!.localizedDescription)
                            completion(nil)
                            return
                        }
                        
                        // Adicionar a referência do usuário a casa.
                        let house = House(name: name)
                        house.users.append(CKRecord.Reference(record: userRecord, action: .none))
                        
                        // Adicionar a referência da casa ao usuário.
                        let houseReference = CKRecord.Reference(recordID: house.ckRecordId(), action: .none)
                        userRecord["house"] = houseReference
                        
                        self.publicDB?.save(userRecord) { (record, error) in
                            guard error == nil else {
                                print(error!.localizedDescription)
                                completion(nil)
                                return
                            }
                        }
                        
                        self.publicDB?.save(house.createCKRecord()) { (houseRecord, error) in
                            guard error == nil else {
                                print(error!.localizedDescription)
                                completion(nil)
                                return
                            }
                            
                            print("House \(houseRecord?.recordID) with user \(userRecord.recordID)")
                            
                            defaults.set(houseRecord?.recordID.recordName, forKey: "HouseCreated")
                            
                            self.subscription(in: "Rules", with: house)
                            
                            completion(house)
                        }
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    // Adiciona o usuário a casa passada por parâmentro, e coloca a casa
    // no record do usuário.
    func addUser(to house: House, then completion: @escaping ((Bool) -> Void)) {
        self.container.fetchUserRecordID { (userRecordID, error) in
            guard let userRecordID = userRecordID, error == nil else {
                print(error!.localizedDescription)
                completion(false)
                return
            }
            
            self.publicDB?.fetch(withRecordID: userRecordID) { (userRecord, error) in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    completion(false)
                    return
                }
                
                house.users.append(CKRecord.Reference(record: userRecord, action: .none))

                house.toCKRecord({ (houseRecord) in
                    userRecord["house"] = CKRecord.Reference(record: houseRecord, action: .none)
                    
                    self.publicDB?.save(userRecord, completionHandler: { (_, error) in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            completion(false)
                            return
                        }
                    })
                    
                    self.publicDB?.save(houseRecord) { (_, error) in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            completion(false)
                            return
                        }
                        
                        print("User: \(userRecord.recordID) added to house: \(houseRecord.recordID)")
                        
                        self.subscription(in: "Rules", with: house)
                        
                        completion(true)
                    }
                    
                })
                
            }
        }
    }
    
    func getUser(then completion: @escaping ((User) -> Void)) {
        self.container.fetchUserRecordID { (recordID, error) in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            self.discoverIdentity(for: recordID, then: { (user) in
                self.publicDB?.fetch(withRecordID: recordID, completionHandler: { (userRecord, error) in
                    guard let userRecord = userRecord, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    let houseReference = userRecord["house"] as! CKRecord.Reference
                    user.house = House(from: houseReference)
                    
                    completion(user)
                })
            })
        }
    }
    
    private func discoverIdentity(for recordID: CKRecord.ID, then completion: @escaping ((User) -> Void)) {
        self.container.requestApplicationPermission(.userDiscoverability) { (status, error) in
            guard status == .granted, error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            self.container.discoverUserIdentity(withUserRecordID: recordID) { (identity, error) in
                guard let identity = identity, let components = identity.nameComponents, error == nil else {
                    return
                }
                
                let fullName = PersonNameComponentsFormatter().string(from: components)
                let email = identity.lookupInfo?.emailAddress

                completion(User(name: fullName, email: email, house: nil))
            }
        }
    }
    
}
