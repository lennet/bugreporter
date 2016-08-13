//
//  ScreenRecorderTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 01/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
import AVFoundation
@testable import Bugreporter

class FakeRecorder: ScreenRecorder {
    
    var didStartRecord = false
    
    init() {
        super.init(device: FakeDevice(), delegate: nil, settings: UserPreferences.shared.recorderSettings)
    }
    
    override func start() {
        isRecording = true
        didStartRecord = true
    }
    
    var didStopRecord = false
    
    override func stop(interrupted: Bool = false) {
        isRecording = false
        didStopRecord = true
    }
    
    var didTakeScreenshot = false
    
    override func screenshot(with result: ((imageData: NSData?, error: Error?) -> ())?) {
        didTakeScreenshot = true
    }
        
    func fakeResizeDevice(size: CGSize) {
        delegate?.sizeDidChanged(newSize: size)
    }
    
    var didCalledGetSessionLayer = false
    
    override var sessionLayer: AVCaptureVideoPreviewLayer? {
        get {
            didCalledGetSessionLayer = true
            return super.sessionLayer
        }
    }
    
}

class FakeScreenRecorderDelegate: ScreenRecorderDelegate {
    
    var sizeDidChangeCalled = false
    
    func sizeDidChanged(newSize: CGSize) {
        sizeDidChangeCalled = true
    }
    
    var recordingInterruptedCalled = false
    func recordinginterrupted() {
        recordingInterruptedCalled = true
    }
    
}


class ScreenRecorderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStartStopRecording() {
        let recorder = ScreenRecorder(device: FakeDevice(), delegate: nil, settings: ScreenRecorderSettings(framesPerSecond: 10, duration: .infinite))
        XCTAssertFalse(recorder.isRecording)
        
        recorder.start()
        XCTAssertTrue(recorder.isRecording)
        
        recorder.stop()
        XCTAssertFalse(recorder.isRecording)
    }
    
    func testScreenRecorderDelegate() {
        let recorder = ScreenRecorder(device: FakeDevice(), delegate: nil, settings: ScreenRecorderSettings(framesPerSecond: 10, duration: .infinite))
        let fakeDelegate = FakeScreenRecorderDelegate()
        recorder.delegate = fakeDelegate
        
        XCTAssertFalse(fakeDelegate.sizeDidChangeCalled)
        
        recorder.deviceSize = CGSize.zero
        XCTAssertFalse(fakeDelegate.sizeDidChangeCalled)
        
        recorder.deviceSize = CGSize(width: 222, height: 111)
        XCTAssertTrue(fakeDelegate.sizeDidChangeCalled)
        
        XCTAssertFalse(fakeDelegate.recordingInterruptedCalled)
        
        recorder.stop()
        XCTAssertFalse(fakeDelegate.recordingInterruptedCalled)
        
        
        let newRecorder = ScreenRecorder(device: FakeDevice(), delegate: nil, settings: ScreenRecorderSettings(framesPerSecond: 10, duration: .infinite))
        newRecorder.delegate = fakeDelegate
        newRecorder.stop(interrupted: true)
        XCTAssertTrue(fakeDelegate.recordingInterruptedCalled)
    }
    
    func testScreenshotFailed() {
        let recorder = ScreenRecorder(device: FakeDevice(), delegate: nil, settings: ScreenRecorderSettings(framesPerSecond: 10, duration: .infinite))

        let screenshotExpectation = expectation(description: "Wait for Screenshot")
        recorder.screenshot { (imageData, error) in
            XCTAssertNil(imageData)
            XCTAssertNotNil(error)
            screenshotExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
