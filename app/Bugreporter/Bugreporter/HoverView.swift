//
//  HoverView.swift
//  Bugreporter
//
//  Created by Leo Thomas on 13/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

protocol HoverDelegate: class {
    
    func mouseEntered()
    
    func mouseExited()
    
}

class HoverView: NSView {
    
    weak var delegate: HoverDelegate?
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        let area = NSTrackingArea(rect: frame, options: [NSTrackingAreaOptions.activeAlways, NSTrackingAreaOptions.mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(area)
    }
    
    override func mouseEntered(_ event: NSEvent) {
        delegate?.mouseEntered()
    }
    
    override func mouseExited(_ event: NSEvent) {
        delegate?.mouseExited()
    }
    
}
