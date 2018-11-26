//
//  Repository.swift
//  RuleOfThumb
//
//  Created by Matheus Costa on 21/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import Foundation

// TODO: Reescrever isso para usar uma implementação mais generica.
protocol RulesRepository {
    func fetchAllRules(from house: House, then completion: @escaping (([Rule]) -> Void))
    func save(rule: Rule, then completion: @escaping ((_ rule: Rule) -> Void))
    func delete(rule: Rule, then completion: @escaping ((_ success: Bool) -> Void))
}

protocol HousesRepository {
    func create(house: House, then completion: @escaping ((_ house: House) -> Void))
}
