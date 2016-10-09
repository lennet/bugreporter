//
//  RecordExternalDeviceViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class RecordExternalDeviceViewController: RecorderViewController {

    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var controlContainerView: NSView!
    
    @IBOutlet weak var recordingIndicatorHeight: NSLayoutConstraint!
    @IBOutlet weak var recordingIndicatorContainer: NSView!
    
    @IBOutlet weak var recordingIndicator: CircleView!
    @IBOutlet weak var timerLabel: NSTextField!
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var titleView: NSView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    
    var timer: Timer?
    var seconds = 0 {
        didSet {
            let minutes = Int(self.seconds / 60)
            let seconds = self.seconds % 60
            
            timerLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    var animationDuration: TimeInterval = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideControlContainer(animated: false)
        (view as? HoverView)?.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        titleLabel.stringValue = device?.name ?? ""
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        NSApp.activate(ignoringOtherApps: true)
        if let layer = recorder?.sessionLayer {
            
            layer.frame = view.bounds
            layer.frame.origin = CGPoint.zero
            
            contentView.layer = layer
            contentView.wantsLayer = true
        }
        
        hideTitleBar()
    }
    
    override func viewWillDisappear() {
        timer?.invalidate()
        super.viewWillDisappear()
    }
    
    override func recordClicked(_ sender: AnyObject) {
        super.recordClicked(sender)
        
        let isRecording = (recorder?.isRecording ?? false)
        recordingIndicatorHeight.constant = isRecording ? 20:0
        recordingIndicatorContainer.alphaValue = isRecording ? 0:1
        
        if isRecording {
            seconds = 0
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = animationDuration
            context.allowsImplicitAnimation = true
            recordingIndicatorContainer.alphaValue = isRecording ? 1:0
            view.layoutSubtreeIfNeeded()
            }, completionHandler: {
               self.recordingIndicator.blink = isRecording
        })
    }
    
    func updateTimer() {
        seconds += 1
    }
    
    func hideTitleBar() {
        self.view.window?.styleMask.insert(.fullSizeContentView)
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.title = ""
    }
    
    func hideControlContainer(animated: Bool) {
        containerViewBottomConstraint.constant = -controlContainerView.bounds.height
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = animationDuration
            context.allowsImplicitAnimation = true
            view.layoutSubtreeIfNeeded()
            }, completionHandler: nil)
    }
    
    func showControlContainer(animated: Bool) {
        containerViewBottomConstraint.constant = 0
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = animationDuration
            context.allowsImplicitAnimation = true
            view.layoutSubtreeIfNeeded()
            }, completionHandler: nil)
    }

    func resizeWindow(size: CGSize) {
        guard size != CGSize.zero else { return }
        guard let window = view.window else { return }
        
        var rect = window.frame
        rect.size = CGSize(width: size.width/2, height: (size.height/2) + titleView.frame.height)
        window.setFrame(rect, display: true, animate: true)
    }

}

extension RecordExternalDeviceViewController: HoverDelegate {
    
    func mouseEntered() {
        showControlContainer(animated: true)
    }
    
    func mouseExited() {
        hideControlContainer(animated: true)
    }
    
}

extension RecordExternalDeviceViewController {
    
    override func recordinginterrupted() {
        view.window?.close()
    }
    
    override func sizeDidChanged(newSize: CGSize) {
        resizeWindow(size: newSize)
    }
    
}
