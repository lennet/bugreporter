//
//  AttachmentsTableViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 15/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa
protocol AttachmentsTableViewControllerDelegate: class {
    func didSelectAttachment(attachment: Attachment)
}

class AttachmentsTableViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    var attachments: [Attachment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: AttachmentsTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(forDraggedTypes: [NSURLPboardType])
        tableView.setDraggingSourceOperationMask(.every, forLocal: false)
        
        attachments = AttachmentManager.getAll()
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
    
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        
        pboard.declareTypes([NSURLPboardType], owner: self)
        for row in rowIndexes {
            let attachment = attachments[row]
            (attachment.url as NSURL).write(to: pboard)

        }
        return true
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {
        return .every
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
        
        
        return true
    }

    override func namesOfPromisedFilesDropped(atDestination dropDestination: URL) -> [String]? {
        
        return nil
    }
    
}

extension AttachmentsTableViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: "AttachmentCell", owner: self) as! AttachmentTableCellView
        
        let attachment = attachments[row]
        cell.titleLabel.stringValue = attachment.title
        cell.thumbView.image = NSImage(contentsOf: attachment.thumbURL)
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        delegate?.didSelectAttachment(attachment: attachments[row])
        return true
    }
    
}
