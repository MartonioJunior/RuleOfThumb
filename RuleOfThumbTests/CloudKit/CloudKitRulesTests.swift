//
//  CloudKitRulesTests.swift
//  RuleOfThumbTests
//
//  Created by Matheus Costa on 27/11/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import XCTest
@testable import RuleOfThumb

class CloudKitRulesTests: XCTestCase {
    let house = House(name: "Casa de Testes")
    var testRules = [Rule]()
    let repository = CloudKitRepository()
    
    override func setUp() {
//        repository.create(house: house) { (house) in
//            for i in 1...3 {
//                let rule = Rule(name: "Teste 0\(i)", description: "Isso é um teste", house: house)
//                self.repository.save(rule: rule, then: { _ in
//                    self.testRules.append(rule)
//                })
//            }
//        }
    }

    override func tearDown() {
        for rule in testRules {
            repository.delete(rule: rule) { (success) in }
        }
    }

    func CKRepository_fetchAll_test() {
        self.repository.fetchAllRules(from: house) { (rules) in
            XCTAssertEqual(rules.count, self.testRules.count)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
