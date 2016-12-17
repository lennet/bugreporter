//
//  SidebarNavigationButton.swift
//  Bugreporter
//
//  Created by Leo Thomas on 10/10/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

enum KeyboardEvent: UInt16 {
    case up = 126
    case down = 125
    case left = 123
    case right = 124
}

class SidebarNavigationButton: NSButton {
    
    var item: SidebarNavigationItem
    
    var didClicked: (_ item: SidebarNavigationItem) -> ()
    var didPressedKey: ((_ item: SidebarNavigationItem, _ event: KeyboardEvent) -> ())?
    
    init(item: SidebarNavigationItem, clickHandler: @escaping (_ item: SidebarNavigationItem) -> ()) {
        self.item = item
        self.didClicked = clickHandler
        super.init(frame: .zero)
    
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override var canBecomeKeyView: Bool {
        return true
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
        window?.makeFirstResponder(self)
        didClicked(item)
    }
    
    override func keyDown(with event: NSEvent) {
        if let keyboardEvent = KeyboardEvent(rawValue: event.keyCode) {
            didPressedKey?(item, keyboardEvent)
        } else {
            super.keyDown(with: event)
        }
    }
    
}
