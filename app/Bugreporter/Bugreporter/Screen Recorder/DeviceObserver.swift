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

class DeviceObserver {
    
    static let shared = DeviceObserver()
    var devices: [AVCaptureDevice]  {
        get {
            return (AVCaptureDevice.devices() as! [AVCaptureDevice]).filter({ (device) -> Bool in
                return device.isiOS
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
            delegate?.didAddDevice(name: device.localizedName)
        }
    }
    
    private func deviceWasConnected(with notification: Notification) {
        guard let device = notification.object as? AVCaptureDevice else { return }
        guard device.isiOS else { return }
        
        delegate?.didAddDevice(name: device.localizedName)
    }
    
    private func deviceWasDisconnected(with notification: Notification) {
        guard let device = notification.object as? AVCaptureDevice else { return }
        guard device.isiOS else { return }
        
        delegate?.didRemoveDevice()
        ScreenRecorderManager.shared[forDevice: iOSDevice(captureDevice:device)]?.stop(interrupted: true)
    }
    
    
    /// - parameter name: localized name of the desired Device
    ///
    /// - returns: the instance of the device if its exists
    func device(withName name: String) -> AVCaptureDevice? {
        for device in devices where device.localizedName == name {
            return device
        }
        return nil
    }

}
