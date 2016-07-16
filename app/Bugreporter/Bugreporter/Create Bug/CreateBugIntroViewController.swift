//
//  CreateBugIntroViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class CreateBugIntroViewController: NSViewController, BugStepController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func canContinue() -> Bool {
        return true
    }
    
    
    
}
