//
//  FancyView.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

@IBDesignable
class FancyView: NSView {

    @IBInspectable var backgroundColor: NSColor = .white() {
        didSet {
            setNeedsDisplay(frame)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        backgroundColor.setFill()
        NSRectFill(dirtyRect)
    }
    
}
