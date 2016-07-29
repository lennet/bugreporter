//
//  CreateBugViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 15/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

protocol BugStepController: class {

    func canContinue() -> Bool
    
}

enum CreateBugStep {
    case intro
    case chooseAttachment
    case howToReproduce
    case upload
    
    var identifier: String{
        get {
            switch self {
            case .intro:
                return "CreateBugIntroViewController"
            case .chooseAttachment:
                return "SelectFilesSplitView"
            case .howToReproduce:
                return "CreateBugReproduceViewController"
            case .upload:
                return "UploadBugViewController"
            }
        }
    }
    
    mutating func next() {
        switch self {
        case .intro:
            self = .chooseAttachment
        case .chooseAttachment:
            self = .howToReproduce
        case .howToReproduce:
            self = .upload
        default:
            fatalError("not implemented")
            break
        }
    }
    
    mutating func previous() {
        switch self {
        case .intro:
            fatalError("is first step")
        case .chooseAttachment:
            self = .intro
        case .howToReproduce:
            self = .chooseAttachment
        case .upload:
            self = .howToReproduce
        }
    }
    
    var isLast: Bool {
        get {
            return self == .upload
        }
    }
    
    var isFirst: Bool {
        get {
            return self == .intro
        }
    }

}

final class CreateBugViewController: NSViewController {
    
    
    @IBOutlet weak var containerView: NSView!
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var previousButton: NSButton!

    private var currentStep: CreateBugStep = .intro {
        didSet {
            updateButtonsVisibility()
            show(step: currentStep)
        }
    }
    
    weak var currentStepController: BugStepController?
    
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
