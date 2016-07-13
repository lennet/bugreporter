//
//  CreateBugViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 13/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class CreateBugViewController: NSViewController {

    @IBOutlet weak var filesCollectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
//        let mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
//        let itemPrototype = mainStoryboard.instantiateController(withIdentifier: "CollectionViewItem") as? NSCollectionViewItem
//        filesCollectionView.itemPrototype = itemPrototype
    }
    
}

extension CreateBugViewController: NSCollectionViewDataSource {
    
    private func numberOfSectionsInCollectionView(collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: "FileCollectionViewItem", for: indexPath)
        
        return item
    }
    
}


extension CreateBugViewController: NSCollectionViewDelegate {


}
