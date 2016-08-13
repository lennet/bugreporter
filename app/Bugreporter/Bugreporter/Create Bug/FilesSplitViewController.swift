//
//  FilesSplitViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class FilesSplitViewController: NSSplitViewController, BugStepController {
    
    var attachmentViewController: AttachmentViewController? {
        for item in splitViewItems where item.viewController is AttachmentViewController {
            return item.viewController as? AttachmentViewController
        }
        return nil
    }
    
    var attachmentsTableViewController: AttachmentsTableViewController? {
        for item in splitViewItems where item.viewController is AttachmentsTableViewController {
            return item.viewController as? AttachmentsTableViewController
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        attachmentsTableViewController?.delegate = self
        
    }
    
    func canContinue() -> Bool {
        return true
    }

}

extension FilesSplitViewController: AttachmentsTableViewControllerDelegate {
    
    func didSelectAttachment(attachment: Attachment) {
        attachmentViewController?.attachment = attachment
    }
    
}
