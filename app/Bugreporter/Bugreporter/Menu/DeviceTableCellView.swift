//
//  DeviceTableCellView.swift
//  Bugreporter
//
//  Created by Leo Thomas on 11/09/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class DeviceTableCellView: NSTableCellView {

    @IBOutlet weak var nameLabel: NSTextField!
        
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var recordingIndicator: CircleView!
    
}

extension DeviceTableCellView {

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        let area = NSTrackingArea(rect: frame, options: [NSTrackingAreaOptions.activeAlways, NSTrackingAreaOptions.mouseEnteredAndExited], owner: self, userInfo: nil)
        addTrackingArea(area)
    }

    
    func configure(with device: RecordableDevice) {
        nameLabel.stringValue = device.name
        // TODO add image
        
        if device.isRecording {
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(blinkRecordingIndicator), userInfo: nil, repeats: true)
        } else {
            recordingIndicator.isHidden = true
        }
    }
    
    func blinkRecordingIndicator() {
        recordingIndicator.isHidden = !recordingIndicator.isHidden
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        
        layer?.backgroundColor = NSColor.darkGray.withAlphaComponent(0.75).cgColor
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        
        layer?.backgroundColor = NSColor.clear.cgColor
    }
}
