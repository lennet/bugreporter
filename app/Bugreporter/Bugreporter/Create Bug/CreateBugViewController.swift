//
//  CreateBugViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 15/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa


class BugStepViewController: NSViewController {

    var bugreport: Bugreport!
    
    class func instantiate(bugreport: Bugreport) -> BugStepViewController {
        guard let viewController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: String(describing: self)) as? BugStepViewController else {
            fatalError("Could instantiate ViewController\(String(describing: self))")
        }
        
        viewController.bugreport = bugreport
        return viewController
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.gray.cgColor
    }

}

final class CreateBugViewController: NSViewController {
    
    var bugreport: Bugreport = Bugreport()
    
    @IBOutlet weak var containerView: NSView!
    
    
    private var currentStep: CreateBugStep = .intro {
        didSet {
            show(step: currentStep)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add first controller
        show(step: currentStep)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        hideTitleBar()
    }
    
    func show(step: CreateBugStep) {
    }
    
    func addController(_ controller: NSViewController) {
    }
    
    func removeController(_ controller: NSViewController) {
    }

    private func getViewController(for step: CreateBugStep) -> NSViewController {
        let viewController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: step.identifier) as! NSViewController
        viewController.view.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        viewController.view.frame = containerView.bounds
        return viewController
    }
    
    // MARK: - Actions
    
    @IBAction func nextClicked(_ sender: AnyObject) {
    }
    
    @IBAction func previousClicked(_ sender: AnyObject) {
        if !currentStep.isFirst {
            currentStep.previous()
        }
    }
    
}
