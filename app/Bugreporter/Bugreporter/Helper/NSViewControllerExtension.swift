//
//  NSViewControllerExtension.swift
//  Bugreporter
//
//  Created by Leo Thomas on 10/10/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

extension NSViewController {

    func hideTitleBar() {
        self.view.window?.styleMask.insert(.fullSizeContentView)
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.title = ""
    }
    
}
