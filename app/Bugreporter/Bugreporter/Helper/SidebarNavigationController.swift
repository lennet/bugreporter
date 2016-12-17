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

class SidebarNavigationController: NSViewController {

    weak var navigationStackView: NSStackView?
    weak var currentChildViewController: NSViewController?
    weak var contentView: NSView?
    var bugreport: Bugreport = Bugreport()
    
    
    
    var items: [SidebarNavigationItem] {
        return [SidebarNavigationItem(name: "Start", icon: #imageLiteral(resourceName: "apple-tv"), viewController: CreateBugIntroViewController.self), SidebarNavigationItem(name: "Attachments", icon: #imageLiteral(resourceName: "apple-tv"), viewController: CreateBugAttachmentViewController.self), SidebarNavigationItem(name: "Environment", icon: #imageLiteral(resourceName: "apple-tv"), viewController: CreateBugIntroViewController.self),
            SidebarNavigationItem(name: "Export", icon: #imageLiteral(resourceName: "apple-tv"), viewController: CreateBugIntroViewController.self)]
    }
    
    let navigationbarWidth: CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        configureContentView()
        
        if let first = items.first {
            show(item: first)
        }
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        hideTitleBar()
    }
    
    func configureContentView() {
        let contentView = NSView(frame: NSRect(x: navigationbarWidth, y: 0, width: view.frame.width-navigationbarWidth, height: view.frame.height))
        contentView.wantsLayer = true
        contentView.backgroundColor = .white
        contentView.autoresizingMask = .viewWidthHeightSizable
        view.addSubview(contentView)
        self.contentView = contentView
    }
    
    func configureStackView() {
        let insets: EdgeInsets = EdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        let stackView = NSStackView(frame: NSRect(origin: CGPoint(x:insets.left, y:insets.top) , size: CGSize(width: navigationbarWidth-(insets.left + insets.right), height: view.frame.height-(insets.top + insets.bottom))))
        
        stackView.wantsLayer = true
        stackView.autoresizingMask = .viewHeightSizable
        stackView.distribution = .equalCentering
        stackView.orientation = .vertical
        
        items.forEach {
            let button = SidebarNavigationButton(item: $0, clickHandler: show)
            stackView.addArrangedSubview(button)
        }
        
        view.addSubview(stackView)
        navigationStackView = stackView
        
    }
    
    func show(item: SidebarNavigationItem) {
        if let currentChildViewController = currentChildViewController {
            removeController(currentChildViewController)
        }
    
        let viewController = item.viewController.instantiate(bugreport: bugreport)
        addController(viewController)
        
    }
    
    func addController(_ controller: NSViewController) {
        guard let contentView = contentView else { return }
        
        addChildViewController(controller)
        contentView.addSubview(controller.view)
        controller.view.frame = contentView.bounds
        controller.view.autoresizingMask = .viewWidthHeightSizable
        currentChildViewController = controller
    }
    
    func removeController(_ controller: NSViewController) {
        controller.view.removeFromSuperview()
        if let index = childViewControllers.index(of: controller) {
            removeChildViewController(at: index)
        }
    }

}
