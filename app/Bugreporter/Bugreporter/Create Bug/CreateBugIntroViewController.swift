//
//  CreateBugIntroViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class CreateBugIntroViewController: NSViewController, BugStepController {
    
    @IBOutlet var descriptionTextView: NSTextView!
    @IBOutlet weak var titleTextField: NSTextField!
    
    func canContinue() -> Bool {
        let validTitle = ValidatorUtility.validTitle(value: titleTextField.stringValue)
        let validDescription = ValidatorUtility.validDescription(value: descriptionTextView.string ?? "")
        return validTitle && validDescription
    }
    
}
