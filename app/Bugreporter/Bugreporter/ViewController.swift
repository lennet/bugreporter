//
//  ViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa
import AVFoundation


class ViewController: NSViewController {

    var sessionLayer: AVCaptureVideoPreviewLayer?
    var recorder: ScreenRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for case let device as AVCaptureDevice in AVCaptureDevice.devices() where device.isiOS {
            print(device)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil) { (notification) in
            guard let port = notification.object as? AVCaptureInputPort else { return }
            self.resizeWindow(port: port)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureDeviceWasConnected, object:nil, queue: nil) { (notification) in
            guard let device = notification.object as? AVCaptureDevice else { return }
            guard device.isiOS else { return }
            
            DispatchQueue.main.async(execute: { 
                self.showDevice(device: device)
            })
            

        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureDeviceWasDisconnected, object:nil, queue: nil) { (notification) in
            guard let device = notification.object as? AVCaptureDevice else { return }
            guard device.isiOS else { return }
            
            
            self.recorder?.stop()
        }
        
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        sessionLayer?.frame = view.bounds
        sessionLayer?.frame.origin = CGPoint.zero
    }
    
    func showDevice(device: AVCaptureDevice) {
        
        let recorder = ScreenRecorder(device: device)
        recorder.start()
        
        let layer = recorder.sessionLayer
        layer?.frame = view.bounds
        layer?.frame.origin = CGPoint.zero
        
        view.layer?.addSublayer(layer!)
        sessionLayer = layer
        self.recorder = recorder

    }

    func resizeWindow(port: AVCaptureInputPort) {
        var size = CGSize.zero
        if let description = port.formatDescription {
            let dimension = CMVideoFormatDescriptionGetDimensions(description)
            size = CGSize(width: Int(dimension.width)/2, height: Int(dimension.height)/2)
        }

        guard size != CGSize.zero else { return }
        if let window = view.window {
            var rect = window.frame
            rect.size = size
            window.setFrame(rect, display: true, animate: true)
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}



