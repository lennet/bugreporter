//
//  RecorderViewControllerManager.swift
//  Bugreporter
//
//  Created by Leo Thomas on 09/10/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Foundation

class RecorderViewControllerManager {

    static let shared = RecorderViewControllerManager()
    
    subscript(forDevice device: RecordableDevice) -> RecorderViewController? {
        for recorder in instances where recorder.device?.name == device.name {
            return recorder
        }
        return nil
    }
    
    private var instances: [RecorderViewController] = []
    
    func add(recorder: RecorderViewController) {
        instances.append(recorder)
    }
    
    func remove(recorder: RecorderViewController) {
        guard let index = instances.index(of: recorder) else { return }
        instances.remove(at: index)
    }
}
