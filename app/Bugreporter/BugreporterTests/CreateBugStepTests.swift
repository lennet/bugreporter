//
//  CreateBugStepTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 11/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

extension CreateBugStep {
    static var all: [CreateBugStep] {
        return [.intro, .chooseAttachment, .howToReproduce, .upload]
    }
}

class CreateBugStepTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIdentifier() {
        let createBugStoryboard = NSStoryboard(name: "CreateBug", bundle: nil)
        
        XCTAssertNotNil(createBugStoryboard.instantiateController(withIdentifier: CreateBugStep.intro.identifier) as? CreateBugIntroViewController)

        XCTAssertNotNil(createBugStoryboard.instantiateController(withIdentifier: CreateBugStep.chooseAttachment.identifier) as? FilesSplitViewController)
        
        XCTAssertNotNil(createBugStoryboard.instantiateController(withIdentifier: CreateBugStep.howToReproduce.identifier) as? HowToReproduceViewController)
        
        XCTAssertNotNil(createBugStoryboard.instantiateController(withIdentifier: CreateBugStep.upload.identifier) as? UploadBugViewController)
    }
    
    func testIsFirst() {
        for step in CreateBugStep.all where step != .intro {
            XCTAssertFalse(step.isFirst)
        }
        
        XCTAssertTrue(CreateBugStep.intro.isFirst)
    }
    
    func testIsLast() {
        for step in CreateBugStep.all where step != .upload {
            XCTAssertFalse(step.isLast)
        }
        
        XCTAssertTrue(CreateBugStep.upload.isLast)
    }
    
    func testNext() {
        var step: CreateBugStep = .intro
        
        step.next()
        XCTAssertEqual(step, .chooseAttachment)
        
        step.next()
        XCTAssertEqual(step, .howToReproduce)

        step.next()
        XCTAssertEqual(step, .upload)

        step.next()
        XCTAssertEqual(step, .upload)
    }
    
    func testPrevious() {
        var step: CreateBugStep = .upload
        
        step.previous()
        XCTAssertEqual(step, .howToReproduce)
        
        step.previous()
        XCTAssertEqual(step, .chooseAttachment)
        
        step.previous()
        XCTAssertEqual(step, .intro)
        
        step.previous()
        XCTAssertEqual(step, .intro)
    }

}
