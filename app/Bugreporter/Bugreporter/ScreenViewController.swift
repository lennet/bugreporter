//
//  ScreenViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa
import AVFoundation


class ScreenViewController: NSViewController {

    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var controlContainerView: NSView!
    
    @IBOutlet weak var screenshotButton: NSButton!
    @IBOutlet weak var recordButton: NSButton!

    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    var sessionLayer: AVCaptureVideoPreviewLayer?
    var recorder: ScreenRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideControlContainer(animated: false)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil, queue: nil) { (notification) in
            guard let port = notification.object as? AVCaptureInputPort else { return }
            self.resizeWindow(port: port)
        }
        
        (view as? HoverView)?.delegate = self
        view.layer?.backgroundColor = NSColor.black().cgColor
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        NSApp.activateIgnoringOtherApps(true)
        guard let device = representedObject as? AVCaptureDevice else { return }
        
        showDevice(device: device)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        recorder?.finnishSession()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        sessionLayer?.frame = view.bounds
        sessionLayer?.frame.origin = CGPoint.zero
    }
    
    private func hideControlContainer(animated: Bool) {
        containerViewBottomConstraint.constant = -controlContainerView.bounds.height
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.25
            context.allowsImplicitAnimation = true
            view.layoutSubtreeIfNeeded()
            }, completionHandler: nil)
    }
    
    private func showControlContainer(animated: Bool) {
        containerViewBottomConstraint.constant = 0
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = 0.25
            context.allowsImplicitAnimation = true
            view.layoutSubtreeIfNeeded()
            }, completionHandler: nil)
    }
    
    func showDevice(device: AVCaptureDevice) {
        
        view.window?.title = device.localizedName
        
        let recorder = ScreenRecorder(device: device, delegate: self)
        
        let layer = recorder.sessionLayer
        layer?.frame = view.bounds
        layer?.frame.origin = CGPoint.zero
        
        contentView.layer?.addSublayer(layer!)
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
        }
    }
    
    @IBAction func recordClicked(_ sender: NSButton) {
        guard let recorder = recorder else { return }
        
        if recorder.isRecording {
            recorder.stop()
            sender.title = "Start"
        } else {
            recorder.start()
            sender.title = "Stop"
        }
        
    }
    
    @IBAction func screenshotClicked(_ sender: AnyObject) {
        recorder?.screenshot()
    }

}

extension ScreenViewController: HoverDelegate {
    
    func mouseEntered() {
        showControlContainer(animated: true)
    }
    
    func mouseExited() {
        hideControlContainer(animated: true)
    }
    
}

extension ScreenViewController: ScreenRecorderDelegate {
    
    func recordinginterrupted() {
        view.window?.close()
    }
    
}
