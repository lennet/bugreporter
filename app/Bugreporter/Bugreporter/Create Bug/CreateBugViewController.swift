//
//  CreateBugViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 15/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class CreateBugViewController: NSViewController {

    weak var pageController: NSPageController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: AnyObject?) {
        if let pageController = segue.destinationController as? NSPageController {
            pageController.delegate = self
            pageController.arrangedObjects = ["1", "2", "3"]
            self.pageController = pageController
        }
    }
    
    @IBAction func nextClicked(_ sender: AnyObject) {
        pageController?.navigateForward(sender)
    }
    
    @IBAction func previousClicked(_ sender: AnyObject) {
        pageController?.navigateBack(sender)
    }
    
}

extension CreateBugViewController: NSPageControllerDelegate {

    
    func pageController(_ pageController: NSPageController, identifierFor object: AnyObject) -> String {

        return "()"
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: String) -> NSViewController {
        let controller = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SelectFilesSplitView") as! NSViewController
        
        controller.view.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
        controller.view.frame = pageController.view.bounds
        
        return controller
    }

}
