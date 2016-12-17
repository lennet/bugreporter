//
//  FrameBufferTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 01/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
import CoreMedia
@testable import Bugreporter

class FrameBufferTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAppendFrame() {
        let buffer = FrameBuffer(length: 30)
        buffer.waitingForFrames = false
        let frame = Frame(data: Data(), timeStamp: CMTimeMake(0, 0))
        
        buffer.append(element:frame)
        XCTAssertEqual(buffer.count, 0)
        
        buffer.waitingForFrames = true
        buffer.append(element:frame)
        XCTAssertEqual(buffer.count, 1)
    }

}
