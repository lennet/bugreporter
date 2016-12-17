//
//  AttachmentManagerTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 11/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

extension Data {
    static func testData() -> Data {
        return "test Data".data(using: .utf8)!
    }

}

class AttachmentManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        for attachment in AttachmentManager.shared.getAll() {
            AttachmentManager.shared.delete(attachment: attachment)
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSave() {
        let data = Data.testData()
        let name = "FakeImage"
        let type: AttachmentType = .image
        
        XCTAssertTrue(AttachmentManager.shared.getAll().isEmpty)
        
        XCTAssertTrue(AttachmentManager.shared.save(data: data, name: name, type: type))
        
        guard let attachment = AttachmentManager.shared.getAll().first else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(attachment.name, name)
        XCTAssertEqual(attachment.type, type)
    }
    
    func testRemove() {
        let data = Data.testData()
        let name = "FakeImage"
        let type: AttachmentType = .image
        
        XCTAssertTrue(AttachmentManager.shared.getAll().isEmpty)
        
        XCTAssertTrue(AttachmentManager.shared.save(data: data, name: name, type: type))
        
        guard let attachment = AttachmentManager.shared.getAll().first else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(AttachmentManager.shared.delete(attachment: attachment))
        
        XCTAssertTrue(AttachmentManager.shared.getAll().isEmpty)
        
        // deleting directory should fail 
        XCTAssertFalse(AttachmentManager.shared.delete(attachment: Attachment(url: URL(fileURLWithPath: ""), type: .image)))
    }

}
