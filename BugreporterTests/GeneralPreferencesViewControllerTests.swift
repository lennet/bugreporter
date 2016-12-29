//
//  GeneralPreferencesViewControllerTests.swift
//  Bugreporter
//
//  Created by Leo Thomas on 31/07/16.
//  Copyright © 2016 Leonard Thomas. All rights reserved.
//

import XCTest
@testable import Bugreporter

class GeneralPreferencesViewControllerTests: XCTestCase {

    func testNotificationButton() {
        let viewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "GeneralPreferencesViewController") as! GeneralPreferencesViewController
        _ = viewController.view // to get viewdidLoad called
        
        let oldValue = UserPreferences.showNotifications
        
        XCTAssertEqual(viewController.notificationEnabledButton.boolForState, oldValue)
        
        // simulate check box click
        viewController.notificationEnabledButton.boolForState = !oldValue
        viewController.notificationButtonClicked(self)

        XCTAssertNotEqual(viewController.notificationEnabledButton.boolForState, oldValue)
        
        let newValue = UserPreferences.showNotifications
        XCTAssertEqual(viewController.notificationEnabledButton.boolForState, newValue)
    }

}
