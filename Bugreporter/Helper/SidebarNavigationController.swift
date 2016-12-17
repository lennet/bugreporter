//
//  SidebarNavigationController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 10/10/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

struct SidebarNavigationItem {
    var name: String?
    var icon: NSImage?
    var viewController: BugStepViewController.Type
}

extension SidebarNavigationItem: Equatable {
    
    static func ==(lhs: SidebarNavigationItem, rhs: SidebarNavigationItem) -> Bool {
        return lhs.name == rhs.name && lhs.viewController == rhs.viewController
    }
    
}

class SidebarNavigationController: NSViewController {

    let navigationbarWidth: CGFloat = 120
    let navigationViewInsets: EdgeInsets = EdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    
    weak var navigationView: NSView?
    weak var currentChildViewController: NSViewController?
    weak var contentView: NSView?
    weak var selectionIndicator: NSView?
    
    var bugreport: Bugreport = Bugreport()
    
    var items: [SidebarNavigationItem] {
        return [SidebarNavigationItem(name: "Start", icon: #imageLiteral(resourceName: "apple-tv"), viewController: CreateBugIntroViewController.self), SidebarNavigationItem(name: "Attachments", icon: #imageLiteral(resourceName: "apple-tv"), viewController: CreateBugAttachmentViewController.self), SidebarNavigationItem(name: "Environment", icon: #imageLiteral(resourceName: "apple-tv"), viewController: CreateBugIntroViewController.self),
            SidebarNavigationItem(name: "Export", icon: #imageLiteral(resourceName: "apple-tv"), viewController: CreateBugIntroViewController.self)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContentView()
        configureNavigationView()
        configureSelectionIndicator()
        
        if let first = items.first {
            show(item: first)
        }
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        hideTitleBar()
    }
    
    func configureSelectionIndicator() {
        let selectionIndicator = NSView(frame: NSRect(origin: .zero, size: CGSize(width: navigationbarWidth, height: 100)))
        selectionIndicator.backgroundColor = .white
        selectionIndicator.autoresizingMask = .viewHeightSizable
        
        
        navigationView?.addSubview(selectionIndicator, positioned: .below, relativeTo: nil)
        self.selectionIndicator = selectionIndicator
    }
    
    
    func configureContentView() {
        let contentView = NSView(frame: NSRect(x: navigationbarWidth, y: 0, width: view.frame.width-navigationbarWidth, height: view.frame.height))
        contentView.wantsLayer = true
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .viewWidthHeightSizable
        view.addSubview(contentView)
        self.contentView = contentView
    }
    
    func configureNavigationView() {
        let rect = CGRect(origin: .zero, size: CGSize(width: navigationbarWidth, height: view.frame.height))
        let navigationView = NSView(frame: rect.inset(by: navigationViewInsets))

        navigationView.autoresizingMask = .viewHeightSizable
        
        let buttonHeight = navigationView.height/CGFloat(items.count)
        
        
        for (index, item) in items.enumerated() {
            let button = SidebarNavigationButton(item: item, clickHandler: didClicked)
            button.frame = NSRect(x: 0, y: buttonHeight*CGFloat(items.count-index-1), width: navigationView.width, height: buttonHeight)
            navigationView.addSubview(button)
        }
        
        view.addSubview(navigationView)
        self.navigationView = navigationView
    }
    
    func button(for item: SidebarNavigationItem) -> SidebarNavigationButton? {
        for case let button as SidebarNavigationButton in navigationView?.subviews ?? [] {
            guard button.item == item else {
                continue
            }
            return button
        }
        return nil
    }
    
    func didClicked(item: SidebarNavigationItem) {
        show(item: item, animated: true)
    }
    
    func show(item: SidebarNavigationItem, animated: Bool = false) {
        if let currentChildViewController = currentChildViewController {
            remove(Controller: currentChildViewController)
        }
        
        if let selectedButton = button(for: item) {
            selectionIndicator?.alphaValue = 1
            NSAnimationContext.runAnimationGroup({ (context) in
                context.duration = animated ? animationDuration : 0
                context.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                selectionIndicator?.animator().frame = selectedButton.frame
            }, completionHandler: nil)
        } else {
            selectionIndicator?.alphaValue = 0
        }
    
        let viewController = item.viewController.instantiate(bugreport: bugreport)
        
        guard let contentView = contentView else { return }
        add(Controller: viewController, to: contentView)
        currentChildViewController = viewController
    }
    
}
