//
//  AppDelegateTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 31/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class FakeDeviceObserver {

    weak var delegate: DeviceObserverDelegate?
    
    func fakeFoundDevice() {
        delegate?.didAddDevice(name: "Fake Device")
    }

}

class FakeAppDelegate: NSObject, NSApplicationDelegate {

    var willTerminate = false
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        willTerminate = true
        return .terminateCancel
    }
}

class AppDelegateTests: XCTestCase {

    var appDelegate: AppDelegate!
    
    override func setUp() {
        super.setUp()
        appDelegate = NSApp.delegate as! AppDelegate
    }
    
    func testNotificationsEnabled() {
        NSUserNotificationCenter.default.removeAllDeliveredNotifications()
        let fakeDeviceObserver = FakeDeviceObserver()
        
        UserPreferences.shared.showNotifications = true
        
        fakeDeviceObserver.delegate = appDelegate
        
        XCTAssertTrue(NSUserNotificationCenter.default.deliveredNotifications.isEmpty)
        
        
        fakeDeviceObserver.fakeFoundDevice()
        XCTAssertFalse(NSUserNotificationCenter.default.deliveredNotifications.isEmpty)
    }
    
    func testNotificationsDisbled() {
        NSUserNotificationCenter.default.removeAllDeliveredNotifications()
        let fakeDeviceObserver = FakeDeviceObserver()
        
        UserPreferences.shared.showNotifications = false
        
        fakeDeviceObserver.delegate = appDelegate
        
        XCTAssertTrue(NSUserNotificationCenter.default.deliveredNotifications.isEmpty)
        
        
        fakeDeviceObserver.fakeFoundDevice()
        XCTAssertTrue(NSUserNotificationCenter.default.deliveredNotifications.isEmpty)
    }
    
    func testQuitApplication() {
        let fakeDelegate = FakeAppDelegate()
        let originalDelegate = appDelegate
        NSApplication.shared().delegate = fakeDelegate
        
        XCTAssertFalse(fakeDelegate.willTerminate)
        
        originalDelegate?.quitClicked(self)
        
        XCTAssertTrue(fakeDelegate.willTerminate)
        
        NSApplication.shared().delegate = originalDelegate
    }
    
}
