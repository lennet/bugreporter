//
//  AttachmentCollectionViewItem.swift
//  Bugreporter
//
//  Created by Leo Thomas on 18/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class AttachmentCollectionViewItem: NSCollectionViewItem {
    
    var attachment: Attachment?
    
    var customIsSelected: Bool = false {
        didSet {
            view.backgroundColor = customIsSelected ? .white : .clear
        }
    }
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var thumbImageView: NSImageView?
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        thumbImageView?.image = attachment?.thumb
        titleLabel.stringValue = attachment?.name ?? ""
    }
    
}

