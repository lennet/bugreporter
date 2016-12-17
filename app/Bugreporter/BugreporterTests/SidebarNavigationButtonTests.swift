//
//  SidebarNavigationButtonTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 17/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class SidebarNavigationButtonTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDidClicked() {
        let exp = expectation(description: "Wait for click callback")
        
        var didCalledHandler = false
        let item = SidebarNavigationItem(name: "Test item", icon: nil, viewController: CreateBugIntroViewController.self)
        
        let clickHandler: (SidebarNavigationItem) -> () = { clickedItem in
            XCTAssertEqual(clickedItem, item)
            didCalledHandler = true
            exp.fulfill()
        }
        
        let button = SidebarNavigationButton(item: item, clickHandler: clickHandler)
        XCTAssertFalse(didCalledHandler)
        
        button.performClick(nil)
        
        waitForExpectations(timeout: 1.0) { (_) in
            XCTAssertTrue(didCalledHandler)
        }
    }
    
    func testConfigure() {
        let item = SidebarNavigationItem(name: "Test item", icon: nil, viewController: CreateBugIntroViewController.self)
        
        let clickHandler: (SidebarNavigationItem) -> () = { _ in }
        let button = SidebarNavigationButton(item: item, clickHandler: clickHandler)
        
        XCTAssertEqual(button.title, item.name)
    }

}
