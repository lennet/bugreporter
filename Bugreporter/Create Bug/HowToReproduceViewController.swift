//
//  HowToReproduceViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

enum Reproducibility: String {
    case always = "Always"
    case often = "Often"
    case rare = "Rare"
    case unicorn = "🦄"
    
    static let all: [Reproducibility] = [.always, .often, .rare, .unicorn]
}

class HowToReproduceViewController: NSViewController {
    
    var bugreport: Bugreport = Bugreport()
    
    @IBOutlet var stepsTextView: NSTextView!
    @IBOutlet weak var reproducibilityPopUp: NSPopUpButton!
    @IBOutlet weak var environmentTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        reproducibilityPopUp.removeAllItems()
        reproducibilityPopUp.addItems(withTitles: Reproducibility.all.map({ (reproducibility) -> String in
            return reproducibility.rawValue
        }))
    }
    
    func canContinue() -> Bool {
        let validEnvironment = ValidatorUtility.validEnvironment(value: environmentTextField.stringValue)
        let validSteps = ValidatorUtility.validReproduceSteps(value: stepsTextView.string ?? "")
        
        return validEnvironment && validSteps
    }
    
}
