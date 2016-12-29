//
//  Global.swift
//  Bugreporter
//
//  Created by Leo Thomas on 17/12/2016.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Cocoa

var animationDuration: TimeInterval {
    let defaultValue = 0.25
    if #available(OSX 10.12, *) {
        return NSWorkspace.shared().accessibilityDisplayShouldReduceMotion ? 0 : defaultValue
    } else {
        return defaultValue
    }
}

enum LTInterfaceStyle {
    case dark
    case light
}

var ltInterfaceStyle: LTInterfaceStyle {
    let defaultsValue = UserDefaults.standard.string(forKey: "AppleInterfaceStyle")
    return defaultsValue != nil ? .dark : .light
}
