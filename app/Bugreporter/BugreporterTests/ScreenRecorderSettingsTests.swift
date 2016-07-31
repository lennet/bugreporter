//
//  ScreenRecorderSettingsTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 31/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class ScreenRecorderSettingsTests: XCTestCase {

    func testCompareRecorderDurationOptions() {
        XCTAssert(RecorderDurationOptions.infinite == RecorderDurationOptions.infinite)
        XCTAssert(RecorderDurationOptions.finite(seconds: 50) == RecorderDurationOptions.finite(seconds: 50))

        XCTAssertEqual(RecorderDurationOptions.infinite.seconds, 0)
        XCTAssertFalse(RecorderDurationOptions.infinite == RecorderDurationOptions.finite(seconds: 0))
        
        XCTAssertFalse(RecorderDurationOptions.finite(seconds: 50) == RecorderDurationOptions.infinite)
        XCTAssertFalse(RecorderDurationOptions.finite(seconds: 50) == RecorderDurationOptions.finite(seconds: 60))
    }
    
    
    func testRecorderDurationOptionsInit() {
        
        XCTAssert(RecorderDurationOptions(seconds: 0) == RecorderDurationOptions.infinite)
        
        let fiftySeconds = RecorderDurationOptions(seconds:50)
        if case .finite(let seconds) = fiftySeconds {
            XCTAssertEqual(seconds, 50)
        } else {
            XCTAssert(false == true, "getting seconds parameter from RecorderDurationOptions failed: \(fiftySeconds)")
        }
        
    }

}
