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

    var timer: Timer?
    
    @IBInspectable
    var color: NSColor = .black
    
    @IBInspectable
    var blink: Bool = false {
        didSet {
            if !blink {
                timer?.invalidate()
                alphaValue = 1
            } else {
                timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            }
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        timer?.invalidate()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        display()
    }
        
    func update() {
        alphaValue = alphaValue == 1 ? 0:1
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        color.setFill()
        NSBezierPath(ovalIn: dirtyRect).fill()
    }
    
}
