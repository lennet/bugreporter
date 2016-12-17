//
//  NSAutoresizingMaskOptionsExtension.swift
//  Bugreporter
//
//  Created by Leo Thomas on 17/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

extension NSAutoresizingMaskOptions {
    
    public static var viewWidthHeightSizable: NSAutoresizingMaskOptions {
        return NSAutoresizingMaskOptions.viewWidthSizable.union(.viewHeightSizable)
    }
    
}
