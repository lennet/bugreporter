//
//  CircleView.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/09/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

@IBDesignable
class CircleView: NSView {

    @IBInspectable
    var color: NSColor = .black
    
    override func prepareForInterfaceBuilder() {
        display()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        color.setFill()
        NSBezierPath(ovalIn: dirtyRect).fill()
    }
    
}
