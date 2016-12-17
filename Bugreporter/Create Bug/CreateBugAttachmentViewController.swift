//
//  CreateBugAttachmentViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 17/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class CreateBugAttachmentViewController: BugStepViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {

    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .clear
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> NSView {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .white
        return view
    }
    
    @available(OSX 10.11, *)
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        return collectionView.makeItem(withIdentifier: "identifier", for: indexPath)
    }
    
    
}
