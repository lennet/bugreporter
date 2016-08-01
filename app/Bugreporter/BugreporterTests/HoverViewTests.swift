//
//  HoverViewTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 31/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class MockHoverDelegate: HoverDelegate {
    
    var mouseExitedCalled = false
    var mouseEnteredCalled = false
    
    func mouseExited() {
        mouseExitedCalled = true
    }
    
    func mouseEntered() {
        mouseEnteredCalled = true
    }
    
}

class HoverViewTests: XCTestCase {

    func testMouseExited() {
        let mockDelegate = MockHoverDelegate()
        let hoverView = HoverView()
        hoverView.delegate = mockDelegate
        
        XCTAssertFalse(mockDelegate.mouseExitedCalled)
        XCTAssertFalse(mockDelegate.mouseEnteredCalled)
        hoverView.mouseExited(with: NSEvent())
        XCTAssertTrue(mockDelegate.mouseExitedCalled)
        XCTAssertFalse(mockDelegate.mouseEnteredCalled)
    }
    
    func testMouseEntered() {
        let mockDelegate = MockHoverDelegate()
        let hoverView = HoverView()
        hoverView.delegate = mockDelegate
        
        XCTAssertFalse(mockDelegate.mouseExitedCalled)
        XCTAssertFalse(mockDelegate.mouseEnteredCalled)
        
        hoverView.mouseEntered(with: NSEvent())
        
        XCTAssertTrue(mockDelegate.mouseEnteredCalled)
        XCTAssertFalse(mockDelegate.mouseExitedCalled)
    }

}
