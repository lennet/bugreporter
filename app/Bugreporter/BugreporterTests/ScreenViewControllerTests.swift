//
//  ScreenViewControllerTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 01/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
import AVFoundation
@testable import Bugreporter

class FakeDevice: RecordableDevice {
    
    var fakableName = "Fake Device"
    
    var name: String {
        get {
            return fakableName
        }
    }

    var captureDevice: AVCaptureDevice {
        get {
            return AVCaptureDevice()
        }
        
    }
}

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
    
    override func screenshot() {
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

class ScreenViewControllerTests: XCTestCase {

    func testStartStopRecording() {
        let viewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ScreenViewController") as! ScreenViewController
        _ = viewController.view
        
        let fakeRecorder = FakeRecorder()
        
        viewController.recorder = fakeRecorder
        
        XCTAssertFalse(fakeRecorder.didStartRecord)
        XCTAssertFalse(fakeRecorder.didStopRecord)
        
        viewController.recordClicked(self)
        
        XCTAssertTrue(fakeRecorder.didStartRecord)
        XCTAssertFalse(fakeRecorder.didStopRecord)

        viewController.recordClicked(self)
        
        XCTAssertTrue(fakeRecorder.didStartRecord)
        XCTAssertTrue(fakeRecorder.didStopRecord)
    }
    
    func testTakeScreenshot() {
        let viewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ScreenViewController") as! ScreenViewController
        _ = viewController.view
        
        let fakeRecorder = FakeRecorder()
        
        viewController.recorder = fakeRecorder
        
        XCTAssertFalse(fakeRecorder.didStartRecord)
        
        viewController.screenshotClicked(self)
        
        XCTAssertTrue(fakeRecorder.didTakeScreenshot)
    }
    
    func testResizeWindow() {
        let windowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "DeviceWindowController") as? NSWindowController
        
        let viewController = windowController?.contentViewController as! ScreenViewController
        _ = viewController.view
        
        let fakeRecorder = FakeRecorder()
        fakeRecorder.delegate = viewController
        
        viewController.recorder = fakeRecorder
        
        let newSize = CGSize(width: 200, height: 200)
        XCTAssertNotEqual(viewController.view.window?.frame.size, newSize)
        
        // TODO fix mysterious screen resizment
        fakeRecorder.fakeResizeDevice(size: CGSize(width: (newSize.height * 2)+24, height: newSize.height * 2))
        

        XCTAssertEqual(viewController.view.window?.frame.size, newSize)
    }

}
