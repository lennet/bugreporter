//
//  UserPreferencesTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 31/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
import Foundation
@testable import Bugreporter

class UserPreferencesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecorderPreferences() {
        let preferences = UserPreferences.shared
        let recorderSettings = ScreenRecorderSettings(framesPerSecond: 120, duration: .finite(seconds: 12))
        
        preferences.recorderSettings =  ScreenRecorderSettings(framesPerSecond: 99, duration: .finite(seconds: 5))
        
        XCTAssertNotEqual(preferences.recorderFrameRate, recorderSettings.framesPerSecond)
        XCTAssertNotEqual(preferences.recorderMaxDuration.seconds, recorderSettings.duration.seconds)
        
        preferences.recorderSettings = recorderSettings
        
        XCTAssertEqual(preferences.recorderFrameRate, recorderSettings.framesPerSecond)
        XCTAssertEqual(preferences.recorderMaxDuration.seconds, recorderSettings.duration.seconds)
    }

}
