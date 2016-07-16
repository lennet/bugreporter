//
//  AttachmentsTableViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 15/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class AttachmentsTableViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    var attachments: [Attachment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachments = AttachmentManager.shared.getAll()
        tableView.sizeLastColumnToFit()
    }
    
}

extension AttachmentsTableViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return attachments.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 100
    }
    
    // I am not sure why the objc call is needed looks like a Swift 3 Bug
    @objc(tableView:viewForTableColumn:row:) func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: "AttachmentCell", owner: self) as! AttachmentTableCellView
        
        let attachment = attachments[row]
        cell.titleLabel.stringValue = attachment.title
        if let thumbURL = attachment.thumbURL {
            cell.thumbView.image = NSImage(contentsOf: thumbURL)
        }
        
        return cell
    }
}

extension AttachmentsTableViewController: NSTableViewDelegate {


}
