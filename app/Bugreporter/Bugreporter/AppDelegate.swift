//
//  AppDelegate.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

extension NSMenu {

    func itemExisits(withTitle title: String) -> Bool {
        return item(withTitle: title) != nil
    }
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,  DeviceObserverDelegate {

    @IBOutlet weak var menu: NSMenu!
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        configureStatusItem()
        DeviceObserver.shared.delegate = self
        NSUserNotificationCenter.default.delegate = self
    }
    
    @IBAction func quitClicked(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    func configureStatusItem() {
        statusItem.title = "Bugreporter"
        statusItem.menu = menu
    }
    
    func configureMenu() {
        
        for device in DeviceObserver.shared.devices where !menu.itemExisits(withTitle: device.localizedName) {
            let menuItem = NSMenuItem(title: device.localizedName, action: #selector(clickedMenuItem), keyEquivalent: "")
            menu.insertItem(menuItem, at: 0)
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    var windowController: NSWindowController?
    
    func clickedMenuItem(sender: NSMenuItem) {
        showDevice(name: sender.title)
    }
    
    func showDevice(name: String) {
        guard let selectedDevice = DeviceObserver.shared.device(withName: name) else { return }
        windowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "DeviceWindowController") as? NSWindowController
        windowController?.contentViewController?.representedObject = selectedDevice
        
        windowController?.showWindow(self)
    }
    
    func didRemoveDevice() {
        configureMenu()
    }
    
    func didAddDevice() {
        configureMenu()
    }
    
}

extension AppDelegate : NSUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: NSUserNotificationCenter, didDeliver notification: NSUserNotification) {
        
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        guard let informativeText = notification.informativeText else { return }
        showDevice(name: informativeText)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

}
