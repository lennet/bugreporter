//
//  ValidatorUtilityTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest

@testable import Bugreporter
class ValidatorUtilityTests: XCTestCase {

    func testValidateEnvironmentValue() {
        var validInput = "iPhone 6, iOS 9.3.2, v9.3.2"
        XCTAssertTrue(ValidatorUtility.validEnvironment(value: validInput))

        validInput = "iPhone 6s. iOS 9.3.2 version 0.3.2"
        XCTAssertTrue(ValidatorUtility.validEnvironment(value: validInput))

        validInput = "iPad Pro, iOS 9.3.2 App Version 2"
        XCTAssertTrue(ValidatorUtility.validEnvironment(value: validInput))

        validInput = "iPad Air 2, iOS 9.3.2, Build 323"
        XCTAssertTrue(ValidatorUtility.validEnvironment(value: validInput))

        var invalidInput = "iPhone"
        XCTAssertFalse(ValidatorUtility.validEnvironment(value: invalidInput))
        
        invalidInput = "OS 9.3.2"
        XCTAssertFalse(ValidatorUtility.validEnvironment(value: invalidInput))
        
        invalidInput = "9.3.2"
        XCTAssertFalse(ValidatorUtility.validEnvironment(value: invalidInput))

        invalidInput = "iOS 9.3.2"
        XCTAssertFalse(ValidatorUtility.validEnvironment(value: invalidInput))
        
        invalidInput = "iPhone 6, iOS 9.3.2"
        XCTAssertFalse(ValidatorUtility.validEnvironment(value: invalidInput))

    }
    
    func testValidateReproduceSteps() {
        let validInput = "1. Create a new Document\n2. Type \"Hello World\"\n3.press the print button"
        XCTAssertTrue(ValidatorUtility.validReproduceSteps(value: validInput))
    
        
        var invalidInput = "1. Create a new Document\n2. Type \"Hello World\""
        XCTAssertFalse(ValidatorUtility.validReproduceSteps(value: invalidInput))
        
        invalidInput = "1. Create a new Document\n2. Type \"Hello World\"\n"
        XCTAssertFalse(ValidatorUtility.validReproduceSteps(value: invalidInput))
        
        invalidInput = "1. Create a new Document\n2. Type \"Hello World\"\n3. "
        XCTAssertFalse(ValidatorUtility.validReproduceSteps(value: invalidInput))

    }
    
}
