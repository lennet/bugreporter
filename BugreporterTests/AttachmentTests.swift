//
//  AttachmentTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class AttachmentTests: XCTestCase {

    override func setUp() {
        super.setUp()
        for attachment in AttachmentManager.getAll() {
            AttachmentManager.delete(attachment: attachment)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInitWithUrl() {
        let testData = Data.testData()
        let name = "TestAttachment"
        let type: AttachmentType = .video
        AttachmentManager.save(data: testData, name: name, type: type)
        
        let url = AttachmentManager.getURL(for: type, name: name)
        
        let attachment = Attachment(url: url, type: type)
        XCTAssertEqual(name, attachment.name)
        XCTAssertEqual(type, attachment.type)
        XCTAssertEqual(testData, attachment.data)
    }
    
    func testDataForInvalidURL() {
        let brokenAttachment = Attachment(url: URL(fileURLWithPath: ""), type: .image)
        XCTAssertNil(brokenAttachment.data)
    }

}
