//
//  NSViewExtension.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

extension NSView {
    
    
    var width: CGFloat {
        
        set {
            bounds.size.width = newValue
        }

        
        get {
            return bounds.size.width
        }
        
    }
    
    var height: CGFloat {
        
        set {
            bounds.size.height = newValue
        }
        
        
        get {
            return bounds.size.height
        }
        
    }
    
    var backgroundColor: NSColor? {
        
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
        
        get {
            if let color = layer?.backgroundColor {
                return NSColor(cgColor: color)
            }
            return nil
        }
    
    }

}
