//
//  HowToReproduceViewControllerTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 13/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class HowToReproduceViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReproducibilityPopUp() {
        let reproduceViewController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: CreateBugStep.howToReproduce.identifier) as! HowToReproduceViewController
        _ = reproduceViewController.view
        
        
        XCTAssertEqual(reproduceViewController.reproducibilityPopUp.itemTitles, Reproducibility.all.map { (value) -> String in
            return value.rawValue
            })
    }
    
    func testCanContinue() {
        let reproduceViewController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: CreateBugStep.howToReproduce.identifier) as! HowToReproduceViewController
        _ = reproduceViewController.view
        XCTAssertFalse(reproduceViewController.canContinue())
        
        reproduceViewController.environmentTextField.stringValue = "iPhone 6, iOS 9.3.2, v9.3.2"
        XCTAssertFalse(reproduceViewController.canContinue())
        
        reproduceViewController.stepsTextView.string = "1. Create a new Document\n2. Type \"Hello World\"\n3.press the print button"
        
        XCTAssertTrue(reproduceViewController.canContinue())
        
    }

    
}
