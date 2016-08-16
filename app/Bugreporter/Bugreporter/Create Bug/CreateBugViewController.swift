//
//  CreateBugViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 15/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

protocol BugstepControllerDelegate: class {
    func updateToolbar(views: [NSView])
}

protocol BugStepController: class {
    
    weak var delegate: BugstepControllerDelegate? { get set }
    
    var bugreport: Bugreport { get set }

    func canContinue() -> Bool
    
}

final class CreateBugViewController: NSViewController {
    
    var bugreport: Bugreport = Bugreport()
    
    @IBOutlet weak var containerView: NSView!
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var toolbarView: NSStackView!
    
    private var currentStep: CreateBugStep = .intro {
        didSet {
            updateButtonsVisibility()
            show(step: currentStep)
        }
    }
    
    weak var currentStepController: BugStepController? {
        didSet {
            if let previousStepController = oldValue {
                bugreport = previousStepController.bugreport
            }
            clearToolbar()
            currentStepController?.delegate = self
            currentStepController?.bugreport = bugreport
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add first controller
        show(step: currentStep)
    }
    
    func show(step: CreateBugStep) {
        let newController = getViewController(for: currentStep)

        
        if let currentController = currentStepController as? NSViewController {
            removeController(currentController)
        }
        
        addController(newController)
    }
    
    func addController(_ controller: NSViewController) {
        addChildViewController(controller)
        containerView.addSubview(controller.view)
        titleLabel.stringValue = controller.title ?? ""
        currentStepController = controller as? BugStepController
    }
    
    func removeController(_ controller: NSViewController) {
        controller.view.removeFromSuperview()
        if let index = childViewControllers.index(of: controller) {
            removeChildViewController(at: index)
        }
    }
    
    private func getViewController(for step: CreateBugStep) -> NSViewController {
        let viewController = NSStoryboard(name: "CreateBug", bundle: nil).instantiateController(withIdentifier: step.identifier) as! NSViewController
        viewController.view.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        viewController.view.frame = containerView.bounds
        return viewController
    }
    
    private func updateButtonsVisibility() {
        previousButton.isEnabled = !currentStep.isFirst
        nextButton.isEnabled = !currentStep.isLast
    }
    
    func clearToolbar() {
        for view in toolbarView.subviews {
            toolbarView.removeView(view)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextClicked(_ sender: AnyObject) {
        guard let currentStepController = currentStepController else { return }
        if !currentStep.isLast && currentStepController.canContinue() {
            currentStep.next()
        } else {
            // show error
        }
    }
    
    @IBAction func previousClicked(_ sender: AnyObject) {
        if !currentStep.isFirst {
            currentStep.previous()
        }
    }
    
}

extension CreateBugViewController: BugstepControllerDelegate {
    
    func updateToolbar(views: [NSView]) {
        clearToolbar()
        
        for view in views {
            toolbarView.addView(view, in: .center)
        }
    }
    
}
