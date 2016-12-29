//
//  BugreporterBaseViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 29/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class BugreporterBaseViewController: NSViewController {

    override func viewDidAppear() {
        super.viewDidAppear()
        if self.view.window?.contentViewController == self {
            hideTitleBar()
        }
    }
    
}
