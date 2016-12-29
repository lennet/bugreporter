//
//  AppDelegate.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var windowController: NSWindowController?
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    weak var menuController: MenuViewController?
    weak var menuPopover: NSPopover?
    
    override func awakeFromNib() {
        configureStatusItem()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserPreferences.setup()
        DeviceObserver.shared.delegate = self
        NSUserNotificationCenter.default.delegate = self
    }
    
    func configureStatusItem() {
        guard let button = statusItem.button else { return }
        button.title = "Bugreporter"
        button.target = self
        button.action = #selector(statusItemClicked)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func statusItemClicked(sender: NSButton) {
        guard let menuController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "MenuViewController") as? MenuViewController else { return }
        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = menuController
        self.menuController = menuController
        popover.show(relativeTo: sender.frame, of: sender, preferredEdge: .minY)
        self.menuPopover = popover
    }
    

    func showDevice(name: String) {
        guard let selectedDevice = DeviceObserver.shared.device(withName: name) else { return }
        windowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "DeviceWindowController") as? NSWindowController
        (windowController?.contentViewController as? RecordExternalDeviceViewController)?.device = selectedDevice
        
        windowController?.showWindow(self)
    }
    
    func showNotification(text: String) {
        let notification = NSUserNotification()
        
        notification.title = "Device detected"
        
        notification.informativeText = text
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.hasActionButton = true
        
        NSUserNotificationCenter.default.deliver(notification)
    }
    
}

extension AppDelegate: DeviceObserverDelegate {
    
    func didRemoveDevice() {
        menuController?.reload()
    }
    
    func didAddDevice(name: String) {
        menuController?.reload()
        
        if UserPreferences.showNotifications {
            showNotification(text: name)
        }
    }

}

extension AppDelegate : NSUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        guard let informativeText = notification.informativeText else { return }
        showDevice(name: informativeText)
    }
    
}
