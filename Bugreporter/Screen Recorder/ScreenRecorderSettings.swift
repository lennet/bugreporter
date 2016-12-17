//
//  ScreenRecorderSettings.swift
//  Bugreporter
//
//  Created by Leo Thomas on 31/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Foundation

func ==(a: RecorderDurationOptions, b: RecorderDurationOptions) -> Bool {
    switch (a, b) {
    case (.infinite, .infinite):
        return true
    case (.finite(let a), .finite(let b) ):
        return a == b
    default:
        return false
    }
}

enum RecorderDurationOptions {
    case infinite
    case finite(seconds: UInt)
    
    init(seconds: UInt) {
        switch seconds{
        case 0:
            self = .infinite
        default:
            self = .finite(seconds: seconds)
        }
    }
    
    var seconds: UInt {
        switch self {
        case .infinite:
            return 0
        case let .finite(duration):
            return duration
        }
    }
    
}

struct ScreenRecorderSettings {
    var framesPerSecond: Int
    var duration: RecorderDurationOptions
}

