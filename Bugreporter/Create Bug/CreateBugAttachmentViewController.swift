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

    // the default selection behaviour doesn't allow multiple selection without pressing shift
    var selectedIndeces: Set<IndexPath> = []
    
    var attachments: [Attachment] = [] {
        didSet {
            updateSelectedIndeces()
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        attachments = AttachmentManager.getAll()
        view.layout()
    }
    
    func updateSelectedIndeces() {
        selectedIndeces.removeAll()
        for attachment in bugreport.attachments {
            guard let index = attachments.index(of: attachment) else { continue }
            selectedIndeces.insert(IndexPath(item: index, section: 0))
        }
    }
        
    func configureCollectionView() {
        collectionView.register(AttachmentCollectionViewItem.self, forItemWithIdentifier: "identifier")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.enclosingScrollView?.drawsBackground = false
        collectionView.enclosingScrollView?.wantsLayer = true
        collectionView.enclosingScrollView?.scrollerStyle = .overlay
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachments.count
    }
    
    @available(OSX 10.11, *)
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "identifier", for: indexPath) as! AttachmentCollectionViewItem
        item.attachment = attachments[indexPath.item]
        item.customIsSelected = selectedIndeces.contains(indexPath)
        return item
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        
        for indexPath in indexPaths {
            let isSelected = !selectedIndeces.contains(indexPath)
            let selectedAttachment = attachments[indexPath.item]
            let item = (collectionView.item(at: indexPath) as? AttachmentCollectionViewItem)
            item?.customIsSelected = isSelected
            if isSelected {
                selectedIndeces.insert(indexPath)
                bugreport.attachments.insert(selectedAttachment)
            } else {
                selectedIndeces.remove(indexPath)
                bugreport.attachments.remove(selectedAttachment)
            }
        }
        
        collectionView.deselectItems(at: indexPaths)
    }
    
}
