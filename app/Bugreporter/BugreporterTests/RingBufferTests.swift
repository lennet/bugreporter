//
//  RingBufferTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 18/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class RingBufferTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRingWriteLoop() {
        let ringBuffer = RingBuffer<Int>(length: 30)
        for i in 0...ringBuffer.length {
            ringBuffer.append(element: i)
        }
        XCTAssertEqual(ringBuffer[0], ringBuffer.length)
    }
    
    func testMaxLength() {
        let length = 30
        let ringBuffer = RingBuffer<Int>(length: length)
        XCTAssertEqual(length, ringBuffer.length)
        for i in 0...ringBuffer.length * 2 {
            ringBuffer.append(element: i)
        }
        XCTAssertEqual(ringBuffer.count, ringBuffer.length)
        XCTAssertEqual(length, ringBuffer.length)
    }
    
    func testIsEmpty() {
        let ringBuffer = RingBuffer<Int>(length: 30)
        XCTAssertTrue(ringBuffer.isEmpty)
        for i in 0...ringBuffer.length {
            ringBuffer.append(element: i)
        }
        XCTAssertFalse(ringBuffer.isEmpty)
    }

}
