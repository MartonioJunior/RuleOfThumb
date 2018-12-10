//
//  RuleModelTests.swift
//  RuleOfThumbTests
//
//  Created by Martônio Júnior on 03/12/18.
//  Copyright © 2018 So Many Deadlines. All rights reserved.
//

import XCTest
@testable import RuleOfThumb

class RuleModelTests: XCTestCase {
    
    override func setUp() {
        
    }

    override func tearDown() {
        
    }
    
    func Rule_createWithNameDescriptionHouse_test() {
        let name = "Clean the dishes at 6 PM"
        let description = "Because I need to make dinner"
        let house = House(name: "Silva")
        
        let rule = Rule(name: name, description: description, house: house)
        XCTAssert(rule.name == "Clean the dishes at 6 PM")
        XCTAssert(rule.description == "Because I need to make dinner")
        XCTAssert(rule.house?.name == "Silva")
        XCTAssert(rule.status == Rule.Status.voting)
        guard let ruleDate = rule.validFrom else {
            XCTAssert(false)
            return
        }
        XCTAssert(Calendar.current.isDate(Date(), inSameDayAs: ruleDate))
    }
}
