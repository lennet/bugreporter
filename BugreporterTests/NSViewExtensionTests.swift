//
//  NSViewExtensionTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 29/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class NSViewExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testWidth() {
        let width: CGFloat = 100
        let view = NSView(frame: NSRect(origin: .zero, size: CGSize(width: width, height: 0)))
        
        XCTAssertEqual(view.width, width)
        
        let newWidth: CGFloat = 200
        view.width = newWidth
        
        XCTAssertEqual(view.width, newWidth)
    }
    
    func testHeight() {
        let height: CGFloat = 100
        let view = NSView(frame: NSRect(origin: .zero, size: CGSize(width: 0, height: height)))
        
        XCTAssertEqual(view.height, height)
        
        let newHeight: CGFloat = 200
        view.height = newHeight
        
        XCTAssertEqual(view.height, newHeight)
    }
    
    func testSetBackgroundColor() {
        let view = NSView(frame: .zero)
        let color: NSColor = .red
        
        view.backgroundColor = color
        XCTAssertEqual(view.layer?.backgroundColor, color.cgColor)
        
        XCTAssertEqual(view.backgroundColor, color)
    }
    
    func testEmptyBackgroundColor() {
        let view = NSView(frame: .zero)
        XCTAssertNil(view.backgroundColor)
    }
    
}
