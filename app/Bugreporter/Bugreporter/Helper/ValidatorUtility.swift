//
//  ValidatorUtility.swift
//  Bugreporter
//
//  Created by Leo Thomas on 16/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Foundation

class ValidatorUtility {
    
    class func validTitle(value: String) -> Bool {
        return true
    }
    
    class func validDescription(value: String) -> Bool {
        return true 
    }

    class func validEnvironment(value: String) -> Bool {
        do {
            
            // check for device
            let deviceRegexp = try RegularExpression(pattern: "(iPhone|iPad)(\\s){0,3}(Pro|Air|s)?\\d?", options: .useUnixLineSeparators)
            
            guard deviceRegexp.numberOfMatches(in: value, options: .withoutAnchoringBounds, range: NSMakeRange(0, value.characters.count)) > 0  else {
                return false
            }
            
            let inputWithoutDevice = deviceRegexp.stringByReplacingMatches(in: value, options: .withoutAnchoringBounds, range: NSMakeRange(0, value.characters.count), withTemplate: "")
        
            // check for two version numbers (Device & App)
            let versionRegexp = try RegularExpression(pattern: "(\\d\\.)?(\\d+\\.)?(\\*|\\d+)", options: .useUnixLineSeparators)
            
            guard versionRegexp.numberOfMatches(in: inputWithoutDevice, options: .withoutAnchoringBounds, range: NSMakeRange(0, inputWithoutDevice.characters.count)) >= 2 else {
                return false
            }

        } catch {
            return false
        }
        
        return true
    }
    
    class func validReproduceSteps(value: String) -> Bool {
        var lines: [String] = []
        value.enumerateLines { (line, stop) in
            lines.append(line)
        }
    
        var validLines = lines.count
        for line in lines {
            if line.characters.count < 5 {
                validLines -= 1
            }
        }
        
        guard validLines > 2 else {
            return false
        }

        
        return true
    }
    
}
