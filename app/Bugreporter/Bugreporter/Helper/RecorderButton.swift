//
//  RecorderButton.swift
//  Bugreporter
//
//  Created by Leo Thomas on 17/09/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

enum RecorderButtonState {
    case waiting
    case recording
}

enum RecorderButtonType: Int {
    case video
    case screenshot
}

extension RecorderButtonState {
    mutating func next() {
        switch self {
        case .waiting:
            self = .recording
            break
        case .recording:
            self = .waiting
            break
        }
    }
}

@IBDesignable
class RecorderButton: NSControl {
    
    @IBInspectable var padding: CGFloat = 6 {
        didSet {
            layout()
        }
    }

    @IBInspectable var lineWidth: CGFloat = 2 {
        didSet {
            needsDisplay = true
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            layout()
        }
    }
    
    var animationDuration: TimeInterval = 0.25
    
    @IBInspectable var type: Int = RecorderButtonType.video.rawValue {
        didSet {
            needsDisplay = true
            layout()
        }
    }

    private weak var innerLayer: CALayer?
    var pressed: Bool = false
    
    var state: RecorderButtonState = .waiting {
        didSet {
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = animationDuration
                context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    self.layoutInnerLayer()
                }, completionHandler: nil)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        pressed = true
    }

    
    override func mouseUp(with event: NSEvent) {
        pressed = false
        if RecorderButtonType(rawValue: type) == .video {
            state.next()
        }
        sendAction(action, to: target)
    }
    
    @IBInspectable var strokeColor: NSColor = .white
    @IBInspectable var fillColor: NSColor = .red

    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
        addLayer()
        layerContentsRedrawPolicy = .onSetNeedsDisplay
        layout()
    }
    
    func addLayer() {
        let layer = CALayer()
        layer.backgroundColor = fillColor.cgColor
        self.layer?.addSublayer(layer)
        self.innerLayer = layer
    }
    
    func layoutInnerLayer() {
        guard let innerLayer = innerLayer else { return }
        
        switch state {
        case .recording:
            innerLayer.frame = CGRect(x: padding * 1.5, y: padding * 1.5, width: frame.width - 2 * padding * 1.5, height: frame.height - 2 * padding * 1.5 )
            innerLayer.cornerRadius = cornerRadius

            break
        case .waiting:
            innerLayer.frame = CGRect(x: padding, y: padding, width: frame.width - 2 * padding, height: frame.height - 2 * padding)
            innerLayer.cornerRadius = innerLayer.frame.height / 2
            break
        }
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        (pressed ? strokeColor.highlighted : strokeColor).setStroke()
        (pressed ? fillColor.highlighted : fillColor).setFill()
        
        let outerCircle = NSBezierPath(ovalIn: dirtyRect.insetBy(dx: lineWidth, dy: lineWidth))
        outerCircle.lineWidth = lineWidth
        outerCircle.stroke()
    }
    
    override func layout() {
        super.layout()
        layoutInnerLayer()
    }
    
}

extension NSColor {
    
    var highlighted: NSColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return NSColor(hue: hue, saturation: saturation, brightness: brightness * 0.8, alpha: alpha)
    }
    
}
