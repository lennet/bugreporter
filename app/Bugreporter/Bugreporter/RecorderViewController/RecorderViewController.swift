//
//  RecorderViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 13/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class RecorderViewController: NSViewController {

    @IBOutlet weak var recordButton: NSButton!
    @IBOutlet weak var screenshotButton: NSButton!
    
    var recorder: ScreenRecorder?
    var device: RecordableDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        configureRecorder()
        view.window?.title = device?.name ?? ""
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        if !(recorder?.isRecording ?? false) {
            recorder?.finnishSession()
        }
    }
    
    private func configureRecorder() {
        guard let device = device else { return }
        if let recorder = ScreenRecorderManager.shared[forDevice: device] {
            if recorder.isRecording {
                recordButton.title = "stop"
            }
            self.recorder = recorder
        } else {
            let recorderSettings = UserPreferences.shared.recorderSettings
            self.recorder = ScreenRecorder(device: device, delegate: self, settings: recorderSettings)
        }
    }
    
    //MARK - Actions
    
    @IBAction func recordClicked(_ sender: AnyObject) {
        guard let recorder = recorder else { return }
        
        if recorder.isRecording {
            recorder.stop()
            recordButton.title = "Start"
        } else {
            recorder.start()
            recordButton.title = "Stop"
        }
        
    }
    
    @IBAction func screenshotClicked(_ sender: AnyObject) {
        recorder?.screenshot(with: { (imageData, error) in
            if let imageData = imageData {
                let name = "\(self.recorder!.device.name)_\(Date().toString())"
                AttachmentManager.shared.save(data: imageData, name: name, type: .image)
            } else {
                //show error
            }
        })
    }
    
}

extension RecorderViewController: ScreenRecorderDelegate {
    
    func recordinginterrupted() {
        
    }
    
    func sizeDidChanged(newSize: CGSize) {
        
    }
}
