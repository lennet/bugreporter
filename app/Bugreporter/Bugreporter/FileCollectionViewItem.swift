//
//  FileCollectionViewItem.swift
//  Bugreporter
//
//  Created by Leo Thomas on 13/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class FileCollectionViewItem: NSCollectionViewItem {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer?.backgroundColor = NSColor.red().cgColor
    }
    
    override var representedObject: AnyObject? {
        didSet {
            print(representedObject)
        }
    }
    
}
