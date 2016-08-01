//
//  DeviceObserver.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import AVFoundation
import CoreMediaIO

protocol DeviceObserverDelegate: class {
    
    func didAddDevice(name: String)
    
    func didRemoveDevice()
    
}

extension AVCaptureDevice: RecordableDevice {
    
    var name: String {
        get {
            return localizedName
        }
    }
    
    var captureDevice: AVCaptureDevice {
        get {
            return self
        }
    }
    
    var supported: Bool {
        get {
            return isiOS
        }
    }
    
}

class DeviceObserver {
    
    static let shared = DeviceObserver()
    var devices: [RecordableDevice]  {
        get {
            return AVCaptureDevice.devices().map({ (captureDevice) -> RecordableDevice in
                return captureDevice as! RecordableDevice
            }).filter({ (device) -> Bool in
                return device.supported
            })
        }
    }
    
    weak var delegate: DeviceObserverDelegate?
    
    private init() {
        activateGlobalScope()
        initialScan()
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureDeviceWasConnected, object: nil, queue: nil, using: deviceWasConnected)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureDeviceWasDisconnected, object: nil, queue: nil, using: deviceWasDisconnected)
    }
    
    
    /// **must** be called before looking for iOS Devices
    private func activateGlobalScope() {
        var adress = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster))
        var allow: UInt32 = 1
        let dataSize: UInt32 = 4
        let zero: UInt32 = 0
        CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &adress, zero, nil, dataSize, &allow)
    }
    
    
    /// looks if devices are already connected and informs delegate
    private func initialScan() {
        if let device = devices.first {
            delegate?.didAddDevice(name: device.name)
        }
    }
    
    private func deviceWasConnected(with notification: Notification) {
        guard let device = notification.object as? RecordableDevice, device.supported else { return }
        
        delegate?.didAddDevice(name: device.name)
    }
    
    private func deviceWasDisconnected(with notification: Notification) {
        guard let device = notification.object as? RecordableDevice, device.supported else { return }
        
        
        delegate?.didRemoveDevice()
        ScreenRecorderManager.shared[forDevice: device]?.stop(interrupted: true)
    }
    
    
    /// - parameter name: localized name of the desired Device
    ///
    /// - returns: the instance of the device if its exists
    func device(withName name: String) -> RecordableDevice? {
        for device in devices where device.name == name {
            return device
        }
        return nil
    }

}
