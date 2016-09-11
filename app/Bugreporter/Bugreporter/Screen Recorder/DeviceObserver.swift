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
        return localizedName
    }
    
    var input: AVCaptureInput? {
        do {
            return try AVCaptureDeviceInput(device: self)
        } catch {
            print("Could not create Capture Device Input with error: \(error)")
            return nil
        }
    }

    var supported: Bool {
        return isiOS
    }
    
}


class DeviceObserver {
    
    static let shared = DeviceObserver()
    
    var devices: [RecordableDevice] = []
    weak var delegate: DeviceObserverDelegate?
    
    private init() {
        activateGlobalScope()
        initialScan()
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureDeviceWasConnected, object: nil, queue: nil, using: deviceWasConnected)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureDeviceWasDisconnected, object: nil, queue: nil, using: deviceWasDisconnected)
    }
    
    
    /// **must** be called before looking for iOS Devices
    private func activateGlobalScope() {
        var address = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster))
        var allow: UInt32 = 1
        let dataSize: UInt32 = 4
        let zero: UInt32 = 0
        CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &address, zero, nil, dataSize, &allow)
    }
    
    
    /// looks if devices are already connected and informs delegate
    private func initialScan() {
        for case let device as RecordableDevice in AVCaptureDevice.devices() where device.supported {
                    devices.append(device)
        }
        
        if let last = devices.last {
            delegate?.didAddDevice(name: last.name)
        }
    }
    
    private func deviceWasConnected(with notification: Notification) {
        guard let device = notification.object as? RecordableDevice, device.supported else { return }
        
        
        devices.append(device)
        delegate?.didAddDevice(name: device.name)
    }
    
    private func deviceWasDisconnected(with notification: Notification) {
        guard let device = notification.object as? RecordableDevice, device.supported else { return }
        
        if let index = devices.index(where: { (recordableDevice) -> Bool in
            return device.name == device.name
        }) {
            devices.remove(at: index)
        }
        
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
