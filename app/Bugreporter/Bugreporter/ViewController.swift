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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil) { (notification) in
            guard let port = notification.object as? AVCaptureInputPort else { return }
            self.resizeWindow(port: port)
        }
    
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        NSApp.activateIgnoringOtherApps(true)
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
            guard let device = representedObject as? AVCaptureDevice else { return }
            showDevice(device: device)
        }
    }

}



