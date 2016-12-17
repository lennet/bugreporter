//
//  SidebarNavigationButton.swift
//  Bugreporter
//
//  Created by Leo Thomas on 10/10/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class SidebarNavigationButton: NSButton {
    
    var item: SidebarNavigationItem
    
    var didClicked: (_ item: SidebarNavigationItem) -> ()
    
    init(item: SidebarNavigationItem, clickHandler: @escaping (_ item: SidebarNavigationItem) -> ()) {
        self.item = item
        self.didClicked = clickHandler
        super.init(frame: .zero)
    
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        isBordered = false
        title = item.name ?? ""
        target = self
        action = #selector(performClick)

        if let image = item.icon {
            imagePosition = .imageLeft
            self.image = image
        } else {
            imagePosition = .noImage
        }
    }
    
    override func performClick(_ sender: Any?) {
        didClicked(item)
    }
    
}
