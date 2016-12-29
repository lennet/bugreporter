//
//  UserPreferences.swift
//  Bugreporter
//
//  Created by Leo Thomas on 31/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Foundation

class UserPreferences {
    
    class func setup() {
        
        if isFirstRun {
            // setup defaults
            isFirstRun = false
            recorderMaxDuration = .infinite
            recorderFrameRate = 60
            showNotifications = false
        }
    }
    
    
    /// only for internal purposes because its set to true after first init of this class
    private class var isFirstRun: Bool {
        
        get {
            if UserDefaults.standard.value(forKey: "isFirstRun") == nil {
                return true
            }
            return UserDefaults.standard.bool(forKey: "isFirstRun")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "isFirstRun")
        }
        
    }
    
    class var recorderSettings: ScreenRecorderSettings {
        
        get {
            return ScreenRecorderSettings(framesPerSecond: recorderFrameRate, duration: recorderMaxDuration)
        }
        
        set {
            recorderFrameRate = newValue.framesPerSecond
            recorderMaxDuration = newValue.duration
        }
        
    }
    
    class var recorderFrameRate: Int {
        get {
            return UserDefaults.standard.integer(forKey: "frameRate")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey:  "frameRate")
        }
    }
    
    class var recorderMaxDuration: RecorderDurationOptions {
        get {
            let durationValue = UserDefaults.standard.integer(forKey: "maxDuration")
            return RecorderDurationOptions(seconds: UInt(durationValue))
        }
        
        set {
            UserDefaults.standard.set(newValue.seconds, forKey: "maxDuration")
        }
    }
    
    class var showNotifications: Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: "showNotificationsKey")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "showNotificationsKey")
        }
    }
    
}
