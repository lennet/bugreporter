//
//  NSViewControllerExtension.swift
//  Bugreporter
//
//  Created by Leo Thomas on 10/10/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

extension NSViewController {

    class var nibName: String {
        return String(describing: self)
    }
    
    class var nib: NSNib? {
        return NSNib(nibNamed: nibName, bundle: nil)
    }
    
    func hideTitleBar() {
        self.view.window?.styleMask.insert(.fullSizeContentView)
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.title = ""
    }
    
    func add(Controller controller: NSViewController, to view: NSView) {
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.view.autoresizingMask = .viewWidthHeightSizable
    }
    
    func remove(Controller controller: NSViewController) {
        controller.view.removeFromSuperview()
        if let index = childViewControllers.index(of: controller) {
            removeChildViewController(at: index)
        }
    }
    
}
