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
        return fakableName
    }
    
    var input: AVCaptureInput? {
        return nil
    }
    
    var fakedDeviceSupport = true
    
    var supported: Bool {
        return fakedDeviceSupport
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
        DeviceObserver.shared.devices.removeAll()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func testDeviceWithName() {
        let fakeDevice = FakeDevice()
        fakeDevice.fakableName = "Fake Device"
        XCTAssertNil(DeviceObserver.shared.device(withName: fakeDevice.name))
        
        NotificationCenter.default.post(name: NSNotification.Name.AVCaptureDeviceWasConnected, object: fakeDevice)
        
        XCTAssertNotNil(DeviceObserver.shared.device(withName: fakeDevice.name))
        
        XCTAssertEqual(DeviceObserver.shared.device(withName: fakeDevice.name)?.name, fakeDevice.name)
    }
    
}
