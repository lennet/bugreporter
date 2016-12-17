//
//  CreateBugIntroViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class CreateBugIntroViewController: BugStepViewController {
    
    @IBOutlet weak var separatorView: NSView!
    @IBOutlet var descriptionTextView: NSTextField!
    @IBOutlet weak var titleTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        separatorView.backgroundColor = .black
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        titleTextField.stringValue = bugreport.title
        descriptionTextView.stringValue = bugreport.description
    }
    
}


extension CreateBugIntroViewController: NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        guard let textfield = obj.object as? NSTextField else { return }
        if textfield == descriptionTextView {
            bugreport.description = textfield.stringValue
        } else if textfield == titleTextField {
            bugreport.title = textfield.stringValue
        }
    }
}
