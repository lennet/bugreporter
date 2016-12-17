//
//  FilesSplitViewControllerTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 13/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class FilesSplitViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    /*
    func testCanContinue() {
        let fileSplitViewController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: CreateBugStep.chooseAttachment.identifier) as! FilesSplitViewController
        _ = fileSplitViewController.view

        // can continue should always succeed
        XCTAssertTrue(fileSplitViewController.canContinue())
    }
    
    func testLoadItems() {
        let fileSplitViewController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: CreateBugStep.chooseAttachment.identifier) as! FilesSplitViewController
        _ = fileSplitViewController.view
        
        XCTAssertNotNil(fileSplitViewController.attachmentsTableViewController)
        XCTAssertNotNil(fileSplitViewController.attachmentViewController)
    }
    
    func testAttachmentSelection() {
        let fileSplitViewController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: CreateBugStep.chooseAttachment.identifier) as! FilesSplitViewController
        _ = fileSplitViewController.view
        
        AttachmentManager.shared.save(data: Data.testData(), name: "FakeAttachment", type: .image)
        let attachment = AttachmentManager.shared.getAll().last!
        
        XCTAssertNil(fileSplitViewController.attachmentViewController?.attachment)
        
        fileSplitViewController.attachmentsTableViewController?.delegate?.didSelectAttachment(attachment: attachment)
        
        XCTAssertEqual(fileSplitViewController.attachmentViewController!.attachment!.name, attachment.name)
        
        AttachmentManager.shared.delete(attachment: attachment)
    }
    */
}
