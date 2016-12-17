//
//  CreateBugIntroViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class CreateBugIntroViewController: BugStepViewController {
    

//    @IBOutlet var descriptionTextView: NSTextView!
//    @IBOutlet weak var titleTextField: NSTextField!
    
    func canContinue() -> Bool {
//        let validTitle = ValidatorUtility.validTitle(value: titleTextField.stringValue)
//        let validDescription = ValidatorUtility.validDescription(value: descriptionTextView.string ?? "")
//        return validTitle && validDescription
        return true
    }
    
}


extension CreateBugIntroViewController: NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        guard let textfield = obj.object as? NSTextField else { return }
        bugreport.title = textfield.stringValue
    }
}

extension CreateBugIntroViewController: NSTextViewDelegate {
    
    func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        bugreport.description = textView.string ?? ""
    }
}

