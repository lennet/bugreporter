//
//  DeviceObserverTests.swift
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
    
    var fakedDeviceSupport = true
    
    var supported: Bool {
        get {
            return fakedDeviceSupport
        }
    }
}

class FakeDeviceObserverDelegate: DeviceObserverDelegate {
    
    var didCalledRemoveDevice = false
    
    func didRemoveDevice() {
        didCalledRemoveDevice = true
    }
    
    var didCalledAddDevice = false
    func didAddDevice(name: String) {
        didCalledAddDevice = true
    }
}

class DeviceObserverTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testConnectNewDevice() {
        let fakeDelegate = FakeDeviceObserverDelegate()
        DeviceObserver.shared.delegate = fakeDelegate
        
        XCTAssertFalse(fakeDelegate.didCalledAddDevice)
        
        let fakeDevice = FakeDevice()
        fakeDevice.fakedDeviceSupport = false
        
        NotificationCenter.default.post(name: NSNotification.Name.AVCaptureDeviceWasConnected, object: fakeDevice)
        XCTAssertFalse(fakeDelegate.didCalledAddDevice)
        
        fakeDevice.fakedDeviceSupport = true
        NotificationCenter.default.post(name: NSNotification.Name.AVCaptureDeviceWasConnected, object: fakeDevice)

        
        XCTAssertTrue(fakeDelegate.didCalledAddDevice)
    }
    
    func testDisconnectDevice() {
        let fakeDelegate = FakeDeviceObserverDelegate()
        DeviceObserver.shared.delegate = fakeDelegate
        
        XCTAssertFalse(fakeDelegate.didCalledRemoveDevice)
        
        let fakeDevice = FakeDevice()
        fakeDevice.fakedDeviceSupport = false
        
        NotificationCenter.default.post(name: NSNotification.Name.AVCaptureDeviceWasDisconnected, object: fakeDevice)
        XCTAssertFalse(fakeDelegate.didCalledRemoveDevice)
        
        fakeDevice.fakedDeviceSupport = true
        NotificationCenter.default.post(name: NSNotification.Name.AVCaptureDeviceWasDisconnected, object: fakeDevice)
        XCTAssertTrue(fakeDelegate.didCalledRemoveDevice)
    }
    
}
