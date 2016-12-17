//
//  RecorderViewController.swift
//  Bugreporter
//
//  Created by Leo Thomas on 13/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

class RecorderViewController: NSViewController {

    @IBOutlet weak var recordButton: NSControl!
    @IBOutlet weak var screenshotButton: NSControl!
    
    var recorder: ScreenRecorder?
    var device: RecordableDevice?
    
    override func viewDidLoad() {
        RecorderViewControllerManager.shared.add(recorder: self)
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        configureRecorder()
        view.window?.title = device?.name ?? ""
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        if let recorder = recorder,
            !recorder.isRecording {
            recorder.finnishSession()
            ScreenRecorderManager.shared.remove(recorder: recorder)
        }
        RecorderViewControllerManager.shared.remove(recorder: self)
    }
    
    private func configureRecorder() {
        guard let device = device else { return }
        if let recorder = ScreenRecorderManager.shared[forDevice: device] {
            if recorder.isRecording {
                
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
            
        } else {
            recorder.start()
            
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
