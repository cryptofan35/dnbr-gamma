//
//  iOS_KeyboardUITests.swift
//  iOS KeyboardUITests
//
//  Created by George Birch on 8/8/23.
//

import XCTest

final class iOS_KeyboardUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
