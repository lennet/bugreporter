//
//  RecordExternalDeviceViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa
import AVFoundation


class RecordExternalDeviceViewController: RecorderViewController {

    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var controlContainerView: NSView!
    
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    var animationDuration: TimeInterval = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideControlContainer(animated: false)
        (view as? HoverView)?.delegate = self
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
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        contentView.frame = view.bounds
        contentView.frame.origin = CGPoint.zero
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
        if let window = view.window {
            var rect = window.frame
            // not sure why width -12 is needed to remove padding 🔮🦄
            rect.size = CGSize(width: size.width/2-12, height: size.height/2)
            print(rect.size)
            window.setFrame(rect, display: true, animate: true)
            
        }
        
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
