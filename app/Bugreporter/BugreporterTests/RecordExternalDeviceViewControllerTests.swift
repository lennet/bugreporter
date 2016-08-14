//
//  RecordExternalDeviceViewControllerTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 01/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class RecordExternalDeviceViewControllerTests: XCTestCase {

    func testStartStopRecording() {
        let viewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "RecordExternalDeviceViewController") as! RecordExternalDeviceViewController
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
        let viewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "RecordExternalDeviceViewController") as! RecordExternalDeviceViewController
        _ = viewController.view
        
        let fakeRecorder = FakeRecorder()
        
        viewController.recorder = fakeRecorder
        
        XCTAssertFalse(fakeRecorder.didStartRecord)
        
        viewController.screenshotClicked(self)
        
        XCTAssertTrue(fakeRecorder.didTakeScreenshot)
    }
    
    func testResizeWindow() {
        let windowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "DeviceWindowController") as? NSWindowController
        
        let viewController = windowController?.contentViewController as! RecordExternalDeviceViewController
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
    
    func testHoverInAndOut() {
        let viewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "RecordExternalDeviceViewController") as! RecordExternalDeviceViewController
        viewController.animationDuration = 0 // disable animation
        _ = viewController.view
        
        //Control container should be hidden
        XCTAssertEqual(viewController.controlContainerView.frame.intersection(viewController.view.frame).size.height, 0)
        
        (viewController as HoverDelegate).mouseEntered()
        
        //Control container should be visible
        XCTAssertEqual(viewController.controlContainerView.frame.intersection(viewController.view.frame).size.height, viewController.controlContainerView.frame.size.height)
        
        (viewController as HoverDelegate).mouseExited()
        
        //Control container should be hidden
        XCTAssertEqual(viewController.controlContainerView.frame.intersection(viewController.view.frame).size.height, 0)
    }

}
