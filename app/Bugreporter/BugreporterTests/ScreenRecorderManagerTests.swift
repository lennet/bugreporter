//
//  ScreenRecorderManagerTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 01/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class ScreenRecorderManagerTests: XCTestCase {

    func testAppend() {
        ScreenRecorderManager.shared.recorderInstances.removeAll()
        let fakeRecorder = FakeRecorder()
        XCTAssertEqual(ScreenRecorderManager.shared.recorderInstances.count, 0)
        ScreenRecorderManager.shared.add(recorder: fakeRecorder)
        XCTAssertEqual(ScreenRecorderManager.shared.recorderInstances.count, 1)
    }
    
    func testRemove() {
        ScreenRecorderManager.shared.recorderInstances.removeAll()
        let fakeRecorder = FakeRecorder()
        XCTAssertEqual(ScreenRecorderManager.shared.recorderInstances.count, 0)
        ScreenRecorderManager.shared.add(recorder: fakeRecorder)
        XCTAssertEqual(ScreenRecorderManager.shared.recorderInstances.count, 1)
        
        let anotherFakeRecorder = FakeRecorder()
        (anotherFakeRecorder.device as! FakeDevice).fakableName = "New Fake Name"
        ScreenRecorderManager.shared.remove(recorder: anotherFakeRecorder)
        XCTAssertEqual(ScreenRecorderManager.shared.recorderInstances.count, 1)
        
        ScreenRecorderManager.shared.remove(recorder: fakeRecorder)
        XCTAssertEqual(ScreenRecorderManager.shared.recorderInstances.count, 0)
    }
    
    func testSubscript() {
        ScreenRecorderManager.shared.recorderInstances.removeAll()
        let fakeRecorder = FakeRecorder()
        ScreenRecorderManager.shared.add(recorder: fakeRecorder)
        
        XCTAssertEqual(fakeRecorder, ScreenRecorderManager.shared[forDevice: fakeRecorder.device])
        
        let anotherFakeRecorder = FakeRecorder()
        (anotherFakeRecorder.device as! FakeDevice).fakableName = "New Fake Name"
        XCTAssertNil(ScreenRecorderManager.shared[forDevice: anotherFakeRecorder.device])

    }

}
