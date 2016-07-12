//
//  ScreenRecorderManager.swift
//  Bugreporter
//
//  Created by Leo Thomas on 12/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa
import AVFoundation

class ScreenRecorderManager: NSObject {

    static let shared = ScreenRecorderManager()
    
    subscript(forDevice device: AVCaptureDevice) -> ScreenRecorder? {
        for recorder in recorderInstances where recorder.device == device {
            return recorder
        }
        return nil
    }
    
    var recorderInstances: [ScreenRecorder] = []
    
    private override init() {
        super.init()
    }
    
    func add(recorder: ScreenRecorder) {
        recorderInstances.append(recorder)
    }
    
    func remove(recorder: ScreenRecorder) {
        guard let index = recorderInstances.index(of: recorder) else { return }
        recorderInstances.remove(at: index)
    }
}
