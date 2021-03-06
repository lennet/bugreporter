//
//  CreateBugViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 15/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa


class BugStepViewController: NSViewController {
    
    // Keyboard Navigation
    var firstkeyView: NSView? { return nil }
    var lastKeyView: NSView? { return nil }

    var bugreport: Bugreport!
    
    class func instantiate(bugreport: Bugreport) -> BugStepViewController {
        guard let viewController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: String(describing: self)) as? BugStepViewController else {
            fatalError("Could instantiate ViewController\(String(describing: self))")
        }
        
        viewController.bugreport = bugreport
        return viewController
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        view.backgroundColor = .clear
    }

}
