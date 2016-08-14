//
//  CreateBugStep.swift
//  Bugreporter
//
//  Created by Leo Thomas on 13/08/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import Foundation

enum CreateBugStep {
    
    case intro
    case chooseAttachment
    case howToReproduce
    case upload
    
    // identifier can be used for instatiating the ViewController from Storyboard
    var identifier: String {
        get {
            switch self {
            case .intro:
                return "CreateBugIntroViewController"
            case .chooseAttachment:
                return "SelectFilesSplitView"
            case .howToReproduce:
                return "CreateBugReproduceViewController"
            case .upload:
                return "UploadBugViewController"
            }
        }
    }
    
    mutating func next() {
        switch self {
        case .intro:
            self = .chooseAttachment
        case .chooseAttachment:
            self = .howToReproduce
        case .howToReproduce:
            self = .upload
        case .upload:
            // is last step
            break
        }
    }
    
    mutating func previous() {
        switch self {
        case .intro:
            // is first step
            break
        case .chooseAttachment:
            self = .intro
        case .howToReproduce:
            self = .chooseAttachment
        case .upload:
            self = .howToReproduce
        }
    }
    
    var isLast: Bool {
        get {
            return self == .upload
        }
    }
    
    var isFirst: Bool {
        get {
            return self == .intro
        }
    }
    
}
