//
//  MenuViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 11/09/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class MenuViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
    }
    
    @IBAction func quitClicked(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }

    func reload() {
        tableView.reloadData()
        tableView.layout()
        tableViewHeight.constant = CGFloat(tableView.numberOfRows) * tableView.rowHeight
        view.layout()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let selectedDevie = sender as? RecordableDevice else { return }
        if let recorderViewController = segue.destinationController as? RecorderViewController {
            recorderViewController.device = selectedDevie
        }
    }
    
}

extension MenuViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return DeviceObserver.shared.devices.count
    }

}

extension MenuViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.make(withIdentifier: "DeviceCell", owner: self) as! DeviceTableCellView
        let device = DeviceObserver.shared.devices[row]
        cell.configure(with: device)
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let selectedDevice = DeviceObserver.shared.devices[row]
        if let _ = RecorderViewControllerManager.shared[forDevice: selectedDevice] {
            NSApp.activate(ignoringOtherApps: true)
            (NSApplication.shared().delegate as? AppDelegate)?.menuPopover?.performClose(self)
        } else {
            performSegue(withIdentifier: "showDevice", sender: selectedDevice)
        }
        
        return true
    }
    
}
