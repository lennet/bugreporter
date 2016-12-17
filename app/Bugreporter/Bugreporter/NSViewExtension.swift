//
//  NSViewExtension.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

extension NSView {
    
    class func load(with nibName: String, bundle: Bundle = .main) -> NSView? {
        let viewController = NSViewController(nibName: nibName, bundle: bundle)
        return viewController?.view
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
