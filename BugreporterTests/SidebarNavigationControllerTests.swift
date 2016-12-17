//
//  SidebarNavigationControllerTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 17/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class SidebarNavigationControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testButtonForItem() {
        
        let sidebarController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: "SidebarNavigationController") as! SidebarNavigationController
        _ = sidebarController.view
        
        for item in sidebarController.items {
            let button = sidebarController.button(for: item)
            XCTAssertNotNil(button)
            XCTAssertEqual(button?.title, item.name)
        }
        
    }
    
    func testShowItem() {
        class FakeController: BugStepViewController {
            override class func instantiate(bugreport: Bugreport) -> BugStepViewController {
                return FakeController()
            }
            
            override func loadView() {
                self.view = NSView()
            }
        
        }
        let item = SidebarNavigationItem(name: nil, icon: nil, viewController: FakeController.self)
        
        let sidebarController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: "SidebarNavigationController") as! SidebarNavigationController
        _ = sidebarController.view
        
        XCTAssertFalse(sidebarController.currentChildViewController is FakeController)
        sidebarController.show(item: item)
        
        XCTAssertTrue(sidebarController.currentChildViewController is FakeController)
    }
    
}
