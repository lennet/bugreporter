//
//  GeneralPreferencesViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 31/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

extension NSButton {
    
    var boolForState: Bool {
        get {
            return state == NSOnState
        }
        set {
            state = newValue ? NSOnState : NSOffState
        }
    }

}


class GeneralPreferencesViewController: NSViewController {

    @IBOutlet weak var notificationEnabledButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationEnabledButton.boolForState = UserPreferences.showNotifications
        
    }
    
    @IBAction func notificationButtonClicked(_ sender: AnyObject) {
        UserPreferences.showNotifications = notificationEnabledButton.boolForState
    }
    
}
