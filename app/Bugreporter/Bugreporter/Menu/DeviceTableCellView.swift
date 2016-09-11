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
}
