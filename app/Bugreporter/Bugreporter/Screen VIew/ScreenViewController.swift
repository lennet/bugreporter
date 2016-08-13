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
    
    var recorder: ScreenRecorder?
    var animationDuration: TimeInterval = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideControlContainer(animated: false)
        
        (view as? HoverView)?.delegate = self
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        NSApp.activateIgnoringOtherApps(true)
        guard let device = representedObject as? RecordableDevice else { return }
        
        showDevice(device: device)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        if !(recorder?.isRecording ?? false) {
            recorder?.finnishSession()
        }
        
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        contentView.frame = view.bounds
        contentView.frame.origin = CGPoint.zero
    }
    
    private func hideControlContainer(animated: Bool) {
        containerViewBottomConstraint.constant = -controlContainerView.bounds.height
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = animationDuration
            context.allowsImplicitAnimation = true
            view.layoutSubtreeIfNeeded()
            }, completionHandler: nil)
    }
    
    private func showControlContainer(animated: Bool) {
        containerViewBottomConstraint.constant = 0
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = animationDuration
            context.allowsImplicitAnimation = true
            view.layoutSubtreeIfNeeded()
            }, completionHandler: nil)
    }
    
    func showDevice(device: RecordableDevice) {
        
        view.window?.title = device.name
        
        if let recorder = ScreenRecorderManager.shared[forDevice: device] {
            if recorder.isRecording {
                recordButton.title = "stop"
            }
            recorder.delegate = self
            self.recorder = recorder
            resizeWindow(size: recorder.deviceSize)
        } else {
            let recorderSettings = UserPreferences.shared.recorderSettings
            let recorder = ScreenRecorder(device: device, delegate: self, settings: recorderSettings)
            self.recorder = recorder
        }
        
        if let layer = recorder?.sessionLayer {
            
            layer.frame = view.bounds
            layer.frame.origin = CGPoint.zero
            
            contentView.layer = layer
            contentView.wantsLayer = true
        }
        
    }

    func resizeWindow(size: CGSize) {
        guard size != CGSize.zero else { return }
        if let window = view.window {
            var rect = window.frame
            // not sure why width -12 is needed to remove padding 🔮🦄
            rect.size = CGSize(width: size.width/2-12, height: size.height/2)
            print(rect.size)
            window.setFrame(rect, display: true, animate: true)
            
        }
        
    }

    @IBAction func recordClicked(_ sender: AnyObject) {
        guard let recorder = recorder else { return }
        
        if recorder.isRecording {
            recorder.stop()
            recordButton.title = "Start"
        } else {
            recorder.start()
            recordButton.title = "Stop"
        }
        
    }
    
    @IBAction func screenshotClicked(_ sender: AnyObject) {
        recorder?.screenshot(with: { (imageData, error) in
            if let imageData = imageData {
                let name = "\(self.recorder!.device.name)_\(Date().toString())"
                AttachmentManager.shared.save(data: imageData, name: name, type: .image)
            } else {
                //show error
            }
        })
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
    
    func sizeDidChanged(newSize: CGSize) {
        resizeWindow(size: newSize)
    }
}
