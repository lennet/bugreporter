
//
//  RecorderButtonTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 29/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class RecorderButtonTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testButtonStateNext() {
        var state = RecorderButtonState.recording
        
        state.next()
        XCTAssertEqual(state, RecorderButtonState.waiting)
        
        state.next()
        XCTAssertEqual(state, RecorderButtonState.recording)

    }
}
