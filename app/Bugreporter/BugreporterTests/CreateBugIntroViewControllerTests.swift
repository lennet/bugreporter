//
//  CreateBugIntroViewControllerTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 11/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class CreateBugIntroViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanContinue() {
        let createIntroBugViewController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: CreateBugStep.intro.identifier) as! CreateBugIntroViewController
        _ = createIntroBugViewController.view // load view
        
        XCTAssertFalse(createIntroBugViewController.canContinue())
        
        createIntroBugViewController.descriptionTextView.string = "Here is a long valid Description of the Bug."
        createIntroBugViewController.titleTextField.stringValue = "Bug Title"
        
        XCTAssertTrue(createIntroBugViewController.canContinue())
        
    }
}
