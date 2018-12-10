//
//  CoreDataManager.swift
//  RuleOfThumb
//
//  Created by Martônio Júnior on 03/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    static let current = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer
        }
    }
    
    @discardableResult
    func saveContext() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        appDelegate.saveContext()
        return true
    }
    
    func fetch(predicate: String?, arg: String) -> [Vote] {
        let request = NSFetchRequest<Vote>(entityName: "Vote")
        if let format = predicate {
            request.predicate = NSPredicate(format: format, arg)
        }
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            return result
        } catch {
            print(error)
            return []
        }
    }
    
    func fetchAllVotes() -> [Vote] {
        return self.fetch(predicate: nil, arg: "")
    }
    
    func getVote(rule: Rule) -> Vote? {
        guard let recordName = rule.recordName else { return nil }
        return self.fetch(predicate: "ruleRecordName == %@", arg: recordName).first
    }
    
    func insert(new rule: Rule) {
        guard let recordName = rule.recordName else { return }
        let voteRegister = Vote(context: persistentContainer.viewContext)
        voteRegister.ruleRecordName = recordName
        saveContext()
        AppDelegate.notificationManager.removeNotifications(ofProposed: rule)
    }
    
    func remove(vote: Vote) {
        persistentContainer.viewContext.delete(vote)
    }
}

